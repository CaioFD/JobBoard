# Tests for applying to jobs. They run the real backend on port 8765 against the local job_board database;
# every user they create is deleted at the end, together with its applications.
# Run from the backend folder: python -m pytest
import json
import os
import threading
import time
import urllib.error
import urllib.request
import uuid

import pytest

os.environ.setdefault("JWT_SECRET", "secret_used_only_by_the_tests_0000000")
import main
import uvicorn
from connexion_mysql import get_connection

BASE_URL = "http://127.0.0.1:8765"


def call(method, path, body=None, token=None, content_type="application/json"):
    data = body if isinstance(body, bytes) else (json.dumps(body).encode() if body is not None else None)
    request = urllib.request.Request(BASE_URL + path, data=data, method=method)
    if data is not None:
        request.add_header("Content-Type", content_type)
    if token:
        request.add_header("Authorization", "Bearer " + token)
    try:
        with urllib.request.urlopen(request) as response:
            raw = response.read()
            status = response.status
    except urllib.error.HTTPError as error:
        raw = error.read()
        status = error.code
    try:
        return status, json.loads(raw)
    except ValueError:
        return status, raw


@pytest.fixture(scope="module", autouse=True)
def server():
    server = uvicorn.Server(uvicorn.Config(main.app, port=8765, log_level="error"))
    threading.Thread(target=server.run, daemon=True).start()
    while not server.started:
        time.sleep(0.05)
    yield
    server.should_exit = True


@pytest.fixture
def make_user():
    emails = []

    def make(role="user", complete=True):
        email = f"test_{uuid.uuid4().hex[:12]}@example.com"
        emails.append(email)
        call("POST", "/api/register", {"email": email, "password": "password123"})
        if role == "admin":
            connexion = get_connection()
            cursor = connexion.cursor()
            cursor.execute("UPDATE users SET user_role='admin' WHERE email=%s", (email,))
            connexion.commit()
            connexion.close()
        token = call("POST", "/api/login", {"email": email, "password": "password123"})[1]["token"]
        if complete:
            call("PUT", "/api/profile", {"full_name": "Test User", "birth_date": "2000-01-01"}, token)
            call("PUT", "/api/profile/cv", b"%PDF-1.4 test cv", token, "application/pdf")
        return token, email

    yield make
    connexion = get_connection()
    cursor = connexion.cursor()
    for email in emails:
        cursor.execute("DELETE FROM users WHERE email=%s", (email,))
    connexion.commit()
    connexion.close()


@pytest.fixture(scope="module")
def job_id():
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("SELECT id_job FROM job LIMIT 1")
    row = cursor.fetchone()
    connexion.close()
    assert row, "the job table is empty, run data_base.sql first"
    return row[0]


def test_apply_requires_login(job_id):
    assert call("POST", f"/api/jobs/{job_id}/apply")[0] == 401


def test_apply_requires_complete_profile(make_user, job_id):
    token, _ = make_user(complete=False)
    assert call("POST", f"/api/jobs/{job_id}/apply", token=token)[0] == 400
    # name and birth date are not enough, the CV is required too
    call("PUT", "/api/profile", {"full_name": "Test User", "birth_date": "2000-01-01"}, token)
    assert call("POST", f"/api/jobs/{job_id}/apply", token=token)[0] == 400


def test_apply_unknown_job(make_user):
    token, _ = make_user()
    assert call("POST", "/api/jobs/NOPE/apply", token=token)[0] == 404


def test_apply_and_cancel(make_user, job_id):
    token, email = make_user()
    admin_token, _ = make_user(role="admin")

    def admin_emails():
        return [a["email"] for a in call("GET", "/api/applications", token=admin_token)[1]["applications"]]

    assert call("GET", f"/api/jobs/{job_id}/apply", token=token)[1] == {"applied": False}
    assert call("POST", f"/api/jobs/{job_id}/apply", token=token)[0] == 201
    assert call("POST", f"/api/jobs/{job_id}/apply", token=token)[0] == 409
    assert call("GET", f"/api/jobs/{job_id}/apply", token=token)[1] == {"applied": True}
    assert [a["id_job"] for a in call("GET", "/api/my_applications", token=token)[1]["applications"]] == [job_id]
    assert email in admin_emails()

    assert call("DELETE", f"/api/jobs/{job_id}/apply", token=token)[0] == 200
    assert call("DELETE", f"/api/jobs/{job_id}/apply", token=token)[0] == 404
    assert call("GET", "/api/my_applications", token=token)[1]["applications"] == []
    assert email not in admin_emails()


def test_admin_sees_applicant_and_cv(make_user, job_id):
    token, email = make_user()
    admin_token, _ = make_user(role="admin")
    call("POST", f"/api/jobs/{job_id}/apply", token=token)
    application = next(a for a in call("GET", "/api/applications", token=admin_token)[1]["applications"] if a["email"] == email)
    assert application["full_name"] == "Test User"
    assert application["id_job"] == job_id
    assert call("GET", f"/api/users/{application['id_user']}/cv", token=admin_token) == (200, b"%PDF-1.4 test cv")


def test_admin_routes_are_closed_to_users(make_user):
    token, _ = make_user()
    assert call("GET", "/api/applications", token=token)[0] == 403
    assert call("GET", "/api/users/anyone/cv", token=token)[0] == 403

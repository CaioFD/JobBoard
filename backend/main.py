import fastapi
import datetime
import hashlib
import hmac
import os
import secrets
import jwt
import mysql.connector
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel

JWT_SECRET = os.environ.get("JWT_SECRET")
if not JWT_SECRET:
    raise RuntimeError("JWT_SECRET is not set. Run once in PowerShell: setx JWT_SECRET <long random value>, then reopen the terminal")
TOKEN_HOURS = 2
MAX_CV_BYTES = 5 * 1024 * 1024

app=fastapi.FastAPI()
@app.get("/api/categories_HomePage")
def get_categories():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("SELECT id_category,name_category FROM category")
    categories=cursor.fetchall()
    cursor.close()
    categories_json=[]
    for i in categories:
        categories_json.append({"id" : i[0] ,"name" : i[1] })
    return {
        "categories" : categories_json

    }
@app.get("/api/locations_HomePage")
def get_locations():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("""
    SELECT country.name_country,country.id_country
    FROM country
    """)
    locations=cursor.fetchall()
    cursor.close()
    locations_json=[]
    for i in locations:
        locations_json.append({ "country" : i[0] , "id_country" : i[1]});
    return {
       "locations" : locations_json
    }

@app.get("/api/tot_jobs")
def get_tot_jobs():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("""
        SELECT count(*) FROM job;
    """)
    tot_jobs=cursor.fetchall()
    cursor.close()
    tot_jobs_json=tot_jobs[0][0]
    return{
        "tot_jobs" : tot_jobs_json
    }

@app.get("/api/job_titles")
def get_tob_titles():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("SELECT title_job,id_job FROM job")
    job_tiles=cursor.fetchall()
    job_tiles_json=[]
    for i in job_tiles:
        job_tiles_json.append({"title": i[0] ,"id": i[1]})
    cursor.close()
    return {
        "job_titles" : job_tiles_json
    }
@app.get("/api/tot_companies")
def get_tot_companies():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor= connexion.cursor()
    cursor.execute("SELECT count(*) FROM company")
    tot_comapanies=cursor.fetchall()
    return{
        "tot_companies" : tot_comapanies[0][0]
    }
    
@app.get("/api/recent_jobs")
def get_recent_jobs():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("""
        SELECT job.id_job,job.title_job,company.name_company,category.name_category,job.job_type,job.min_salary,job.max_salary,city.name_city,country.name_country,job.added_time
        FROM job 
        INNER JOIN city
        ON job.id_city=city.id_city
        INNER JOIN country
        ON country.id_country=city.id_country
        INNER JOIN company
        ON job.id_company=company.id_company
        INNER JOIN category
        ON job.id_category=category.id_category
        ORDER BY added_time DESC
        LIMIT 5
    """)
    cards_data = cursor.fetchall()
    cards_data_json = []
    for i in cards_data:
        cards_data_json.append({"id" : i[0] ,"title" : i[1] ,"company" : i[2] ,"category" : i[3],"job_type" : i[4],"min_salary" : i[5],"max_salary" : i[6] ,"added_time" : i[9] ,"city" :i[7],"country" : i[8] })
    return {
        "cards_data" : cards_data_json
    }

class Credentials(BaseModel):
    email: str
    password: str

def hash_password(password):
    salt = secrets.token_bytes(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 600_000)
    return salt.hex() + "$" + digest.hex()

def check_password(password, stored):
    salt, digest = stored.split("$")
    new_digest = hashlib.pbkdf2_hmac("sha256", password.encode(), bytes.fromhex(salt), 600_000)
    return hmac.compare_digest(new_digest.hex(), digest)

@app.post("/api/register", status_code=201)
def register(credentials: Credentials):
    from connexion_mysql import get_connection
    email = credentials.email.strip().lower()
    if "@" not in email or len(email) > 100:
        raise fastapi.HTTPException(400, "Invalid email")
    if len(credentials.password) < 8:
        raise fastapi.HTTPException(400, "Password must have at least 8 characters")
    connexion = get_connection()
    cursor = connexion.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (id_user,email,password_user,user_role) VALUES (%s,%s,%s,'user')",
            (secrets.token_hex(15), email, hash_password(credentials.password))
        )
        connexion.commit()
    except mysql.connector.IntegrityError:
        raise fastapi.HTTPException(409, "This email is already registered")
    finally:
        cursor.close()
        connexion.close()
    return {"message": "Account created"}

@app.post("/api/login")
def login(credentials: Credentials):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("SELECT id_user,password_user,user_role FROM users WHERE email=%s", (credentials.email.strip().lower(),))
    user = cursor.fetchone()
    cursor.close()
    connexion.close()
    if user is None or not check_password(credentials.password, user[1]):
        raise fastapi.HTTPException(401, "Invalid email or password")
    expires = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=TOKEN_HOURS)
    token = jwt.encode({"sub": user[0], "exp": expires}, JWT_SECRET, algorithm="HS256")
    return {"token": token, "email": credentials.email.strip().lower(), "role": user[2]}

bearer = HTTPBearer(auto_error=False)

def get_current_user(auth: HTTPAuthorizationCredentials | None = fastapi.Depends(bearer)):
    from connexion_mysql import get_connection
    if auth is None:
        raise fastapi.HTTPException(401, "You need to log in")
    try:
        payload = jwt.decode(auth.credentials, JWT_SECRET, algorithms=["HS256"])
    except jwt.InvalidTokenError:
        raise fastapi.HTTPException(401, "Your session is invalid or expired, please log in again")
    connexion = get_connection()
    cursor = connexion.cursor()
    # role is read from the database, not the token, so a demoted admin loses access right away
    cursor.execute("SELECT id_user,email,user_role FROM users WHERE id_user=%s", (payload["sub"],))
    user = cursor.fetchone()
    cursor.close()
    connexion.close()
    if user is None:
        raise fastapi.HTTPException(401, "You need to log in")
    return {"id": user[0], "email": user[1], "role": user[2]}

def require_admin(user: dict = fastapi.Depends(get_current_user)):
    if user["role"] != "admin":
        raise fastapi.HTTPException(403, "Only admins can do this")
    return user

class Profile(BaseModel):
    full_name: str
    birth_date: datetime.date

def get_age(birth_date):
    today = datetime.date.today()
    return today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))

@app.get("/api/profile")
def get_profile(user: dict = fastapi.Depends(get_current_user)):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("SELECT full_name,birth_date,cv IS NOT NULL FROM users WHERE id_user=%s", (user["id"],))
    profile = cursor.fetchone()
    cursor.close()
    connexion.close()
    return {
        "email": user["email"],
        "full_name": profile[0],
        "birth_date": profile[1],
        "age": get_age(profile[1]) if profile[1] else None,
        "has_cv": bool(profile[2])
    }

@app.put("/api/profile")
def update_profile(profile: Profile, user: dict = fastapi.Depends(get_current_user)):
    from connexion_mysql import get_connection
    full_name = profile.full_name.strip()
    if not full_name or len(full_name) > 100:
        raise fastapi.HTTPException(400, "Full name must have between 1 and 100 characters")
    age = get_age(profile.birth_date)
    if age < 16 or age > 120:
        raise fastapi.HTTPException(400, "You must be at least 16 years old")
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("UPDATE users SET full_name=%s,birth_date=%s WHERE id_user=%s", (full_name, profile.birth_date, user["id"]))
    connexion.commit()
    cursor.close()
    connexion.close()
    return {"message": "Profile saved", "age": age}

# the frontend sends the PDF itself as the request body, so no multipart library is needed
@app.put("/api/profile/cv")
def upload_cv(cv: bytes = fastapi.Body(media_type="application/pdf"), user: dict = fastapi.Depends(get_current_user)):
    from connexion_mysql import get_connection
    if len(cv) > MAX_CV_BYTES:
        raise fastapi.HTTPException(413, "The CV must be 5 MB or less")
    if not cv.startswith(b"%PDF-"):
        raise fastapi.HTTPException(400, "The CV must be a PDF file")
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("UPDATE users SET cv=%s WHERE id_user=%s", (cv, user["id"]))
    connexion.commit()
    cursor.close()
    connexion.close()
    return {"message": "CV saved"}

@app.get("/api/profile/cv")
def get_cv(user: dict = fastapi.Depends(get_current_user)):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("SELECT cv FROM users WHERE id_user=%s", (user["id"],))
    cv = cursor.fetchone()[0]
    cursor.close()
    connexion.close()
    if cv is None:
        raise fastapi.HTTPException(404, "You have not uploaded a CV yet")
    return fastapi.Response(content=bytes(cv), media_type="application/pdf")

@app.get("/api/jobs")
def get_all_jobs():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("""
        SELECT job.id_job,job.title_job,company.name_company,category.name_category,job.job_type,job.min_salary,job.max_salary,city.name_city,country.name_country,job.added_time
        FROM job 
        INNER JOIN city
        ON job.id_city=city.id_city
        INNER JOIN country
        ON country.id_country=city.id_country
        INNER JOIN company
        ON job.id_company=company.id_company
        INNER JOIN category
        ON job.id_category=category.id_category
        ORDER BY added_time DESC
    """)
    cards_data = cursor.fetchall()
    cards_data_json = []
    for i in cards_data:
        cards_data_json.append({"id" : i[0] ,"title" : i[1] ,"company" : i[2] ,"category" : i[3],"job_type" : i[4],"min_salary" : i[5],"max_salary" : i[6] ,"added_time" : i[9] ,"city" :i[7],"country" : i[8] })
    return {
        "cards_data" : cards_data_json
    }
@app.get("/api/filters_jobs")
def filter_jobs(id_country=None,id_category=None,job_title=None,date_posted=None,job_type=None,degree=None):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    query = """SELECT job.id_job,job.title_job,company.name_company,category.name_category,job.job_type,job.min_salary,job.max_salary,city.name_city,country.name_country,job.added_time
        FROM job 
        INNER JOIN city
        ON job.id_city=city.id_city
        INNER JOIN country
        ON country.id_country=city.id_country
        INNER JOIN company
        ON job.id_company=company.id_company
        INNER JOIN category
        ON job.id_category=category.id_category
        WHERE 1=1
        """
    list_params = []
    if id_country:
        list_params.append(id_country)
        query += " and country.id_country = %s"
    if id_category:
        if id_category:
            list_cat = id_category.split(",")
            query += " and (1=0"
            for i in list_cat:
                query += " or category.id_category = %s"
                list_params.append(i)
            query += ")"
    if job_title:
        list_params.append(job_title)
        query += " and job.id_job = %s"
    if date_posted:
        query += " and (1=0"
        list_date_posted = date_posted.split(","); 
        for i in list_date_posted:
            if i == "Last Hour":
                query += " or job.added_time >= NOW() - INTERVAL 1 HOUR"
            elif i == "Last 24 hours":
                query += " or job.added_time >= NOW() - INTERVAL 24 HOUR"
            elif i == "Last 7 days":
                query += " or job.added_time >= NOW() - INTERVAL 7 DAY"
            elif i == "Last 30 days":
                query += " or job.added_time >= NOW() - INTERVAL 30 DAY"
            elif i == "Older than 30 days":
                query += " or job.added_time < NOW() - INTERVAL 30 DAY"
        query += ")"
    if job_type:
        values = job_type.split(",")
        query += " and job.job_type IN (" + ",".join(["%s"] * len(values)) + ")"
        list_params.extend(values)

    if degree:
        values = degree.split(",")
        query += " and job.degree IN (" + ",".join(["%s"] * len(values)) + ")"
        list_params.extend(values)
    query += " ORDER BY added_time DESC;"
    cursor.execute(
        query,
        list_params
    )
    filter_data=cursor.fetchall()
    json_data = []
    for i in filter_data:
        json_data.append({"id": i[0], "title": i[1], "company": i[2], "category": i[3],
                          "job_type": i[4], "min_salary": i[5], "max_salary": i[6],
                          "added_time": i[9], "city": i[7], "country": i[8]})
    return {"filters": json_data}
@app.get("/api/filter_counts")
def get_filter_counts():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()

    def count_list(column):
        cursor.execute(f"SELECT {column}, COUNT(*) FROM job GROUP BY {column} ORDER BY COUNT(*) DESC")
        return [{"value": r[0], "label": r[0], "count": r[1]} for r in cursor.fetchall()]

    cursor.execute("""
        SELECT category.id_category, category.name_category, COUNT(job.id_job)
        FROM category
        LEFT JOIN job ON job.id_category = category.id_category
        GROUP BY category.id_category, category.name_category
        ORDER BY category.id_category
    """)
    category = [{"value": r[0], "label": r[1], "count": r[2]} for r in cursor.fetchall()]

    job_type = count_list("job_type")
    degree = count_list("degree")
    cursor.execute("""
        SELECT
            COALESCE(SUM(added_time >= NOW() - INTERVAL 1 HOUR), 0),
            COALESCE(SUM(added_time >= NOW() - INTERVAL 24 HOUR), 0),
            COALESCE(SUM(added_time >= NOW() - INTERVAL 7 DAY), 0),
            COALESCE(SUM(added_time >= NOW() - INTERVAL 30 DAY), 0),
            COALESCE(SUM(added_time < NOW() - INTERVAL 30 DAY), 0)
        FROM job
    """)
    d = cursor.fetchone()
    cursor.close()
    connexion.close()

    date_posted = [
        {"value": "Last Hour",          "label": "Last Hour",          "count": int(d[0])},
        {"value": "Last 24 hours",      "label": "Last 24 Hours",      "count": int(d[1])},
        {"value": "Last 7 days",        "label": "Last 7 Days",        "count": int(d[2])},
        {"value": "Last 30 days",       "label": "Last 30 Days",       "count": int(d[3])},
        {"value": "Older than 30 days", "label": "Older than 30 Days", "count": int(d[4])},
    ]

    return {"category": category, "job_type": job_type, "degree": degree, "date_posted": date_posted}

@app.get("/api/filters_homePage")
def apply_filters_homePage(category = None, location = None, job_titles = None):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    query = """
        SELECT job.id_job,job.title_job,company.name_company,category.name_category,job.job_type,job.min_salary,job.max_salary,city.name_city,country.name_country,job.added_time
        FROM job 
        INNER JOIN city
        ON job.id_city=city.id_city
        INNER JOIN country
        ON country.id_country=city.id_country
        INNER JOIN company
        ON job.id_company=company.id_company
        INNER JOIN category
        ON category.id_category=job.id_category
        WHERE 1=1 
    """
    params = []
    if category:
        params.append(category)
        query += " and job.id_category = %s"
    if location:
        params.append(location)
        query += " and country.id_country = %s"
    if job_titles:
        params.append(job_titles)
        query += " and job.id_job = %s"
    query += " ORDER BY added_time DESC;"
    cursor.execute(
        query,
        params
    )
    filter_data=cursor.fetchall()
    json_data = []
    for i in filter_data:
        json_data.append({"id": i[0], "title": i[1], "company": i[2], "category": i[3],
                          "job_type": i[4], "min_salary": i[5], "max_salary": i[6],
                          "added_time": i[9], "city": i[7], "country": i[8]})
    return {"filters_homePage": json_data}
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:5500"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

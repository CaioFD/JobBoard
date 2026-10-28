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

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:5500"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
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

@app.get("/api/cities")
def get_cities():
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("""
        SELECT city.id_city,city.name_city,country.name_country
        FROM city
        INNER JOIN country
        ON city.id_country=country.id_country
        ORDER BY country.name_country,city.name_city
    """)
    cities = cursor.fetchall()
    cursor.close()
    connexion.close()
    return {
        "cities" : [{"id" : i[0], "city" : i[1], "country" : i[2]} for i in cities]
    }

JOB_TYPES = ["Full Time", "Part Time", "Freelance", "Seasonal", "Fixed-Price"]
CURRENCIES = ["USD", "EUR", "GBP", "BRL", "MAD"]

class NewJob(BaseModel):
    title: str
    company: str
    job_type: str
    id_category: str
    degree: str
    experience: int
    currency: str
    min_salary: int
    max_salary: int
    id_city: str
    description: str
    skills: str

def check_job(job):
    if not job.title.strip() or len(job.title.strip()) > 50:
        raise fastapi.HTTPException(400, "Job title must have between 1 and 50 characters")
    if not job.company.strip() or len(job.company.strip()) > 30:
        raise fastapi.HTTPException(400, "Company name must have between 1 and 30 characters")
    if job.job_type not in JOB_TYPES or job.currency not in CURRENCIES:
        raise fastapi.HTTPException(400, "Invalid job type or currency")
    if not job.degree.strip() or len(job.degree) > 50:
        raise fastapi.HTTPException(400, "Choose a degree")
    if not 0 <= job.experience <= 5:
        raise fastapi.HTTPException(400, "Invalid years of experience")
    if not 0 < job.min_salary < job.max_salary:
        raise fastapi.HTTPException(400, "Minimum salary must be above 0 and lower than the maximum salary")
    if not job.description.strip() or not job.skills.strip():
        raise fastapi.HTTPException(400, "Description and skills are required")

# reuse the company if it already exists (MySQL compares names ignoring case), otherwise create it
def get_company_id(cursor, company):
    cursor.execute("SELECT id_company FROM company WHERE name_company=%s", (company,))
    row = cursor.fetchone()
    if row:
        return row[0]
    id_company = "COMP" + secrets.token_hex(3).upper()
    cursor.execute("INSERT INTO company (id_company,name_company) VALUES (%s,%s)", (id_company, company))
    return id_company

@app.post("/api/jobs", status_code=201)
def create_job(job: NewJob, admin: dict = fastapi.Depends(require_admin)):
    from connexion_mysql import get_connection
    check_job(job)
    connexion = get_connection()
    cursor = connexion.cursor()
    try:
        id_company = get_company_id(cursor, job.company.strip())
        id_job = "JOB" + secrets.token_hex(3).upper()
        cursor.execute("""
            INSERT INTO job (id_job,title_job,id_category,job_type,degree,job_description,pro_skills,id_company,id_city,experience,min_salary,max_salary,currency)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (id_job, job.title.strip(), job.id_category, job.job_type, job.degree.strip(), job.description.strip(), job.skills.strip(),
              id_company, job.id_city, str(job.experience), job.min_salary, job.max_salary, job.currency))
        connexion.commit()
    except mysql.connector.IntegrityError:
        connexion.rollback()
        raise fastapi.HTTPException(400, "Unknown category or city")
    finally:
        cursor.close()
        connexion.close()
    return {"message": "Job created", "id": id_job}

# public on purpose: the future Job Details page will show this to everyone
@app.get("/api/jobs/{id_job}")
def get_job(id_job: str):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("""
        SELECT job.id_job,job.title_job,company.name_company,job.job_type,job.id_category,job.degree,job.experience,
               job.currency,job.min_salary,job.max_salary,job.id_city,job.job_description,job.pro_skills,
               category.name_category,city.name_city,country.name_country,job.added_time
        FROM job
        INNER JOIN company
        ON job.id_company=company.id_company
        INNER JOIN category
        ON job.id_category=category.id_category
        INNER JOIN city
        ON job.id_city=city.id_city
        INNER JOIN country
        ON city.id_country=country.id_country
        WHERE job.id_job=%s
    """, (id_job,))
    i = cursor.fetchone()
    cursor.close()
    connexion.close()
    if i is None:
        raise fastapi.HTTPException(404, "This job does not exist anymore")
    return {"id" : i[0], "title" : i[1], "company" : i[2], "job_type" : i[3], "id_category" : i[4], "degree" : i[5],
            "experience" : int(i[6]), "currency" : i[7], "min_salary" : i[8], "max_salary" : i[9], "id_city" : i[10],
            "description" : i[11], "skills" : i[12], "category" : i[13], "city" : i[14], "country" : i[15], "added_time" : i[16]}

@app.put("/api/jobs/{id_job}")
def update_job(id_job: str, job: NewJob, admin: dict = fastapi.Depends(require_admin)):
    from connexion_mysql import get_connection
    check_job(job)
    connexion = get_connection()
    cursor = connexion.cursor()
    try:
        # added_time is not touched, so editing a job does not move it to the top of Recent Jobs
        cursor.execute("SELECT id_job FROM job WHERE id_job=%s", (id_job,))
        if cursor.fetchone() is None:
            raise fastapi.HTTPException(404, "This job does not exist anymore")
        id_company = get_company_id(cursor, job.company.strip())
        cursor.execute("""
            UPDATE job SET title_job=%s,id_category=%s,job_type=%s,degree=%s,job_description=%s,pro_skills=%s,
                           id_company=%s,id_city=%s,experience=%s,min_salary=%s,max_salary=%s,currency=%s
            WHERE id_job=%s
        """, (job.title.strip(), job.id_category, job.job_type, job.degree.strip(), job.description.strip(), job.skills.strip(),
              id_company, job.id_city, str(job.experience), job.min_salary, job.max_salary, job.currency, id_job))
        connexion.commit()
    except mysql.connector.IntegrityError:
        connexion.rollback()
        raise fastapi.HTTPException(400, "Unknown category or city")
    finally:
        cursor.close()
        connexion.close()
    return {"message": "Job updated", "id": id_job}


@app.delete("/api/jobs/{id_job}")
def delete_job(id_job: str, admin: dict = fastapi.Depends(require_admin)):
    from connexion_mysql import get_connection
    connexion = get_connection()
    cursor = connexion.cursor()
    cursor.execute("DELETE FROM job WHERE id_job=%s", (id_job,))
    connexion.commit()
    deleted = cursor.rowcount
    cursor.close()
    connexion.close()
    if deleted == 0:
        raise fastapi.HTTPException(404, "This job does not exist anymore")
    return {"message": "Job deleted"}

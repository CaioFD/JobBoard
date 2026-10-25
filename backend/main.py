import fastapi 
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
    SELECT country.name_country,country.id_country,city.name_city,city.id_city
    FROM country
    INNER JOIN city
    ON city.id_country=country.id_country;
    """)
    locations=cursor.fetchall();
    cursor.close()
    locations_json=[]
    for i in locations:
        locations_json.append({ "country" : i[0] , "city" : i[2] , "id_country" : i[1] , "id_city" : i[3] });
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

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:5500"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
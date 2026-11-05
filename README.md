# JobBoard

A full-stack job board: candidates browse and filter job offers, create a profile, upload a CV and apply; admins publish, edit and delete jobs and review every application.

**Stack:** HTML · CSS · vanilla JavaScript · Python (FastAPI) · MySQL · JWT · deployed on Railway

## Features

**Candidates**
- Home page with live stats (total jobs, companies), categories, locations and the most recent offers
- Jobs page with search and filters (country, category, job title, date posted, job type, degree) and live filter counts
- Job details page
- Sign up / log in (JWT, 2-hour sessions)
- Profile: full name, birth date and CV upload (PDF, max 5 MB)
- Apply to a job, cancel an application, and see all applications on **My Applications**

**Admins**
- Create, edit and delete job offers (with currency choice)
- See every application and download the applicant's CV

**Security**
- Passwords hashed with PBKDF2-SHA256 (600,000 iterations, random salt)
- Admin routes protected by role checks on the server
- Parameterized SQL queries

## Project structure

```
JobBoard/
├── backend/
│   ├── main.py               # FastAPI app: API routes + serves the frontend
│   ├── connexion_mysql.py    # MySQL connection (reads env variables)
│   └── test_applications.py  # pytest tests for the application flow
├── Frontend/
│   ├── auth.js               # shared login token handling + navbar
│   ├── home_page/  Jobs/  JobDetails/
│   ├── login/  signIn/  Profile/  MyApplications/
│   ├── Admin/                # create_job + applications (admin only)
│   └── AboutUs/  ContactUs/
├── data_base/
│   └── data_base.sql         # schema + sample data
├── requirements.txt
└── railway.json              # Railway start command
```

## Running locally

**Requirements:** Python 3.10+ and MySQL 8.

1. **Clone and install dependencies**
   ```bash
   git clone <repo-url>
   cd JobBoard
   pip install -r requirements.txt
   ```

2. **Create the database** — run `data_base/data_base.sql` in MySQL (Workbench or CLI). It creates the `job_board` database, its tables and sample data.
   ```bash
   mysql -u root -p < data_base/data_base.sql
   ```

3. **Set the environment variables**

   | Variable        | Required | Default     |
   |-----------------|----------|-------------|
   | `MYSQLPASSWORD` | yes      | —           |
   | `JWT_SECRET`    | yes      | —           |
   | `MYSQLHOST`     | no       | `localhost` |
   | `MYSQLPORT`     | no       | `3306`      |
   | `MYSQLUSER`     | no       | `root`      |

   On Windows (PowerShell), then reopen the terminal:
   ```powershell
   setx MYSQLPASSWORD "your_mysql_password"
   setx JWT_SECRET "a_long_random_value"
   ```

4. **Start the server**
   ```bash
   cd backend
   uvicorn main:app --reload
   ```
   Open http://localhost:8000 — it redirects to the home page. Interactive API docs are at http://localhost:8000/docs.

### Creating an admin

New accounts are always regular users. To make one an admin, register it on the site, then run:
```sql
UPDATE job_board.users SET user_role = 'admin' WHERE email = 'you@example.com';
```

## Running the tests

The tests start the real backend on port 8765 against the local `job_board` database and delete every user they create.
```bash
cd backend
python -m pytest
```

## Deployment

The project is set up for [Railway](https://railway.app): add a MySQL service (it provides the `MYSQL*` variables), set `JWT_SECRET`, and Railway runs the start command from `railway.json`:
```
cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT
```

## API overview

| Method | Route | Access |
|--------|-------|--------|
| GET | `/api/jobs`, `/api/jobs/{id}` | public |
| GET | `/api/categories_HomePage`, `/api/locations_HomePage`, `/api/cities` | public |
| GET | `/api/tot_jobs`, `/api/tot_companies`, `/api/recent_jobs`, `/api/job_titles` | public |
| GET | `/api/filters_jobs`, `/api/filter_counts`, `/api/filters_homePage` | public |
| POST | `/api/register`, `/api/login` | public |
| GET / PUT | `/api/profile`, `/api/profile/cv` | logged in |
| GET / POST / DELETE | `/api/jobs/{id}/apply` | logged in |
| GET | `/api/my_applications` | logged in |
| POST / PUT / DELETE | `/api/jobs`, `/api/jobs/{id}` | admin |
| GET | `/api/applications`, `/api/users/{id}/cv` | admin |

## License

[MIT](LICENSE)

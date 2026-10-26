
CREATE DATABASE IF NOT EXISTS job_board;
USE job_board;
create table company(
    id_company varchar(30) PRIMARY KEY,
    name_company varchar(30) NOT NULL
);
create table category(
    id_category varchar(30) PRIMARY KEY,
    name_category varchar(50) NOT NULL
);
create table country(
    id_country varchar(30) PRIMARY KEY,
    name_country varchar(30) NOT NULL
);
create table city(
    id_city varchar(30) PRIMARY KEY,
    name_city varchar(30) NOT NULL,
    id_country varchar(30) NOT NULL,
    CONSTRAINT fk_location 
        FOREIGN KEY(id_country)
        REFERENCES country(id_country)
);
create table users(
    id_user varchar(30) PRIMARY KEY,
    email varchar(100) NOT NULL UNIQUE,
    password_user varchar(255) NOT NULL,
    user_role varchar(15) NOT NULL check(user_role in('admin','user'))
);
create table job(
    id_job varchar(10) PRIMARY KEY,
    title_job varchar(50) NOT NULL,
    id_category varchar(30) NOT NULL,
    job_type varchar(50) NOT NULL,
    degree varchar(50) NOT NULL,
    job_description TEXT NOT NULL,
    pro_skills TEXT NOT NULL,
    id_company varchar(30) NOT NULL,
    id_city varchar(30) NOT NULL,
    experience VARCHAR(30) NOT NULL,
    min_salary INT NOT NULL check(min_salary>0),
    max_salary INT NOT NULL check(max_salary>0),
    constraint check_salary
        check(min_salary<max_salary),
    constraint fk_company
        FOREIGN KEY(id_company)
        REFERENCES company(id_company),
    constraint fk_category
        FOREIGN KEY(id_category)
        REFERENCES category(id_category),
    constraint fk_city
        FOREIGN KEY(id_city)
        REFERENCES city(id_city)
);
USE job_board;
SHOW TABLES;
SHOW DATABASES;
SELECT USER(),CURRENT_USER();
USE job_board;

INSERT INTO category (id_category, name_category)
VALUES
    ('CAT001', 'IT'),
    ('CAT002', 'Marketing'),
    ('CAT003', 'Finance'),
    ('CAT004', 'Design'),
    ('CAT005', 'Hotels & Tourism'),
    ('CAT006', 'Media'),
    ('CAT007', 'Construction'),
    ('CAT008', 'Commerce'),
    ('CAT009', 'Education'),
    ('CAT010', 'Financial Services'),
    ('CAT011', 'Telecommunications'),
    ('CAT012', 'Human Resources'),
    ('CAT013', 'Healthcare'),
    ('CAT014', 'Engineering'),
    ('CAT015', 'Data & Analytics'),
    ('CAT016', 'Software Development'),
    ('CAT017', 'Customer Support'),
    ('CAT018', 'Logistics'),
    ('CAT019', 'Administration'),
    ('CAT020', 'Legal');
SELECT id_category, name_category
FROM category;

USE job_board;

INSERT INTO country (id_country, name_country)
VALUES
    ('COUNTRY001', 'Morocco'),
    ('COUNTRY002', 'France'),
    ('COUNTRY003', 'Spain'),
    ('COUNTRY004', 'Germany'),
    ('COUNTRY005', 'Canada'),
    ('COUNTRY006', 'United Kingdom'),
    ('COUNTRY007', 'Belgium'),
    ('COUNTRY008', 'Netherlands');
INSERT INTO city (id_city, name_city, id_country)
VALUES
    ('CITY001', 'Casablanca', 'COUNTRY001'),
    ('CITY002', 'Rabat', 'COUNTRY001'),
    ('CITY003', 'Marrakech', 'COUNTRY001'),
    ('CITY004', 'Tangier', 'COUNTRY001'),

    ('CITY005', 'Paris', 'COUNTRY002'),
    ('CITY006', 'Lyon', 'COUNTRY002'),
    ('CITY007', 'Marseille', 'COUNTRY002'),
    ('CITY008', 'Lille', 'COUNTRY002'),
    ('CITY009', 'Nice', 'COUNTRY002'),
    ('CITY010', 'Toulouse', 'COUNTRY002'),

    ('CITY011', 'Madrid', 'COUNTRY003'),
    ('CITY012', 'Barcelona', 'COUNTRY003'),
    ('CITY013', 'Valencia', 'COUNTRY003'),

    ('CITY014', 'Berlin', 'COUNTRY004'),
    ('CITY015', 'Munich', 'COUNTRY004'),
    ('CITY016', 'Hamburg', 'COUNTRY004'),

    ('CITY017', 'Toronto', 'COUNTRY005'),
    ('CITY018', 'Montreal', 'COUNTRY005'),

    ('CITY019', 'London', 'COUNTRY006'),
    ('CITY020', 'Manchester', 'COUNTRY006'),

    ('CITY021', 'Brussels', 'COUNTRY007'),
    ('CITY022', 'Antwerp', 'COUNTRY007'),

    ('CITY023', 'Amsterdam', 'COUNTRY008'),
    ('CITY024', 'Rotterdam', 'COUNTRY008');

SELECT name_country,name_city
    FROM country
    INNER JOIN city
    ON city.id_country=country.id_country;

 SELECT count(*) FROM job;
 
 USE job_board;
 TRUNCATE job;

INSERT INTO company (id_company, name_company)
VALUES
    ('COMP001', 'TechNova'),
    ('COMP002', 'DataPlus'),
    ('COMP003', 'MarketPro');

INSERT INTO job (
    id_job,
    title_job,
    id_category,
    id_company,
    id_city,
    job_type,
    degree,
    experience,
    min_salary,
    max_salary,
    job_description,
    pro_skills
)
VALUES
(
    'JOB001',
    'Junior Python Developer',
    'CAT001',
    'COMP001',
    'CITY005',
    'Full time',
    'Bac+5',
    1,
    40000,
    45000,
    'Develop and maintain backend applications and REST APIs.',
    'Python, SQL, FastAPI, Git'
),
(
    'JOB002',
    'Data Analyst',
    'CAT015',
    'COMP002',
    'CITY006',
    'Full time',
    'Master',
    3,
    45000,
    55000,
    'Analyze business data, prepare reports, and build dashboards.',
    'SQL, Python, Excel, Power BI'
),
(
    'JOB003',
    'Marketing Assistant',
    'CAT002',
    'COMP003',
    'CITY001',
    'Part time',
    'Bac+3',
    2,
    28000,
    32000,
    'Support digital marketing campaigns and analyze their performance.',
    'SEO, Social Media, Analytics'
);
USE job_board;

SELECT * FROM category;
SELECT * FROM company;
SELECT * FROM city;
SELECT * FROM job;
SELECT * FROM company;

SELECT title_job,id_job FROM job;

ALTER TABLE job 
ADD COLUMN added_time DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL;

UPDATE job
SET added_time='2026-10-25 10:15:00'
WHERE id_job = 'JOB001';

UPDATE job
SET added_time='2026-10-25 10:09:00'
WHERE id_job = 'JOB002';
UPDATE job
SET added_time='2026-10-25 10:05:00'
WHERE id_job = 'JOB003';

SELECT job.title_job,company.name_company,category.name_category,job.job_type,job.min_salary,job.max_salary,city.name_city,country.name_country,job.added_time
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
;

-- Profile data, filled in later from the Profile page
ALTER TABLE users
ADD COLUMN full_name VARCHAR(100) NULL,
ADD COLUMN birth_date DATE NULL,
ADD COLUMN cv MEDIUMBLOB NULL;

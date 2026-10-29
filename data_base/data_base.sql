
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

-- Currency chosen by the admin on the Create Job page
ALTER TABLE job
ADD COLUMN currency VARCHAR(3) NOT NULL DEFAULT 'USD';

SELECT * FROM category;
SELECT * FROM country;
SELECT * FROM city;
USE job_board;

-- Entreprises
INSERT INTO company (id_company, name_company) VALUES
    ('COMP004', 'Orion Tech'),
    ('COMP005', 'Delta Labs'),
    ('COMP006', 'Alpha Solutions'),
    ('COMP007', 'Orion Services'),
    ('COMP008', 'Blue Industries'),
    ('COMP009', 'Oasis Tech'),
    ('COMP010', 'Atlas Group'),
    ('COMP011', 'Vertex Labs'),
    ('COMP012', 'Apex Industries'),
    ('COMP013', 'Atlas Services'),
    ('COMP014', 'Vertex Services'),
    ('COMP015', 'Oasis Labs'),
    ('COMP016', 'Phoenix Industries'),
    ('COMP017', 'Delta Tech'),
    ('COMP018', 'Zenith Digital'),
    ('COMP019', 'Quantum Systems'),
    ('COMP020', 'Helios Labs'),
    ('COMP021', 'Quantum Group'),
    ('COMP022', 'Blue Digital'),
    ('COMP023', 'Orion Consulting'),
    ('COMP024', 'Sahara Industries'),
    ('COMP025', 'Phoenix Services'),
    ('COMP026', 'Orion Digital'),
    ('COMP027', 'Blue Services'),
    ('COMP028', 'Nimbus Industries'),
    ('COMP029', 'Vertex Group'),
    ('COMP030', 'Nova Labs'),
    ('COMP031', 'Nimbus Group'),
    ('COMP032', 'Alpha Group'),
    ('COMP033', 'Medina Systems'),
    ('COMP034', 'Phoenix Consulting'),
    ('COMP035', 'Zenith Consulting'),
    ('COMP036', 'Sahara Labs'),
    ('COMP037', 'Delta Group'),
    ('COMP038', 'Maple Solutions'),
    ('COMP039', 'Cedar Labs'),
    ('COMP040', 'Zenith Partners'),
    ('COMP041', 'Quantum Tech'),
    ('COMP042', 'Alpha Tech'),
    ('COMP043', 'Quantum Digital'),
    ('COMP044', 'Vertex Industries'),
    ('COMP045', 'Quantum Labs'),
    ('COMP046', 'Lumen Digital'),
    ('COMP047', 'Phoenix Solutions'),
    ('COMP048', 'Delta Solutions'),
    ('COMP049', 'Alpha Services'),
    ('COMP050', 'Cedar Systems'),
    ('COMP051', 'Falcon Digital'),
    ('COMP052', 'Helios Services'),
    ('COMP053', 'Lumen Group'),
    ('COMP054', 'Nova Group'),
    ('COMP055', 'Helios Solutions'),
    ('COMP056', 'Oasis Industries'),
    ('COMP057', 'Medina Industries'),
    ('COMP058', 'Delta Services'),
    ('COMP059', 'Nimbus Digital'),
    ('COMP060', 'Atlas Systems'),
    ('COMP061', 'Apex Solutions'),
    ('COMP062', 'Apex Group'),
    ('COMP063', 'Nimbus Services');

-- Offres d'emploi
INSERT INTO job (id_job, title_job, id_category, id_company, id_city, job_type, degree, experience, min_salary, max_salary, job_description, pro_skills, added_time) VALUES
    ('JOB004', 'Intern Corporate Lawyer', 'CAT020', 'COMP021', 'CITY016', 'Internship', 'Bac+2', '0', 12000, 16000, 'Draft legal documents and advise on regulatory matters.', 'Contracts, Legal Research, Compliance', '2026-08-31 11:22:00'),
    ('JOB005', 'Senior Talent Acquisition Specialist', 'CAT012', 'COMP047', 'CITY016', 'Full time', 'Bac+5', '5', 59500, 76500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-08-29 09:55:00'),
    ('JOB006', 'Events Coordinator', 'CAT005', 'COMP047', 'CITY023', 'Full time', 'Bac+3', '3', 49500, 58500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-08-29 18:12:00'),
    ('JOB007', 'Lead Pharmacy Assistant', 'CAT013', 'COMP005', 'CITY011', 'Full time', 'Master', '7', 86500, 103500, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-10-21 04:46:00'),
    ('JOB008', 'Intern Office Assistant', 'CAT019', 'COMP022', 'CITY003', 'Internship', 'Bac+2', '0', 8000, 10500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-24 10:05:00'),
    ('JOB009', 'Intern Backend Developer', 'CAT016', 'COMP031', 'CITY014', 'Internship', 'Bac+2', '0', 12500, 16500, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-09-28 04:10:00'),
    ('JOB010', 'Product Designer', 'CAT004', 'COMP007', 'CITY002', 'Full time', 'Bac+5', '3', 50500, 57000, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-14 15:19:00'),
    ('JOB011', 'Senior Telecom Engineer', 'CAT011', 'COMP012', 'CITY009', 'Full time', 'Master', '5', 58000, 74500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-09-30 07:33:00'),
    ('JOB012', 'Tax Consultant', 'CAT003', 'COMP027', 'CITY016', 'Full time', 'Bac+5', '3', 36000, 43000, 'Prepare financial reports, forecasts and ensure compliance.', 'Excel, Accounting, IFRS', '2026-08-30 04:50:00'),
    ('JOB013', 'Senior Medical Secretary', 'CAT013', 'COMP028', 'CITY023', 'Full time', 'Master', '5', 64000, 76000, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-08-29 21:42:00'),
    ('JOB014', 'Junior Site Manager', 'CAT007', 'COMP004', 'CITY019', 'Full time', 'Bac+5', '1', 32500, 36500, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-11 01:57:00'),
    ('JOB015', 'Lead Digital Marketing Manager', 'CAT002', 'COMP016', 'CITY013', 'Freelance', 'Master', '7', 72000, 91500, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-10-23 14:05:00'),
    ('JOB016', 'Sales Representative', 'CAT008', 'COMP043', 'CITY023', 'Part time', 'Bac+5', '3', 49000, 63000, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-10-08 03:47:00'),
    ('JOB017', 'Instructional Designer', 'CAT009', 'COMP007', 'CITY003', 'Full time', 'Master', '3', 38000, 44000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-28 16:24:00'),
    ('JOB018', 'Junior Technical Support Specialist', 'CAT017', 'COMP054', 'CITY018', 'Freelance', 'Bac+5', '1', 27500, 34000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-10 06:32:00'),
    ('JOB019', 'Junior Logistics Coordinator', 'CAT018', 'COMP036', 'CITY005', 'Contract', 'Bac+5', '1', 26000, 32000, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-10-21 08:13:00'),
    ('JOB020', 'Junior Corporate Lawyer', 'CAT020', 'COMP058', 'CITY002', 'Full time', 'Bac+3', '1', 34000, 40000, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-09-25 20:44:00'),
    ('JOB021', 'Intern Instructional Designer', 'CAT009', 'COMP048', 'CITY015', 'Internship', 'Bac+3', '0', 14000, 16500, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-18 03:50:00'),
    ('JOB022', 'Junior Graphic Designer', 'CAT004', 'COMP009', 'CITY002', 'Full time', 'Bac+5', '1', 29500, 38000, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-09-23 07:33:00'),
    ('JOB023', 'Senior SEO Specialist', 'CAT002', 'COMP056', 'CITY014', 'Part time', 'Bac+5', '5', 73000, 82500, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-05 18:04:00'),
    ('JOB024', 'Lead Journalist', 'CAT006', 'COMP060', 'CITY014', 'Freelance', 'Master', '7', 70500, 83000, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-09-11 01:10:00'),
    ('JOB025', 'Senior Video Editor', 'CAT006', 'COMP059', 'CITY015', 'Full time', 'Master', '5', 53000, 68500, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-10-14 05:08:00'),
    ('JOB026', 'Junior Store Manager', 'CAT008', 'COMP042', 'CITY017', 'Full time', 'Bac+5', '1', 28000, 32500, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-09 03:38:00'),
    ('JOB027', 'Junior System Administrator', 'CAT001', 'COMP023', 'CITY024', 'Full time', 'Bac+5', '1', 28000, 32000, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-10-21 16:33:00'),
    ('JOB028', 'Lead Legal Assistant', 'CAT020', 'COMP028', 'CITY001', 'Full time', 'Master', '7', 88000, 101000, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-10-12 10:15:00'),
    ('JOB029', 'Intern Industrial Engineer', 'CAT014', 'COMP058', 'CITY010', 'Internship', 'Bac+3', '0', 12500, 15500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-09-16 08:14:00'),
    ('JOB030', 'RF Engineer', 'CAT011', 'COMP048', 'CITY006', 'Full time', 'Master', '3', 42000, 54500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-15 23:17:00'),
    ('JOB031', 'Nurse', 'CAT013', 'COMP042', 'CITY011', 'Full time', 'Bac+5', '3', 42500, 55000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-07 17:22:00'),
    ('JOB032', 'Machine Learning Engineer', 'CAT015', 'COMP041', 'CITY020', 'Full time', 'Bac+5', '3', 41000, 48000, 'Collect, model and analyze data to support decision making.', 'SQL, Python, Power BI', '2026-10-09 19:18:00'),
    ('JOB033', 'Intern Store Manager', 'CAT008', 'COMP040', 'CITY003', 'Internship', 'Bac+3', '0', 9000, 11000, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-10-26 04:30:00'),
    ('JOB034', 'Junior Administrative Officer', 'CAT019', 'COMP058', 'CITY004', 'Full time', 'Bac+5', '1', 27500, 32500, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-16 14:00:00'),
    ('JOB035', 'Senior Content Producer', 'CAT006', 'COMP009', 'CITY015', 'Full time', 'Master', '5', 69500, 81000, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-08-31 08:31:00'),
    ('JOB036', 'Intern Legal Counsel', 'CAT020', 'COMP056', 'CITY016', 'Internship', 'Bac+3', '0', 12000, 15500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-09-01 06:13:00'),
    ('JOB037', 'Intern Account Executive', 'CAT008', 'COMP029', 'CITY003', 'Internship', 'Bac+3', '0', 12000, 15500, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-09-18 04:43:00'),
    ('JOB038', 'Junior Language Teacher', 'CAT009', 'COMP046', 'CITY007', 'Full time', 'Bac+3', '1', 26000, 31500, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-03 13:51:00'),
    ('JOB039', 'Junior Quality Engineer', 'CAT014', 'COMP002', 'CITY019', 'Full time', 'Bac+5', '1', 27000, 34000, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-10-03 17:16:00'),
    ('JOB040', 'Intern System Administrator', 'CAT001', 'COMP052', 'CITY020', 'Internship', 'Bac+2', '0', 11000, 15000, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-09-10 12:26:00'),
    ('JOB041', 'Junior Business Developer', 'CAT008', 'COMP011', 'CITY015', 'Full time', 'Bac+3', '1', 29000, 38000, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-09-14 23:14:00'),
    ('JOB042', 'Nurse', 'CAT013', 'COMP004', 'CITY009', 'Full time', 'Bac+5', '3', 49500, 57500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-02 21:49:00'),
    ('JOB043', 'Intern Quantity Surveyor', 'CAT007', 'COMP054', 'CITY003', 'Internship', 'Bac+3', '0', 11000, 14000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-09 22:44:00'),
    ('JOB044', 'Intern Warehouse Manager', 'CAT018', 'COMP049', 'CITY001', 'Internship', 'Bac+2', '0', 9500, 11500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-08 15:58:00'),
    ('JOB045', 'Network Administrator', 'CAT001', 'COMP050', 'CITY012', 'Full time', 'Bac+3', '3', 39500, 48500, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-09-28 13:44:00'),
    ('JOB046', 'Intern Legal Assistant', 'CAT020', 'COMP060', 'CITY010', 'Internship', 'Bac+3', '0', 9000, 12000, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-10-21 17:59:00'),
    ('JOB047', 'Junior Civil Engineer', 'CAT007', 'COMP052', 'CITY004', 'Full time', 'Bac+3', '1', 36000, 42000, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-09-03 14:22:00'),
    ('JOB048', 'Warehouse Manager', 'CAT018', 'COMP032', 'CITY004', 'Full time', 'Bac+5', '3', 46500, 52500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-03 22:08:00'),
    ('JOB049', 'BI Developer', 'CAT015', 'COMP047', 'CITY019', 'Full time', 'Bac+5', '3', 44500, 58000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-28 22:08:00'),
    ('JOB050', 'Senior Sales Representative', 'CAT008', 'COMP040', 'CITY022', 'Full time', 'Master', '5', 66000, 77500, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-09 21:24:00'),
    ('JOB051', 'System Administrator', 'CAT001', 'COMP018', 'CITY020', 'Full time', 'Master', '3', 42500, 54000, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-09-07 03:39:00'),
    ('JOB052', 'Intern Supply Chain Analyst', 'CAT018', 'COMP036', 'CITY008', 'Internship', 'Bac+3', '0', 8500, 11000, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-11 22:29:00'),
    ('JOB053', 'Senior Data Analyst', 'CAT015', 'COMP038', 'CITY012', 'Full time', 'Master', '5', 64500, 83500, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-10-13 02:18:00'),
    ('JOB054', 'Junior Technical Support Specialist', 'CAT017', 'COMP008', 'CITY024', 'Full time', 'Bac+3', '1', 31000, 37000, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-10-09 03:46:00'),
    ('JOB055', 'Senior Graphic Designer', 'CAT004', 'COMP034', 'CITY020', 'Full time', 'Master', '5', 67000, 79000, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-09-11 17:12:00'),
    ('JOB056', 'Junior Quantity Surveyor', 'CAT007', 'COMP063', 'CITY002', 'Full time', 'Bac+5', '1', 24000, 32000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-10-20 03:58:00'),
    ('JOB057', 'Junior Frontend Developer', 'CAT016', 'COMP062', 'CITY002', 'Full time', 'Bac+5', '1', 31500, 39000, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-09-30 01:49:00'),
    ('JOB058', 'Senior Motion Designer', 'CAT004', 'COMP010', 'CITY019', 'Full time', 'Master', '5', 70000, 88000, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-09-15 10:51:00'),
    ('JOB059', 'Junior Business Developer', 'CAT008', 'COMP029', 'CITY015', 'Part time', 'Bac+5', '1', 33500, 39000, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-08 19:36:00'),
    ('JOB060', 'Bank Advisor', 'CAT010', 'COMP043', 'CITY003', 'Part time', 'Bac+3', '3', 39000, 48000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-18 05:44:00'),
    ('JOB061', 'Journalist', 'CAT006', 'COMP019', 'CITY023', 'Full time', 'Bac+5', '3', 50000, 63500, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-10-10 10:46:00'),
    ('JOB062', 'Intern Auditor', 'CAT003', 'COMP008', 'CITY018', 'Internship', 'Bac+2', '0', 13000, 17000, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-09-16 05:33:00'),
    ('JOB063', 'Senior Tour Guide', 'CAT005', 'COMP037', 'CITY010', 'Full time', 'Master', '5', 57000, 69500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-19 12:08:00'),
    ('JOB064', 'BI Developer', 'CAT015', 'COMP003', 'CITY014', 'Contract', 'Master', '3', 52000, 65500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-30 09:22:00'),
    ('JOB065', 'Junior Legal Assistant', 'CAT020', 'COMP044', 'CITY009', 'Full time', 'Bac+3', '1', 34500, 43000, 'Draft legal documents and advise on regulatory matters.', 'Contracts, Legal Research, Compliance', '2026-09-21 11:12:00'),
    ('JOB066', 'Mobile Developer', 'CAT016', 'COMP031', 'CITY012', 'Freelance', 'Bac+5', '3', 41500, 54000, 'Build, test and maintain high quality software applications.', 'Node.js, MySQL, Docker, Git', '2026-09-17 20:55:00'),
    ('JOB067', 'Network Technician', 'CAT011', 'COMP049', 'CITY018', 'Full time', 'Bac+3', '3', 51500, 62000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-15 23:08:00'),
    ('JOB068', 'Junior Auditor', 'CAT003', 'COMP001', 'CITY022', 'Full time', 'Bac+5', '1', 36000, 43000, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-02 19:08:00'),
    ('JOB069', 'Junior Content Marketer', 'CAT002', 'COMP018', 'CITY018', 'Part time', 'Bac+3', '1', 31500, 40500, 'Plan and run marketing campaigns and measure their performance.', 'Social Media, Canva, Copywriting', '2026-09-30 10:47:00'),
    ('JOB070', 'Senior BI Developer', 'CAT015', 'COMP011', 'CITY010', 'Full time', 'Bac+5', '5', 72000, 89500, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-09-07 04:15:00'),
    ('JOB071', 'Junior Mechanical Engineer', 'CAT014', 'COMP060', 'CITY023', 'Full time', 'Bac+5', '1', 25500, 34500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-09-05 07:29:00'),
    ('JOB072', 'Senior Quality Engineer', 'CAT014', 'COMP039', 'CITY017', 'Full time', 'Bac+5', '5', 69500, 79500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-04 05:02:00'),
    ('JOB073', 'Senior Academic Advisor', 'CAT009', 'COMP047', 'CITY010', 'Full time', 'Master', '5', 68000, 80000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-06 11:42:00'),
    ('JOB074', 'Data Scientist', 'CAT015', 'COMP013', 'CITY023', 'Full time', 'Bac+3', '3', 48000, 61000, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-08-30 01:05:00'),
    ('JOB075', 'Junior Lab Technician', 'CAT013', 'COMP043', 'CITY021', 'Full time', 'Bac+3', '1', 35500, 43000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-12 23:36:00'),
    ('JOB076', 'Junior Brand Manager', 'CAT002', 'COMP030', 'CITY001', 'Full time', 'Bac+3', '1', 25500, 33000, 'Plan and run marketing campaigns and measure their performance.', 'Social Media, Canva, Copywriting', '2026-10-21 19:02:00'),
    ('JOB077', 'Junior Restaurant Manager', 'CAT005', 'COMP022', 'CITY022', 'Full time', 'Bac+5', '1', 35000, 42000, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-09-17 09:06:00'),
    ('JOB078', 'Senior Frontend Developer', 'CAT016', 'COMP048', 'CITY003', 'Part time', 'Master', '5', 59500, 77500, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-09-15 02:46:00'),
    ('JOB079', 'Product Designer', 'CAT004', 'COMP023', 'CITY012', 'Freelance', 'Bac+5', '3', 37000, 48000, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-09-08 10:42:00'),
    ('JOB080', 'Retail Advisor', 'CAT008', 'COMP056', 'CITY013', 'Part time', 'Master', '3', 41500, 50000, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-10-17 09:21:00'),
    ('JOB081', 'Senior Backend Developer', 'CAT016', 'COMP001', 'CITY015', 'Full time', 'Master', '5', 72000, 84000, 'Build, test and maintain high quality software applications.', 'Python, Django, REST, SQL', '2026-09-29 03:18:00'),
    ('JOB082', 'Auditor', 'CAT003', 'COMP055', 'CITY010', 'Contract', 'Bac+3', '3', 45500, 58000, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-14 03:31:00'),
    ('JOB083', 'Junior Mobile Developer', 'CAT016', 'COMP063', 'CITY022', 'Full time', 'Bac+5', '1', 33000, 39000, 'Build, test and maintain high quality software applications.', 'Node.js, MySQL, Docker, Git', '2026-09-14 02:59:00'),
    ('JOB084', 'Intern Cloud Engineer', 'CAT001', 'COMP058', 'CITY010', 'Internship', 'Bac+2', '0', 8000, 12000, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-09-10 20:07:00'),
    ('JOB085', 'Junior Recruiter', 'CAT012', 'COMP007', 'CITY021', 'Part time', 'Bac+3', '1', 34500, 43500, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-09-15 07:20:00'),
    ('JOB086', 'Intern Data Scientist', 'CAT015', 'COMP048', 'CITY014', 'Internship', 'Bac+2', '0', 13500, 16000, 'Collect, model and analyze data to support decision making.', 'SQL, Python, Power BI', '2026-10-23 02:40:00'),
    ('JOB087', 'Senior Restaurant Manager', 'CAT005', 'COMP019', 'CITY024', 'Full time', 'Master', '5', 60500, 71000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-11 20:09:00'),
    ('JOB088', 'Intern Data Engineer', 'CAT015', 'COMP006', 'CITY013', 'Internship', 'Bac+2', '0', 9500, 13000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-03 18:37:00'),
    ('JOB089', 'Junior Warehouse Manager', 'CAT018', 'COMP041', 'CITY012', 'Part time', 'Bac+3', '1', 34500, 40500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-20 23:08:00'),
    ('JOB090', 'Intern QA Engineer', 'CAT016', 'COMP041', 'CITY015', 'Internship', 'Bac+3', '0', 10500, 14500, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-10-13 15:56:00'),
    ('JOB091', 'Junior UI/UX Designer', 'CAT004', 'COMP035', 'CITY005', 'Full time', 'Bac+5', '1', 31500, 36000, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-10-22 04:04:00'),
    ('JOB092', 'HR Business Partner', 'CAT012', 'COMP032', 'CITY020', 'Full time', 'Bac+5', '3', 40500, 53000, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-09-17 08:07:00'),
    ('JOB093', 'SEO Specialist', 'CAT002', 'COMP035', 'CITY021', 'Full time', 'Bac+5', '3', 43500, 55000, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-21 14:37:00'),
    ('JOB094', 'Junior Nurse', 'CAT013', 'COMP041', 'CITY020', 'Contract', 'Bac+3', '1', 31000, 35500, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-09-16 05:19:00'),
    ('JOB095', 'Intern Network Technician', 'CAT011', 'COMP038', 'CITY007', 'Internship', 'Bac+2', '0', 9500, 11500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-04 18:47:00'),
    ('JOB096', 'Senior Events Coordinator', 'CAT005', 'COMP012', 'CITY004', 'Full time', 'Bac+5', '5', 56500, 66500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-24 03:09:00'),
    ('JOB097', 'Network Administrator', 'CAT001', 'COMP048', 'CITY014', 'Full time', 'Master', '3', 36500, 45000, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-10-12 10:52:00'),
    ('JOB098', 'Auditor', 'CAT003', 'COMP003', 'CITY024', 'Full time', 'Master', '3', 39000, 52000, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-09-26 04:21:00'),
    ('JOB099', 'Bank Advisor', 'CAT010', 'COMP032', 'CITY023', 'Full time', 'Bac+5', '3', 51000, 63000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-30 14:54:00'),
    ('JOB100', 'Junior Accountant', 'CAT003', 'COMP046', 'CITY011', 'Full time', 'Bac+5', '1', 28000, 36500, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-09-17 17:25:00'),
    ('JOB101', 'Junior Customer Success Manager', 'CAT017', 'COMP057', 'CITY018', 'Full time', 'Bac+3', '1', 35000, 39500, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-03 15:19:00'),
    ('JOB102', 'Senior BI Developer', 'CAT015', 'COMP021', 'CITY014', 'Full time', 'Master', '5', 66500, 80500, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-10-01 12:54:00'),
    ('JOB103', 'Training Coordinator', 'CAT009', 'COMP028', 'CITY004', 'Part time', 'Master', '3', 51000, 58000, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-23 09:55:00');

INSERT INTO job (id_job, title_job, id_category, id_company, id_city, job_type, degree, experience, min_salary, max_salary, job_description, pro_skills, added_time) VALUES
    ('JOB104', 'Events Coordinator', 'CAT005', 'COMP043', 'CITY014', 'Contract', 'Master', '3', 46500, 54000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-02 00:05:00'),
    ('JOB105', 'Risk Analyst', 'CAT010', 'COMP015', 'CITY004', 'Full time', 'Bac+5', '3', 52000, 61000, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-10-18 14:30:00'),
    ('JOB106', 'Senior Art Director', 'CAT004', 'COMP044', 'CITY021', 'Full time', 'Bac+5', '5', 65500, 82000, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-08 16:21:00'),
    ('JOB107', 'Intern Instructional Designer', 'CAT009', 'COMP001', 'CITY006', 'Internship', 'Bac+2', '0', 13500, 16500, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-08-31 01:38:00'),
    ('JOB108', 'Junior Controller', 'CAT003', 'COMP030', 'CITY011', 'Contract', 'Bac+3', '1', 25000, 33000, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-10-14 23:34:00'),
    ('JOB109', 'Senior Compliance Officer', 'CAT010', 'COMP044', 'CITY003', 'Full time', 'Master', '5', 53500, 63500, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-10-17 16:57:00'),
    ('JOB110', 'Quality Engineer', 'CAT014', 'COMP008', 'CITY010', 'Full time', 'Master', '3', 42500, 56500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-10-21 00:33:00'),
    ('JOB111', 'Customer Support Agent', 'CAT017', 'COMP050', 'CITY005', 'Full time', 'Bac+5', '3', 37500, 43500, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-10-15 02:47:00'),
    ('JOB112', 'Intern Customer Solutions Engineer', 'CAT011', 'COMP015', 'CITY017', 'Internship', 'Bac+3', '0', 9000, 11500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-10-03 18:15:00'),
    ('JOB113', 'Senior Nurse', 'CAT013', 'COMP028', 'CITY019', 'Full time', 'Master', '5', 66500, 75500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-03 01:24:00'),
    ('JOB114', 'Junior Bank Advisor', 'CAT010', 'COMP024', 'CITY003', 'Contract', 'Bac+5', '1', 26500, 35000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-28 13:02:00'),
    ('JOB115', 'Business Developer', 'CAT008', 'COMP022', 'CITY006', 'Full time', 'Bac+3', '3', 48500, 59000, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-09-11 01:46:00'),
    ('JOB116', 'Technical Support Specialist', 'CAT017', 'COMP013', 'CITY006', 'Full time', 'Master', '3', 40500, 50000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-22 07:44:00'),
    ('JOB117', 'Junior Controller', 'CAT003', 'COMP044', 'CITY019', 'Full time', 'Bac+5', '1', 36000, 44500, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-09-09 17:32:00'),
    ('JOB118', 'Junior Telecom Engineer', 'CAT011', 'COMP004', 'CITY012', 'Full time', 'Bac+3', '1', 34000, 40000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-08 03:23:00'),
    ('JOB119', 'Data Analyst', 'CAT015', 'COMP039', 'CITY017', 'Full time', 'Bac+5', '3', 45000, 52000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-17 09:21:00'),
    ('JOB120', 'Office Assistant', 'CAT019', 'COMP010', 'CITY002', 'Full time', 'Bac+5', '3', 42000, 53000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-19 20:28:00'),
    ('JOB121', 'Lead Telecom Engineer', 'CAT011', 'COMP029', 'CITY017', 'Full time', 'Master', '7', 75500, 86000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-12 13:32:00'),
    ('JOB122', 'Senior Payroll Officer', 'CAT012', 'COMP041', 'CITY021', 'Full time', 'Master', '5', 62500, 81000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-20 10:10:00'),
    ('JOB123', 'Junior Customer Solutions Engineer', 'CAT011', 'COMP010', 'CITY011', 'Full time', 'Bac+3', '1', 35500, 44500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-08-30 16:05:00'),
    ('JOB124', 'Junior Payroll Officer', 'CAT012', 'COMP042', 'CITY011', 'Full time', 'Bac+3', '1', 35000, 39500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-08 18:36:00'),
    ('JOB125', 'Mechanical Engineer', 'CAT014', 'COMP015', 'CITY005', 'Full time', 'Bac+3', '3', 41500, 50500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-06 20:48:00'),
    ('JOB126', 'Senior Bank Advisor', 'CAT010', 'COMP043', 'CITY011', 'Full time', 'Bac+5', '5', 69000, 88500, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-09-01 19:58:00'),
    ('JOB127', 'Intern Events Coordinator', 'CAT005', 'COMP044', 'CITY024', 'Internship', 'Bac+2', '0', 9000, 12500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-25 22:37:00'),
    ('JOB128', 'Junior Legal Counsel', 'CAT020', 'COMP054', 'CITY007', 'Full time', 'Bac+5', '1', 27500, 33500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-09-06 20:03:00'),
    ('JOB129', 'Senior BI Developer', 'CAT015', 'COMP039', 'CITY005', 'Full time', 'Master', '5', 65000, 75500, 'Collect, model and analyze data to support decision making.', 'SQL, Python, Power BI', '2026-09-06 05:09:00'),
    ('JOB130', 'Senior QA Engineer', 'CAT016', 'COMP006', 'CITY006', 'Contract', 'Master', '5', 74500, 90500, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-09-04 08:42:00'),
    ('JOB131', 'Junior Customer Success Manager', 'CAT017', 'COMP002', 'CITY014', 'Full time', 'Bac+3', '1', 27500, 35000, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-02 00:01:00'),
    ('JOB132', 'Customer Success Manager', 'CAT017', 'COMP007', 'CITY023', 'Contract', 'Master', '3', 47500, 57000, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-10-27 01:01:00'),
    ('JOB133', 'Junior Restaurant Manager', 'CAT005', 'COMP029', 'CITY020', 'Freelance', 'Bac+3', '1', 31500, 36500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-09 13:30:00'),
    ('JOB134', 'Junior Network Administrator', 'CAT001', 'COMP050', 'CITY010', 'Full time', 'Bac+3', '1', 35500, 44000, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-09-24 22:53:00'),
    ('JOB135', 'Intern Motion Designer', 'CAT004', 'COMP054', 'CITY016', 'Internship', 'Bac+2', '0', 13000, 17000, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-29 09:53:00'),
    ('JOB136', 'Call Center Advisor', 'CAT017', 'COMP012', 'CITY022', 'Full time', 'Master', '3', 36000, 47500, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-12 17:34:00'),
    ('JOB137', 'Lead Customer Support Agent', 'CAT017', 'COMP002', 'CITY013', 'Contract', 'Doctorate', '7', 87000, 105000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-07 19:25:00'),
    ('JOB138', 'Intern Pharmacy Assistant', 'CAT013', 'COMP043', 'CITY021', 'Internship', 'Bac+2', '0', 10500, 12500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-10-06 04:14:00'),
    ('JOB139', 'Intern Events Coordinator', 'CAT005', 'COMP063', 'CITY023', 'Internship', 'Bac+3', '0', 10500, 13000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-04 14:31:00'),
    ('JOB140', 'Intern Travel Consultant', 'CAT005', 'COMP013', 'CITY002', 'Internship', 'Bac+3', '0', 8000, 11000, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-16 10:10:00'),
    ('JOB141', 'Customer Success Manager', 'CAT017', 'COMP042', 'CITY011', 'Full time', 'Bac+5', '3', 42000, 52500, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-06 10:05:00'),
    ('JOB142', 'Intern Payroll Officer', 'CAT012', 'COMP032', 'CITY012', 'Internship', 'Bac+3', '0', 11000, 14000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-16 20:16:00'),
    ('JOB143', 'Junior Maintenance Engineer', 'CAT014', 'COMP006', 'CITY011', 'Contract', 'Bac+5', '1', 26500, 34500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-10-10 01:54:00'),
    ('JOB144', 'BI Developer', 'CAT015', 'COMP056', 'CITY012', 'Full time', 'Master', '3', 50000, 61500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-30 10:14:00'),
    ('JOB145', 'Teacher Assistant', 'CAT009', 'COMP011', 'CITY001', 'Full time', 'Bac+3', '3', 48500, 60000, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-09-25 12:17:00'),
    ('JOB146', 'Intern SEO Specialist', 'CAT002', 'COMP039', 'CITY005', 'Internship', 'Bac+3', '0', 10500, 13500, 'Plan and run marketing campaigns and measure their performance.', 'Social Media, Canva, Copywriting', '2026-10-03 17:58:00'),
    ('JOB147', 'HR Assistant', 'CAT012', 'COMP016', 'CITY004', 'Full time', 'Bac+3', '3', 47500, 59500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-07 15:43:00'),
    ('JOB148', 'QA Engineer', 'CAT016', 'COMP045', 'CITY016', 'Full time', 'Bac+3', '3', 44000, 57000, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-10-14 16:42:00'),
    ('JOB149', 'Senior Travel Consultant', 'CAT005', 'COMP021', 'CITY022', 'Full time', 'Master', '5', 74500, 89500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-22 14:06:00'),
    ('JOB150', 'Warehouse Manager', 'CAT018', 'COMP013', 'CITY005', 'Freelance', 'Bac+3', '3', 41500, 53000, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-26 04:53:00'),
    ('JOB151', 'DevOps Engineer', 'CAT001', 'COMP046', 'CITY024', 'Full time', 'Bac+5', '3', 40000, 47000, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-10-24 02:35:00'),
    ('JOB152', 'Senior Maintenance Engineer', 'CAT014', 'COMP044', 'CITY017', 'Full time', 'Master', '5', 62000, 80000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-23 21:31:00'),
    ('JOB153', 'Intern Supply Chain Analyst', 'CAT018', 'COMP008', 'CITY017', 'Internship', 'Bac+2', '0', 9000, 12500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-26 10:07:00'),
    ('JOB154', 'Junior Journalist', 'CAT006', 'COMP013', 'CITY021', 'Full time', 'Bac+5', '1', 32000, 38000, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-09-04 09:44:00'),
    ('JOB155', 'Bank Advisor', 'CAT010', 'COMP047', 'CITY020', 'Full time', 'Bac+5', '3', 41000, 49000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-10-17 14:21:00'),
    ('JOB156', 'Intern Cloud Engineer', 'CAT001', 'COMP040', 'CITY021', 'Internship', 'Bac+2', '0', 10000, 12500, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-09-08 17:34:00'),
    ('JOB157', 'Junior Warehouse Manager', 'CAT018', 'COMP045', 'CITY002', 'Full time', 'Bac+3', '1', 34500, 41500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-10-08 21:56:00'),
    ('JOB158', 'Electrical Engineer', 'CAT014', 'COMP047', 'CITY012', 'Full time', 'Bac+5', '3', 40500, 51500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-02 13:40:00'),
    ('JOB159', 'HR Assistant', 'CAT012', 'COMP010', 'CITY004', 'Full time', 'Bac+3', '3', 50500, 58000, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-10-10 21:45:00'),
    ('JOB160', 'Senior Lab Technician', 'CAT013', 'COMP021', 'CITY007', 'Full time', 'Bac+5', '5', 57000, 70000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-08-29 17:14:00'),
    ('JOB161', 'Technical Support Specialist', 'CAT017', 'COMP014', 'CITY019', 'Full time', 'Bac+5', '3', 38500, 50500, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-25 21:45:00'),
    ('JOB162', 'Junior Brand Manager', 'CAT002', 'COMP001', 'CITY004', 'Freelance', 'Bac+5', '1', 34000, 43000, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-09-28 02:26:00'),
    ('JOB163', 'Senior Academic Advisor', 'CAT009', 'COMP024', 'CITY018', 'Full time', 'Master', '5', 64500, 73000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-21 18:48:00'),
    ('JOB164', 'Health Administrator', 'CAT013', 'COMP051', 'CITY011', 'Full time', 'Master', '3', 39500, 47500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-10-21 23:37:00'),
    ('JOB165', 'Junior Events Coordinator', 'CAT005', 'COMP022', 'CITY016', 'Full time', 'Bac+5', '1', 24500, 28500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-26 07:15:00'),
    ('JOB166', 'Senior Paralegal', 'CAT020', 'COMP048', 'CITY010', 'Full time', 'Master', '5', 71500, 84500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-10-17 23:21:00'),
    ('JOB167', 'Junior Office Assistant', 'CAT019', 'COMP051', 'CITY024', 'Full time', 'Bac+3', '1', 34500, 39000, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-01 17:41:00'),
    ('JOB168', 'Lead Language Teacher', 'CAT009', 'COMP034', 'CITY021', 'Full time', 'Doctorate', '7', 93000, 103500, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-20 20:50:00'),
    ('JOB169', 'Intern Sales Representative', 'CAT008', 'COMP010', 'CITY014', 'Internship', 'Bac+2', '0', 9500, 11500, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-30 01:34:00'),
    ('JOB170', 'Senior Customer Success Manager', 'CAT017', 'COMP014', 'CITY018', 'Freelance', 'Master', '5', 75000, 83500, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-13 07:27:00'),
    ('JOB171', 'Call Center Advisor', 'CAT017', 'COMP042', 'CITY023', 'Full time', 'Bac+5', '3', 46500, 58000, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-14 12:17:00'),
    ('JOB172', 'Lead Quantity Surveyor', 'CAT007', 'COMP014', 'CITY023', 'Full time', 'Doctorate', '7', 77000, 102000, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-10-09 02:15:00'),
    ('JOB173', 'Junior Software Engineer', 'CAT016', 'COMP058', 'CITY013', 'Full time', 'Bac+5', '1', 25500, 34000, 'Build, test and maintain high quality software applications.', 'Python, Django, REST, SQL', '2026-09-14 18:36:00'),
    ('JOB174', 'Intern Bank Advisor', 'CAT010', 'COMP031', 'CITY007', 'Internship', 'Bac+2', '0', 10500, 14000, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-09-17 03:13:00'),
    ('JOB175', 'Supply Chain Analyst', 'CAT018', 'COMP034', 'CITY008', 'Full time', 'Master', '3', 43500, 53000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-24 14:03:00'),
    ('JOB176', 'Intern Content Marketer', 'CAT002', 'COMP011', 'CITY014', 'Internship', 'Bac+3', '0', 8500, 11000, 'Plan and run marketing campaigns and measure their performance.', 'Social Media, Canva, Copywriting', '2026-10-27 18:01:00'),
    ('JOB177', 'Senior Quantity Surveyor', 'CAT007', 'COMP037', 'CITY008', 'Full time', 'Bac+5', '5', 72500, 81000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-08-31 09:19:00'),
    ('JOB178', 'Senior Electrical Engineer', 'CAT014', 'COMP060', 'CITY024', 'Contract', 'Master', '5', 53000, 67000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-07 20:49:00'),
    ('JOB179', 'Junior DevOps Engineer', 'CAT001', 'COMP034', 'CITY016', 'Full time', 'Bac+3', '1', 29000, 35000, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-09-28 15:26:00'),
    ('JOB180', 'Junior Data Analyst', 'CAT015', 'COMP012', 'CITY001', 'Full time', 'Bac+5', '1', 35500, 43000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-17 03:15:00'),
    ('JOB181', 'Executive Assistant', 'CAT019', 'COMP026', 'CITY022', 'Full time', 'Bac+3', '3', 48500, 61000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-26 01:55:00'),
    ('JOB182', 'Tour Guide', 'CAT005', 'COMP020', 'CITY019', 'Full time', 'Master', '3', 48000, 57500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-30 03:39:00'),
    ('JOB183', 'Training Coordinator', 'CAT009', 'COMP044', 'CITY017', 'Full time', 'Master', '3', 39500, 52500, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-09 06:35:00'),
    ('JOB184', 'Product Designer', 'CAT004', 'COMP030', 'CITY024', 'Full time', 'Master', '3', 43000, 52500, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-10-19 20:51:00'),
    ('JOB185', 'Intern Quality Engineer', 'CAT014', 'COMP049', 'CITY020', 'Internship', 'Bac+2', '0', 14000, 16500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-09-10 04:17:00'),
    ('JOB186', 'Customer Support Agent', 'CAT017', 'COMP033', 'CITY007', 'Freelance', 'Master', '3', 39500, 46000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-04 18:03:00'),
    ('JOB187', 'Junior Content Producer', 'CAT006', 'COMP006', 'CITY017', 'Full time', 'Bac+5', '1', 34500, 40000, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-09-12 17:29:00'),
    ('JOB188', 'Junior BI Developer', 'CAT015', 'COMP020', 'CITY024', 'Full time', 'Bac+3', '1', 24500, 32500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-28 14:09:00'),
    ('JOB189', 'Senior Training Coordinator', 'CAT009', 'COMP035', 'CITY002', 'Full time', 'Bac+5', '5', 53000, 67500, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-05 13:56:00'),
    ('JOB190', 'Intern SEO Specialist', 'CAT002', 'COMP056', 'CITY013', 'Internship', 'Bac+3', '0', 14000, 17500, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-04 23:32:00'),
    ('JOB191', 'Junior Warehouse Manager', 'CAT018', 'COMP063', 'CITY008', 'Full time', 'Bac+3', '1', 32500, 39500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-25 07:14:00'),
    ('JOB192', 'Compliance Officer', 'CAT010', 'COMP010', 'CITY009', 'Full time', 'Bac+3', '3', 48000, 57500, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-10-12 21:38:00'),
    ('JOB193', 'Senior Social Media Manager', 'CAT002', 'COMP039', 'CITY002', 'Part time', 'Master', '5', 52500, 64000, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-10-15 09:54:00'),
    ('JOB194', 'Junior Digital Marketing Manager', 'CAT002', 'COMP033', 'CITY010', 'Full time', 'Bac+3', '1', 27500, 35500, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-10-15 10:52:00'),
    ('JOB195', 'Junior Receptionist', 'CAT019', 'COMP020', 'CITY009', 'Full time', 'Bac+3', '1', 26000, 35000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-25 04:34:00'),
    ('JOB196', 'Mechanical Engineer', 'CAT014', 'COMP027', 'CITY005', 'Contract', 'Bac+5', '3', 48000, 62000, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-10-07 13:34:00'),
    ('JOB197', 'Senior Photographer', 'CAT006', 'COMP052', 'CITY015', 'Full time', 'Bac+5', '5', 59000, 71500, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-09-03 13:51:00'),
    ('JOB198', 'Electrical Engineer', 'CAT014', 'COMP060', 'CITY015', 'Full time', 'Bac+5', '3', 44000, 53000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-06 15:55:00'),
    ('JOB199', 'Senior Supply Chain Analyst', 'CAT018', 'COMP056', 'CITY003', 'Full time', 'Bac+5', '5', 64000, 82500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-19 16:58:00'),
    ('JOB200', 'Junior Full Stack Developer', 'CAT016', 'COMP008', 'CITY024', 'Full time', 'Bac+5', '1', 24000, 29500, 'Build, test and maintain high quality software applications.', 'Python, Django, REST, SQL', '2026-08-30 05:13:00'),
    ('JOB201', 'Legal Counsel', 'CAT020', 'COMP042', 'CITY012', 'Freelance', 'Bac+5', '3', 46000, 56500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-10-03 21:26:00'),
    ('JOB202', 'Payroll Officer', 'CAT012', 'COMP021', 'CITY014', 'Full time', 'Bac+3', '3', 51000, 62000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-08-31 05:37:00'),
    ('JOB203', 'Intern Events Coordinator', 'CAT005', 'COMP010', 'CITY007', 'Internship', 'Bac+3', '0', 12500, 16500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-11 22:42:00');

INSERT INTO job (id_job, title_job, id_category, id_company, id_city, job_type, degree, experience, min_salary, max_salary, job_description, pro_skills, added_time) VALUES
    ('JOB204', 'Medical Secretary', 'CAT013', 'COMP042', 'CITY024', 'Full time', 'Bac+5', '3', 46500, 56500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-09 20:14:00'),
    ('JOB205', 'Senior Community Manager', 'CAT006', 'COMP057', 'CITY018', 'Full time', 'Bac+5', '5', 75000, 91500, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-09-27 06:02:00'),
    ('JOB206', 'Lead Controller', 'CAT003', 'COMP005', 'CITY023', 'Full time', 'Master', '7', 70000, 86500, 'Prepare financial reports, forecasts and ensure compliance.', 'Excel, Accounting, IFRS', '2026-10-19 15:46:00'),
    ('JOB207', 'Quantity Surveyor', 'CAT007', 'COMP036', 'CITY014', 'Full time', 'Bac+3', '3', 51000, 64500, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-10-27 11:26:00'),
    ('JOB208', 'Senior Technical Support Specialist', 'CAT017', 'COMP059', 'CITY004', 'Full time', 'Bac+5', '5', 74000, 92500, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-01 06:54:00'),
    ('JOB209', 'Intern Quantity Surveyor', 'CAT007', 'COMP030', 'CITY019', 'Internship', 'Bac+2', '0', 10000, 13500, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-10-23 00:35:00'),
    ('JOB210', 'Bank Advisor', 'CAT010', 'COMP036', 'CITY016', 'Part time', 'Bac+3', '3', 37000, 44000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-10-02 23:36:00'),
    ('JOB211', 'Junior Photographer', 'CAT006', 'COMP034', 'CITY002', 'Part time', 'Bac+3', '1', 29000, 37500, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-09-04 08:03:00'),
    ('JOB212', 'Office Assistant', 'CAT019', 'COMP062', 'CITY007', 'Freelance', 'Master', '3', 44500, 51000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-10-17 01:59:00'),
    ('JOB213', 'Lead Pharmacy Assistant', 'CAT013', 'COMP058', 'CITY018', 'Full time', 'Doctorate', '7', 77500, 96500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-04 23:17:00'),
    ('JOB214', 'Senior Hotel Receptionist', 'CAT005', 'COMP054', 'CITY003', 'Full time', 'Master', '5', 63000, 71500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-21 22:46:00'),
    ('JOB215', 'Intern RF Engineer', 'CAT011', 'COMP036', 'CITY013', 'Internship', 'Bac+3', '0', 14000, 17500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-09-27 04:38:00'),
    ('JOB216', 'Intern Office Assistant', 'CAT019', 'COMP018', 'CITY005', 'Internship', 'Bac+3', '0', 10000, 12500, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-13 09:55:00'),
    ('JOB217', 'Junior Nurse', 'CAT013', 'COMP009', 'CITY003', 'Full time', 'Bac+3', '1', 28500, 36000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-10-05 03:54:00'),
    ('JOB218', 'Machine Learning Engineer', 'CAT015', 'COMP039', 'CITY020', 'Full time', 'Bac+5', '3', 36500, 43500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-10-05 18:55:00'),
    ('JOB219', 'Intern Cybersecurity Analyst', 'CAT001', 'COMP034', 'CITY006', 'Internship', 'Bac+3', '0', 13500, 17500, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-09-01 04:24:00'),
    ('JOB220', 'Junior Restaurant Manager', 'CAT005', 'COMP020', 'CITY016', 'Full time', 'Bac+3', '1', 25000, 30000, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-01 03:34:00'),
    ('JOB221', 'Lead Academic Advisor', 'CAT009', 'COMP001', 'CITY013', 'Full time', 'Doctorate', '7', 76000, 93000, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-22 07:41:00'),
    ('JOB222', 'Intern Customer Solutions Engineer', 'CAT011', 'COMP039', 'CITY023', 'Internship', 'Bac+2', '0', 13000, 17000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-20 02:40:00'),
    ('JOB223', 'Junior Customer Solutions Engineer', 'CAT011', 'COMP016', 'CITY011', 'Contract', 'Bac+5', '1', 28500, 37500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-26 17:10:00'),
    ('JOB224', 'Health Administrator', 'CAT013', 'COMP061', 'CITY023', 'Full time', 'Bac+3', '3', 41500, 47500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-08-28 12:31:00'),
    ('JOB225', 'Intern Bank Advisor', 'CAT010', 'COMP041', 'CITY010', 'Internship', 'Bac+2', '0', 14000, 17500, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-09-14 20:52:00'),
    ('JOB226', 'Senior Travel Consultant', 'CAT005', 'COMP033', 'CITY023', 'Full time', 'Master', '5', 71000, 86500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-20 23:26:00'),
    ('JOB227', 'HR Business Partner', 'CAT012', 'COMP043', 'CITY012', 'Full time', 'Bac+3', '3', 38500, 46000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-09 04:18:00'),
    ('JOB228', 'Lead Administrative Officer', 'CAT019', 'COMP001', 'CITY004', 'Contract', 'Doctorate', '7', 80500, 105500, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-07 22:54:00'),
    ('JOB229', 'Senior Call Center Advisor', 'CAT017', 'COMP045', 'CITY017', 'Full time', 'Bac+5', '5', 64500, 79500, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-08 14:23:00'),
    ('JOB230', 'System Administrator', 'CAT001', 'COMP023', 'CITY010', 'Full time', 'Bac+5', '3', 38500, 46000, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-09-04 12:51:00'),
    ('JOB231', 'Quantity Surveyor', 'CAT007', 'COMP003', 'CITY023', 'Full time', 'Bac+3', '3', 50000, 63000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-10-08 09:41:00'),
    ('JOB232', 'Network Technician', 'CAT011', 'COMP022', 'CITY018', 'Freelance', 'Bac+5', '3', 43500, 57500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-16 18:50:00'),
    ('JOB233', 'Senior Store Manager', 'CAT008', 'COMP040', 'CITY007', 'Full time', 'Master', '5', 73000, 87500, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-10-03 11:13:00'),
    ('JOB234', 'Intern Medical Secretary', 'CAT013', 'COMP051', 'CITY003', 'Internship', 'Bac+2', '0', 9500, 12500, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-09-09 13:09:00'),
    ('JOB235', 'Junior Payroll Officer', 'CAT012', 'COMP039', 'CITY013', 'Full time', 'Bac+5', '1', 34500, 42000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-24 15:40:00'),
    ('JOB236', 'Junior Payroll Officer', 'CAT012', 'COMP006', 'CITY022', 'Part time', 'Bac+3', '1', 34500, 40500, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-08-30 16:23:00'),
    ('JOB237', 'Junior UI/UX Designer', 'CAT004', 'COMP039', 'CITY005', 'Full time', 'Bac+5', '1', 35000, 40000, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-09-25 23:34:00'),
    ('JOB238', 'Content Producer', 'CAT006', 'COMP012', 'CITY011', 'Part time', 'Bac+5', '3', 41500, 50000, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-09-27 02:52:00'),
    ('JOB239', 'Lead Payroll Officer', 'CAT012', 'COMP032', 'CITY014', 'Full time', 'Doctorate', '7', 82000, 107000, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-09-22 19:19:00'),
    ('JOB240', 'Data Analyst', 'CAT015', 'COMP035', 'CITY010', 'Full time', 'Bac+3', '3', 43000, 53500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-10-26 03:46:00'),
    ('JOB241', 'Senior Administrative Officer', 'CAT019', 'COMP035', 'CITY012', 'Full time', 'Bac+5', '5', 55500, 72500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-21 03:11:00'),
    ('JOB242', 'Junior Transport Planner', 'CAT018', 'COMP017', 'CITY012', 'Full time', 'Bac+3', '1', 34000, 39500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-10-09 10:32:00'),
    ('JOB243', 'Senior Graphic Designer', 'CAT004', 'COMP041', 'CITY014', 'Full time', 'Bac+5', '5', 70500, 89500, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-10-05 13:21:00'),
    ('JOB244', 'Intern Tour Guide', 'CAT005', 'COMP035', 'CITY006', 'Internship', 'Bac+3', '0', 12500, 15500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-09-24 03:22:00'),
    ('JOB245', 'Compliance Officer', 'CAT010', 'COMP004', 'CITY009', 'Contract', 'Master', '3', 39000, 47000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-09 22:02:00'),
    ('JOB246', 'Intern Restaurant Manager', 'CAT005', 'COMP041', 'CITY009', 'Internship', 'Bac+3', '0', 14000, 17500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-09-27 07:24:00'),
    ('JOB247', 'Junior Data Analyst', 'CAT015', 'COMP061', 'CITY016', 'Full time', 'Bac+5', '1', 35500, 41500, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-09-14 00:31:00'),
    ('JOB248', 'Senior Cloud Engineer', 'CAT001', 'COMP055', 'CITY003', 'Full time', 'Master', '5', 66500, 84500, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-09-15 13:38:00'),
    ('JOB249', 'Senior Quality Engineer', 'CAT014', 'COMP037', 'CITY016', 'Full time', 'Master', '5', 61000, 74000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-22 17:52:00'),
    ('JOB250', 'Junior Social Media Manager', 'CAT002', 'COMP013', 'CITY023', 'Full time', 'Bac+3', '1', 26500, 34000, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-09-29 11:33:00'),
    ('JOB251', 'Junior Risk Analyst', 'CAT010', 'COMP058', 'CITY021', 'Full time', 'Bac+3', '1', 29500, 35500, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-10-23 00:18:00'),
    ('JOB252', 'Medical Secretary', 'CAT013', 'COMP005', 'CITY005', 'Full time', 'Master', '3', 38500, 46000, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-10-28 05:30:00'),
    ('JOB253', 'Customer Support Agent', 'CAT017', 'COMP009', 'CITY016', 'Full time', 'Bac+3', '3', 46500, 54000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-02 22:16:00'),
    ('JOB254', 'Junior Nurse', 'CAT013', 'COMP053', 'CITY005', 'Full time', 'Bac+3', '1', 29500, 35500, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-10-19 23:11:00'),
    ('JOB255', 'Call Center Advisor', 'CAT017', 'COMP044', 'CITY015', 'Full time', 'Bac+3', '3', 42500, 50500, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-08-30 22:21:00'),
    ('JOB256', 'Junior UI/UX Designer', 'CAT004', 'COMP009', 'CITY008', 'Full time', 'Bac+5', '1', 30000, 36500, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-10-01 01:10:00'),
    ('JOB257', 'Junior Tax Consultant', 'CAT003', 'COMP055', 'CITY022', 'Part time', 'Bac+5', '1', 33500, 39500, 'Prepare financial reports, forecasts and ensure compliance.', 'Excel, Accounting, IFRS', '2026-09-08 13:59:00'),
    ('JOB258', 'Intern Call Center Advisor', 'CAT017', 'COMP025', 'CITY004', 'Internship', 'Bac+2', '0', 10000, 12000, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-08 04:29:00'),
    ('JOB259', 'Intern Legal Assistant', 'CAT020', 'COMP054', 'CITY019', 'Internship', 'Bac+3', '0', 10500, 13500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-10-19 23:05:00'),
    ('JOB260', 'Transport Planner', 'CAT018', 'COMP017', 'CITY007', 'Contract', 'Bac+3', '3', 38000, 44000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-21 10:00:00'),
    ('JOB261', 'Intern Health Administrator', 'CAT013', 'COMP035', 'CITY020', 'Internship', 'Bac+2', '0', 11000, 14500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-10-22 15:26:00'),
    ('JOB262', 'Junior Tax Consultant', 'CAT003', 'COMP041', 'CITY021', 'Freelance', 'Bac+3', '1', 26000, 34000, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-10-07 23:23:00'),
    ('JOB263', 'Senior Electrical Engineer', 'CAT014', 'COMP039', 'CITY002', 'Full time', 'Master', '5', 54500, 69000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-20 21:21:00'),
    ('JOB264', 'Intern Graphic Designer', 'CAT004', 'COMP034', 'CITY017', 'Internship', 'Bac+3', '0', 13500, 15500, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-10-17 20:38:00'),
    ('JOB265', 'Intern Talent Acquisition Specialist', 'CAT012', 'COMP034', 'CITY003', 'Internship', 'Bac+3', '0', 8500, 10500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-06 22:43:00'),
    ('JOB266', 'Full Stack Developer', 'CAT016', 'COMP007', 'CITY019', 'Full time', 'Master', '3', 41000, 52500, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-10-18 03:11:00'),
    ('JOB267', 'Senior Sales Representative', 'CAT008', 'COMP025', 'CITY005', 'Full time', 'Bac+5', '5', 52000, 63500, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-10-25 20:37:00'),
    ('JOB268', 'Senior Transport Planner', 'CAT018', 'COMP018', 'CITY003', 'Full time', 'Master', '5', 59500, 74000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-08-30 12:40:00'),
    ('JOB269', 'Customer Support Agent', 'CAT017', 'COMP019', 'CITY010', 'Full time', 'Bac+5', '3', 37000, 49000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-23 21:05:00'),
    ('JOB270', 'Warehouse Manager', 'CAT018', 'COMP063', 'CITY016', 'Full time', 'Bac+3', '3', 45500, 55000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-29 00:23:00'),
    ('JOB271', 'Intern Travel Consultant', 'CAT005', 'COMP054', 'CITY023', 'Internship', 'Bac+2', '0', 8000, 10500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-09-24 00:20:00'),
    ('JOB272', 'Intern Cybersecurity Analyst', 'CAT001', 'COMP063', 'CITY008', 'Internship', 'Bac+3', '0', 13500, 16500, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-10-22 05:27:00'),
    ('JOB273', 'Intern SEO Specialist', 'CAT002', 'COMP055', 'CITY017', 'Internship', 'Bac+3', '0', 8500, 10500, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-08-31 04:03:00'),
    ('JOB274', 'HR Assistant', 'CAT012', 'COMP038', 'CITY019', 'Full time', 'Bac+3', '3', 52000, 60000, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-09-17 23:56:00'),
    ('JOB275', 'Junior Restaurant Manager', 'CAT005', 'COMP015', 'CITY003', 'Freelance', 'Bac+3', '1', 30000, 36500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-07 21:43:00'),
    ('JOB276', 'Junior Office Assistant', 'CAT019', 'COMP023', 'CITY007', 'Full time', 'Bac+5', '1', 31000, 37500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-02 08:26:00'),
    ('JOB277', 'Junior Data Analyst', 'CAT015', 'COMP039', 'CITY002', 'Full time', 'Bac+3', '1', 34500, 40500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-05 13:16:00'),
    ('JOB278', 'Junior Tour Guide', 'CAT005', 'COMP017', 'CITY006', 'Contract', 'Bac+3', '1', 30000, 38000, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-24 14:41:00'),
    ('JOB279', 'Machine Learning Engineer', 'CAT015', 'COMP001', 'CITY002', 'Full time', 'Bac+3', '3', 50500, 58000, 'Collect, model and analyze data to support decision making.', 'SQL, Python, Power BI', '2026-09-07 07:53:00'),
    ('JOB280', 'Senior Quantity Surveyor', 'CAT007', 'COMP059', 'CITY003', 'Part time', 'Bac+5', '5', 72500, 81500, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-20 17:44:00'),
    ('JOB281', 'Intern Architect', 'CAT007', 'COMP004', 'CITY006', 'Internship', 'Bac+3', '0', 8500, 11500, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-10-21 10:31:00'),
    ('JOB282', 'Intern Software Engineer', 'CAT016', 'COMP012', 'CITY009', 'Internship', 'Bac+3', '0', 11000, 13500, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-10-06 05:02:00'),
    ('JOB283', 'Intern Events Coordinator', 'CAT005', 'COMP027', 'CITY018', 'Internship', 'Bac+3', '0', 12500, 15000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-17 02:29:00'),
    ('JOB284', 'Junior Accountant', 'CAT003', 'COMP035', 'CITY001', 'Full time', 'Bac+5', '1', 34000, 42000, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-10-12 15:09:00'),
    ('JOB285', 'Payroll Officer', 'CAT012', 'COMP002', 'CITY011', 'Full time', 'Master', '3', 52000, 63000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-04 03:49:00'),
    ('JOB286', 'Senior System Administrator', 'CAT001', 'COMP063', 'CITY006', 'Full time', 'Bac+5', '5', 67000, 83000, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-10-05 17:46:00'),
    ('JOB287', 'Intern Sales Representative', 'CAT008', 'COMP060', 'CITY006', 'Internship', 'Bac+2', '0', 9500, 13500, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-09-03 23:38:00'),
    ('JOB288', 'Junior Receptionist', 'CAT019', 'COMP010', 'CITY019', 'Freelance', 'Bac+3', '1', 24000, 30500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-08-28 17:24:00'),
    ('JOB289', 'Junior Transport Planner', 'CAT018', 'COMP034', 'CITY016', 'Full time', 'Bac+3', '1', 24500, 30000, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-20 04:59:00'),
    ('JOB290', 'Junior Paralegal', 'CAT020', 'COMP038', 'CITY023', 'Full time', 'Bac+3', '1', 26500, 33000, 'Draft legal documents and advise on regulatory matters.', 'Contracts, Legal Research, Compliance', '2026-10-25 11:51:00'),
    ('JOB291', 'Senior Customer Support Agent', 'CAT017', 'COMP020', 'CITY011', 'Full time', 'Bac+5', '5', 73000, 87000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-21 08:39:00'),
    ('JOB292', 'Senior Quality Engineer', 'CAT014', 'COMP060', 'CITY020', 'Part time', 'Master', '5', 57500, 76500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-22 13:04:00'),
    ('JOB293', 'Senior Administrative Officer', 'CAT019', 'COMP001', 'CITY023', 'Full time', 'Master', '5', 74000, 86500, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-10-20 06:14:00'),
    ('JOB294', 'Content Producer', 'CAT006', 'COMP005', 'CITY008', 'Full time', 'Bac+5', '3', 39000, 52500, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-10-19 01:13:00'),
    ('JOB295', 'Intern Video Editor', 'CAT006', 'COMP014', 'CITY008', 'Internship', 'Bac+2', '0', 13000, 16000, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-09-30 11:44:00'),
    ('JOB296', 'Senior Teacher Assistant', 'CAT009', 'COMP027', 'CITY016', 'Full time', 'Master', '5', 66000, 85500, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-02 06:04:00'),
    ('JOB297', 'Intern Transport Planner', 'CAT018', 'COMP052', 'CITY002', 'Internship', 'Bac+3', '0', 12500, 15000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-17 21:56:00'),
    ('JOB298', 'Junior Telecom Engineer', 'CAT011', 'COMP036', 'CITY003', 'Full time', 'Bac+5', '1', 26500, 33500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-17 12:56:00'),
    ('JOB299', 'Cloud Engineer', 'CAT001', 'COMP014', 'CITY007', 'Full time', 'Bac+5', '3', 49500, 58000, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-10-25 08:39:00'),
    ('JOB300', 'Senior Warehouse Manager', 'CAT018', 'COMP037', 'CITY018', 'Part time', 'Master', '5', 61500, 73000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-22 10:35:00'),
    ('JOB301', 'Social Media Manager', 'CAT002', 'COMP011', 'CITY021', 'Full time', 'Bac+5', '3', 51000, 60000, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-22 11:47:00'),
    ('JOB302', 'Intern Full Stack Developer', 'CAT016', 'COMP006', 'CITY021', 'Internship', 'Bac+3', '0', 11500, 15000, 'Build, test and maintain high quality software applications.', 'Python, Django, REST, SQL', '2026-08-31 14:44:00'),
    ('JOB303', 'Senior Talent Acquisition Specialist', 'CAT012', 'COMP015', 'CITY009', 'Full time', 'Bac+5', '5', 53000, 65000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-29 21:44:00');

INSERT INTO job (id_job, title_job, id_category, id_company, id_city, job_type, degree, experience, min_salary, max_salary, job_description, pro_skills, added_time) VALUES
    ('JOB304', 'Intern Product Designer', 'CAT004', 'COMP054', 'CITY013', 'Internship', 'Bac+3', '0', 11000, 15000, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-10-13 18:57:00'),
    ('JOB305', 'Backend Developer', 'CAT016', 'COMP033', 'CITY019', 'Full time', 'Master', '3', 38500, 50500, 'Build, test and maintain high quality software applications.', 'Python, Django, REST, SQL', '2026-08-31 13:58:00'),
    ('JOB306', 'Lead Motion Designer', 'CAT004', 'COMP003', 'CITY014', 'Full time', 'Master', '7', 75000, 88000, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-07 05:52:00'),
    ('JOB307', 'Intern Electrical Engineer', 'CAT014', 'COMP052', 'CITY003', 'Internship', 'Bac+2', '0', 10000, 13000, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-08-30 12:02:00'),
    ('JOB308', 'Warehouse Manager', 'CAT018', 'COMP038', 'CITY017', 'Freelance', 'Bac+5', '3', 50500, 56500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-07 13:21:00'),
    ('JOB309', 'Junior Maintenance Engineer', 'CAT014', 'COMP050', 'CITY004', 'Full time', 'Bac+5', '1', 36000, 40500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-08-30 08:24:00'),
    ('JOB310', 'Junior Quality Engineer', 'CAT014', 'COMP010', 'CITY020', 'Full time', 'Bac+5', '1', 31500, 35500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-17 03:35:00'),
    ('JOB311', 'Senior Pharmacy Assistant', 'CAT013', 'COMP024', 'CITY001', 'Part time', 'Master', '5', 53500, 73000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-28 03:03:00'),
    ('JOB312', 'Junior Wealth Manager', 'CAT010', 'COMP020', 'CITY024', 'Freelance', 'Bac+5', '1', 34500, 39000, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-09-03 04:52:00'),
    ('JOB313', 'Senior Language Teacher', 'CAT009', 'COMP032', 'CITY017', 'Part time', 'Master', '5', 58000, 73000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-10-14 22:13:00'),
    ('JOB314', 'Senior Customer Support Agent', 'CAT017', 'COMP037', 'CITY001', 'Full time', 'Bac+5', '5', 68000, 82000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-19 19:04:00'),
    ('JOB315', 'Senior Civil Engineer', 'CAT007', 'COMP024', 'CITY015', 'Full time', 'Master', '5', 53500, 67000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-13 05:43:00'),
    ('JOB316', 'Junior Cybersecurity Analyst', 'CAT001', 'COMP023', 'CITY006', 'Full time', 'Bac+5', '1', 26500, 34000, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-09-20 18:38:00'),
    ('JOB317', 'Junior Credit Analyst', 'CAT003', 'COMP015', 'CITY022', 'Full time', 'Bac+3', '1', 33000, 38500, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-04 04:19:00'),
    ('JOB318', 'Mechanical Engineer', 'CAT014', 'COMP017', 'CITY020', 'Full time', 'Bac+5', '3', 40000, 48500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-09-20 11:46:00'),
    ('JOB319', 'Senior Industrial Engineer', 'CAT014', 'COMP053', 'CITY020', 'Full time', 'Master', '5', 58500, 73500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-08 14:27:00'),
    ('JOB320', 'Cloud Engineer', 'CAT001', 'COMP031', 'CITY003', 'Contract', 'Bac+5', '3', 47500, 58000, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-10-08 14:54:00'),
    ('JOB321', 'Senior RF Engineer', 'CAT011', 'COMP049', 'CITY008', 'Part time', 'Bac+5', '5', 72500, 85000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-16 07:27:00'),
    ('JOB322', 'Telecom Engineer', 'CAT011', 'COMP025', 'CITY024', 'Part time', 'Bac+3', '3', 45000, 55000, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-08-30 22:35:00'),
    ('JOB323', 'Senior Network Technician', 'CAT011', 'COMP033', 'CITY010', 'Part time', 'Bac+5', '5', 72000, 87500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-08-30 14:38:00'),
    ('JOB324', 'Intern Insurance Agent', 'CAT010', 'COMP058', 'CITY011', 'Internship', 'Bac+2', '0', 13500, 17500, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-10 06:17:00'),
    ('JOB325', 'Junior Talent Acquisition Specialist', 'CAT012', 'COMP030', 'CITY004', 'Full time', 'Bac+5', '1', 29000, 35500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-11 17:42:00'),
    ('JOB326', 'Office Assistant', 'CAT019', 'COMP034', 'CITY010', 'Full time', 'Bac+5', '3', 42000, 56000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-10-20 14:36:00'),
    ('JOB327', 'Junior Tour Guide', 'CAT005', 'COMP046', 'CITY006', 'Full time', 'Bac+3', '1', 33000, 40500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-19 01:05:00'),
    ('JOB328', 'Network Technician', 'CAT011', 'COMP049', 'CITY006', 'Full time', 'Master', '3', 37500, 43500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-09-30 03:47:00'),
    ('JOB329', 'Senior Frontend Developer', 'CAT016', 'COMP062', 'CITY016', 'Full time', 'Master', '5', 65500, 83500, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-09-30 23:33:00'),
    ('JOB330', 'Growth Marketer', 'CAT002', 'COMP002', 'CITY022', 'Full time', 'Bac+3', '3', 36000, 47000, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-09-09 19:48:00'),
    ('JOB331', 'Junior Account Executive', 'CAT008', 'COMP011', 'CITY003', 'Full time', 'Bac+3', '1', 25500, 32500, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-25 17:41:00'),
    ('JOB332', 'Compliance Officer', 'CAT010', 'COMP022', 'CITY016', 'Full time', 'Bac+5', '3', 46500, 59000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-01 14:52:00'),
    ('JOB333', 'Lead Photographer', 'CAT006', 'COMP002', 'CITY019', 'Full time', 'Master', '7', 77000, 98500, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-10-20 05:14:00'),
    ('JOB334', 'HR Assistant', 'CAT012', 'COMP007', 'CITY021', 'Full time', 'Bac+3', '3', 44000, 50500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-20 10:18:00'),
    ('JOB335', 'Motion Designer', 'CAT004', 'COMP045', 'CITY022', 'Full time', 'Master', '3', 44000, 57500, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-09-14 07:47:00'),
    ('JOB336', 'Bank Advisor', 'CAT010', 'COMP047', 'CITY020', 'Part time', 'Bac+3', '3', 44500, 52500, 'Advise clients on financial products and manage risk.', 'Insurance, Compliance, Reporting', '2026-10-02 08:28:00'),
    ('JOB337', 'Senior Motion Designer', 'CAT004', 'COMP023', 'CITY023', 'Full time', 'Master', '5', 58000, 78000, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-10-11 19:48:00'),
    ('JOB338', 'Intern Photographer', 'CAT006', 'COMP001', 'CITY022', 'Internship', 'Bac+2', '0', 9500, 13000, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-10-07 05:00:00'),
    ('JOB339', 'Executive Assistant', 'CAT019', 'COMP058', 'CITY009', 'Contract', 'Master', '3', 52000, 59000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-11 12:54:00'),
    ('JOB340', 'Lead Data Scientist', 'CAT015', 'COMP003', 'CITY010', 'Full time', 'Doctorate', '7', 71500, 83000, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-09-06 06:05:00'),
    ('JOB341', 'Telecom Engineer', 'CAT011', 'COMP042', 'CITY006', 'Full time', 'Bac+5', '3', 37000, 43000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-04 07:18:00'),
    ('JOB342', 'Lead Data Scientist', 'CAT015', 'COMP008', 'CITY013', 'Freelance', 'Doctorate', '7', 72500, 88000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-06 01:49:00'),
    ('JOB343', 'Intern Academic Advisor', 'CAT009', 'COMP047', 'CITY002', 'Internship', 'Bac+2', '0', 13000, 15500, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-10-21 07:16:00'),
    ('JOB344', 'Intern Quality Engineer', 'CAT014', 'COMP050', 'CITY012', 'Internship', 'Bac+2', '0', 13000, 16500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-16 16:36:00'),
    ('JOB345', 'Senior Frontend Developer', 'CAT016', 'COMP021', 'CITY001', 'Freelance', 'Bac+5', '5', 66000, 74500, 'Build, test and maintain high quality software applications.', 'Node.js, MySQL, Docker, Git', '2026-10-24 03:19:00'),
    ('JOB346', 'Customer Support Agent', 'CAT017', 'COMP042', 'CITY013', 'Full time', 'Bac+3', '3', 43500, 57000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-10-05 14:17:00'),
    ('JOB347', 'Network Administrator', 'CAT001', 'COMP049', 'CITY016', 'Full time', 'Bac+5', '3', 51000, 64500, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-09-03 06:56:00'),
    ('JOB348', 'Lead Telecom Engineer', 'CAT011', 'COMP016', 'CITY003', 'Full time', 'Doctorate', '7', 87500, 107500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-03 23:08:00'),
    ('JOB349', 'Administrative Officer', 'CAT019', 'COMP007', 'CITY013', 'Full time', 'Bac+5', '3', 39500, 53000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-09-10 15:59:00'),
    ('JOB350', 'Intern Logistics Coordinator', 'CAT018', 'COMP014', 'CITY021', 'Internship', 'Bac+3', '0', 12500, 15500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-01 19:25:00'),
    ('JOB351', 'Intern Recruiter', 'CAT012', 'COMP031', 'CITY023', 'Internship', 'Bac+3', '0', 10500, 14500, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-09-08 16:22:00'),
    ('JOB352', 'Junior Graphic Designer', 'CAT004', 'COMP034', 'CITY012', 'Full time', 'Bac+3', '1', 29500, 38500, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-09-07 02:25:00'),
    ('JOB353', 'Photographer', 'CAT006', 'COMP030', 'CITY007', 'Full time', 'Master', '3', 42000, 51000, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-10-20 23:47:00'),
    ('JOB354', 'Senior UI/UX Designer', 'CAT004', 'COMP043', 'CITY019', 'Freelance', 'Bac+5', '5', 73500, 90500, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-10-20 21:31:00'),
    ('JOB355', 'IT Support Technician', 'CAT001', 'COMP059', 'CITY006', 'Full time', 'Master', '3', 49500, 63000, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-08-29 19:11:00'),
    ('JOB356', 'Senior Journalist', 'CAT006', 'COMP057', 'CITY013', 'Full time', 'Master', '5', 73000, 90500, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-09-20 01:28:00'),
    ('JOB357', 'Instructional Designer', 'CAT009', 'COMP045', 'CITY024', 'Contract', 'Master', '3', 50000, 58000, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-19 22:22:00'),
    ('JOB358', 'Senior Supply Chain Analyst', 'CAT018', 'COMP059', 'CITY022', 'Full time', 'Bac+5', '5', 71500, 90500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-09 14:38:00'),
    ('JOB359', 'Intern Technical Support Specialist', 'CAT017', 'COMP037', 'CITY022', 'Internship', 'Bac+3', '0', 14000, 17000, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-22 20:23:00'),
    ('JOB360', 'Senior Maintenance Engineer', 'CAT014', 'COMP013', 'CITY009', 'Full time', 'Bac+5', '5', 64000, 74000, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-10-24 14:57:00'),
    ('JOB361', 'Junior Teacher Assistant', 'CAT009', 'COMP023', 'CITY015', 'Part time', 'Bac+3', '1', 28500, 34000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-09 18:58:00'),
    ('JOB362', 'Warehouse Manager', 'CAT018', 'COMP063', 'CITY022', 'Part time', 'Bac+5', '3', 37500, 49500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-03 22:10:00'),
    ('JOB363', 'Senior Network Administrator', 'CAT001', 'COMP046', 'CITY021', 'Part time', 'Master', '5', 66000, 77500, 'Maintain and secure IT infrastructure and support internal teams.', 'Security, SIEM, Firewall, ISO 27001', '2026-08-30 15:15:00'),
    ('JOB364', 'Intern Supply Chain Analyst', 'CAT018', 'COMP005', 'CITY006', 'Internship', 'Bac+2', '0', 9500, 12500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-30 06:17:00'),
    ('JOB365', 'Intern Pharmacy Assistant', 'CAT013', 'COMP055', 'CITY009', 'Internship', 'Bac+2', '0', 12000, 15000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-10-20 06:23:00'),
    ('JOB366', 'Data Engineer', 'CAT015', 'COMP054', 'CITY022', 'Full time', 'Bac+5', '3', 46000, 52500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-09-08 15:21:00'),
    ('JOB367', 'Intern Office Assistant', 'CAT019', 'COMP005', 'CITY017', 'Internship', 'Bac+2', '0', 10500, 14500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-14 06:27:00'),
    ('JOB368', 'Logistics Coordinator', 'CAT018', 'COMP014', 'CITY020', 'Full time', 'Master', '3', 42500, 53500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-10-07 00:42:00'),
    ('JOB369', 'Senior Logistics Coordinator', 'CAT018', 'COMP059', 'CITY020', 'Full time', 'Bac+5', '5', 63000, 78000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-12 15:21:00'),
    ('JOB370', 'Telecom Engineer', 'CAT011', 'COMP050', 'CITY012', 'Full time', 'Master', '3', 45000, 51000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-08-30 19:08:00'),
    ('JOB371', 'Intern Software Engineer', 'CAT016', 'COMP011', 'CITY018', 'Internship', 'Bac+2', '0', 9500, 12500, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-09-26 09:54:00'),
    ('JOB372', 'Civil Engineer', 'CAT007', 'COMP045', 'CITY024', 'Freelance', 'Bac+5', '3', 49500, 57000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-10-14 18:07:00'),
    ('JOB373', 'Intern Restaurant Manager', 'CAT005', 'COMP051', 'CITY009', 'Internship', 'Bac+2', '0', 8000, 10000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-24 10:49:00'),
    ('JOB374', 'Academic Advisor', 'CAT009', 'COMP008', 'CITY018', 'Part time', 'Bac+3', '3', 49500, 60500, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-10-26 23:17:00'),
    ('JOB375', 'Intern Office Assistant', 'CAT019', 'COMP044', 'CITY010', 'Internship', 'Bac+2', '0', 10500, 14500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-22 02:10:00'),
    ('JOB376', 'Data Analyst', 'CAT015', 'COMP052', 'CITY018', 'Full time', 'Bac+5', '3', 43000, 51000, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-09-10 23:10:00'),
    ('JOB377', 'Junior Restaurant Manager', 'CAT005', 'COMP008', 'CITY002', 'Contract', 'Bac+3', '1', 24000, 32000, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-09-02 18:51:00'),
    ('JOB378', 'Logistics Coordinator', 'CAT018', 'COMP033', 'CITY005', 'Full time', 'Bac+3', '3', 47000, 56000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-01 15:06:00'),
    ('JOB379', 'Account Executive', 'CAT008', 'COMP042', 'CITY018', 'Full time', 'Bac+3', '3', 41500, 48000, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-03 18:31:00'),
    ('JOB380', 'Intern Accountant', 'CAT003', 'COMP042', 'CITY008', 'Internship', 'Bac+2', '0', 11500, 14500, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-10-06 07:18:00'),
    ('JOB381', 'Intern Paralegal', 'CAT020', 'COMP043', 'CITY010', 'Internship', 'Bac+2', '0', 10500, 14000, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-09-30 01:21:00'),
    ('JOB382', 'Lead Network Technician', 'CAT011', 'COMP042', 'CITY014', 'Full time', 'Doctorate', '7', 77500, 100000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-10-13 13:13:00'),
    ('JOB383', 'Restaurant Manager', 'CAT005', 'COMP036', 'CITY004', 'Freelance', 'Bac+3', '3', 50500, 63500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-06 02:29:00'),
    ('JOB384', 'Senior Training Coordinator', 'CAT009', 'COMP047', 'CITY003', 'Freelance', 'Bac+5', '5', 58000, 70000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-11 15:56:00'),
    ('JOB385', 'Executive Assistant', 'CAT019', 'COMP026', 'CITY008', 'Freelance', 'Master', '3', 44000, 57500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-09-17 07:37:00'),
    ('JOB386', 'Events Coordinator', 'CAT005', 'COMP055', 'CITY020', 'Full time', 'Master', '3', 47500, 61500, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-10-27 14:45:00'),
    ('JOB387', 'Junior Call Center Advisor', 'CAT017', 'COMP047', 'CITY016', 'Full time', 'Bac+5', '1', 33000, 42000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-03 07:13:00'),
    ('JOB388', 'Senior Store Manager', 'CAT008', 'COMP034', 'CITY012', 'Full time', 'Master', '5', 63500, 75000, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-10-25 14:47:00'),
    ('JOB389', 'Senior Data Analyst', 'CAT015', 'COMP054', 'CITY009', 'Contract', 'Master', '5', 62000, 71500, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-09-12 19:20:00'),
    ('JOB390', 'Transport Planner', 'CAT018', 'COMP063', 'CITY008', 'Part time', 'Master', '3', 47500, 54500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-25 03:36:00'),
    ('JOB391', 'Senior Talent Acquisition Specialist', 'CAT012', 'COMP009', 'CITY015', 'Full time', 'Bac+5', '5', 67000, 84500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-27 19:04:00'),
    ('JOB392', 'Auditor', 'CAT003', 'COMP053', 'CITY004', 'Full time', 'Master', '3', 41500, 50000, 'Prepare financial reports, forecasts and ensure compliance.', 'Excel, Accounting, IFRS', '2026-10-04 16:15:00'),
    ('JOB393', 'Senior Mechanical Engineer', 'CAT014', 'COMP042', 'CITY014', 'Full time', 'Bac+5', '5', 67000, 82500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-10-14 17:50:00'),
    ('JOB394', 'Junior Brand Manager', 'CAT002', 'COMP004', 'CITY006', 'Full time', 'Bac+5', '1', 34000, 42000, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-25 17:51:00'),
    ('JOB395', 'Lead Customer Support Agent', 'CAT017', 'COMP014', 'CITY015', 'Freelance', 'Doctorate', '7', 93000, 113500, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-06 02:55:00'),
    ('JOB396', 'Junior Photographer', 'CAT006', 'COMP017', 'CITY006', 'Part time', 'Bac+5', '1', 33000, 38000, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-09-18 14:28:00'),
    ('JOB397', 'Paralegal', 'CAT020', 'COMP056', 'CITY017', 'Full time', 'Master', '3', 40000, 47500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-10-27 05:27:00'),
    ('JOB398', 'Tour Guide', 'CAT005', 'COMP031', 'CITY022', 'Full time', 'Bac+3', '3', 37000, 51000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-10 08:55:00'),
    ('JOB399', 'Industrial Engineer', 'CAT014', 'COMP050', 'CITY013', 'Freelance', 'Bac+5', '3', 49500, 59000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-08-28 20:10:00'),
    ('JOB400', 'Intern Quality Engineer', 'CAT014', 'COMP017', 'CITY007', 'Internship', 'Bac+2', '0', 8500, 11500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-19 18:34:00'),
    ('JOB401', 'Office Assistant', 'CAT019', 'COMP010', 'CITY014', 'Full time', 'Master', '3', 42500, 53500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-02 00:54:00'),
    ('JOB402', 'Senior Academic Advisor', 'CAT009', 'COMP014', 'CITY014', 'Full time', 'Master', '5', 71500, 83500, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-14 23:12:00'),
    ('JOB403', 'Payroll Officer', 'CAT012', 'COMP048', 'CITY005', 'Full time', 'Master', '3', 45500, 57000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-08 13:35:00');

INSERT INTO job (id_job, title_job, id_category, id_company, id_city, job_type, degree, experience, min_salary, max_salary, job_description, pro_skills, added_time) VALUES
    ('JOB404', 'Store Manager', 'CAT008', 'COMP036', 'CITY020', 'Full time', 'Master', '3', 52000, 64000, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-09-08 01:09:00'),
    ('JOB405', 'Intern Video Editor', 'CAT006', 'COMP006', 'CITY003', 'Internship', 'Bac+3', '0', 9000, 12500, 'Produce and publish engaging media content across channels.', 'Premiere Pro, Storytelling, Photography', '2026-08-29 16:33:00'),
    ('JOB406', 'Intern HR Assistant', 'CAT012', 'COMP046', 'CITY020', 'Internship', 'Bac+2', '0', 11000, 15000, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-09-16 19:42:00'),
    ('JOB407', 'Backend Developer', 'CAT016', 'COMP034', 'CITY023', 'Freelance', 'Bac+3', '3', 45000, 54000, 'Build, test and maintain high quality software applications.', 'Python, Django, REST, SQL', '2026-10-25 16:28:00'),
    ('JOB408', 'Growth Marketer', 'CAT002', 'COMP043', 'CITY013', 'Full time', 'Bac+5', '3', 41000, 48000, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-10-10 23:38:00'),
    ('JOB409', 'Site Manager', 'CAT007', 'COMP039', 'CITY007', 'Freelance', 'Bac+5', '3', 45000, 56500, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-10-06 03:46:00'),
    ('JOB410', 'Intern Executive Assistant', 'CAT019', 'COMP033', 'CITY010', 'Internship', 'Bac+3', '0', 11000, 15000, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-10-21 18:56:00'),
    ('JOB411', 'Lead Technical Support Specialist', 'CAT017', 'COMP022', 'CITY015', 'Part time', 'Doctorate', '7', 82000, 101000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-28 04:12:00'),
    ('JOB412', 'Junior Frontend Developer', 'CAT016', 'COMP021', 'CITY014', 'Full time', 'Bac+5', '1', 27500, 36500, 'Build, test and maintain high quality software applications.', 'React, JavaScript, CSS, Git', '2026-09-14 04:09:00'),
    ('JOB413', 'Junior Teacher Assistant', 'CAT009', 'COMP012', 'CITY016', 'Full time', 'Bac+5', '1', 35500, 42000, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-23 18:01:00'),
    ('JOB414', 'Senior Quantity Surveyor', 'CAT007', 'COMP016', 'CITY024', 'Full time', 'Bac+5', '5', 73500, 84500, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-09-26 12:48:00'),
    ('JOB415', 'Intern Civil Engineer', 'CAT007', 'COMP059', 'CITY003', 'Internship', 'Bac+3', '0', 10500, 13000, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-09 08:53:00'),
    ('JOB416', 'Lead Transport Planner', 'CAT018', 'COMP018', 'CITY016', 'Full time', 'Master', '7', 80000, 97500, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-08-31 17:05:00'),
    ('JOB417', 'Junior Health Administrator', 'CAT013', 'COMP033', 'CITY012', 'Full time', 'Bac+5', '1', 32000, 39000, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-09-27 18:58:00'),
    ('JOB418', 'Lead Machine Learning Engineer', 'CAT015', 'COMP025', 'CITY019', 'Full time', 'Master', '7', 92000, 102000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-10-27 14:47:00'),
    ('JOB419', 'Talent Acquisition Specialist', 'CAT012', 'COMP022', 'CITY012', 'Full time', 'Bac+3', '3', 44000, 53500, 'Support recruitment, onboarding and employee relations.', 'Payroll, Labor Law, Communication', '2026-10-10 20:21:00'),
    ('JOB420', 'Junior Industrial Engineer', 'CAT014', 'COMP009', 'CITY019', 'Full time', 'Bac+3', '1', 30000, 36000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-30 06:24:00'),
    ('JOB421', 'Senior Language Teacher', 'CAT009', 'COMP031', 'CITY001', 'Full time', 'Bac+5', '5', 64000, 75000, 'Support learners and design effective educational content.', 'Curriculum Design, LMS, Presentation', '2026-10-18 12:51:00'),
    ('JOB422', 'Junior Software Engineer', 'CAT016', 'COMP017', 'CITY018', 'Full time', 'Bac+3', '1', 35500, 42000, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-09-07 20:41:00'),
    ('JOB423', 'UI/UX Designer', 'CAT004', 'COMP029', 'CITY024', 'Full time', 'Bac+5', '3', 44000, 57500, 'Design intuitive interfaces and visual identities for digital products.', 'Photoshop, Illustrator, Branding', '2026-09-04 15:54:00'),
    ('JOB424', 'HR Business Partner', 'CAT012', 'COMP023', 'CITY022', 'Contract', 'Master', '3', 44000, 55500, 'Support recruitment, onboarding and employee relations.', 'Recruitment, Interviewing, ATS', '2026-10-26 22:53:00'),
    ('JOB425', 'Executive Assistant', 'CAT019', 'COMP032', 'CITY024', 'Contract', 'Bac+5', '3', 45000, 56500, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-10-07 14:28:00'),
    ('JOB426', 'Lab Technician', 'CAT013', 'COMP041', 'CITY020', 'Part time', 'Master', '3', 40500, 49000, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-18 01:34:00'),
    ('JOB427', 'Junior Auditor', 'CAT003', 'COMP039', 'CITY021', 'Full time', 'Bac+5', '1', 29000, 38000, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-10-09 13:43:00'),
    ('JOB428', 'Intern Data Scientist', 'CAT015', 'COMP055', 'CITY001', 'Internship', 'Bac+2', '0', 12000, 15500, 'Collect, model and analyze data to support decision making.', 'Python, Pandas, Machine Learning', '2026-10-02 06:49:00'),
    ('JOB429', 'Sales Representative', 'CAT008', 'COMP057', 'CITY016', 'Full time', 'Master', '3', 48500, 56000, 'Develop the client portfolio and drive sales growth.', 'Negotiation, CRM, Prospecting', '2026-10-22 09:01:00'),
    ('JOB430', 'Intern DevOps Engineer', 'CAT001', 'COMP006', 'CITY021', 'Internship', 'Bac+3', '0', 8500, 10500, 'Maintain and secure IT infrastructure and support internal teams.', 'AWS, Terraform, CI/CD, Python', '2026-10-11 16:51:00'),
    ('JOB431', 'Junior Account Executive', 'CAT008', 'COMP003', 'CITY022', 'Full time', 'Bac+5', '1', 26000, 31000, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-25 06:59:00'),
    ('JOB432', 'QA Engineer', 'CAT016', 'COMP012', 'CITY019', 'Contract', 'Master', '3', 50000, 58000, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-08-28 13:26:00'),
    ('JOB433', 'Receptionist', 'CAT019', 'COMP020', 'CITY012', 'Freelance', 'Bac+5', '3', 51000, 60500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-09-07 09:32:00'),
    ('JOB434', 'Junior Hotel Receptionist', 'CAT005', 'COMP035', 'CITY001', 'Full time', 'Bac+5', '1', 36000, 41000, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-10-06 02:30:00'),
    ('JOB435', 'Intern Wealth Manager', 'CAT010', 'COMP001', 'CITY018', 'Internship', 'Bac+3', '0', 14000, 17000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-20 04:10:00'),
    ('JOB436', 'Senior Quality Engineer', 'CAT014', 'COMP054', 'CITY013', 'Full time', 'Bac+5', '5', 57000, 76000, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-09-10 15:36:00'),
    ('JOB437', 'Accountant', 'CAT003', 'COMP052', 'CITY009', 'Full time', 'Bac+5', '3', 44500, 55000, 'Prepare financial reports, forecasts and ensure compliance.', 'Excel, Accounting, IFRS', '2026-09-16 12:26:00'),
    ('JOB438', 'Junior Auditor', 'CAT003', 'COMP040', 'CITY016', 'Full time', 'Bac+3', '1', 31000, 39500, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-30 03:16:00'),
    ('JOB439', 'Junior DevOps Engineer', 'CAT001', 'COMP029', 'CITY024', 'Full time', 'Bac+3', '1', 25500, 31500, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-10-11 07:15:00'),
    ('JOB440', 'Junior Credit Analyst', 'CAT003', 'COMP030', 'CITY023', 'Full time', 'Bac+3', '1', 30500, 36500, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-07 20:37:00'),
    ('JOB441', 'Senior Accountant', 'CAT003', 'COMP013', 'CITY009', 'Full time', 'Master', '5', 64500, 73500, 'Prepare financial reports, forecasts and ensure compliance.', 'Excel, Accounting, IFRS', '2026-09-23 20:49:00'),
    ('JOB442', 'Lead Graphic Designer', 'CAT004', 'COMP030', 'CITY024', 'Full time', 'Master', '7', 84000, 97500, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-11 10:48:00'),
    ('JOB443', 'Quantity Surveyor', 'CAT007', 'COMP008', 'CITY009', 'Contract', 'Bac+5', '3', 41000, 47500, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-09-10 18:27:00'),
    ('JOB444', 'Site Manager', 'CAT007', 'COMP021', 'CITY001', 'Freelance', 'Bac+3', '3', 42500, 50000, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-10-12 15:33:00'),
    ('JOB445', 'Junior Executive Assistant', 'CAT019', 'COMP045', 'CITY020', 'Full time', 'Bac+3', '1', 24500, 33000, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-09-07 13:30:00'),
    ('JOB446', 'Junior Credit Analyst', 'CAT003', 'COMP004', 'CITY012', 'Full time', 'Bac+3', '1', 33500, 40000, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-08-29 15:57:00'),
    ('JOB447', 'Senior Supply Chain Analyst', 'CAT018', 'COMP023', 'CITY015', 'Full time', 'Bac+5', '5', 62000, 78500, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-09-07 15:12:00'),
    ('JOB448', 'Medical Secretary', 'CAT013', 'COMP019', 'CITY018', 'Full time', 'Master', '3', 37000, 50500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-09-12 21:25:00'),
    ('JOB449', 'Safety Officer', 'CAT007', 'COMP056', 'CITY018', 'Full time', 'Bac+3', '3', 50500, 60500, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-02 16:02:00'),
    ('JOB450', 'Intern Technical Support Specialist', 'CAT017', 'COMP041', 'CITY017', 'Internship', 'Bac+3', '0', 12000, 15000, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-29 11:11:00'),
    ('JOB451', 'Intern System Administrator', 'CAT001', 'COMP062', 'CITY018', 'Internship', 'Bac+3', '0', 9500, 12500, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-09-12 09:18:00'),
    ('JOB452', 'Call Center Advisor', 'CAT017', 'COMP007', 'CITY017', 'Part time', 'Master', '3', 46000, 58500, 'Assist customers and resolve their issues efficiently.', 'Communication, CRM, Languages', '2026-09-17 01:53:00'),
    ('JOB453', 'Senior SEO Specialist', 'CAT002', 'COMP007', 'CITY002', 'Full time', 'Master', '5', 53000, 64000, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-10-21 20:48:00'),
    ('JOB454', 'Software Engineer', 'CAT016', 'COMP005', 'CITY001', 'Full time', 'Bac+3', '3', 37500, 49000, 'Build, test and maintain high quality software applications.', 'Java, Spring Boot, SQL', '2026-10-13 16:15:00'),
    ('JOB455', 'Controller', 'CAT003', 'COMP053', 'CITY020', 'Full time', 'Bac+5', '3', 49000, 60500, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-09-07 13:57:00'),
    ('JOB456', 'Senior Content Marketer', 'CAT002', 'COMP015', 'CITY018', 'Full time', 'Master', '5', 58500, 74500, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-22 08:14:00'),
    ('JOB457', 'Civil Engineer', 'CAT007', 'COMP041', 'CITY019', 'Full time', 'Bac+5', '3', 41500, 54000, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-09-11 08:11:00'),
    ('JOB458', 'Intern Electrical Engineer', 'CAT014', 'COMP011', 'CITY018', 'Internship', 'Bac+3', '0', 12000, 15500, 'Design, optimize and maintain industrial systems.', 'PLC, Electrical Design, Maintenance', '2026-09-26 01:18:00'),
    ('JOB459', 'Intern RF Engineer', 'CAT011', 'COMP039', 'CITY008', 'Internship', 'Bac+2', '0', 11000, 14500, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-05 12:40:00'),
    ('JOB460', 'Senior Warehouse Manager', 'CAT018', 'COMP003', 'CITY010', 'Full time', 'Bac+5', '5', 66000, 81000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-03 11:14:00'),
    ('JOB461', 'Intern Insurance Agent', 'CAT010', 'COMP018', 'CITY018', 'Internship', 'Bac+2', '0', 9500, 12500, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-10-26 13:08:00'),
    ('JOB462', 'SEO Specialist', 'CAT002', 'COMP020', 'CITY003', 'Full time', 'Master', '3', 47500, 57000, 'Plan and run marketing campaigns and measure their performance.', 'Social Media, Canva, Copywriting', '2026-10-14 03:09:00'),
    ('JOB463', 'Intern Office Assistant', 'CAT019', 'COMP058', 'CITY023', 'Internship', 'Bac+2', '0', 14000, 17500, 'Provide administrative and organisational support to the team.', 'Scheduling, Excel, Documentation', '2026-10-16 20:08:00'),
    ('JOB464', 'Senior Brand Manager', 'CAT002', 'COMP053', 'CITY014', 'Full time', 'Master', '5', 53500, 73500, 'Plan and run marketing campaigns and measure their performance.', 'SEO, Google Ads, Analytics', '2026-10-07 00:04:00'),
    ('JOB465', 'Senior Retail Advisor', 'CAT008', 'COMP020', 'CITY017', 'Freelance', 'Bac+5', '5', 72000, 92000, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-17 23:57:00'),
    ('JOB466', 'Warehouse Manager', 'CAT018', 'COMP026', 'CITY015', 'Full time', 'Master', '3', 43000, 51000, 'Optimize the flow of goods from suppliers to customers.', 'ERP, Inventory, Planning', '2026-10-24 14:14:00'),
    ('JOB467', 'Business Developer', 'CAT008', 'COMP004', 'CITY018', 'Full time', 'Bac+5', '3', 46500, 53500, 'Develop the client portfolio and drive sales growth.', 'Sales, Customer Relations, Reporting', '2026-09-27 17:13:00'),
    ('JOB468', 'Intern Credit Analyst', 'CAT003', 'COMP032', 'CITY013', 'Internship', 'Bac+2', '0', 9000, 11500, 'Prepare financial reports, forecasts and ensure compliance.', 'Audit, Compliance, Reporting', '2026-09-27 18:48:00'),
    ('JOB469', 'Lead Paralegal', 'CAT020', 'COMP060', 'CITY019', 'Full time', 'Master', '7', 78500, 100500, 'Draft legal documents and advise on regulatory matters.', 'Contracts, Legal Research, Compliance', '2026-10-01 01:17:00'),
    ('JOB470', 'Industrial Engineer', 'CAT014', 'COMP023', 'CITY020', 'Full time', 'Bac+5', '3', 47000, 53000, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-09 02:50:00'),
    ('JOB471', 'Intern Data Engineer', 'CAT015', 'COMP006', 'CITY004', 'Internship', 'Bac+2', '0', 9500, 12500, 'Collect, model and analyze data to support decision making.', 'SQL, Python, Power BI', '2026-10-18 12:06:00'),
    ('JOB472', 'Senior Corporate Lawyer', 'CAT020', 'COMP002', 'CITY011', 'Full time', 'Bac+5', '5', 74000, 83500, 'Draft legal documents and advise on regulatory matters.', 'Contracts, Legal Research, Compliance', '2026-10-08 21:30:00'),
    ('JOB473', 'Quantity Surveyor', 'CAT007', 'COMP043', 'CITY017', 'Full time', 'Bac+3', '3', 40500, 46500, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-10-03 17:03:00'),
    ('JOB474', 'Intern Journalist', 'CAT006', 'COMP042', 'CITY001', 'Internship', 'Bac+2', '0', 14000, 18000, 'Produce and publish engaging media content across channels.', 'Writing, Editing, Social Media', '2026-10-11 10:31:00'),
    ('JOB475', 'Instructional Designer', 'CAT009', 'COMP015', 'CITY013', 'Freelance', 'Master', '3', 36500, 47000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-09-02 15:36:00'),
    ('JOB476', 'Telecom Engineer', 'CAT011', 'COMP003', 'CITY008', 'Full time', 'Master', '3', 52000, 65000, 'Deploy and maintain telecommunication networks.', 'Telecom, Troubleshooting, Monitoring', '2026-09-22 13:59:00'),
    ('JOB477', 'Network Technician', 'CAT011', 'COMP063', 'CITY017', 'Full time', 'Bac+5', '3', 47000, 58500, 'Deploy and maintain telecommunication networks.', '5G, Networking, Fiber', '2026-09-18 02:45:00'),
    ('JOB478', 'Senior Teacher Assistant', 'CAT009', 'COMP026', 'CITY022', 'Contract', 'Bac+5', '5', 60500, 72000, 'Support learners and design effective educational content.', 'Pedagogy, E-learning, Communication', '2026-10-19 01:03:00'),
    ('JOB479', 'Health Administrator', 'CAT013', 'COMP028', 'CITY010', 'Freelance', 'Master', '3', 43000, 55500, 'Provide care and administrative support in healthcare settings.', 'Medical Records, Organisation, Communication', '2026-10-12 17:51:00'),
    ('JOB480', 'Data Engineer', 'CAT015', 'COMP058', 'CITY017', 'Part time', 'Bac+3', '3', 42000, 50000, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-10-08 13:15:00'),
    ('JOB481', 'Events Coordinator', 'CAT005', 'COMP008', 'CITY006', 'Freelance', 'Bac+5', '3', 46000, 53000, 'Welcome guests and ensure an excellent hospitality experience.', 'Customer Service, Languages, Booking', '2026-09-22 18:14:00'),
    ('JOB482', 'Senior Cybersecurity Analyst', 'CAT001', 'COMP048', 'CITY009', 'Contract', 'Bac+5', '5', 61500, 76500, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-09-10 15:01:00'),
    ('JOB483', 'Intern UI/UX Designer', 'CAT004', 'COMP040', 'CITY008', 'Internship', 'Bac+2', '0', 12500, 16500, 'Design intuitive interfaces and visual identities for digital products.', 'Figma, Adobe XD, Prototyping', '2026-10-10 16:24:00'),
    ('JOB484', 'Intern Cloud Engineer', 'CAT001', 'COMP046', 'CITY021', 'Internship', 'Bac+3', '0', 9000, 13000, 'Maintain and secure IT infrastructure and support internal teams.', 'Linux, Networking, Docker, Git', '2026-09-03 16:30:00'),
    ('JOB485', 'Medical Secretary', 'CAT013', 'COMP018', 'CITY014', 'Full time', 'Bac+3', '3', 43000, 49500, 'Provide care and administrative support in healthcare settings.', 'Patient Care, Hygiene, Teamwork', '2026-10-02 11:01:00'),
    ('JOB486', 'Intern Architect', 'CAT007', 'COMP030', 'CITY008', 'Internship', 'Bac+3', '0', 12500, 16000, 'Supervise construction projects from planning to delivery.', 'Site Management, Safety, Planning', '2026-09-14 01:05:00'),
    ('JOB487', 'Intern Social Media Manager', 'CAT002', 'COMP039', 'CITY018', 'Internship', 'Bac+2', '0', 11000, 15000, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-08-28 12:24:00'),
    ('JOB488', 'UI/UX Designer', 'CAT004', 'COMP003', 'CITY018', 'Freelance', 'Bac+5', '3', 43500, 57500, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-23 23:13:00'),
    ('JOB489', 'Junior Social Media Manager', 'CAT002', 'COMP019', 'CITY020', 'Full time', 'Bac+3', '1', 28500, 34500, 'Plan and run marketing campaigns and measure their performance.', 'CRM, Email Marketing, A/B Testing', '2026-09-29 06:33:00'),
    ('JOB490', 'Intern Customer Success Manager', 'CAT017', 'COMP012', 'CITY019', 'Internship', 'Bac+2', '0', 11500, 13500, 'Assist customers and resolve their issues efficiently.', 'Ticketing, Problem Solving, Empathy', '2026-09-11 19:53:00'),
    ('JOB491', 'Junior Mechanical Engineer', 'CAT014', 'COMP017', 'CITY011', 'Full time', 'Bac+3', '1', 33000, 38500, 'Design, optimize and maintain industrial systems.', 'SolidWorks, CAD, Quality', '2026-09-01 21:55:00'),
    ('JOB492', 'Junior Credit Analyst', 'CAT003', 'COMP051', 'CITY017', 'Part time', 'Bac+3', '1', 25000, 33000, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-12 23:14:00'),
    ('JOB493', 'Supply Chain Analyst', 'CAT018', 'COMP050', 'CITY023', 'Freelance', 'Bac+3', '3', 40500, 49000, 'Optimize the flow of goods from suppliers to customers.', 'Supply Chain, Excel, Coordination', '2026-09-03 07:49:00'),
    ('JOB494', 'Junior Wealth Manager', 'CAT010', 'COMP001', 'CITY020', 'Full time', 'Bac+5', '1', 26500, 31000, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-01 07:48:00'),
    ('JOB495', 'BI Developer', 'CAT015', 'COMP043', 'CITY016', 'Full time', 'Bac+5', '3', 36000, 49500, 'Collect, model and analyze data to support decision making.', 'Spark, Airflow, SQL, ETL', '2026-10-13 05:23:00'),
    ('JOB496', 'Junior Machine Learning Engineer', 'CAT015', 'COMP053', 'CITY007', 'Full time', 'Bac+3', '1', 32500, 38500, 'Collect, model and analyze data to support decision making.', 'SQL, Python, Power BI', '2026-09-18 15:25:00'),
    ('JOB497', 'Intern Restaurant Manager', 'CAT005', 'COMP037', 'CITY020', 'Internship', 'Bac+3', '0', 8000, 10500, 'Welcome guests and ensure an excellent hospitality experience.', 'Management, Hospitality, Communication', '2026-09-04 10:18:00'),
    ('JOB498', 'Intern Credit Analyst', 'CAT003', 'COMP043', 'CITY023', 'Internship', 'Bac+2', '0', 9000, 11500, 'Prepare financial reports, forecasts and ensure compliance.', 'Financial Modeling, Excel, SAP', '2026-09-15 02:21:00'),
    ('JOB499', 'Office Assistant', 'CAT019', 'COMP005', 'CITY014', 'Full time', 'Master', '3', 45500, 56500, 'Provide administrative and organisational support to the team.', 'Office, Organisation, Communication', '2026-10-04 23:08:00'),
    ('JOB500', 'Bank Advisor', 'CAT010', 'COMP014', 'CITY023', 'Part time', 'Bac+3', '3', 44500, 55500, 'Advise clients on financial products and manage risk.', 'Banking, Risk, Customer Advisory', '2026-09-24 22:27:00'),
    ('JOB501', 'Art Director', 'CAT004', 'COMP021', 'CITY009', 'Contract', 'Master', '3', 51000, 61500, 'Design intuitive interfaces and visual identities for digital products.', 'After Effects, Premiere, Animation', '2026-09-30 16:06:00'),
    ('JOB502', 'Junior Paralegal', 'CAT020', 'COMP032', 'CITY006', 'Part time', 'Bac+3', '1', 31500, 39500, 'Draft legal documents and advise on regulatory matters.', 'Drafting, Litigation, Communication', '2026-09-11 15:29:00'),
    ('JOB503', 'Intern Site Manager', 'CAT007', 'COMP040', 'CITY014', 'Internship', 'Bac+3', '0', 11500, 13500, 'Supervise construction projects from planning to delivery.', 'AutoCAD, Revit, Project Management', '2026-09-11 05:09:00');

SELECT COUNT(*) AS total_jobs FROM job;
SELECT COUNT(*) AS total_companies FROM company;
SELECT
    job.id_job,
    job.title_job,
    job.id_category,
    city.id_country,
    category.name_category,
    country.name_country
FROM job
INNER JOIN city ON job.id_city = city.id_city
INNER JOIN country ON city.id_country = country.id_country
INNER JOIN category ON job.id_category = category.id_category
WHERE job.id_job = 'JOB012';
-- Applications: one row each time a user applies; the admin sees them on the Applications page
-- deleting a job or a user removes its applications too
CREATE TABLE IF NOT EXISTS application(
    id_user varchar(30) NOT NULL,
    id_job varchar(10) NOT NULL,
    applied_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY(id_user, id_job),
    constraint fk_application_user
        FOREIGN KEY(id_user)
        REFERENCES users(id_user) ON DELETE CASCADE,
    constraint fk_application_job
        FOREIGN KEY(id_job)
        REFERENCES job(id_job) ON DELETE CASCADE
);

SELECT * FROM users;

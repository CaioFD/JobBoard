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
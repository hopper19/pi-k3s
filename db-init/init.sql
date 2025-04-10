-- create user and database
CREATE USER docker WITH PASSWORD 'pswd-docker';
CREATE DATABASE docker;
ALTER DATABASE docker OWNER to docker;

-- switch to the newly created database
\c docker

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Added security-related tables
CREATE TABLE account (
    email         varchar(50) primary key,
    password      char(60),
    token         varchar(255),
    enabled        boolean default false,
    status        VARCHAR(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
CREATE TABLE authority (
    email        varchar(50),
    role         varchar(20),
    FOREIGN KEY (email) REFERENCES account(email)
);

-- TODO: track name changes (multivalued, duration, name)
CREATE TABLE profile (
    email           varchar(50) primary key,
    FOREIGN KEY     (email) REFERENCES account(email),
    name            varchar(255),
    experience      varchar(255),
    job_title       varchar(255),
    company         varchar(255),
    location        varchar(255),
    flag_alumni     boolean default false,
    flag_student    boolean default false,
    flag_faculty   boolean default false
);

CREATE TABLE name_history (
    email          varchar(50),
    name           varchar(50),
    effective_date date NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY    (email) REFERENCES account(email),
    PRIMARY KEY    (email, effective_date)
);

CREATE TABLE skills (
    email        varchar(50),
    skill        varchar(255),
    FOREIGN KEY (email) REFERENCES account(email)
);

CREATE TABLE job (
    job_id  serial primary key,
    email   varchar(50),
    title   varchar(255),
    company varchar(255),
    status        VARCHAR(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    location varchar(255),
    field varchar(255),
    description text,
    salary decimal,
    benefits varchar(255),
    rate decimal,
    internship_startdate date,
    internship_enddate date,
    type varchar(255),
    FOREIGN KEY (email) REFERENCES account(email)
);

-- Insert sample accounts
INSERT INTO account (email, password, token, enabled, status) VALUES 
('cuong.nguyen@scranton.edu', crypt('123', gen_salt('bf')), NULL, TRUE, 'ACTIVE'),
('diego.sanchez@scranton.edu', crypt('123', gen_salt('bf')), NULL, TRUE, 'ACTIVE'),
('vero@scranton.edu', crypt('123', gen_salt('bf')), NULL, TRUE, 'ACTIVE'),
('john@scranton.edu', crypt('123', gen_salt('bf')), NULL, TRUE, 'ACTIVE');

-- Insert sample authorities
INSERT INTO authority (email, role) VALUES 
('cuong.nguyen@scranton.edu', 'ROLE_ALUMNI'),
('cuong.nguyen@scranton.edu', 'ROLE_STUDENT'),
('diego.sanchez@scranton.edu', 'ROLE_FACULTY'),
('vero@scranton.edu', 'ROLE_STUDENT'),
('john@scranton.edu', 'ROLE_FACULTY');

-- Insert sample profiles
INSERT INTO profile (email, experience, job_title, company, location, flag_alumni, flag_student, flag_faculty) VALUES 
('cuong.nguyen@scranton.edu', '3 years of software development', 'Software Engineer', 'Monsters, Inc', 'Scranton, PA', true, true, false),
('diego.sanchez@scranton.edu', '10 years in academia', 'Professor', 'University of Scranton', 'Montclair, NJ', false, false, true),
('vero@scranton.edu', '3 years of software development', 'Marriage & Family Therapist', NULL, 'Justice, CA', false, true, false),
('john@scranton.edu', '3 years of software development', 'FPGA Engineer', 'Stark Industries', 'Scranton, PA', false, false, true);

-- Insert sample names
INSERT INTO name_history (email, name) VALUES 
('cuong.nguyen@scranton.edu', 'Cuong Nguyen'),
('diego.sanchez@scranton.edu', 'Diego Sanchez'),
('vero@scranton.edu', 'Vero'),
('john@scranton.edu', 'John');

-- Insert sample skills
INSERT INTO skills (email, skill) VALUES 
('cuong.nguyen@scranton.edu', 'Java'),
('cuong.nguyen@scranton.edu', 'SQL'),
('diego.sanchez@scranton.edu', 'Data Analysis'),
('diego.sanchez@scranton.edu', 'Teaching'),
('vero@scranton.edu', 'SQL'),
('john@scranton.edu', 'SQL');

-- Insert sample jobs
INSERT INTO job (email, title, company, location, field, description, salary, benefits, rate, internship_startdate, internship_enddate, type, status) VALUES 
('cuong.nguyen@scranton.edu', 'Software Engineer', 'Tech Innovations', 'Scranton, PA', 'Engineering', 'Develop and maintain software applications.', 90000, 'Health, Dental, Vision Insurance', NULL, NULL, NULL, 'Full-time', 'ACTIVE'),
('cuong.nguyen@scranton.edu', 'Part-time Web Developer', 'Web Solutions LLC', 'Remote', 'Web Development', 'Assist in developing web applications.', 30, NULL, 25.00, NULL, NULL, 'Part-time', 'ACTIVE'),
('diego.sanchez@scranton.edu', 'Data Science Intern', 'Scranton Analytics', 'Scranton, PA', 'Data Science', 'Analyze data and create machine learning models.', NULL, 'Free lunch', 20.00, '2024-01-01', '2024-05-01', 'Internship', 'ACTIVE');

-- Confirm owner for all inserted records
ALTER TABLE account OWNER TO docker;
ALTER TABLE authority OWNER TO docker;
ALTER TABLE profile OWNER TO docker;
ALTER TABLE name_history OWNER TO docker;
ALTER TABLE skills OWNER TO docker;
ALTER TABLE job OWNER TO docker;
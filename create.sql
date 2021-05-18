CREATE SCHEMA IF NOT EXISTS hospital;
SET SEARCH_PATH = hospital;

DROP TABLE IF EXISTS hospital.PATIENTS CASCADE;
CREATE TABLE IF NOT EXISTS hospital.PATIENTS
(
    patient_id      INTEGER PRIMARY KEY,
    patient_nm      VARCHAR(255) NOT NULL,
    mobile_phone_no VARCHAR(15),
    sex_dk          VARCHAR(255) CHECK (sex_dk = 'M' or sex_dk = 'F' or sex_dk is NULL),
    birth_dt        DATE,
    assurance_no    VARCHAR(255),
    snils_no        VARCHAR(255)
);


DROP TABLE IF EXISTS hospital.DEPARTMENTS CASCADE;
CREATE TABLE IF NOT EXISTS hospital.DEPARTMENTS
(
    department_id      INTEGER PRIMARY KEY,
    department_nm      VARCHAR(255),
    chief_id           INTEGER,
    in_patient_bed_cnt INTEGER
);

DROP TABLE IF EXISTS hospital.EMPLOYEES CASCADE;
CREATE TABLE hospital.EMPLOYEES
(
    employee_id       INTEGER PRIMARY KEY,
    employee_nm       VARCHAR(255) NOT NULL,
    post_nm           VARCHAR(255) NOT NULL,
    specialization_nm VARCHAR(255),
    mobile_phone_no   VARCHAR(15),
    department_id     INTEGER NOT NULL REFERENCES hospital.DEPARTMENTS (department_id)
);


DROP TABLE IF EXISTS hospital.DIACRISISES CASCADE;
CREATE TABLE hospital.DIACRISISES
(
    diacrisis_id  INTEGER PRIMARY KEY,
    diacrisis_nm  VARCHAR(255) NOT NULL,
    department_id INTEGER REFERENCES hospital.DEPARTMENTS (department_id)
);

DROP TABLE IF EXISTS hospital.DRUGS CASCADE;
CREATE TABLE hospital.DRUGS
(
    drug_id INTEGER PRIMARY KEY,
    drug_nm VARCHAR(255) NOT NULL,
    min_age_dk INTEGER CHECK(min_age_dk >= 0)
);

DROP TABLE IF EXISTS hospital.TREATMENT_HISTORY;
CREATE TABLE hospital.TREATMENT_HISTORY
(
    record_id         INTEGER PRIMARY KEY,
    patient_id        INTEGER      NOT NULL REFERENCES hospital.PATIENTS (patient_id),
    employee_id       INTEGER      NOT NULL REFERENCES hospital.EMPLOYEES (employee_id),
    diacrisis_id      INTEGER      NOT NULL REFERENCES hospital.DIACRISISES (diacrisis_id),
    entry_dttm        TIMESTAMP(0) NOT NULL,
    treatment_end_dttm TIMESTAMP(0),
    current_status_dk VARCHAR(255) CHECK (current_status_dk = 'OK' or current_status_dk = 'D' or
                                          current_status_dk is NULL),
    in_patient_flag BOOLEAN
);

DROP TABLE IF EXISTS hospital.DRUGS_X_DIACRISISES;
CREATE TABLE hospital.DRUGS_X_DIACRISISES (
    drug_id INTEGER REFERENCES hospital.DRUGS (drug_id),
    diacrisis_id INTEGER REFERENCES hospital.DIACRISISES (diacrisis_id),
    duration_days INTEGER CHECK (duration_days is NULL or duration_days >= 0)
);





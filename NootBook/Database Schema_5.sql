/*  -- Patients Information
CREATE TABLE patients (
    patient_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    gender CHAR(1),
    date_of_birth DATE,
    city VARCHAR2(50),
    state VARCHAR2(50)
);

-- Medical Visits
CREATE TABLE visits (
    visit_id NUMBER PRIMARY KEY,
    patient_id NUMBER REFERENCES patients(patient_id),
    visit_date DATE,
    department VARCHAR2(50),
    doctor_id NUMBER,
    diagnosis_code VARCHAR2(10)
);

-- Doctors Information
CREATE TABLE doctors (
    doctor_id NUMBER PRIMARY KEY,
    doctor_name VARCHAR2(100),
    specialization VARCHAR2(50)
);

-- Prescriptions
CREATE TABLE prescriptions (
    prescription_id   NUMBER(4) PRIMARY KEY, -- 4-digit ID
    patient_id        VARCHAR2(10) NOT NULL,
    doctor_id         NUMBER NOT NULL,
    medicine_name     VARCHAR2(100),
    dosage            VARCHAR2(50),
    prescription_date DATE,
    cost              NUMBER(10,2)
);

-- Billing Data
CREATE TABLE billing (
    bill_id NUMBER PRIMARY KEY,
    visit_id NUMBER REFERENCES visits(visit_id),
    total_amount NUMBER(10,2),
    payment_mode VARCHAR2(20)
);
 */
----------------------------------------------------------------------------------------------------------------------
/* 
-- Rename old table
ALTER TABLE patients RENAME TO patients_old;

-- Create new table with correct structure
CREATE TABLE patients (
    patient_id VARCHAR2(10) PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    gender CHAR(1),
    date_of_birth DATE,
    city VARCHAR2(50),
    state VARCHAR2(50)
);
 */

 /* DROP TABLE patients_old CASCADE CONSTRAINTS; */
--Why CASCADE CONSTRAINTS?
--If any child tables or constraints are still pointing to patients_old, Oracle will complain unless you include CASCADE CONSTRAINTS.
--This option tells Oracle: “also drop any foreign keys or constraints that depend on this table.”

/* ALTER TABLE patients MODIFY gender VARCHAR2(10); */
-- Changing

/* ALTER USER project_user QUOTA UNLIMITED ON users; */

/* 
-- allow SYS to query
GRANT SELECT ON patients TO sys;

-- allow SYS to insert/update/delete if needed
GRANT INSERT, UPDATE, DELETE ON patients TO sys;

-- allow SYS to manage everything
GRANT ALL ON patients TO sys;
 */

/* 
SELECT COUNT(*) FROM project_user.patients;
SELECT * FROM project_user.patients FETCH FIRST 10 ROWS ONLY;
 */

/* 
DROP TABLE patients CASCADE CONSTRAINTS;
 */

/* 
--Create a synonym under SYS: If you don’t want to type project_user.patients every time, create a synonym:
CREATE SYNONYM patients FOR project_user.patients;

SELECT * FROM patients;
 */
---------------------------------------------------------------------------------DID NOT EXECUTE-----------------------------------
/* 
ALTER SYSTEM SET NLS_DATE_FORMAT = 'DD-MM-YYYY' SCOPE=SPFILE;
 

SHOW PARAMETER spfile;
--If you see a file path → DB is using SPFILE


CREATE OR REPLACE TRIGGER set_date_format
AFTER LOGON ON DATABASE
BEGIN
  EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD-MM-YYYY''';
END;
/
--This trigger sets the date format for every new session automatically.
 */
-----------------------------------------------------------------------------------------------------------------------------------
/* 
--Drop the old treatments table under SYS
DROP TABLE treatments CASCADE CONSTRAINTS;

--CREATE TABLE for prescriptions
CREATE TABLE prescriptions (
    prescription_id   NUMBER(4) PRIMARY KEY, -- 4-digit ID
    patient_id        VARCHAR2(10) NOT NULL,
    doctor_id         NUMBER NOT NULL,
    medicine_name     VARCHAR2(100),
    dosage            VARCHAR2(50),
    prescription_date DATE,
    cost              NUMBER(10,2),
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_doctor  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

ALTER TABLE prescriptions MODIFY prescription_id NUMBER(6);
-- Changed from 4-digit to 6-digit ID
 */

/* 
-- 1. Create a backup table with only the first 24,266 rows
CREATE TABLE prescriptions_tmp AS
SELECT *
FROM (
    SELECT p.*, ROWNUM rn
    FROM prescriptions p
)
WHERE rn <= 24266;


-- 2. Drop the old big table
DROP TABLE prescriptions PURGE;

-- 3. Rename the trimmed table
ALTER TABLE prescriptions_tmp RENAME TO prescriptions;
 */
--------------------------------------------------------------------------------------------------------------------------------------
/* 
DROP TABLE billing CASCADE CONSTRAINTS;
-- Dropped old billing table under SYS


CREATE TABLE billing (
    bill_id      NUMBER PRIMARY KEY,
    patient_id   VARCHAR2(10) NOT NULL,
    total_amount NUMBER(10,2),
    payment_mode VARCHAR2(20),
    CONSTRAINT fk_patient_billing FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
);

TRUNCATE TABLE billing;
ALTER TABLE billing MODIFY payment_mode VARCHAR2(30);
*/
---------------------------------------------------------------------------------------------------------------------------------------
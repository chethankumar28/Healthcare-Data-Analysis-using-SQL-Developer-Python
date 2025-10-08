/* 
-- 1. Create sequence for doctor_id
CREATE SEQUENCE doctor_seq
    START WITH 1001   -- first doctor_id
    INCREMENT BY 2    -- step size
    NOCACHE
    NOCYCLE;

-- 2. Insert 15 doctors using sequence
INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Arjun Rao', 'Cardiology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Meera Iyer', 'Neurology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Karan Patel', 'Orthopedics');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Sneha Sharma', 'Dermatology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Ramesh Kumar', 'Oncology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Priya Nair', 'Gynecology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Vikram Singh', 'Pediatrics');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Kavita Joshi', 'Psychiatry');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Rohit Menon', 'General Medicine');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Anjali Desai', 'Endocrinology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Suresh Gupta', 'Ophthalmology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Neha Bhat', 'ENT');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Amit Malhotra', 'Pulmonology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Divya Reddy', 'Nephrology');

INSERT INTO doctors (doctor_id, doctor_name, specialization) 
VALUES (doctor_seq.NEXTVAL, 'Dr. Sanjay Verma', 'Urology');

-- 3. Save changes
COMMIT;
 */
------------------------------------------------------------------------------------------------------
/* 
--Add the doctor_id column
ALTER TABLE patients
ADD (doctor_id NUMBER);
*/

/* 
CREATE TABLE project_user.doctors AS
SELECT * FROM sys.doctors;

ALTER TABLE project_user.doctors
ADD CONSTRAINT doctors_pk PRIMARY KEY (doctor_id);

SELECT * FROM project_user.doctors;

DROP TABLE sys.doctors CASCADE CONSTRAINTS;
*/
------------------------------------------------------------------------------------------------------
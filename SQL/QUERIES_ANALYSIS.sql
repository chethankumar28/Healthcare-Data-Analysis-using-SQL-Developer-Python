--------------------------------------------------------------1. PATIENT DEMOGRAPHICS & BEHAVIOR ANALYSIS
--Total number of patients
SELECT COUNT(*) AS total_patients FROM PATIENTS;

--Patients count by state
SELECT STATE, COUNT(*) AS patient_count
FROM PATIENTS
GROUP BY STATE
ORDER BY patient_count DESC;

--Patients count by city
SELECT CITY, COUNT(*) AS patient_count
FROM PATIENTS
GROUP BY CITY
ORDER BY patient_count DESC;

--Gender distribution
SELECT GENDER, COUNT(*) AS gender_count
FROM PATIENTS
GROUP BY GENDER;

--Patients assigned to each doctor
SELECT DOCTOR_ID, COUNT(*) AS patient_count
FROM PATIENTS
GROUP BY DOCTOR_ID
ORDER BY patient_count DESC;

--Doctors with the most patients (join with doctor names)
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, COUNT(P.PATIENT_ID) AS patient_count
FROM DOCTORS D
JOIN PATIENTS P ON D.DOCTOR_ID = P.DOCTOR_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY patient_count DESC;

--Patients without assigned doctor (data quality)
SELECT * FROM PATIENTS
WHERE DOCTOR_ID IS NULL;

--------------------------------------------------------------2. PRESCRIPTION & TREATMENT ANALYSIS

--Total prescriptions count
SELECT COUNT(*) AS total_prescriptions FROM PRESCRIPTIONS;

--Most prescribed medicines
SELECT MEDICINE_NAME, COUNT(*) AS prescription_count
FROM PRESCRIPTIONS
GROUP BY MEDICINE_NAME
ORDER BY prescription_count DESC;

--Average prescription cost per medicine
SELECT MEDICINE_NAME, ROUND(AVG(COST), 2) AS avg_cost
FROM PRESCRIPTIONS
GROUP BY MEDICINE_NAME
ORDER BY avg_cost DESC;

--Doctors prescribing most frequently
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, COUNT(P.PRESCRIPTION_ID) AS total_prescriptions
FROM DOCTORS D
JOIN PRESCRIPTIONS P ON D.DOCTOR_ID = P.DOCTOR_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY total_prescriptions DESC;

--Patients with multiple unique medicines per month (polypharmacy)
SELECT PATIENT_ID,
       EXTRACT(YEAR FROM PRESCRIPTION_DATE) AS year,
       EXTRACT(MONTH FROM PRESCRIPTION_DATE) AS month,
       COUNT(DISTINCT MEDICINE_NAME) AS unique_medicines
FROM PRESCRIPTIONS
GROUP BY PATIENT_ID, EXTRACT(YEAR FROM PRESCRIPTION_DATE), EXTRACT(MONTH FROM PRESCRIPTION_DATE)
HAVING COUNT(DISTINCT MEDICINE_NAME) > 5
ORDER BY unique_medicines DESC;

--Prescriptions whose cost exceeds average cost
SELECT PRESCRIPTION_ID, PATIENT_ID, DOCTOR_ID, MEDICINE_NAME, COST
FROM PRESCRIPTIONS
WHERE COST > (SELECT AVG(COST) FROM PRESCRIPTIONS);

--------------------------------------------------------------3. BILLING & REVENUE ANALYSIS

--Total revenue
SELECT SUM(TOTAL_AMOUNT) AS total_revenue
FROM BILLING;

--Average bill per patient
SELECT ROUND(AVG(TOTAL_AMOUNT), 2) AS avg_bill
FROM BILLING;

--Total revenue by payment mode
SELECT PAYMENT_MODE, SUM(TOTAL_AMOUNT) AS total_revenue, ROUND(AVG(TOTAL_AMOUNT), 2) AS avg_bill
FROM BILLING
GROUP BY PAYMENT_MODE
ORDER BY total_revenue DESC;

--Total revenue by state (join patients)
SELECT P.STATE, SUM(B.TOTAL_AMOUNT) AS total_revenue
FROM PATIENTS P
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY P.STATE
ORDER BY total_revenue DESC;

--Patients with multiple bills
SELECT PATIENT_ID, COUNT(*) AS bill_count, SUM(TOTAL_AMOUNT) AS total_spent
FROM BILLING
GROUP BY PATIENT_ID
HAVING COUNT(*) > 1
ORDER BY total_spent DESC;

--Highest value bills
SELECT BILL_ID, PATIENT_ID, TOTAL_AMOUNT, PAYMENT_MODE
FROM BILLING
ORDER BY TOTAL_AMOUNT DESC
FETCH FIRST 10 ROWS ONLY;

--------------------------------------------------------------4. DOCTOR PERFORMANCE & SPECIALIZATION ANALYSIS

--Prescriptions per doctor
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, COUNT(P.PRESCRIPTION_ID) AS total_prescriptions
FROM DOCTORS D
LEFT JOIN PRESCRIPTIONS P ON D.DOCTOR_ID = P.DOCTOR_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY total_prescriptions DESC;

--Unique patients handled by each doctor
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, COUNT(DISTINCT PR.PATIENT_ID) AS unique_patients
FROM DOCTORS D
JOIN PRESCRIPTIONS PR ON D.DOCTOR_ID = PR.DOCTOR_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY unique_patients DESC;

--Total prescription cost per doctor (performance metric)
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, SUM(PR.COST) AS total_cost
FROM DOCTORS D
JOIN PRESCRIPTIONS PR ON D.DOCTOR_ID = PR.DOCTOR_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY total_cost DESC;

--Performance by specialization
SELECT D.SPECIALIZATION,
       COUNT(PR.PRESCRIPTION_ID) AS total_prescriptions,
       SUM(PR.COST) AS total_rx_cost,
       ROUND(AVG(PR.COST), 2) AS avg_rx_cost
FROM DOCTORS D
JOIN PRESCRIPTIONS PR ON D.DOCTOR_ID = PR.DOCTOR_ID
GROUP BY D.SPECIALIZATION
ORDER BY total_rx_cost DESC;

--------------------------------------------------------------5. CROSS-DOMAIN / ADVANCED ANALYTICAL SCENARIOS

--Doctor-wise revenue generated (doctor + billing + prescriptions)
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, SUM(B.TOTAL_AMOUNT) AS total_revenue
FROM DOCTORS D
JOIN PATIENTS P ON D.DOCTOR_ID = P.DOCTOR_ID
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY total_revenue DESC;

--State-wise payment mode mix
SELECT P.STATE, B.PAYMENT_MODE, COUNT(*) AS total_bills, SUM(B.TOTAL_AMOUNT) AS revenue
FROM PATIENTS P
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY P.STATE, B.PAYMENT_MODE
ORDER BY P.STATE, revenue DESC;

--Correlation between prescription cost and billing per patient
SELECT P.PATIENT_ID,
       ROUND(AVG(PR.COST), 2) AS avg_rx_cost,
       ROUND(AVG(B.TOTAL_AMOUNT), 2) AS avg_bill
FROM PATIENTS P
JOIN PRESCRIPTIONS PR ON P.PATIENT_ID = PR.PATIENT_ID
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY P.PATIENT_ID
ORDER BY avg_bill DESC;

--Patient full journey (patient → doctor → prescription → billing)
SELECT P.PATIENT_ID,
       P.FIRST_NAME || ' ' || P.LAST_NAME AS PATIENT_NAME,
       D.DOCTOR_NAME,
       PR.MEDICINE_NAME,
       B.TOTAL_AMOUNT,
       B.PAYMENT_MODE
FROM PATIENTS P
JOIN DOCTORS D ON P.DOCTOR_ID = D.DOCTOR_ID
JOIN PRESCRIPTIONS PR ON P.PATIENT_ID = PR.PATIENT_ID
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
ORDER BY P.PATIENT_ID;

--------------------------------------------------------------6.ADVANCED INSIGHT EXAMPLES

--Top 5 doctors with highest revenue
SELECT D.DOCTOR_NAME, D.SPECIALIZATION, SUM(B.TOTAL_AMOUNT) AS total_revenue
FROM DOCTORS D
JOIN PATIENTS P ON D.DOCTOR_ID = P.DOCTOR_ID
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY total_revenue DESC
FETCH FIRST 5 ROWS ONLY;

--High-cost medicines responsible for majority of cost
SELECT MEDICINE_NAME,
       COUNT(*) AS rx_count,
       SUM(COST) AS total_cost,
       ROUND(SUM(COST) * 100 / (SELECT SUM(COST) FROM PRESCRIPTIONS), 2) AS cost_percentage
FROM PRESCRIPTIONS
GROUP BY MEDICINE_NAME
ORDER BY total_cost DESC;

--Patients whose total billing exceeds average billing
SELECT PATIENT_ID, SUM(TOTAL_AMOUNT) AS total_spent
FROM BILLING
GROUP BY PATIENT_ID
HAVING SUM(TOTAL_AMOUNT) > (SELECT AVG(TOTAL_AMOUNT) FROM BILLING);

--Specialization-wise average revenue per patient
SELECT D.SPECIALIZATION,
       ROUND(SUM(B.TOTAL_AMOUNT)/COUNT(DISTINCT P.PATIENT_ID), 2) AS avg_revenue_per_patient
FROM DOCTORS D
JOIN PATIENTS P ON D.DOCTOR_ID = P.DOCTOR_ID
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY D.SPECIALIZATION
ORDER BY avg_revenue_per_patient DESC;

--Identify patients with more than 3 visits/prescriptions
SELECT PATIENT_ID, COUNT(*) AS total_visits
FROM PRESCRIPTIONS
GROUP BY PATIENT_ID
HAVING COUNT(*) > 3
ORDER BY total_visits DESC;

--Top states contributing to revenue
SELECT P.STATE, SUM(B.TOTAL_AMOUNT) AS total_revenue
FROM PATIENTS P
JOIN BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY P.STATE
ORDER BY total_revenue DESC
FETCH FIRST 5 ROWS ONLY;

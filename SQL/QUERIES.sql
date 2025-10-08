---------------------------------------------------------------------------------------SQL — DOCTORS TABLE

/* Quick preview and shape */
SELECT * 
FROM DOCTORS
ORDER BY PATIENT_ID
FETCH FIRST 10 ROWS ONLY;

/* List all doctors and specializations for quick reference */
SELECT DOCTOR_ID, DOCTOR_NAME, SPECIALIZATION
FROM DOCTORS
ORDER BY DOCTOR_ID;

/* Count doctors by specialization to verify one-to-one mapping in seed data */
SELECT SPECIALIZATION, COUNT(*) AS doctor_count
FROM DOCTORS
GROUP BY SPECIALIZATION
ORDER BY doctor_count DESC, SPECIALIZATION;

/* Find a doctor by partial name for UI/autocomplete needs */
SELECT DOCTOR_ID, DOCTOR_NAME, SPECIALIZATION
FROM DOCTORS
WHERE DOCTOR_NAME LIKE '%Kumar%';

/* Check uniqueness constraints candidates */
SELECT
  COUNT(*) AS rows_total,
  COUNT(DISTINCT DOCTOR_ID) AS doctor_ids,
  COUNT(DISTINCT DOCTOR_NAME) AS doctor_names,
  COUNT(DISTINCT SPECIALIZATION) AS specializations
FROM DOCTORS;

---------------------------------------------------------------------------------------SQL — PATIENTS TABLE
/* Quick preview and shape */
SELECT * 
FROM PATIENTS
ORDER BY PATIENT_ID
FETCH FIRST 10 ROWS ONLY;

/* Count patients */
SELECT COUNT(*) AS total_patients
FROM PATIENTS;

/* columns of patients table */
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'PATIENTS';

/* Count patients by city */
SELECT CITY, COUNT(*) AS patient_count
FROM PATIENTS
GROUP BY CITY
ORDER BY patient_count DESC, CITY;

/* Count patients by state */
SELECT STATE, COUNT(*) AS patient_count
FROM PATIENTS
GROUP BY STATE
ORDER BY patient_count DESC, STATE;

/* Patients by gender and by city/state for basic distribution */
SELECT GENDER, COUNT(*) AS cnt
FROM PATIENTS
GROUP BY GENDER
ORDER BY cnt DESC;

SELECT STATE, CITY, COUNT(*) AS patients
FROM PATIENTS
GROUP BY STATE, CITY
ORDER BY patients DESC
FETCH FIRST 20 ROWS ONLY;

---------------------------------------------------------------------------------------SQL — PRESCRIPTIONS TABLE

/*Quick preview and shape */
SELECT * FROM PRESCRIPTIONS
ORDER BY PRESCRIPTION_ID
FETCH FIRST 10 ROWS ONLY;

/* Prescriptions by medicine (frequency) */
SELECT MEDICINE_NAME, COUNT(*) AS rx_count
FROM PRESCRIPTIONS
GROUP BY MEDICINE_NAME
ORDER BY rx_count DESC, MEDICINE_NAME;

/* Average prescription cost by medicine */
SELECT MEDICINE_NAME, AVG(COST) AS avg_cost, COUNT(*) AS rx_count
FROM PRESCRIPTIONS
GROUP BY MEDICINE_NAME
ORDER BY avg_cost DESC;

/* Prescriptions per doctor */
SELECT DOCTOR_ID, COUNT(*) AS rx_count
FROM PRESCRIPTIONS
GROUP BY DOCTOR_ID
ORDER BY rx_count DESC, DOCTOR_ID;

/* Monthly prescription volume and cost */
SELECT
  EXTRACT(YEAR FROM PRESCRIPTION_DATE) AS yr,
  EXTRACT(MONTH FROM PRESCRIPTION_DATE) AS mo,
  COUNT(*) AS rx_count,
  SUM(COST) AS total_cost
FROM PRESCRIPTIONS
GROUP BY EXTRACT(YEAR FROM PRESCRIPTION_DATE), EXTRACT(MONTH FROM PRESCRIPTION_DATE)
ORDER BY yr, mo;

---------------------------------------------------------------------------------------SQL — BILLING TABLE

/* Quick preview and shape */
SELECT * 
FROM BILLING
ORDER BY BILL_ID
FETCH FIRST 10 ROWS ONLY;

/* Overall revenue (sum of TOTAL_AMOUNT) */
SELECT SUM(TOTAL_AMOUNT) AS total_revenue
FROM BILLING;

/* Average bill by payment mode */
SELECT PAYMENT_MODE, AVG(TOTAL_AMOUNT) AS avg_bill
FROM BILLING
GROUP BY PAYMENT_MODE
ORDER BY avg_bill DESC;

/* Distinct patient count in billing */
SELECT COUNT(DISTINCT PATIENT_ID) AS billed_patients
FROM BILLING;

/* Top 10 bills by amount */
SELECT BILL_ID, PATIENT_ID, TOTAL_AMOUNT, PAYMENT_MODE
FROM BILLING
ORDER BY TOTAL_AMOUNT DESC
FETCH FIRST 10 ROWS ONLY;

---------------------------------------------------------------------------------------ADVANCE SQL - OVER ALL TABLE

/* List all patients with their assigned doctors */
SELECT P.PATIENT_ID, 
        P.FIRST_NAME || ' ' || P.LAST_NAME AS PATIENT_NAME, 
        D.DOCTOR_NAME
FROM PATIENTS P
LEFT JOIN DOCTORS D ON P.DOCTOR_ID = D.DOCTOR_ID;

/* Find duplicates in DOCTORS table for SPECIALIZATION and DOCTOR_NAME */
SELECT 'SPECIALIZATION' AS field, SPECIALIZATION AS value, COUNT(*) AS cnt
FROM DOCTORS
GROUP BY SPECIALIZATION
HAVING COUNT(*) > 1
UNION ALL
SELECT 'DOCTOR_NAME', DOCTOR_NAME, COUNT(*)
FROM DOCTORS
GROUP BY DOCTOR_NAME
HAVING COUNT(*) > 1;

/* Monthly distinct medicines per patient (polypharmacy indicator) */
SELECT
  PATIENT_ID,
  EXTRACT(YEAR FROM PRESCRIPTION_DATE) AS yr,
  EXTRACT(MONTH FROM PRESCRIPTION_DATE) AS mo,
  COUNT(DISTINCT MEDICINE_NAME) AS distinct_meds
FROM PRESCRIPTIONS
GROUP BY PATIENT_ID, EXTRACT(YEAR FROM PRESCRIPTION_DATE), EXTRACT(MONTH FROM PRESCRIPTION_DATE)
ORDER BY PATIENT_ID, yr, mo;

/* using join to get doctor names with prescriptions */
SELECT P.PRESCRIPTION_ID, P.PATIENT_ID, P.MEDICINE_NAME, P.COST, D.DOCTOR_NAME
FROM PRESCRIPTIONS P
JOIN DOCTORS D ON P.DOCTOR_ID = D.DOCTOR_ID
ORDER BY P.PRESCRIPTION_ID
FETCH FIRST 10 ROWS ONLY;

/* Prescriptions and total prescription cost by specialization (join PRESCRIPTIONS → DOCTORS) */
SELECT 
    D.SPECIALIZATION, 
    COUNT(*) AS rx_count, 
    SUM(P.COST) AS total_cost,
    AVG(P.COST) AS avg_cost
FROM PRESCRIPTIONS P
JOIN DOCTORS D ON P.DOCTOR_ID = D.DOCTOR_ID
GROUP BY D.SPECIALIZATION
ORDER BY total_cost DESC, D.SPECIALIZATION;

/* Billing and total billing amount by payment mode (join BILLING → PRESCRIPTIONS) */
SELECT 
    B.PAYMENT_MODE, 
    COUNT(*) AS bill_count, 
    SUM(B.TOTAL_AMOUNT) AS total_billed,
    AVG(B.TOTAL_AMOUNT) AS avg_bill
FROM BILLING B
JOIN PRESCRIPTIONS P ON B.PATIENT_ID = P.PATIENT_ID
GROUP BY B.PAYMENT_MODE
ORDER BY total_billed DESC, B.PAYMENT_MODE;

/* Doctor performance dashboard: prescriptions, unique patients, and total prescription cost per doctor (join PRESCRIPTIONS → DOCTORS) */
SELECT 
    D.DOCTOR_ID,
    D.DOCTOR_NAME,
    D.SPECIALIZATION,
    COUNT(*) AS rx_count,
    COUNT(DISTINCT P.PATIENT_ID) AS unique_patients,
    SUM(P.COST) AS total_rx_cost
FROM DOCTORS D
LEFT JOIN PRESCRIPTIONS P ON D.DOCTOR_ID = P.DOCTOR_ID
GROUP BY D.DOCTOR_ID, D.DOCTOR_NAME, D.SPECIALIZATION
ORDER BY total_rx_cost DESC, D.DOCTOR_ID;

/* Patients per primary doctor with doctor names via join to DOCTORS */
SELECT 
  d.DOCTOR_ID,
  d.DOCTOR_NAME,
  d.SPECIALIZATION,
  COUNT(p.PATIENT_ID) AS panel_size
FROM PATIENTS p
JOIN DOCTORS d ON p.DOCTOR_ID = d.DOCTOR_ID
GROUP BY d.DOCTOR_ID, d.DOCTOR_NAME, d.SPECIALIZATION
ORDER BY panel_size DESC;

/* Patient to doctor to prescriptions: top medicines per state using patient demographics */
SELECT 
  p.STATE,
  pr.MEDICINE_NAME,
  COUNT(*) AS rx_count
FROM PATIENTS p
JOIN PRESCRIPTIONS pr ON p.PATIENT_ID = pr.PATIENT_ID
GROUP BY p.STATE, pr.MEDICINE_NAME
ORDER BY p.STATE, rx_count DESC;

/* Patient to billing: payment-mode mix by state */
SELECT 
  p.STATE,
  b.PAYMENT_MODE,
  COUNT(*) AS bills,
  SUM(b.TOTAL_AMOUNT) AS revenue
FROM PATIENTS p
JOIN BILLING b ON p.PATIENT_ID = b.PATIENT_ID
GROUP BY p.STATE, b.PAYMENT_MODE
ORDER BY p.STATE, revenue DESC;

/*Specialty productivity: prescriptions, unique patients, and total prescription cost per specialty using patient linkage to attribute panels */
SELECT
  d.SPECIALIZATION,
  COUNT(*) AS rx_count,
  COUNT(DISTINCT pr.PATIENT_ID) AS unique_patients,
  SUM(pr.COST) AS total_rx_cost,
  AVG(pr.COST) AS avg_rx_cost
FROM PRESCRIPTIONS pr
JOIN PATIENTS p   ON pr.PATIENT_ID = p.PATIENT_ID
JOIN DOCTORS d   ON p.DOCTOR_ID   = d.DOCTOR_ID
GROUP BY d.SPECIALIZATION
ORDER BY total_rx_cost DESC;

/* Orphans and referential integrity: patients without matching doctor, and Rx/Billing rows without a patient */
-- Patients with missing doctor assignment
SELECT p.*
FROM PATIENTS p
LEFT JOIN DOCTORS d ON p.DOCTOR_ID = d.DOCTOR_ID
WHERE d.DOCTOR_ID IS NULL;

-- Prescriptions missing patient
SELECT pr.*
FROM PRESCRIPTIONS pr
LEFT JOIN PATIENTS p ON pr.PATIENT_ID = p.PATIENT_ID
WHERE p.PATIENT_ID IS NULL;

-- Billing missing patient
SELECT b.*
FROM BILLING b
LEFT JOIN PATIENTS p ON b.PATIENT_ID = p.PATIENT_ID
WHERE p.PATIENT_ID IS NULL;

/* prescriptions whose cost is above the overall average cost across all prescriptions */
SELECT PRESCRIPTION_ID, PATIENT_ID, DOCTOR_ID, MEDICINE_NAME, COST
FROM PRESCRIPTIONS
WHERE COST > (SELECT AVG(COST) FROM PRESCRIPTIONS);

/* prescriptions for medicines that are “popular” (at least 100 prescriptions) and whose cost exceeds the average cost of those popular medicines */
SELECT PRESCRIPTION_ID, PATIENT_ID, DOCTOR_ID, MEDICINE_NAME, COST
FROM PRESCRIPTIONS
WHERE MEDICINE_NAME IN (
  SELECT MEDICINE_NAME
  FROM PRESCRIPTIONS
  GROUP BY MEDICINE_NAME
  HAVING COUNT(*) >= 100
)
AND COST > (
  SELECT AVG(COST)
  FROM PRESCRIPTIONS
  WHERE MEDICINE_NAME IN (
    SELECT MEDICINE_NAME
    FROM PRESCRIPTIONS
    GROUP BY MEDICINE_NAME
    HAVING COUNT(*) >= 100
  )
);
/* Prescriptions to doctors to get prescription counts per specialization */
SELECT d.SPECIALIZATION, COUNT(*) AS rx_count
FROM PRESCRIPTIONS p
JOIN DOCTORS d ON p.DOCTOR_ID = d.DOCTOR_ID
GROUP BY d.SPECIALIZATION
ORDER BY rx_count DESC;

/* Show all doctors and how many assigned patients they have, including doctors with zero patients by right-joining patients to doctors */
SELECT
  d.DOCTOR_ID, d.DOCTOR_NAME, d.SPECIALIZATION,
  COUNT(p.PATIENT_ID) AS panel_size
FROM PATIENTS p
RIGHT JOIN DOCTORS d
  ON p.DOCTOR_ID = d.DOCTOR_ID
GROUP BY d.DOCTOR_ID, d.DOCTOR_NAME, d.SPECIALIZATION
ORDER BY panel_size DESC;

-- UNION: patients seen in prescriptions or billing (distinct)
SELECT PATIENT_ID FROM PRESCRIPTIONS
UNION
SELECT PATIENT_ID FROM BILLING;

-- INTERSECT: patients present in both
SELECT PATIENT_ID FROM PRESCRIPTIONS
INTERSECT
SELECT PATIENT_ID FROM BILLING;

SELECT PATIENT_ID FROM PRESCRIPTIONS
MINUS
SELECT PATIENT_ID FROM BILLING;

-- Flag prescriptions whose cost is above that patient’s own average, correlating the inner query on PATIENT_ID.
SELECT p1.PRESCRIPTION_ID, p1.PATIENT_ID, p1.MEDICINE_NAME, p1.COST
FROM PRESCRIPTIONS p1
WHERE p1.COST > (
  SELECT AVG(p2.COST)
  FROM PRESCRIPTIONS p2
  WHERE p2.PATIENT_ID = p1.PATIENT_ID
);

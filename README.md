# Healthcare Data Analysis using SQL Developer & Python (OracleDB)

### Overview
This project simulates a **Healthcare Management System** developed completely from scratch using **Python** and **Oracle SQL Developer**.  
It analyzes the relationships between **patients, doctors, prescriptions, and billing** to generate valuable insights into operations, treatment patterns, and financial performance.

---

## Tech Stack
- **Programming:** Python (`faker`, `pandas`, `random`, `oracledb`)
- **Database:** Oracle SQL Developer
- **Concepts Used:** DDL, DML, DQL, Joins, Subqueries, Aggregations, Data Validation

---

## Database Structure

| Table | Description | Key Columns |

| `DOCTORS` | Doctor information & specialization | DOCTOR_ID, DOCTOR_NAME, SPECIALIZATION |

| `PATIENTS` | Patient demographics & doctor linkage | PATIENT_ID, DOCTOR_ID, FIRST_NAME, LAST_NAME, GENDER, DATE_OF_BIRTH, CITY, STATE, |

| `PRESCRIPTIONS` | Medicines prescribed & cost | PRESCRIPTION_ID, PATIENT_ID, DOCTOR_ID, MEDICINE_NAME, DOSAGE, PRESCRIPTION_DATE, COST |

| `BILLING` | Payment and billing information | BILL_ID, PATIENT_ID, TOTAL_AMOUNT, PAYMENT_MODE |

---

## SQL Commands Implemented
- **DDL:** `CREATE`, `ALTER`, `DROP`, `TRUNCATE`
- **DML:** `INSERT`, `UPDATE`, `DELETE`
- **DQL:** `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `JOIN`
- **Advanced SQL:** `CTE`, `UNION`, `INTERSECT`, `MINUS`, subqueries, window functions

---

## Key Analytical Areas

### 1. Patient Demographics & Behavior
- Distribution of patients by city, state, and gender  
- Doctor-to-patient mapping  
- Unassigned or orphan patients (data quality check)

### 2. Prescription & Treatment Trends
- Most prescribed medicines  
- Average cost of prescriptions per medicine  
- Doctors prescribing the highest-cost treatments  
- Polypharmacy detection (patients receiving multiple medicines monthly)

### 3. Billing & Revenue Insights
- Total revenue and average billing  
- Payment mode distribution (cash, card, UPI, etc.)  
- State-wise revenue contribution  
- Patients with multiple bills or high spending

### 4. Doctor Performance & Specialization
- Doctor workload and unique patient count  
- Total prescription cost and average treatment value per specialization  
- Ranking of doctors by total revenue generated

### 5. Cross-Domain & Advanced Insights
- Patient → Doctor → Prescription → Billing Journey  
- Specialization profitability and cost efficiency  
- Revenue by state and payment mode  
- Data validation for missing or inconsistent records

---

## Example Queries
*(Full list available in `sql/QUERIES.sql`)*

## Analysis Queries
*(Full list available in `sql/QUERIES_Analysis.sql`)*

---

## Visual Representation
ER Diagram
<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/60abe1a4-ed4d-4b02-b434-bff34a8e5e10" />

---

## Key Learnings
- Designed a relational database from synthetic data using Python
- Mastered Oracle SQL Developer for data analysis & validation
- Performed end-to-end ETL and analytics workflow
- Gained hands-on experience with Joins, Aggregations, Subqueries, and Data Cleaning

# DentalCraft Database Systems

A SQLite database designed and implemented for **DentalCraft** for Database Systems group coursework
## Project oveview

This database system manages clinic operations, including patient registration, dentist details, appointment booking schedules, treatment tracking, patient reviews and follow up care.

## Key Capabilities
* **Patient & Dentist Record:** Centralised storage preventing duplicate data across visits
* **Appointment status tracking:** Full tracking of attendance outcome (`attended`, `cancelled`, `no_show`, `scheduled`) with cancellation reason
* **Quality & Continuity Care:** Reviews with rating (0-10) and dynamic follow-up appointment tracking

## Normalisation
1. **1NF:** Split multi-value treatment lists into single treatment rows
2. **2NF:** Seperated treatment lookup details into 'treatment_type' and added a linking table via 'appointment_type'
3. **3NF:** Extracted `patient` and `dentist` attributes so all non-key attributes strictly depend on their primary key

## ERD
<img width="1145" height="966" alt="image" src="https://github.com/user-attachments/assets/80e47907-2efb-4160-b934-689c928c12e8" />

## Schema
* **Primary Keys:** Unique text/integer identifiers (`patient_id`, `dentist_id`, `appointment_id`,etc...)
* **Foreign Keys:** Maintains parent-children relationship across appointments, follow-ups and reviews
* **Composite Keys:** Used on linking table ('appointment_type(`appointment_id`, `treatment_code`)')
* **Integrity Constraints:**
  1. `CHECK` (dentist_rating BETWEEN 0 AND 10)' to bound the patient quantitative feedback
  2. `UNIQUE` constraints on NHS numbers and GDC numbers 
 
## Personal analytical Queries

The queries stored in 'quries.sql' ansers key operational and managerial questions

## Limitations
* **DateTime Data Types:** DateTime format is stored as TEXT('DD/MM/YYYY') limiting chronological sorting of appointment datetime
* **Explicit Appointment End Times:** Current database cannot filly enforce time-based scheduling constraints, remains a risk of a dentist could be booked into another appointment while still occupied with another patient

BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Appointment" (
	"appointment_id"	TEXT,
	"patient_id"	TEXT NOT NULL,
	"dentist_id"	TEXT NOT NULL,
	"appt_date_time"	TEXT NOT NULL,
	"follow_up_required"	INTEGER NOT NULL,
	"Room"	TEXT NOT NULL,
	"Status"	TEXT NOT NULL,
	"CreatedDate"	TEXT NOT NULL,
	"Notes"	TEXT,
	PRIMARY KEY("appointment_id"),
	FOREIGN KEY("dentist_id") REFERENCES "Dentist"("dentist_id"),
	FOREIGN KEY("patient_id") REFERENCES "Patient"("patient_id")
);
CREATE TABLE IF NOT EXISTS "Appointment_Type" (
	"appointment_id"	TEXT NOT NULL,
	"treatment_code"	TEXT NOT NULL,
	FOREIGN KEY("appointment_id") REFERENCES "Appointment"("appointment_id"),
	FOREIGN KEY("treatment_code") REFERENCES "Treatment_Type"("treatment_code")
);
CREATE TABLE IF NOT EXISTS "Availability" (
	"availability_id"	TEXT,
	"dentist_id"	TEXT NOT NULL,
	"day_of_the_week"	TEXT NOT NULL,
	"start_time"	TEXT NOT NULL,
	"end_time"	TEXT NOT NULL,
	PRIMARY KEY("availability_id"),
	FOREIGN KEY("dentist_id") REFERENCES "Dentist"("dentist_id")
);
CREATE TABLE IF NOT EXISTS "Dentist" (
	"dentist_id"	TEXT,
	"dentist_name"	TEXT NOT NULL,
	"dentist_email"	TEXT NOT NULL UNIQUE,
	"dentist_phone_number"	INTEGER NOT NULL,
	"gdc_number"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("dentist_id")
);
CREATE TABLE IF NOT EXISTS "Exception" (
	"Exception_ID"	TEXT,
	"appointment_id"	TEXT NOT NULL,
	"Issue_type"	TEXT NOT NULL,
	"exception_reason"	TEXT,
	PRIMARY KEY("Exception_ID"),
	FOREIGN KEY("appointment_id") REFERENCES "Appointment"("appointment_id")
);
CREATE TABLE IF NOT EXISTS "Followup" (
	"FollowUpID"	TEXT,
	"FollowUpReason"	TEXT,
	"FollowUpDateTime"	TEXT NOT NULL,
	"New_Appointment_ID"	TEXT NOT NULL UNIQUE,
	"Old_Appointment_ID"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("FollowUpID"),
	CONSTRAINT "fk_new_appointment_id" FOREIGN KEY("New_Appointment_ID") REFERENCES "Appointment_Type"("appointment_id"),
	CONSTRAINT "fk_old_appointment_id" FOREIGN KEY("Old_Appointment_ID") REFERENCES "Appointment"("appointment_id")
);
CREATE TABLE IF NOT EXISTS "Patient" (
	"patient_id"	TEXT,
	"patient_email"	TEXT NOT NULL UNIQUE,
	"patient_name"	TEXT NOT NULL,
	"patient_phone_number"	TEXT NOT NULL,
	"patient_address"	TEXT NOT NULL,
	"patient_DOB"	TEXT NOT NULL,
	"NHS_number"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("patient_id")
);
CREATE TABLE IF NOT EXISTS "Reviews" (
	"review_id"	TEXT,
	"dentist_rating"	INTEGER NOT NULL,
	"review_summary"	TEXT,
	"dentist_id"	TEXT NOT NULL,
	PRIMARY KEY("review_id"),
	FOREIGN KEY("dentist_id") REFERENCES "Dentist"("dentist_id"),
	CONSTRAINT "check_dentist_rating_range" CHECK("dentist_rating" >= 0 AND "dentist_rating" <= 10)
);
CREATE TABLE IF NOT EXISTS "Treatment_Type" (
	"treatment_code"	TEXT,
	"treatment_name"	TEXT NOT NULL,
	"fees_GBP"	INTEGER NOT NULL,
	PRIMARY KEY("treatment_code")
);
CREATE VIEW appointment_details AS
SELECT 
    a.appointment_id,
    p.patient_name,
    d.dentist_name,
    a.status,
	a.appt_date_time
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Dentist d ON a.dentist_id = d.dentist_id;
CREATE INDEX IF NOT EXISTS "idx_patient_history" ON "Appointment" (
	"patient_id"
);
COMMIT;

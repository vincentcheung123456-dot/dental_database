--Q1
SELECT *
FROM Appointment
WHERE follow_up_required = 1
ORDER BY appointment_id DESC;
--shows all the rows that the appointment requires a followup in a descending appointment id order


--Q2
SELECT *
FROM Exception
WHERE Issue_type = "cancelled"
ORDER BY appointment_id;
-- shows all the appointments that are cancelled from the exception table in an acscending appointment id order


--Q3
SELECT *
FROM Treatment_Type
WHERE treatment_name IS NOT NULL
ORDER BY fees_GBP;
--Shows all rows of the treatment_type table where the treatment_name is not blank and is sorted by the fees from the cheapest to the most expensive


--Q4
SELECT dentist.dentist_id, dentist.dentist_name, Reviews.dentist_rating
FROM dentist
LEFT JOIN Reviews ON dentist.dentist_id = Reviews.dentist_id
ORDER BY dentist_rating DESC;
-- From my dentist table and reviews table, connect the rows where the dentist id matches on both the dentist and reviews table and shows the dentist rating from the highest rating to the lowest


--Q5
SELECT dentist.dentist_name, patient.patient_name, appointment.appt_date_time, Followup.FollowUpDateTime, Followup.FollowUpReason
From Appointment
JOIN followup ON Appointment.appointment_id=Followup.Old_Appointment_ID
JOIN Dentist ON appointment.dentist_id=Dentist.dentist_id
JOIN Patient ON patient.patient_id=appointment.patient_id;
-- From the appointment table connect the followup table where the appointment id matches
-- This also matches the dentist id from appointment and dentist table to give the dentist name
-- And also matches the patient id from patient and appointment table to give the patient name
-- This makes this query a 4 table join


--Q6
SELECT Appointment.appointment_id, patient.patient_name, dentist.dentist_name, Treatment_Type.treatment_name, Treatment_Type.fees_GBP
FROM Appointment 
JOIN Appointment_Type ON Appointment.appointment_id = Appointment_Type.appointment_id
JOIN Patient ON Patient.patient_id = Appointment.patient_id
JOIN Dentist ON Dentist.dentist_id = Appointment.dentist_id
JOIN Treatment_Type ON Treatment_Type.treatment_code = Appointment_Type.treatment_code
ORDER BY Appointment.appointment_id, Treatment_Type.fees_GBP;
--From the Appointment table join the appointment id thats the same in the Appointment_Type TABLE
--Also joins the patient_id and dentist_id to the patient and dentist table so it displays the name
--Join the treatment code from the Treatment_Type table and the Appointment_Type so it shows the treatment_name
--And it is order by the appointment_id the ones that is first is shown on top and is order by fees so the cheapest treatment is shown first
--This is a five table join


--Q7
SELECT Appointment.appointment_id, patient.patient_name, Appointment.appt_date_time, Exception.Issue_type, Exception.exception_reason
From Appointment
JOIN Patient ON Patient.patient_id = Appointment.patient_id
LEFT JOIN Exception on Exception.appointment_id = Appointment.appointment_id;
-- From Appointment table joins the patient id with the patient table to get patient name
-- From the Appointment table left joins the appointment id with the Exception table to get the issue type and the exception reason
-- Left join used in here so it shows every row from the appointments table so you can see some issue_type are NULL
-- This makes it a 3 table join


--Q8
SELECT dentist_id, COUNT(appointment_id) AS Appointment_attended
FROM Appointment
WHERE appointment.Status = "attended"
GROUP BY dentist_id
HAVING Appointment_attended > 10;
-- From the Appointment table select the column dentist id
-- count all the appointment id where the condition status is attended and group all of them by dentist id
-- and only display results with appointment_attended greater than 10


--Q9
SELECT dentist.dentist_id, dentist.dentist_name, AVG(dentist_rating) AS 'Average rating', MIN(dentist_rating) AS 'Lowest rating', MAX(dentist_rating) AS 'Highest rating'
FROM Reviews
LEFT JOIN Dentist ON Dentist.dentist_id = Reviews.dentist_id
GROUP BY Dentist.dentist_id;
-- Select dentist name and calculate the average of the ratings, the minimum and maximum rating of the corresponding dentist
-- Start from the reviews table and left join dentist table to get the dentist name by matching dentist id
-- Left join is used here so it ensures all the dentist have a rating in case of a dentist without rating it will be shown as NULL
-- Results are grouped to get one average per dentist


--Q10
SELECT dentist.dentist_id, dentist.dentist_name, COUNT(Appointment_Type.treatment_code) AS 'Total treatments performed', SUM(Treatment_Type.fees_GBP) AS 'Total revenue generated', ROUND(AVG(Treatment_Type.fees_GBP), 2) AS 'Avg treatment value'
FROM Dentist 
JOIN Appointment ON Dentist.dentist_id = Appointment.dentist_id
JOIN Appointment_Type ON Appointment.appointment_id = Appointment_Type.appointment_id
JOIN Treatment_Type ON Appointment_Type.treatment_code = Treatment_Type.treatment_code
GROUP BY Dentist.dentist_id
ORDER BY SUM(Treatment_Type.fees_GBP) DESC;
--Shows total revenue and treatments peformed by each individual Dentist
--Start from dentist table joins the Appointment table by dentist id to get the dentist name
--Links appointment and Appointment_Type table by appointment_id
--The last join connects treatment_code to retrieve fees_GBP
--Order by the highest total revenue dentist showing at the top to the lowest one at the bottom


--Q11
SELECT *
FROM Appointment
WHERE appointment_id IN (
	SELECT Old_Appointment_ID
	FROM Followup);
--Display the rows of the appointments table that required follow up and is in the followup table and has a valid Old_Appointment_ID



--Q12
SELECT *
FROM Appointment
WHERE NOT EXISTS(	
	SELECT 1
	FROM Appointment_Type 
	WHERE Appointment.appointment_id = Appointment_Type.appointment_id);
-- Search all the rows from the appointment table and only keep the appointments where the subquery returns nothing
-- Subquery using not exists finds the appointment id from the appointments table and that is NOT in the appointment_type table 



--Q13
CREATE VIEW 'Follow Up Information' AS
SELECT patient.patient_id, Patient.patient_name, dentist.dentist_id, dentist.dentist_name AS 'Last Dentist Seen', Appointment.appt_date_time AS 'Date of Last Appointment'
GROUP_CONCAT(Treatment_Type.treatment_name) AS 'Last Treatments',
Followup.FollowUpDateTime AS 'Follow up Appointment', Followup.FollowUpReason AS 'Reason for Follow-up'
FROM Patient 
JOIN Appointment ON patient.patient_id = Appointment.patient_id
JOIN Dentist ON Appointment.dentist_id = Dentist.dentist_id
JOIN Followup ON Appointment.appointment_id = Followup.Old_Appointment_ID
JOIN Treatment_Type ON Appointment_Type.treatment_code = Treatment_Type.treatment_code
JOIN Appointment_Type ON Appointment.appointment_id = Appointment_Type.appointment_id
GROUP BY Patient.patient_id;
--View shows patients that requires followups and gives information about the previous treatments and the dentist they had
--Requires 6 table joins to obtain information to get the relevent dentist name, last appointment time by joining the patient id from appointments table
--Appointment table joins followup and links the old id to get the detail on the new appointment time and reason
--Last two joins are for getting the last treatements information 
--GROUP CONCAT concatentates all the treatments the patient had in one Appointment


--Q14
CREATE INDEX idx_appointment_status
ON Appointment (Status);
-- Index can be used to look up status of the appointment from the appointment's table that is desired(i.e attended, no_show, cancelled ...)

SELECT Appointment.appointment_id, patient.patient_id, patient.patient_name, Appointment.Status
FROM Appointment
JOIN Patient ON Patient.patient_id = Appointment.patient_id
WHERE Appointment.Status = 'attended';
-- Using the created index to show from the appointments table the appointments that has the status attended
-- Link appointment and patient and joins patient_id to get the patient name



--Q15
--Safety check
SELECT Appointment_id, Status
FROM Appointment
WHERE appointment_id IN(
	SELECT appointment_id
	FROM Exception
	WHERE Issue_type = "cancelled");
--This identify appointments that are cancelled in the exception table
--The update
UPDATE Appointment
SET Status = "cancelled"
WHERE appointment_id IN(
	SELECT appointment_id
	FROM Exception
	WHERE Issue_type = "cancelled");
--Changes status in appointment's table to cancelled if an appointment id is cancelled in the exception's table



--EXTENSION Q16: DENTIST UTILISATION AND PERFORMANCE REPORT
SELECT dentist.dentist_id, Dentist.dentist_name, COUNT(DISTINCT appointment.appointment_id) AS 'Total booked', 
COUNT(DISTINCT CASE WHEN appointment.Status = 'attended' THEN Appointment.appointment_id END) AS 'Attended',
COUNT(DISTINCT CASE WHEN appointment.Status = 'cancelled' THEN Appointment.appointment_id END) AS 'Cancelled',
COUNT(DISTINCT CASE WHEN appointment.Status = 'no_show' THEN Appointment.appointment_id END) AS 'No Show',
ROUND(AVG(dentist_rating), 2) AS 'Average rating',
(COUNT(DISTINCT CASE WHEN appointment.Status = 'attended' THEN Appointment.appointment_id END)*100 / (SELECT COUNT(DISTINCT CASE WHEN appointment.Status in ('cancelled', 'attended', 'no_show') THEN Appointment.appointment_id END))) as 'attended percentage'
FROM Dentist
JOIN Appointment ON Appointment.dentist_id = Dentist.dentist_id
JOIN Reviews ON reviews.dentist_id = Dentist.dentist_id
GROUP BY dentist.dentist_id;
--Counts how many times the dentist has been booked and how many appointments has been attended and missed
--By using the combination COUNT(DISTINCT CASE WHEN..) allows me count up the unique appointment id when the status is either attended or cancelled/no show
--attended percentage is based on the formula that is attended/(Attended + cancelled + no_show) * 100



--EXTENSION Q17 SERVICE DEMAND REPORT
SELECT Treatment_Type.treatment_code, Treatment_Type.treatment_name, COUNT(appointment.appointment_id) AS 'Times Performed', SUM(Treatment_Type.fees_GBP) AS 'Total Revenue Generated'
FROM Appointment
JOIN Treatment_Type ON Treatment_Type.treatment_code = Appointment_Type.treatment_code
JOIN Appointment_Type ON Appointment.appointment_id = Appointment_Type.appointment_id
GROUP BY Treatment_Type.treatment_name
ORDER BY SUM(Treatment_Type.fees_GBP) DESC;
--3 table join from to get the treatment name
--counts up how mant times a treatment has been performed and how much money it genereated


-- Q18: PATIENT ACTIVITY REPORT
SELECT patient.patient_id, patient.patient_name, max(Appointment.appointment_id) AS 'Last appointment ID', GROUP_CONCAT(Treatment_Type.treatment_name) AS 'Last Treatments',
SUM(Treatment_Type.fees_GBP) AS 'Total cost', MAX(appointment.appt_date_time) AS 'Date of Last Visit',
(SELECT COUNT(*)
     FROM Appointment 
     WHERE appointment.patient_id = Patient.patient_id) AS 'Total Patient Visits'
FROM Appointment
JOIN Appointment_Type ON Appointment.appointment_id = Appointment_Type.appointment_id
JOIN Patient ON Appointment.patient_id = Patient.patient_id
JOIN Treatment_Type ON Appointment_Type.treatment_code = Treatment_Type.treatment_code
GROUP BY Appointment.appointment_id
ORDER BY [Total cost] desc; 
--Query shows the Patient's last treatments, total cost, last appointment attended, and the total visits
--It is done by joining appointment and patient table to match the appointment id and also match the patient id to get the patient name
-- Joins appointment_type and Treatment_Type tables to treatment_code allows to calculate the sum of the fees and displays the name of treamtnets
--GROUP_CONCAT is used to concatenate treatment names into one string
--subquery (select count(*)...) used in here so it looks at the appointment table and count how many times a specific patient id appears
--Group by appointment id due to one to many appointment and treatments relationship so it sums up the cost for ONE appointment and shows the last treatments for the patient



-- ================================
-- DATABASE CREATION
-- ================================

create database Hospital_patients_Analytics;
use Hospital_patients_Analytics;

-- ================================
-- TABLE CREATION
-- ================================

create table patients(
patient_id int auto_increment primary key,
patient_name varchar(255),
age int,
gender varchar(75),
blood_type varchar(30)
);
create table admissions (
admission_id int auto_increment primary key,
patient_id int,
medical_condition varchar(255),
doctor varchar(255),
hospital varchar(255),
admission_date date,
dicharge_date date,
admission_type varchar(100),
patient_status varchar(50),
length_of_stay int,
room_number int,
test_results varchar(100),
medication varchar(255),
foreign key (patient_id) references patients(patient_id)
);
create table billing(
bill_id int auto_increment primary key,
admission_id int,
insurance_provider varchar(255),
billing_amount decimal (12,2),
foreign key (admission_id) references admissions(admission_id)
);

-- ================================
-- DATA INSERTION
-- ================================


insert into patients (patient_name,age,gender,blood_type) select distinct Name,Age,Gender,Blood_Type
from staging_hospital_data;
select count(*) from patients;

INSERT INTO admissions (
  patient_id,
  medical_condition,
  doctor,
  hospital,
  admission_date,
  dicharge_date ,
  admission_type,
  patient_status,
  length_of_stay,
  room_number,
  test_results,
  medication
)
SELECT
  p.patient_id,
  s.Medical_Condition,
  s.Doctor,
  s.Hospital,
  s.Date_of_Admission,
  s.Discharge_Date,
  s.Admission_Type,
  s.Status,
  s.Length_of_Stay,
  s.Room_Number,
  s.Test_Results,
  s.Medication
FROM staging_hospital_data s
JOIN patients p
  ON s.Name = p.patient_name
 AND s.Age = p.age
 AND s.Gender = p.gender;
 select count(*) from admissions;
 select*from admissions limit 5;
 
 
 INSERT INTO billing (
  admission_id,
  insurance_provider,
  billing_amount
)
SELECT
  a.admission_id,
  s.Insurance_Provider,
  s.Billing_Amount
FROM staging_hospital_data s
JOIN patients p
  ON s.Name = p.patient_name
 AND s.Age = p.age
 AND s.Gender = p.gender
JOIN admissions a
  ON a.patient_id = p.patient_id
 AND a.admission_date = s.Date_of_Admission
 AND (a.dicharge_date = s.Discharge_Date OR a.dicharge_date IS NULL);
 select count(*) from billing;
 select*from billing limit 5;
 alter table admissions rename column dicharge_date to discharge_date;

-- ================================
-- DATA ANALYSIS QUERIES
-- ================================

 select count(*) as total_patients from patients;
 select count(*) as total_admissions from admissions;
 select count(*) as total_bills from billing;
 
 select patient_status,count(*) as total from admissions group by patient_status;
 select sum(billing_amount) as total_revenue from billing;
 
 
 select a.hospital,sum(b.billing_amount) as revenue from admissions a 
 join billing b on a.admission_id = b.admission_id 
 group by a.hospital
 order by revenue desc;
 
 
 select b.insurance_provider,sum(b.billing_amount) as revenue
 from billing b 
 group by b.insurance_provider
 order by revenue desc;
 
 
 select avg(length_of_stay) as avg_days from admissions;
 
 
 select medical_condition,count(*) as total_cases from admissions
 group by medical_condition
 order by total_cases desc limit 5;
 
 
 select date_format(admission_date,'%Y-%m') as month,count(*) as total_admissions from
 admissions
 group by month 
 order by month;
 
 select count(*) as currently_admitted from admissions
 where discharge_date is NULL;
 
 select medical_condition,count(*) as total_cases from admissions
 where medical_condition in ('Diabetes','Cancer','Heart Disease','Stroke')
 group by medical_condition
 order by total_cases desc limit 1;
 
 
 use hospital_patients_analytics;
 
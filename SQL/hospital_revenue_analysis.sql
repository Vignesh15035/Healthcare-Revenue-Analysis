create database hospital_revenue;
use hospital_revenue;


CREATE TABLE hospital_data (
name VARCHAR(100),
age INT,
gender VARCHAR(20),
blood_type VARCHAR(10),
medical_condition VARCHAR(100),
date_of_admission DATE,
doctor VARCHAR(100),
hospital VARCHAR(150),
insurance_provider VARCHAR(100),
billing_amount DECIMAL(10,2),
room_number INT,
admission_type VARCHAR(50),
discharge_date DATE,
medication VARCHAR(100),
test_results VARCHAR(50),
status VARCHAR(50),
hospital_location VARCHAR(100)
);

select count(*) from hospital_data;
select * from hospital_data limit 10;

select sum(billing_amount) as total_revenue from hospital_data;

select medical_condition,sum(billing_amount) as total_revenue from hospital_data
group by medical_condition order by total_revenue desc;

select hospital,sum(billing_amount) as total_revenue from hospital_data
group by hospital order by total_revenue desc;

select hospital_location,sum(billing_amount) as total_revenue from hospital_data
group by hospital_location order by total_revenue desc;

select insurance_provider,sum(billing_amount) as total_revenue from hospital_data
group by insurance_provider order by total_revenue desc;

select year(date_of_admission) as year,sum(billing_amount) as total_revenue
from hospital_data group by year order by year;

select avg(billing_amount) as avg_revenue from hospital_data;

select name,billing_amount from hospital_data order by billing_amount desc limit 10;

SELECT admission_type,
SUM(billing_amount) AS total_revenue
FROM hospital_data
GROUP BY admission_type;

SELECT hospital,
SUM(billing_amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(billing_amount) DESC) AS hospital_rank
FROM hospital_data
GROUP BY hospital;


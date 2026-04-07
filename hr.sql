# Database creation
CREATE DATABASE hr_project;
USE hr_project;

SELECT * FROM hr_analytics;

CREATE TABLE hr_table AS
SELECT 
  
  -- core columns
    LOWER(Attrition) AS attrition,
    Department AS department,
    `Job Role` AS job_role,
    Gender AS gender,
    Age AS age,
    `Employee Number` AS emp_id,
    
  -- cleaned column names
     LOWER(`Over Time`) AS over_time,
    `Job Level` AS job_level,
    `Work Life Balance` AS work_life_balance,
    
    -- salary and performance
	`Monthly Income` AS monthly_income,
	`Performance Rating` AS performance_rating,
	`Percent Salary Hike` AS salary_hike,
    
    -- Derived Column: Experience Group
    CASE 
        WHEN `Total Working Years` < 5 THEN '0-5'
        WHEN `Total Working Years` BETWEEN 5 AND 10 THEN '5-10'
        ELSE '10+'
    END AS experience_group,

    -- Derived column: Income Group
    CASE 
        WHEN `Monthly Income` < 3000 THEN 'Low'
        WHEN `Monthly Income` BETWEEN 3000 AND 8000 THEN 'Medium'
        ELSE 'High'
    END AS income_group
    
FROM hr_analytics
WHERE attrition IS NOT NULL
AND age IS NOT NULL
AND `Monthly Income` IS NOT NULL;

SELECT * FROM hr_table
LIMIT 10;

#Unique values
SELECT DISTINCT attrition FROM hr_table;
SELECT DISTINCT department FROM hr_table;
SELECT DISTINCT job_role FROM hr_table;
SELECT DISTINCT over_time FROM hr_table;
SELECT COUNT(DISTINCT emp_id) FROM hr_table;

SELECT attrition, COUNT(*) 
FROM hr_table
GROUP BY attrition;

SELECT department, COUNT(*) 
FROM hr_table
GROUP BY department;

SELECT job_role, COUNT(*) 
FROM hr_table
GROUP BY job_role;

-- Total Employees
SELECT COUNT(*) FROM hr_table;

-- Attrition Count
SELECT COUNT(*) AS attrition_count
FROM hr_table
WHERE attrition = 'yes';

-- Attrition Rate %
SELECT 
(COUNT(CASE WHEN attrition='yes' THEN 1 END)*100.0)/COUNT(*) AS attrition_rate
FROM hr_table;

-- Average Salary
SELECT ROUND(AVG(monthly_income),2) FROM hr_table;

#analysis queries

-- Attrition by Department
SELECT department, COUNT(*) AS attrition_count
FROM hr_table
WHERE attrition='yes'
GROUP BY department;

-- Attrition by Job Role
SELECT job_role,COUNT(*)
FROM hr
WHERE attrition='yes'
GROUP BY job_role;

-- Attrition by over time
SELECT over_time, COUNT(*) 
FROM hr_table
WHERE attrition='yes'
GROUP BY over_time;

-- Attrition by work life balance
SELECT work_life_balance, COUNT(*) 
FROM hr_table
WHERE attrition='yes'
GROUP BY work_life_balance;

-- Salary VS attrition
SELECT attrition, AVG(monthly_income)
FROM hr_table
GROUP BY attrition;

#attrition by experience group
SELECT experience_group,
COUNT(*) AS total_employees,
SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) AS attrition_count,
ROUND(SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate
FROM hr_table
GROUP BY experience_group;

#attrition by income group
SELECT income_group,
COUNT(*) AS total_employees,
SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) AS attrition_count,
ROUND(SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate
FROM hr_table
GROUP BY income_group;

#attrition by performance rating and avg salary
SELECT performance_rating,
COUNT(*) AS total_employees,
AVG(monthly_income) AS avg_salary,
SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) AS attrition_count,
ROUND(SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate
FROM hr_table
GROUP BY performance_rating;


    
    

    



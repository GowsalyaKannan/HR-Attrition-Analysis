# 📊 HR Attrition Analysis Dashboard

## 📌 Project Overview

This project focuses on analyzing employee attrition trends to identify key factors driving workforce turnover. Using **MySQL for data processing** and **Power BI for visualization**, the project delivers actionable insights to improve employee retention and support data-driven HR decisions.

The analysis highlights how factors such as **salary, experience, department, overtime, and performance** influence attrition.

---

## 🎯 Business Objective

* Identify key drivers of employee attrition
* Analyze attrition patterns across departments, roles, and income groups
* Evaluate the impact of salary, performance, and experience on employee retention
* Provide actionable recommendations to reduce attrition

---

## 🛠 Tools & Technologies Used

* **MySQL** – Data cleaning, transformation, and analysis
* **Power BI** – Interactive dashboards and data visualization
* **ODBC Connector** – Database connectivity between MySQL and Power BI
* **DAX (Data Analysis Expressions)** – KPI calculations and measures

---

## 🗂 Dataset Information

The dataset contains employee-level information including:

* Demographics: Age, Gender
* Job Details: Department, Job Role, Job Level
* Compensation: Monthly Income, Salary Hike
* Performance: Performance Rating
* Work Conditions: Work-Life Balance, Overtime
* Attrition Status

---

## ⚙️ Data Processing (MySQL)

Key steps performed:

* Standardized column names and text fields using `LOWER()`
* Validated dataset for missing values (no null values found)
* Ensured data consistency across categorical fields
* Created derived columns:

  * **Experience Group** (0–5, 5–10, 10+)
  * **Income Group** (Low, Medium, High)
* Prepared dataset for analysis and visualization in Power BI

---

## 🗄 SQL Analysis Queries

The following SQL queries were used to clean, transform, and analyze the dataset:

### 🔹 Data Cleaning & Transformation

* Standardized text fields using `LOWER()`
* hecked for duplicate records
* Created derived columns:

```sql
CASE 
    WHEN `Total Working Years` < 5 THEN '0-5'
    WHEN `Total Working Years` BETWEEN 5 AND 10 THEN '5-10'
    ELSE '10+'
END AS experience_group
```

```sql
CASE 
    WHEN `Monthly Income` < 3000 THEN 'Low'
    WHEN `Monthly Income` BETWEEN 3000 AND 8000 THEN 'Medium'
    ELSE 'High'
END AS income_group
```

---

### 🔹 Key KPI Queries

**Total Employees**

```sql
SELECT COUNT(*) FROM hr_table;
```

**Attrition Count**

```sql
SELECT COUNT(*) 
FROM hr_table
WHERE attrition = 'yes';
```

**Attrition Rate (%)**

```sql
SELECT 
(COUNT(CASE WHEN attrition='yes' THEN 1 END)*100.0)/COUNT(*) AS attrition_rate
FROM hr_table;
```

**Average Salary**

```sql
SELECT ROUND(AVG(monthly_income),2) 
FROM hr_table;
```

---

### 🔹 Analytical Queries

**Attrition by Department**

```sql
SELECT department, COUNT(*) AS attrition_count
FROM hr_table
WHERE attrition='yes'
GROUP BY department;
```

**Attrition by Income Group**

```sql
SELECT income_group,
COUNT(*) AS total_employees,
SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) AS attrition_count,
ROUND(SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate
FROM hr_table
GROUP BY income_group;
```

**Attrition by Experience Group**

```sql
SELECT experience_group,
COUNT(*) AS total_employees,
SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) AS attrition_count,
ROUND(SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate
FROM hr_table
GROUP BY experience_group;
```

---

## 📊 Dashboard Overview

### 🔹 Page 1: Attrition Overview

* Attrition by Department, Job Role, Income Group
* Attrition by Work-Life Balance & Experience
* KPI Cards: Total Employees, Attrition Rate, Avg Salary

### 🔹 Page 2: Performance Analysis

* Attrition Rate by Performance Rating
* Performance distribution across departments and experience
* Salary vs Performance comparison

### 🔹 Page 3: Salary Analysis

* Salary comparison (Attrition vs Non-Attrition)
* Salary by Department, Job Role, Experience, Gender
* Attrition Rate by Income Group

## 📐 DAX Measures (Power BI)

The following DAX measures were created to calculate KPIs and drive insights:

### 🔹 Core KPIs

**Total Employees**

```DAX
Total Employees = COUNT(hr_table[emp_id])
```

**Attrition Count**

```DAX
Attrition Count = 
CALCULATE(
    COUNT(hr_table[Attrition]),
    hr_table[attrition] = "yes"
)
```

**Attrition Rate (%)**

```DAX
Attrition Rate % = 
DIVIDE(
    [Attrition Count],
    [Total Employees]
) * 100
```

**Average Salary**

```DAX
Avg Salary = AVERAGE(hr_table[monthly_income])
```

---

### 🔹 Advanced Measures

**Avg Salary (Attrition = Yes)**

```DAX
Avg Salary Attrition Yes = 
CALCULATE(
    [Avg Salary],
    hr_table[attrition] = "yes"
)
```

**Avg Salary (Attrition = No)**

```DAX
Avg Salary Attrition No = 
CALCULATE(
    [Avg Salary],
    hr_table[attrition] = "no"
)
```

**Salary Gap %**

```DAX
Salary Gap % = 
DIVIDE(
    [Avg Salary Attrition No] - [Avg Salary Attrition Yes],
    [Avg Salary Attrition No]
) * 100
```

---

## 🔍 Key Insights

### 📉 Attrition Drivers

* **R&D** department has the highest attrition (**~56%** of total attrition)
* **Low-income employees** show the highest attrition rate **(~28%)**
* Employees with **5–10 years of experience** are most likely to leave
* Overtime employees have significantly higher attrition (~3x higher risk)

### 📊 Performance Insights

* Majority employees are average performers (Rating = 3)
* Attrition is not limited to low performers
* High-performing employees are also leaving → retention risk
* Minimal salary difference across performance levels

### 💰 Salary Insights

* Employees who left earn lower salary than those who stayed
* Salary increases significantly with experience (up to ~$10K)
* Gender pay gap is minimal
* Certain roles (Manager, Director) show high salary concentration

---

## 💡 Recommendations

* Improve compensation for **low-income employees**
* Reduce **overtime workload** and improve work-life balance
* Focus retention strategies on **mid-experience employees (5–10 years)**
* Introduce **performance-based incentives and recognition programs**
* Align **salary growth with performance ratings**
* Conduct employee engagement surveys to identify hidden dissatisfaction

---

## 📸 Dashboard Preview

### Attrition Overview

![Attrition Overview](4_Screenshots/attrition_overview.png)

### Performance Analysis

![Performance Analysis](4_Screenshots/performance_analysis.png)

### Salary Analysis

![Salary Analysis](4_Screenshots/salary_analysis.png)

---

## 📁 Project Structure

```
HR-Attrition-Analysis/
│
├── 1_Dataset/
├── 2_SQL/
├── 3_PowerBI/
├── 4_Screenshots/
└── README.md
```

---

## 🔗 Project Files

* SQL Scripts (Data Cleaning & Analysis)
* Power BI Dashboard (.pbix file)
* Dataset
* Dashboard Screenshots

---

## 🚀 How to Use

1. Open SQL scripts to understand data preparation
2. Connect Power BI to MySQL using ODBC
3. Load dataset and refresh dashboard
4. Explore insights using filters and visuals

---

## 📌 Key Skills Demonstrated

* Data Cleaning & Transformation (SQL)
* Data Analysis & Aggregation
* Data Visualization (Power BI)
* KPI Development & DAX
* Business Insight Generation
* Dashboard Design & Storytelling

---

## 📬 Conclusion

This project demonstrates how raw HR data can be transformed into meaningful insights that help organizations **reduce attrition, improve employee satisfaction, and make data-driven decisions**.

---

## 🔗 Author

**Gowsalya**

* LinkedIn: www.linkedin.com/in/gowsalya-kannadhasan-0a7017139
* GitHub: https://github.com/GowsalyaKannan

---

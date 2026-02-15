/*****************************************************************************************************************
NAME:    My Script Name
PURPOSE: My script purpose...

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     02/15/2026   Juvens ASIFIWE       1. Built this script for EC IT440


RUNTIME: 
Xm Xs

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
 
******************************************************************************************************************/

-- Q1: What should go here?
-- A1: Question goes on the previous line, intoduction to the answer goes on this line...

SELECT GETDATE() AS my_date;

USE Employee_HR
go

--Question1: How do employee engagement levels differ between high?performing employees 
-- and those with lower performance scores across the organization?


select * from dbo.employee_data
select * from dbo.training_and_development_data;


SELECT 
    ed.Performance_Score,
    AVG(es.Engagement_Score) AS Avg_Engagement,
    AVG(es.Satisfaction_Score) AS Avg_Satisfaction,
    AVG(es.Work_Life_Balance_Score) AS Avg_WorkLifeBalance,
    COUNT(*) AS Number_of_Employees
FROM employee_data AS ed
JOIN employee_engagement_survey_data AS es
    ON ed.EmpID = es.Employee_ID
WHERE ed.Performance_Score IN ('Exceed', 'Fully Meets', 'PIP')
GROUP BY ed.Performance_Score;

-- Question 2: Are employees who completed recent training programs more likely to remain active compared to 
-- those who have not participated in training? 

WITH recent_training AS (
    SELECT DISTINCT Employee_ID
    FROM training_and_development_data
    WHERE Training_Date >= DATEADD(month, -6, GETDATE())
),

-- Add training flag to all employees
employee_training_flag AS (
    SELECT 
        e.EmpID,
        e.EmployeeStatus,
        CASE 
            WHEN r.Employee_ID IS NOT NULL THEN 1 
            ELSE 0 
        END AS trained_recently
    FROM employee_data e
    LEFT JOIN recent_training r
        ON e.EmpID = r.Employee_ID
)

-- Compare active rates
SELECT 
    trained_recently,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN EmployeeStatus = 'Active' THEN 1 ELSE 0 END) AS active_employees,
    AVG(CASE WHEN EmployeeStatus = 'Active' THEN 1.0 ELSE 0 END) AS active_rate
FROM employee_training_flag
GROUP BY trained_recently;

-- Question 3: How do engagement and satisfaction scores vary across different demographic groups such as gender, race, and marital status within the company?

SELECT 
    e.GenderCode,
    e.RaceDesc,
    e.MaritalDesc,
    AVG(s.Engagement_Score) AS avg_engagement,
    AVG(s.Satisfaction_Score) AS avg_satisfaction,
    AVG(s.Work_Life_Balance_Score) AS avg_work_life_balance
FROM employee_data e
JOIN employee_engagement_survey_data s
    ON e.EmpID = s.Employee_ID
GROUP BY 
    e.GenderCode,
    e.RaceDesc,
    e.MaritalDesc
ORDER BY avg_engagement DESC;

-- 4: How closely do our external job applicants match the demographic and skill profile of our current employees, especially for roles with high turnover?

SELECT 
    'Employee' AS GroupType,
    GenderCode AS Gender,
    RaceDesc AS Race,
    EmployeeClassificationType AS Education_Level,
    COUNT(*) AS total_people
FROM employee_data
GROUP BY GenderCode, RaceDesc, EmployeeClassificationType

UNION ALL

SELECT 
    'Applicant' AS GroupType,
    Gender,
    Country AS Race,
    Education_Level,
    COUNT(*) AS total_people
FROM recruitment_data
GROUP BY Gender, Country, Education_Level;

-- Question 5: How have player monthly salaries changed over time for each team, and are certain playing positions experiencing faster salary growth than others across the season?

use MyFC
go

SELECT 
    t.t_code AS Team,
    p.p_name AS Position,
    d.year_number,
    d.month_number,
    SUM(f.mtd_salary) AS total_monthly_salary
FROM tblPlayerFact f
JOIN tblPlayerDim pl
    ON f.pl_id = pl.pl_id
JOIN tblTeamDim t
    ON pl.t_id = t.t_id
JOIN tblPositionDim p
    ON pl.p_id = p.p_id
JOIN DateDim d
    ON f.as_of_date = d.day_date
GROUP BY 
    t.t_code,
    p.p_name,
    d.year_number,
    d.month_number
ORDER BY 
    t.t_code,
    p.p_name,
    d.year_number,
    d.month_number;

    -- Question 6: How many players does each team currently have in each playing position, and are there any teams showing shortages or imbalances in key 
    -- roles that could affect match preparation or squad depth?


SELECT 
    t.t_code AS Team,
    p.p_name AS Position,
    COUNT(*) AS player_count
FROM tblPlayerDim pl
JOIN tblTeamDim t
    ON pl.t_id = t.t_id
JOIN tblPositionDim p
    ON pl.p_id = p.p_id
GROUP BY 
    t.t_code,
    p.p_name
ORDER BY 
    t.t_code,
    player_count ASC;

-- Question 7: What is the total monthly salary cost for each team, and how does this cost vary across different months of the season when considering player movements or contract adjustments?


SELECT 
    t.t_code AS Team,
    d.year_number,
    d.month_number,
    SUM(f.mtd_salary) AS total_monthly_salary
FROM tblPlayerFact f
JOIN tblPlayerDim pl
    ON f.pl_id = pl.pl_id
JOIN tblTeamDim t
    ON pl.t_id = t.t_id
JOIN DateDim d
    ON f.as_of_date = d.day_date
GROUP BY 
    t.t_code,
    d.year_number,
    d.month_number
ORDER BY 
    t.t_code,
    d.year_number,
    d.month_number;

-- Question 8: How does the age distribution of players differ across various playing positions, and are certain roles dominated by younger or older players who may influence 
-- long‑term squad planning or future recruitment needs?


SELECT 
    p.p_name AS Position,
    AVG(f.mtd_salary) AS avg_salary,
    MIN(f.mtd_salary) AS min_salary,
    MAX(f.mtd_salary) AS max_salary,
    COUNT(DISTINCT pl.pl_id) AS player_count
FROM tblPlayerFact f
JOIN tblPlayerDim pl
    ON f.pl_id = pl.pl_id
JOIN tblPositionDim p
    ON pl.p_id = p.p_id
GROUP BY p.p_name
ORDER BY avg_salary DESC; 


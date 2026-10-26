-- Staging: clean types and text once, so every KPI reads the same definitions.
CREATE OR REPLACE TABLE stg_employee AS
SELECT
    EmpID                                         AS emp_id,
    TRIM(Department)                              AS department,
    TRIM(Position)                                AS position,
    TRIM(Sex)                                     AS sex,
    ManagerID                                     AS manager_id,
    TRIM(RecruitmentSource)                       AS recruitment_source,
    TRIM(PerformanceScore)                        AS performance_score,
    CAST(strptime(DateofHire, '%m/%d/%Y') AS DATE) AS hire_date,
    CAST(strptime(DateofTermination, '%m/%d/%Y') AS DATE) AS term_date,
    CASE EmploymentStatus WHEN 'Voluntarily Terminated' THEN 'Voluntary'
                          WHEN 'Terminated for Cause' THEN 'Involuntary' END AS term_type,
    NULLIF(TermReason, 'N/A-StillEmployed')       AS term_reason,
    Salary                                        AS salary,
    EngagementSurvey                              AS engagement,
    Absences                                      AS absences
FROM raw_hr;

CREATE OR REPLACE TABLE dim_month AS
SELECT CAST(last_day(m) AS DATE) AS month_end
FROM range(DATE '2012-01-01', DATE '2019-01-01', INTERVAL 1 MONTH) t(m);

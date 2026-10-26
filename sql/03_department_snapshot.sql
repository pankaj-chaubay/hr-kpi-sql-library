-- KPI-03..07 Department snapshot at the reporting date (default 2018-12-31):
-- headcount, average tenure, annual personnel cost (current salaries), average engagement, average absences.
SELECT COALESCE(department, 'All') AS department,
       COUNT(*)                                                    AS headcount,
       ROUND(AVG(date_diff('day', hire_date, DATE '2018-12-31')) / 365.25, 2) AS avg_tenure_years,
       CAST(SUM(salary) AS BIGINT)                                 AS annual_personnel_cost,
       ROUND(AVG(salary), 0)                                       AS avg_salary,
       ROUND(AVG(engagement), 2)                                   AS avg_engagement,
       ROUND(AVG(absences), 1)                                     AS avg_absences
FROM stg_employee
WHERE hire_date <= DATE '2018-12-31' AND (term_date IS NULL OR term_date > DATE '2018-12-31')
GROUP BY ROLLUP (department)
HAVING COUNT(*) >= 5 OR GROUPING(department) = 1  -- small-group rule: no cut below 5 people
ORDER BY GROUPING(department) DESC, department;

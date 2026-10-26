-- KPI-10 Span of control: active direct reports per manager at the reporting date.
SELECT manager_id, COUNT(*) AS direct_reports
FROM stg_employee
WHERE manager_id IS NOT NULL
  AND hire_date <= DATE '2018-12-31' AND (term_date IS NULL OR term_date > DATE '2018-12-31')
GROUP BY manager_id
ORDER BY direct_reports DESC;

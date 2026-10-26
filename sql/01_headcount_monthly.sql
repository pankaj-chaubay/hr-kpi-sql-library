-- KPI-01 Headcount: employees on payroll at month-end (hire_date <= month_end and not yet left).
SELECT m.month_end,
       COUNT(e.emp_id) AS headcount
FROM dim_month m
LEFT JOIN stg_employee e
       ON e.hire_date <= m.month_end
      AND (e.term_date IS NULL OR e.term_date > m.month_end)
GROUP BY m.month_end
ORDER BY m.month_end;

-- KPI-08 Leavers by reason and type, all years. Shows what drives voluntary exits.
SELECT term_type, term_reason, COUNT(*) AS leavers,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS share_pct
FROM stg_employee
WHERE term_date IS NOT NULL
GROUP BY term_type, term_reason
ORDER BY leavers DESC;

-- KPI-09 Recruitment source quality: hires, share still employed, share leaving within 12 months,
-- and share rated 'Exceeds' or 'Fully Meets'.
SELECT recruitment_source,
       COUNT(*) AS hires,
       ROUND(AVG(CASE WHEN term_date IS NULL THEN 1 ELSE 0 END) * 100, 1) AS still_employed_pct,
       ROUND(AVG(CASE WHEN term_date IS NOT NULL AND date_diff('day', hire_date, term_date) <= 365 THEN 1 ELSE 0 END) * 100, 1)
           AS left_within_12m_pct,
       ROUND(AVG(CASE WHEN performance_score IN ('Exceeds', 'Fully Meets') THEN 1 ELSE 0 END) * 100, 1)
           AS meets_or_exceeds_pct
FROM stg_employee
GROUP BY recruitment_source
HAVING COUNT(*) >= 5
ORDER BY hires DESC;

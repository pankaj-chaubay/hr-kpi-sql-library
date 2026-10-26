-- KPI-02 Attrition rate (rolling 12 months) = leavers in the last 12 months / average month-end headcount
-- over the same 12 months. Voluntary attrition counts voluntary leavers only.
WITH hc AS (
    SELECT m.month_end, COUNT(e.emp_id) AS headcount
    FROM dim_month m
    LEFT JOIN stg_employee e
           ON e.hire_date <= m.month_end AND (e.term_date IS NULL OR e.term_date > m.month_end)
    GROUP BY m.month_end
),
lv AS (
    SELECT CAST(last_day(term_date) AS DATE) AS month_end,
           COUNT(*) AS leavers,
           COUNT(*) FILTER (WHERE term_type = 'Voluntary') AS voluntary_leavers
    FROM stg_employee WHERE term_date IS NOT NULL
    GROUP BY 1
),
j AS (
    SELECT hc.month_end, hc.headcount, COALESCE(lv.leavers, 0) AS leavers,
           COALESCE(lv.voluntary_leavers, 0) AS voluntary_leavers
    FROM hc LEFT JOIN lv USING (month_end)
)
SELECT month_end, headcount,
       SUM(leavers) OVER w AS leavers_12m,
       SUM(voluntary_leavers) OVER w AS voluntary_leavers_12m,
       ROUND(AVG(headcount) OVER w, 2) AS avg_headcount_12m,
       ROUND(SUM(leavers) OVER w / AVG(headcount) OVER w, 4) AS attrition_rate_12m,
       ROUND(SUM(voluntary_leavers) OVER w / AVG(headcount) OVER w, 4) AS voluntary_attrition_rate_12m
FROM j
WINDOW w AS (ORDER BY month_end ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)
QUALIFY COUNT(*) OVER w = 12
ORDER BY month_end;

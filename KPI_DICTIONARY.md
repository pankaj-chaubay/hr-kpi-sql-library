# HR KPI dictionary

One definition per KPI, so every report, dashboard and spreadsheet gives the same number. Each KPI names its SQL file, its grain and the traps to avoid.

| ID | KPI | Definition | Grain | SQL |
|---|---|---|---|---|
| KPI-01 | Headcount | Employees with hire date on or before the month-end and no termination date, or a termination date after the month-end | Month-end | 01_headcount_monthly.sql |
| KPI-02 | Attrition rate, rolling 12 months | Leavers in the last 12 months / average month-end headcount over the same 12 months | Month-end | 02_attrition_rolling_12m.sql |
| KPI-02v | Voluntary attrition rate, rolling 12 months | As KPI-02, voluntary leavers only | Month-end | 02_attrition_rolling_12m.sql |
| KPI-03 | Average tenure | Mean of (reporting date - hire date) in years, active employees | Reporting date | 03_department_snapshot.sql |
| KPI-04 | Annual personnel cost | Sum of annual salary of active employees (base pay only) | Reporting date | 03_department_snapshot.sql |
| KPI-05 | Average salary | KPI-04 / headcount | Reporting date | 03_department_snapshot.sql |
| KPI-06 | Average engagement | Mean engagement survey score (1-5), active employees | Reporting date | 03_department_snapshot.sql |
| KPI-07 | Average absences | Mean absence days per active employee | Reporting date | 03_department_snapshot.sql |
| KPI-08 | Leavers by reason | Count and share of leavers by termination type and reason | All years | 04_leavers_by_reason.sql |
| KPI-09 | Recruitment source quality | Hires, share still employed, share leaving within 12 months, share rated Meets or Exceeds, per source (5+ hires) | All years | 05_source_quality.sql |
| KPI-10 | Span of control | Active direct reports per manager | Reporting date | 06_span_of_control.sql |

## Rules that apply to every KPI

- **Leaver month:** a leaver counts in the month of their termination date. Their last day is not counted as a headcount day at that month-end.
- **Text fields are trimmed** in staging (`00_staging.sql`). In the raw file 'Production' and 'Production  ' would otherwise be two departments. See the data quality project.
- **Small groups:** do not publish a KPI cut for fewer than 5 people. Average salary or engagement for 1-2 people identifies them. For example, the Executive Office has one person.
- **Salary:** the source has the current salary only. Personnel cost for past months therefore uses today's pay. Say so on any trend chart.
- **Rolling 12 months** needs 12 complete months of data. Earlier months are left out (QUALIFY in KPI-02).

## Cross-check

`run_kpis.py` checks that headcount (207) and 12-month leavers (13) at Dec 2018 match the Power BI dashboard in the people-analytics-portfolio repository. The SQL and the DAX measures use the same definitions.

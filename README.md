# HR KPI SQL library

Ten HR KPIs written once in SQL, with a [KPI dictionary](KPI_DICTIONARY.md) that defines each one: headcount, rolling 12-month attrition (total and voluntary), tenure, personnel cost, engagement, absences, leavers by reason, recruitment source quality and span of control.

The point is consistency. When HR, Finance and the business each calculate attrition their own way, the monthly review turns into a debate about numbers. One staging layer, one definition per KPI and one check against the dashboard fix that.

**Data:** Human Resources Data Set by Dr. Rich Huebner (public, fictional, 311 employees). **Engine:** DuckDB. The SQL is close to standard and moves to Snowflake with small changes.

## Results (Dec 2018)

| KPI | Value |
|---|---|
| Headcount | 207 |
| Attrition, rolling 12 months | 6.1% (13 leavers, 9 voluntary) |
| Average tenure | 5.4 years |
| Annual personnel cost (base salary) | 14.6 M |
| Top voluntary leaving reasons, all years | another position (20), unhappy (14), more money (11) |

`run_kpis.py` checks headcount and leavers against the [Power BI dashboard project](https://github.com/pankaj-chaubay/people-analytics-portfolio/tree/main/03-powerbi-people-dashboard). Both pass, so SQL and DAX use the same definitions.

## Files

| File | KPI |
|---|---|
| `sql/00_staging.sql` | Clean types and trim text once, build the month calendar |
| `sql/01_headcount_monthly.sql` | KPI-01 headcount by month-end |
| `sql/02_attrition_rolling_12m.sql` | KPI-02 attrition, rolling 12 months |
| `sql/03_department_snapshot.sql` | KPI-03 to 07 by department, with the small-group rule (no cut below 5 people) |
| `sql/04_leavers_by_reason.sql` | KPI-08 leavers by reason |
| `sql/05_source_quality.sql` | KPI-09 recruitment source quality |
| `sql/06_span_of_control.sql` | KPI-10 span of control |

## Run

```
pip install -r requirements.txt
python run_kpis.py
```

Outputs go to `output/`. Summary: [results.md](results.md).

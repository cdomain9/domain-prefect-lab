WITH date_spine AS (

  {{ dbt_utils.date_spine(
      start_date="to_date('11/01/2009', 'mm/dd/yyyy')",
      datepart="day",
      end_date="dateadd(year, 30, current_date)"
     )
  }}

)
, 

calculated as (

    SELECT  
      date_day,
      date_day                                                                                AS date_actual,

      DAYNAME(date_day)                                                                       AS day_name,

      DATE_PART('month', date_day)                                                            AS month_actual,
      DATE_PART('year', date_day)                                                             AS year_actual,
      DATE_PART(quarter, date_day)                                                            AS quarter_actual,

      DATE_PART(dayofweek, date_day) + 1                                                      AS day_of_week,
      CASE WHEN day_name = 'Sun' THEN date_day
        ELSE DATEADD('day', -1, DATE_TRUNC('week', date_day)) END                             AS first_day_of_week,

      CASE WHEN day_name = 'Sun' THEN WEEK(date_day) + 1
        ELSE WEEK(date_day) END                                                               AS week_of_year_temp, --remove this column

      CASE WHEN day_name = 'Sun' AND LEAD(week_of_year_temp) OVER (ORDER BY date_day) = '1'
        THEN '1'
        ELSE week_of_year_temp END                                                            AS week_of_year,

      DATE_PART('day', date_day)                                                              AS day_of_month,

      ROW_NUMBER() OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day)          AS day_of_quarter,
      ROW_NUMBER() OVER (PARTITION BY year_actual ORDER BY date_day)                          AS day_of_year,

      

      TO_CHAR(date_day, 'MMMM')                                                               AS month_name,

      TRUNC(date_day, 'Month')                                                                AS first_day_of_month,
      LAST_VALUE(date_day) OVER (PARTITION BY year_actual, month_actual ORDER BY date_day)    AS last_day_of_month,

      FIRST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day)                 AS first_day_of_year,
      LAST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day)                  AS last_day_of_year,

      FIRST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day) AS first_day_of_quarter,
      LAST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day)  AS last_day_of_quarter,


      LAST_VALUE(date_day) OVER (PARTITION BY first_day_of_week ORDER BY date_day)            AS last_day_of_week,

      (year_actual || '-Q' || EXTRACT(QUARTER FROM date_day))                                 AS quarter_name



    FROM date_spine

)

select * from calculated
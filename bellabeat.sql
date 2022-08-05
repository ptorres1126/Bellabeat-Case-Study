  -- Verify 33 users in daily activity table.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.daily_activity`;
  -- Verify 33 users in daily calories.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.daily_calories`;
  -- Verify 33 users in daily intensities.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.daily_intensities`;
  -- Verify 33 users in daily steps.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.daily_steps`;
  -- Verify 33 users in hourly calories.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.hourly_calories`;
  -- Verify 33 users in hourly intensities.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.hourly_intensities`;
  -- Verify 33 users in hourly steps.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.hourly_steps`;
  -- Verify 24 users in sleep.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.sleep`;
  -- Verify 8 users in weight.
SELECT
  COUNT(DISTINCT Id)
FROM
  `fitbit_data.weight`;
  -- Check to see which column names are shared across tables
SELECT
  column_name,
  COUNT(table_name)
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
GROUP BY
  1;
  -- We found that Id was used 8 times across the 8 tables in the dataset, let's make sure that it is in used once in each table.
SELECT
  table_name,
  SUM(CASE
      WHEN column_name = "Id" THEN 1
    ELSE
    0
  END
    ) AS has_id_column
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
GROUP BY
  1
ORDER BY
  1 ASC;
  -- This query checks to make sure that each table has a column of a date or time related type. Timestamps were formatted & split in Google Sheets. If run correctly,no data should be returned.
SELECT
  table_name,
  SUM(CASE
      WHEN data_type IN ("TIMESTAMP", "DATETIME", "TIME", "DATE") THEN 1
    ELSE
    0
  END
    ) AS has_time_info
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
WHERE
  data_type IN ("TIMESTAMP",
    "DATETIME",
    "DATE")
GROUP BY
  1
HAVING
  has_time_info = 0;
  -- Here we check to see if the column name has any of the keywords below:
  -- date, minute, daily, hourly, day, seconds
SELECT
  table_name,
  column_name
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
WHERE
  REGEXP_CONTAINS(LOWER(column_name), "date|minute|daily|hourly|day|seconds");
  -- Confirm 4 tables have daily data.
SELECT
  DISTINCT table_name
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
WHERE
  REGEXP_CONTAINS(LOWER(table_name),"day|daily");
  --Confirm 2 tables have hourly data
SELECT
  DISTINCT table_name
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
WHERE
  REGEXP_CONTAINS(LOWER(table_name),"hour|hourly");
  -- Check that data types align between tables.
SELECT
  column_name,
  table_name,
  data_type
FROM
  `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
WHERE
  REGEXP_CONTAINS(LOWER(table_name),"day|daily")
  AND column_name IN (
  SELECT
    column_name
  FROM
    `bellabeat-214.fitbit_data.INFORMATION_SCHEMA.COLUMNS`
  WHERE
    REGEXP_CONTAINS(LOWER(table_name),"day|daily")
  GROUP BY
    1
  HAVING
    COUNT(table_name) >=2)
ORDER BY
  1;
SELECT
  A.Id,
  A.Calories,
  * EXCEPT(Id,
    Calories,
    Date,
    SedentaryMinutes,
    LightlyActiveMinutes,
    FairlyActiveMinutes,
    VeryActiveMinutes,
    SedentaryActiveDistance,
    LightActiveDistance,
    ModeratelyActiveDistance,
    VeryActiveDistance),
  I.SedentaryMinutes,
  I.LightlyActiveMinutes,
  I.FairlyActiveMinutes,
  I.VeryActiveMinutes,
  I.SedentaryActiveDistance,
  I.LightActiveDistance,
  I.ModeratelyActiveDistance,
  I.VeryActiveDistance
FROM
  `bellabeat-214.fitbit_data.daily_activity` A
LEFT JOIN
  `bellabeat-214.fitbit_data.daily_calories` C
ON
  A.Id = C.Id
  AND A.Date=C.Date
  AND A.Calories = C.Calories
LEFT JOIN
  `bellabeat-214.fitbit_data.daily_intensities` I
ON
  A.Id = I.Id
  AND A.Date=I.Date
  AND A.FairlyActiveMinutes = I.FairlyActiveMinutes
  AND A.LightActiveDistance = I.LightActiveDistance
  AND A.LightlyActiveMinutes = I.LightlyActiveMinutes
  AND A.ModeratelyActiveDistance = I.ModeratelyActiveDistance
  AND A.SedentaryActiveDistance = I.SedentaryActiveDistance
  AND A.SedentaryMinutes = I.SedentaryMinutes
  AND A.VeryActiveDistance = I.VeryActiveDistance
  AND A.VeryActiveMinutes = I.VeryActiveMinutes
LEFT JOIN
  `bellabeat-214.fitbit_data.daily_steps` S
ON
  A.Id = S.Id
  AND A.Date=S.Date
LEFT JOIN
  `bellabeat-214.fitbit_data.sleep` Sl
ON
  A.Id = Sl.Id
  AND A.Date=Sl.Date;
  -- Find average daily steps per user. Average device recommendation is 10,000 steps daily.
  -- https://www.nih.gov/news-events/nih-research-matters/how-many-steps-better-health
SELECT
  Id,
  AVG(TotalSteps)
FROM
  `fitbit_data.daily_activity`
GROUP BY
  Id
ORDER BY
  AVG(TotalSteps);
  -- Users that meet the recommended daily steps.(7 users)
SELECT
  Id,
  AVG(TotalSteps)
FROM
  `fitbit_data.daily_activity`
GROUP BY
  Id
HAVING
  AVG(TotalSteps) >= 10000;
  -- Users that do not meet recommended daily steps.(26 users)
SELECT
  Id,
  AVG(TotalSteps)
FROM
  `fitbit_data.daily_activity`
GROUP BY
  Id
HAVING
  AVG(TotalSteps) < 10000;
  -- Setting variables for time of day/ day of week analyses
DECLARE
  MORNING_START,
  MORNING_END,
  AFTERNOON_END,
  EVENING_END INT64;
  -- Set the times for the times of the day
SET
  MORNING_START = 6;
SET
  MORNING_END = 12;
SET
  AFTERNOON_END = 18;
SET
  EVENING_END = 21;
  -- Analysis based upon the time of day and day of the week
  -- We will do this at a person level such that we smooth over anomalous days for an individual
  --Results saved in Google Sheets as fitbit_data_dow_summary
WITH
  user_dow_summary AS (
  SELECT
    Id,
    FORMAT_TIMESTAMP("%w", Time) AS dow_number,
    FORMAT_TIMESTAMP("%A", Time) AS day_of_week,
    CASE
      WHEN FORMAT_TIMESTAMP("%A", Time) IN ("Sunday", "Saturday") THEN "Weekend"
      WHEN FORMAT_TIMESTAMP("%A", Time) NOT IN ("Sunday",
      "Saturday") THEN "Weekday"
    ELSE
    "ERROR"
  END
    AS part_of_week,
    CASE
      WHEN TIME(Time) BETWEEN TIME(MORNING_START, 0, 0) AND TIME(MORNING_END, 0, 0) THEN "Morning"
      WHEN TIME(Time) BETWEEN TIME(MORNING_END,
      0,
      0)
    AND TIME(AFTERNOON_END,
      0,
      0) THEN "Afternoon"
      WHEN TIME(Time) BETWEEN TIME(AFTERNOON_END, 0, 0) AND TIME(EVENING_END, 0, 0) THEN "Evening"
      WHEN TIME(Time) >= TIME(EVENING_END,
      0,
      0)
    OR TIME(TIMESTAMP_TRUNC(Time, MINUTE)) <= TIME(MORNING_START,
      0,
      0) THEN "Night"
    ELSE
    "ERROR"
  END
    AS time_of_day,
    SUM(TotalIntensity) AS total_intensity,
    SUM(AverageIntensity) AS total_average_intensity,
    AVG(AverageIntensity) AS average_intensity,
    MAX(AverageIntensity) AS max_intensity,
    MIN(AverageIntensity) AS min_intensity
  FROM
    `bellabeat-214.fitbit_data.hourly_intensities`
  GROUP BY
    1,
    2,
    3,
    4,
    5),
  intensity_deciles AS (
  SELECT
    DISTINCT dow_number,
    part_of_week,
    day_of_week,
    time_of_day,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.1) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_first_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.2) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_second_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.3) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_third_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.4) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_fourth_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.6) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_sixth_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.7) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_seventh_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.8) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_eigth_decile,
    ROUND(PERCENTILE_CONT(total_intensity,
        0.9) OVER (PARTITION BY dow_number, part_of_week, day_of_week, time_of_day),4) AS total_intensity_ninth_decile
  FROM
    user_dow_summary ),
  basic_summary AS (
  SELECT
    part_of_week,
    day_of_week,
    time_of_day,
    SUM(total_intensity) AS total_total_intensity,
    AVG(total_intensity) AS average_total_intensity,
    SUM(total_average_intensity) AS total_total_average_intensity,
    AVG(total_average_intensity) AS average_total_average_intensity,
    SUM(average_intensity) AS total_average_intensity,
    AVG(average_intensity) AS average_average_intensity,
    AVG(max_intensity) AS average_max_intensity,
    AVG(min_intensity) AS average_min_intensity
  FROM
    user_dow_summary
  GROUP BY
    1,
    dow_number,
    2,
    3)
SELECT
  *
FROM
  basic_summary
LEFT JOIN
  intensity_deciles
USING
  (part_of_week,
    day_of_week,
    time_of_day)
ORDER BY
  1,
  dow_number,
  2,
  CASE
    WHEN time_of_day = "Morning" THEN 0
    WHEN time_of_day = "Afternoon" THEN 1
    WHEN time_of_day = "Evening" THEN 2
    WHEN time_of_day = "Night" THEN 3
END
  ;
  --Daily instensities: Combine total minutes per activity level, extract day of week.
SELECT
  Date AS day,
  FORMAT_DATE('%A', DATE) AS weekday_name,
  SUM(SedentaryMinutes) AS total_sedentary_minutes,
  SUM(LightlyActiveMinutes) AS total_lightly_active_minutes,
  SUM(FairlyActiveMinutes) AS total_fairly_actice_minutes,
  SUM(VeryActiveMinutes) AS total_very_active_minutes,
FROM
  `fitbit_data.daily_intensities`
GROUP BY
  Date
ORDER BY
  weekday_name ;
  --Total intensity minutes per day of week.
  --Results save to Google Sheets as average_intensity_minutes_dow
SELECT
  AVG(SedentaryMinutes) AS avg_sedentary_minutes,
  AVG(LightlyActiveMinutes) AS avg_lightly_active_minutes,
  AVG(FairlyActiveMinutes) AS avg_fairly_actice_minutes,
  AVG(VeryActiveMinutes) AS avg_very_active_minutes,
  FORMAT_DATE('%A', DATE) AS weekday_name,
FROM
  `fitbit_data.daily_intensities`
GROUP BY
  weekday_name;
  --Total steps per day of week.
  --Results save to Google Sheets as average_daily_steps_dow
SELECT
  FORMAT_DATE('%A', Date) AS weekday_name,
  AVG(StepTotal) AS average_daily_steps,
FROM
  `fitbit_data.daily_steps`
GROUP BY
  weekday_name;
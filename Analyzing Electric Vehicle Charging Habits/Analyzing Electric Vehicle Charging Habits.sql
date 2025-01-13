CREATE TABLE public.charging_sessions(
    garage_id VARCHAR(255),
    user_id VARCHAR(255),
    user_type VARCHAR(255),
    start_plugin TIMESTAMP,
    start_plugin_hour NUMERIC,
    end_plugout TIMESTAMP,
    end_plugout_hour NUMERIC,
    el_kwh NUMERIC,
    duration_hours NUMERIC,
    month_plugin VARCHAR(255),
    weekdays_plugin VARCHAR(255)
);

/* Write three SQL queries to answer the following questions: 

1. Find the number of unique individuals that use each garage’s shared charging stations. 
The output should contain two columns: garage_id and num_unique_users. 
Sort your results by the number of unique users from highest to lowest. Save the result as unique_users_per_garage.

2. Find the top 10 most popular charging start times (by weekday and start hour) for sessions that use shared charging stations. 
Your result should contain three columns: weekdays_plugin, start_plugin_hour, 
and a column named num_charging_sessions containing the number of plugins on that weekday at that hour. 
Sort your results from the most to the least number of sessions. Save the result as most_popular_shared_start_times.

3. Find the users whose average charging duration last longer than 10 hours when using shared charging stations. 
Your result should contain two columns: user_id and avg_charging_duration. 
Sort your result from highest to lowest average charging duration. Save the result as long_duration_shared_users. */

-- 1. Find the number of unique individuals that use each garage’s shared charging stations.
-- unique_users_per_garage
SELECT garage_id, 
       COUNT(DISTINCT user_id) AS num_unique_users
FROM public.charging_sessions
WHERE user_type = 'Shared'
GROUP BY garage_id
ORDER BY num_unique_users DESC;

-- 2. Find the top 10 most popular charging start times (by weekday and start hour) for sessions that use shared charging stations.
-- most_popular_shared_start_times
SELECT weekdays_plugin, 
    start_plugin_hour, 
    COUNT(*) AS num_charging_sessions
FROM public.charging_sessions
WHERE user_type = 'Shared'
GROUP BY weekdays_plugin, start_plugin_hour
ORDER BY num_charging_sessions DESC
LIMIT 10;

-- 3. Find the users whose average charging duration last longer than 10 hours when using shared charging stations.
-- long_duration_shared_users
SELECT user_id, 
    AVG(duration_hours) AS avg_charging_duration
FROM public.charging_sessions
WHERE user_type = 'Shared'
GROUP BY user_id
HAVING AVG(duration_hours) > 10
ORDER BY avg_charging_duration DESC;

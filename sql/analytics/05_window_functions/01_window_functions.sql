-- Raking de usuarios por watch_time
SELECT
  user_id,
  watch_time_minutes,
  ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY watch_time_minutes DESC
  ) as rn
FROM viewing_session
LIMIT 10;

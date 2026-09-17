SELECT
    sid,
    serial#,
    username,
    status,
    sql_id,
    event
FROM v$session
WHERE username IS NOT NULL;
SELECT
    s.sid,
    s.serial#,
    s.sql_id,
    q.sql_text
FROM v$session s
LEFT JOIN v$sql q
    ON s.sql_id = q.sql_id
WHERE s.blocking_session IS NOT NULL;
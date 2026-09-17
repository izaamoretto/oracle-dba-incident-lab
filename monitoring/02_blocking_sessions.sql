SELECT
    sid,
    serial#,
    username,
    status,
    blocking_session
FROM v$session
WHERE blocking_session IS NOT NULL;
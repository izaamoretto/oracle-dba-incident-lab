SELECT
    tablespace_name,
    ROUND(used_space * block_size / 1024 / 1024, 2) AS used_mb,
    ROUND(tablespace_size * block_size / 1024 / 1024, 2) AS total_mb,
    ROUND(used_percent, 2) AS used_percent
FROM dba_tablespace_usage_metrics
ORDER BY used_percent DESC;
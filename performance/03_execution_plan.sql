EXPLAIN PLAN FOR
SELECT
    id_cliente,
    nome,
    cpf,
    email,
    cidade,
    estado
FROM clientes
WHERE cpf = '00000456789';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
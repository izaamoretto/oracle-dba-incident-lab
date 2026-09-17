INSERT INTO clientes (
    nome,
    cpf,
    email,
    cidade,
    estado,
    data_cadastro
)
SELECT
    'Cliente ' || LEVEL,
    LPAD(LEVEL, 11, '0'),
    'cliente' || LEVEL || '@email.com',
    CASE MOD(LEVEL, 5)
        WHEN 0 THEN 'Blumenau'
        WHEN 1 THEN 'Timbó'
        WHEN 2 THEN 'Joinville'
        WHEN 3 THEN 'Florianópolis'
        ELSE 'Itajaí'
    END,
    'SC',
    SYSDATE - MOD(LEVEL, 1000)
FROM dual
CONNECT BY LEVEL <= 500000;

COMMIT;
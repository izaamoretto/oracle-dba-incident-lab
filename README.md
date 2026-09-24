# Oracle DBA Incident Lab
Laboratório prático de administração, troubleshooting e performance em Oracle Database.

## Objetivo:
Simular incidentes reais de sustentação de banco de dados, realizando investigação, análise de evidências, aplicação de correções, validação dos resultados e documentação técnica.

## Ambiente:
- Oracle Database 26ai Free
- Docker
- SQL
- PL/SQL
- Windows / PowerShell
- Git e GitHub

## Estrutura do projeto:
- database/ - criação das tabelas e carga de dados
- incidents/ - documentação dos incidentes
- performance/ - consultas e scripts de análise de performance
- monitoring/ - scripts de monitoramento e diagnóstico
- evidence/ - evidências e prints das análises

# Incidentes:

# 20260916-INC
Problema: lentidão em consulta de clientes por CPF.

Durante a investigação, foi identificado que a consulta realizava TABLE ACCESS FULL na tabela CLIENTES, que possuía 500.000 registros.

Após análise dos índices existentes, foi constatado que a coluna CPF, utilizada como filtro altamente seletivo, não possuía índice.

Foi criado o índice:
CREATE INDEX idx_clientes_cpf
ON clientes(cpf);

Após a criação do índice, as estatísticas da tabela foram atualizadas e o plano de execução foi analisado novamente.

O plano deixou de utilizar TABLE ACCESS FULL e passou a utilizar INDEX RANGE SCAN.

## Resultado:

Antes:
TABLE ACCESS FULL
Cost: 1572

Depois:
INDEX RANGE SCAN
Cost: 4

O tempo observado no ambiente de laboratório passou de aproximadamente 0,02s para 0,00s.

O principal resultado considerado foi a mudança do plano de execução e a redução do custo estimado.

---------------------------------------------------------------------------------------

# 20260917-INC
Problema: sessão bloqueada por transação aberta.

Foi simulado um cenário em que uma sessão executou um UPDATE na tabela PEDIDOS e permaneceu sem executar COMMIT ou ROLLBACK.

Uma segunda sessão tentou atualizar o mesmo registro e permaneceu aguardando a liberação do lock.

Durante a investigação, a sessão bloqueada foi identificada através da view dinâmica V$SESSION, utilizando o campo BLOCKING_SESSION.

Foi identificado que:
- a sessão bloqueada estava em estado ACTIVE;
- a sessão bloqueadora estava em estado INACTIVE;
- mesmo estando inativa, a sessão bloqueadora mantinha uma transação aberta;
- o SQL bloqueado era um UPDATE na tabela PEDIDOS.

Exemplo do SQL bloqueado:
UPDATE pedidos
SET valor_total = 1500
WHERE id_pedido = 1;

A causa foi uma transação aberta na sessão bloqueadora, que mantinha o lock sobre o registro.

A ação aplicada foi:
COMMIT;

Após o COMMIT, o lock foi liberado e a sessão bloqueada conseguiu concluir a operação normalmente.

A consulta de verificação em V$SESSION deixou de retornar sessões com BLOCKING_SESSION.

## Resultado:

Antes:
Sessão bloqueada identificada
BLOCKING_SESSION preenchido

Depois:
no rows selected

O incidente foi considerado resolvido após a validação de que não havia mais sessões bloqueadas.

---------------------------------------------------------------------------------------

# 20260921-INC
Problema: falha de inserção por falta de espaço em tablespace.

Foi simulado um cenário em que a aplicação começou a falhar ao inserir dados devido à falta de espaço disponível no tablespace TS_INCIDENT.

Durante a investigação, foi identificado o erro ORA-01653, além de um datafile limitado a 10 MB e com AUTOEXTEND OFF.

O uso do tablespace estava em aproximadamente 90,63%.

Como ação corretiva, foi habilitado o crescimento automático do datafile:
ALTER DATABASE DATAFILE
'/opt/oracle/oradata/FREE/FREEPDB1/ts_incident01.dbf'
AUTOEXTEND ON
NEXT 5M
MAXSIZE 50M;

Após a alteração, a carga foi executada novamente com sucesso e o datafile cresceu até 50 MB.

## Resultado:

Antes:
SIZE_MB: 10
AUTOEXTENSIBLE: NO
ORA-01653

Depois:
SIZE_MB: 50
AUTOEXTENSIBLE: YES
Inserção concluída com sucesso

---------------------------------------------------------------------------------------

# 20260922-INC
Problema: Falha de conexão com Oracle. Indisponibilidade de novas conexões com o banco de dados.

Foi simulado um incidente de conectividade através da interrupção do Oracle Listener. Durante a investigação, uma tentativa de conexão retornou o erro 'ORA-12541: No listener'.

Através do 'lsnrctl status', foi confirmada a indisponibilidade do Listener. Uma conexão administrativa local permitiu verificar que a instância Oracle permanecia 'OPEN' e o banco 'ACTIVE'.

Como ação corretiva, o Listener foi reiniciado utilizando 'lsnrctl start'. Após a correção, uma nova conexão TCP com o serviço 'FREEPDB1' foi estabelecida com sucesso.

## Resultado:
Conectividade restabelecida sem necessidade de reiniciar o banco de dados.

---------------------------------------------------------------------------------------

# 20260922-INC-005
Problema: Backup e recuperação com RMAN. Simulação de perda de dados e validação de procedimentos de recuperação no Oracle.

Foi realizado um backup completo com RMAN, incluindo archived redo logs, seguido da validação dos backups.

Durante o laboratório, foi identificada uma limitação do Oracle Free ('ORA-00441') ao tentar recuperar uma tabela por meio de uma instância auxiliar.

Como alternativa, foi realizada a restauração física de uma cópia do datafile do tablespace `USERS` em um diretório separado, preservando o banco original.

Também foi simulada a exclusão acidental de uma tabela contendo três registros, posteriormente recuperada utilizando Flashback e a Recycle Bin do Oracle.

## Resultado:
Backup validado, restauração física com RMAN concluída e recuperação lógica da tabela realizada com sucesso.

---------------------------------------------------------------------------------------

# 20260923-INC
Problema: Investigação de consumo de CPU e I/O. Investigação de uma consulta SQL com potencial consumo elevado de recursos.

Foi analisada uma consulta que percorre 500 mil registros da tabela 'CLIENTES', utilizando 'AUTOTRACE', planos de execução e a view 'V$SQL' para investigar o consumo de CPU, leituras lógicas e físicas.

Durante os testes, foram observadas 5.796 leituras lógicas, além de leituras físicas nas primeiras execuções. O plano apresentou 'TABLE ACCESS FULL', 'HASH GROUP BY e 'SORT ORDER BY'.

Uma alternativa para o cálculo de caracteres também foi testada, mas não demonstrou melhoria significativa.

## Resultado:
Investigação concluída sem evidências suficientes de um gargalo que justificasse alterações na consulta ou criação de novos índices.


---------------------------------------------------------------------------------------


### Competências praticadas:
- Oracle Database
- SQL
- Administração de Banco de Dados
- Troubleshooting
- Performance Tuning
- Análise de plano de execução
- Índices
- Locks e transações
- Monitoramento de sessões
- Documentação de incidentes
- Docker
- Git e GitHub


### Próximos cenários:
Este laboratório será expandido com novos incidentes relacionados a administração e sustentação de banco de dados, como:
- deadlocks
- consumo de tablespace
- análise de queries com alto consumo
- backup e restore
- RMAN
- indisponibilidade de banco
- troubleshooting de listener
- análise de CPU, memória e I/O
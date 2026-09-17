\# Oracle DBA Incident Lab



Laboratório prático de administração e troubleshooting em Oracle Database.



\## Objetivo



Simular incidentes reais de sustentação de banco de dados, realizando investigação, análise de evidências, aplicação de correções e documentação técnica.



\## Ambiente



\- Oracle Database 26ai Free

\- Docker

\- SQL

\- PL/SQL

\- Windows / PowerShell



\## Incidentes



\### 20260916-INC



\*\*Problema:\*\* lentidão em consulta de clientes por CPF.



Durante a investigação foi identificado que a consulta realizava `TABLE ACCESS FULL` na tabela `CLIENTES`, que possuía 500.000 registros.



Após análise dos índices existentes, foi constatado que a coluna `CPF` não possuía índice.



Foi criado o índice:



CREATE INDEX idx\_clientes\_cpf

ON clientes(cpf);



Após a correção, o plano de execução passou a utilizar INDEX RANGE SCAN.



\### Resultado



Antes:



TABLE ACCESS FULL

Cost: 1572



Depois:



INDEX RANGE SCAN

Cost: 4



\## Estrutura do projeto



\- `database/` - criação das tabelas e carga de dados

\- `incidents/` - documentação dos incidentes

\- `performance/` - consultas e scripts de análise de performance

\- `monitoring/` - scripts de monitoramento

\- `evidence/` - evidências e prints das análises






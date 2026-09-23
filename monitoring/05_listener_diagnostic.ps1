# 20260922-INC - Diagnóstico do Oracle Listener
# Executar no PowerShell com o container iniciado.

Write-Host "Verificando o status do container..."
docker ps --filter "name=oracle-dba-lab"

Write-Host "`nVerificando o Oracle Listener..."
docker exec oracle-dba-lab lsnrctl status
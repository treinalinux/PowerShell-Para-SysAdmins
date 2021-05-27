# revogar_certificados_de_usuarios.ps1
# Alan da Silva Alves
# 26/05/2021
# 
# O AD simplesmente não remove certos certificaods, e isso é problema quando uma autenticação é feita com base no certificado.
# O script deve ajudar bastante, vale ressaltar que para usar o script você deve fazer todos os testes necessário em cada uma das linhas.
# 
# Caso o script venha te ajudar, só cite a fonte.
# 
Clear-Host

## Guarda o email de um usário na variável chave
$chave = Read-Host "Informe o e-mail "

## Lista os certificados emitidos uma usuário
certutil -view -restrict "CertificateTemplate==User,UPN==$chave,Request.Disposition=0x14" -out "SerialNumber" csv > chaves.csv

## Remove o Header
Get-Content .\chaves.csv | select -Skip 1 | Set-Content novo.csv

## Guarda o arquivo na variável revogar
$revogar = Get-Content .\novo.csv

## Remove as aspas revoga a lista de certificados da chave
$revogar.trim('"') | ForEach-Object { certutil -config "DC01\CA-CORPORATIVA" -revoke $_ }

Write-Host "------------------Log detalhado para finalizar o chamado------------------"
certutil -view -restrict "CertificateTemplate==User,UPN==$chave" -out "RequesterName,SerialNumber,Request.DispositionMessage" csv

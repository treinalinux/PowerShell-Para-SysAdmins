# Nome............: revogar_certificados_de_usuarios.ps1
# Versão.........:  1.1
# Criado por......: Alan da Silva Ales
# Criado em.......: 26/5/2021
# Atualizado em...: 17/7/2021
#         - Versão 1.1 agora recebe um arquivo como entrada de dados.
#         - Deixa de usar o UPN e passar usar o CommonName
# 
# O AD simplesmente não remove certos certificaods, e isso é problema quando uma autenticação é feita com base no certificado.
# O script deve ajudar bastante, vale ressaltar que para usar o script você deve fazer todos os testes necessário em cada uma das linhas.
# 
# Caso o script venha te ajudar, só informe a fonte.
# 
Clear-Host

## ------------ Recebe as chaves dos usuários  -----------
Write-Host "

Informe os CommonName assinado:

"
pause
& .\chaves.txt
pause

$chaves = Get-Content .\chaves.txt
$chaves = $chaves.Trim()

Write-Host = "

Certificados de usuários são válidos por 1 ano,
por isso deve informar a data com menos -1 ano
Se hoje for 19/7/2021, então informe 19/7/2020

"

$AnoPassado = Read-Host "Informar a data [ex: 19/7/2020] "

## ------------ Obtendo o serial number e gerando o relatório em csv -----------

Foreach ($chave in $chaves) {
certutil -view -restrict "CertificateTemplate==User,Request.Disposition=0x14,NotBefore>=$AnoPassado,CommonName=$chave" -out "SerialNumber" csv | select -Skip 1 | Add-Content -Path SerialNumber.csv

}

## ------------ Recebe o relatório em csv e faz o tratamento -----------
$revogar = Get-Content .\SerialNumber.csv
$revogar = $revoga.Trim('"').Trim()


## ------------ Revoga os certificados válidos de usuários desligados -----------

$revogar | ForEach-Object { certutil -config "DC01\CA-CORPORATIVA" -revoke $_ 6 }

Write-Host "------------------Log detalhado para finalizar o chamado------------------"

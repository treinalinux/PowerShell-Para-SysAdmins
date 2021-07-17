# PowerShell-Para-SysAdmins

- Nome............: revogar_certificados_de_usuarios.ps1
- Versão..........: 1.1
- Criado por......: Alan da Silva Ales
- Criado em.......: 26/5/2021
- Atualizado em...: 17/7/2021         
  Versão 1.1 agora recebe um arquivo como entrada de dados.
  Deixa de usar o UPN e passar usar o CommonName

---

O Windows Server simplesmente não remove certos certificaods de usuários removidos do AD, e isso é problema quando uma autenticação é feita com base no certificado, a Microsoft deveria arrumar uma solução visto que o ADCS é integrado ao AD.

O script deve ajudar bastante, vale ressaltar que para usar o script você deve fazer todos os testes necessário em cada uma das linhas.
 
Caso o script venha te ajudar, só informe a fonte.
 

## Recebe as chaves dos usuários

Certificados de usuários são válidos por 1 ano, e por isso deve informar a data com menos -1 ano, por exemplo:
Se hoje for 19/7/2021, então informe 19/7/2020.

Sua empresa pode trabalhar com templates customizados, e por isso deve verificar a validade usada na sua empresa.


## Obtendo o serial number e gerando o relatório em csv

```PorwerShell

certutil -view -restrict "CertificateTemplate==User,Request.Disposition=0x14,NotBefore>=$AnoPassado,CommonName=$chave" -out "SerialNumber" csv

```

## Recebe o relatório em csv e faz o tratamento

Necessário remover espaços em branco e principalmente as aspas no início e no fim

## Revoga os certificados válidos de usuários desligados

A opção 6 garante a possibilidade de um rollback.

```PorwerShell

$revogar | ForEach-Object { certutil -config "DC01\CA-CORPORATIVA" -revoke $_ 6 }

```

---

## Mudança proposta para próxima versão

- Tratamento de erros
- Gerar log detalhado antes da revogação

--- 

Espero ter ajudado...

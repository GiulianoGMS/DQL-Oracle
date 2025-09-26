-- Adicionar em MACV_CONSISTELOTECOMPRA
-- Adicionado por Giuliano em 26/09/2025
-- Não gera lote se existir verba no item e não existir emai lcadastrado para envio do acordo atraves do TAE

UNION ALL

SELECT DISTINCT X.SEQGERCOMPRA,
                108 CODIGOCONSIST,
               'O Fornecedor não possui e-mail vinculado à um representante para envio do acordo ao TAE - Totvs Assinatura Eletronica!' DESCRICAO,
               'Verifique o cadastro do fornecedor e cadastre um e-mail para envio do acordo.' COMPLEMENTO,
               'B' BLOQUEIOLIBERACAO
FROM MAC_GERCOMPRA X INNER JOIN MAC_GERCOMPRAFORN Y ON (X.SEQGERCOMPRA = Y.SEQGERCOMPRA)
                     INNER JOIN MAC_GERCOMPRAITEM XI ON X.SEQGERCOMPRA = XI.SEQGERCOMPRA
                     INNER JOIN MAF_FORNECEDOR F ON F.SEQFORNECEDOR = Y.SEQFORNECEDOR
WHERE 1=1
  AND TRIM(F.EMAILACORDO) IS NULL
  AND NVL(XI.VLRUNITVERBA,0) > 0
  AND X.DTAHORINCLUSAO >= SYSDATE - 30

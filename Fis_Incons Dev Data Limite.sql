-- Ticket 658925
-- Adicionado por Giuliano em 27/11/2025
-- Nao permite vincular NF emitidas antes de 01/06/2025

SELECT A.IDSESSION,
       A.INST_ID,
       A.SEQNFDEVFORNEC,
       A.SEQPRODUTO,
       10 CODCRITICA,
       'CGO '||A.CODGERALOPER || ' não permitido para referências anteriores a 01/06/2025. Entre em contato com o suporte da loja' MENSAGEM,
       'B' INDBLOQUEIOLIBERA
  FROM MFLX_NFDEVFORNEC A INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = A.SEQPRODUTO
                          INNER JOIN MLF_NOTAFISCAL X ON X.SEQNF = A.SEQNFREF
 WHERE 1=1
   AND A.CODGERALOPER = 935
   AND X.DTAEMISSAO <= DATE '2025-06-01'

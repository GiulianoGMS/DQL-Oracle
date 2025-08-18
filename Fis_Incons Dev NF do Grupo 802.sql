-- Critica de devolucao
-- Inserir o select em ESPV_CRITICADEVNFFORN

UNION ALL
-- Ticket 619423
-- Adicionado por Giuliano em 18/08/2025
-- CGO 802 nao pode ser utilizado para fornec do grupo Nagumo            
SELECT A.IDSESSION,
       A.INST_ID,
       A.SEQNFDEVFORNEC,
       A.SEQPRODUTO,
       3 CODCRITICA,
       'Este CGO não pode ser utilizado para fornecedores do grupo [NAGUMO]' MENSAGEM,
       'B' INDBLOQUEIOLIBERA
  FROM MFLX_NFDEVFORNEC A INNER JOIN MAX_EMPRESA E ON E.NROEMPRESA = A.NROEMPRESA
 WHERE 1=1
   AND A.CODGERALOPER = 802
   AND SEQFORNECEDOR < 999

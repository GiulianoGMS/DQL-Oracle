-- Critica de devolucao
-- Inserir o select em ESPV_CRITICADEVNFFORN

UNION ALL
-- Ticket 619419
-- Adicionado por Giuliano em 18/08/2025
-- CGO 853 apenas para produtor rural                 
SELECT A.IDSESSION,
       A.INST_ID,
       A.SEQNFDEVFORNEC,
       A.SEQPRODUTO,
       2 CODCRITICA,
       'Este CGO somente pode ser utilizado para fornecedores cadastrados como Produtor Rural' MENSAGEM,
       'B' INDBLOQUEIOLIBERA
  FROM MFLX_NFDEVFORNEC A INNER JOIN MAX_EMPRESA E ON E.NROEMPRESA = A.NROEMPRESA
 WHERE 1=1
   AND A.CODGERALOPER = 853
   AND EXISTS (SELECT 1 FROM GE_PESSOA G WHERE G.SEQPESSOA = A.SEQFORNECEDOR AND NVL(G.INDPRODRURAL, 'N') = 'N')

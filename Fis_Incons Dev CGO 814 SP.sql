-- Adicionar em ESPV_CRITICADEVNFFORN

UNION ALL
-- Ticket 622611
-- Adicionado por Giuliano em 25/08/2025
-- Barra CGO 814 para empresas fora RJ
SELECT A.IDSESSION,
       A.INST_ID,
       A.SEQNFDEVFORNEC,
       A.SEQPRODUTO,
       3 CODCRITICA,
       'Não é permitido a utilização do CGO 814 para operação de empresas em SP!' MENSAGEM,
       'B' INDBLOQUEIOLIBERA
  FROM MFLX_NFDEVFORNEC A INNER JOIN MAX_EMPRESA E ON E.NROEMPRESA = A.NROEMPRESA
 WHERE 1=1
   AND A.CODGERALOPER = 814
   AND E.UF != 'RJ'

-- Inserir select em ESPV_CRITICADEVNFFORN

UNION ALL
-- Ticket 645195
-- Adicionado por Giuliano em 23/10/2025
-- CGO 811 Nao permite emissao para finalidades Uso Consumo - Ativo - Outros Insumos
SELECT A.IDSESSION,
       A.INST_ID,
       A.SEQNFDEVFORNEC,
       A.SEQPRODUTO,
       7 CODCRITICA,
       'Não é permitido a utilização do CGO 811 para emissão do produto '||P.SEQPRODUTO|| ' - '|| P.DESCCOMPLETA MENSAGEM,
       'B' INDBLOQUEIOLIBERA
  FROM MFLX_NFDEVFORNEC A INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = A.SEQPRODUTO
                          INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA
 WHERE 1=1
   AND A.CODGERALOPER = 811
   AND F.FINALIDADEFAMILIA IN ('A', 'U', 'O')

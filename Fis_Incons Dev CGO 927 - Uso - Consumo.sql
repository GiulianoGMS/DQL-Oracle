-- Adicionar em ESPV_CRITICADEVNFFORN

-- Ticket 622538
-- Adicionado por Giuliano em 25/08/2025
-- CGO 927 Nao permite emitir Finalidade Uso/Consumo
SELECT A.IDSESSION,
       A.INST_ID,
       A.SEQNFDEVFORNEC,
       A.SEQPRODUTO,
       3 CODCRITICA,
       'Não é permitido a utilização do CGO 927 para emissão de produtos com finalidade Uso/Consumo!' MENSAGEM,
       'B' INDBLOQUEIOLIBERA
  FROM MFLX_NFDEVFORNEC A INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = A.SEQPRODUTO
                          INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA
 WHERE 1=1
   AND A.CODGERALOPER = 927
   AND F.FINALIDADEFAMILIA IN ('O','U')

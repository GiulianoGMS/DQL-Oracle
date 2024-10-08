SELECT X.SEQFAMILIA FAMILIA, X.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO, SUM(ESTOQUE) ESTOQUE, Z.NROEMPRESA
 FROM MAP_PRODUTO X INNER JOIN MRL_PRODLOCAL Z ON X.SEQPRODUTO = Z.SEQPRODUTO
                    INNER JOIN MAP_FAMDIVISAO Y ON X.SEQFAMILIA = Y.SEQFAMILIA

WHERE DESCCOMPLETA LIKE 'MP%' 
  AND ESTOQUE != 0

GROUP BY X.SEQPRODUTO, DESCCOMPLETA, X.SEQFAMILIA, NROEMPRESA

ORDER BY 3

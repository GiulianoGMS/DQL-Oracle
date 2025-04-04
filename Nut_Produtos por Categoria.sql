SELECT P.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO, CATEGORIAN1 CATEGORIA, 
       TO_CHAR(ROUND(AVG(S.PRECOVALIDNORMAL),2), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') PRECO_VENDA_MEDIO 
  FROM MAP_PRODUTO P INNER JOIN DIM_CATEGORIA@CONSINCODW X ON X.SEQFAMILIA = P.SEQFAMILIA 
                     INNER JOIN MRL_PRODEMPSEG S ON S.SEQPRODUTO = P.SEQPRODUTO AND S.NROSEGMENTO IN (2,5) AND S.QTDEMBALAGEM = 1 AND NROEMPRESA < 300

WHERE CATEGORIAN1 IN (:LS2)
  AND EXISTS (SELECT 1 FROM MRL_PRODEMPSEG ST WHERE ST.SEQPRODUTO = P.SEQPRODUTO AND ST.NROSEGMENTO = S.NROSEGMENTO AND ST.QTDEMBALAGEM = 1 AND ST.NROEMPRESA = :LS1 AND ST.STATUSVENDA = 'A')
  
  GROUP BY P.SEQPRODUTO, DESCCOMPLETA, CATEGORIAN1
  
  ORDER BY 2,3

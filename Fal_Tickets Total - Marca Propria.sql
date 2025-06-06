SELECT  LOJA EMPRESA,PERIODO,DECODE(SEGMENTO,5,'E-Commerce','Lojas') SEGMENTO,
       'NAGUMO' MARCA,
        SUM(QTD_CUPONS_PROMO) + 
        SUM(QTE_CUPONS) AS CUPONS
           
FROM (SELECT TO_CHAR(X.DTAOPERACAO, 'MM-YYYY') PERIODO,
                      X.NROEMPRESA LOJA, 
                      X.NROSEGMENTO SEGMENTO,
           CASE WHEN X.INDPROMOCAO = 'S' THEN COUNT(DISTINCT X.SEQNF) END    QTD_CUPONS_PROMO,
           CASE WHEN X.INDPROMOCAO = 'N' THEN COUNT(DISTINCT X.SEQNF) END    QTE_CUPONS
          
FROM CONSINCO.FATO_VENDA X INNER JOIN CONSINCO.MAP_PRODUTO Y ON (X.SEQPRODUTO = Y.SEQPRODUTO)
                           INNER JOIN CONSINCO.MAP_FAMILIA F ON F.SEQFAMILIA = Y.SEQPRODUTO
                           INNER JOIN CONSINCO.MAP_MARCA Z ON Z.SEQMARCA = F.SEQMARCA
WHERE X.CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911)
AND X.DTAOPERACAO BETWEEN :DT1 AND :DT2
AND X.NROEMPRESA IN (#LS1)
AND Z.MARCA = 'NAGUMO'
AND Z.STATUS = 'A'
GROUP BY X.NROEMPRESA, X.INDPROMOCAO, TO_CHAR(X.DTAOPERACAO, 'MM-YYYY'),X.NROSEGMENTO )

GROUP BY LOJA, PERIODO, SEGMENTO

ORDER BY 2,1


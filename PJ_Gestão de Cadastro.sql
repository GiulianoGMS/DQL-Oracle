SELECT * FROM (
SELECT DISTINCT FV.NROEMPRESA EMP, FV.SEQPRODUTO PLU, QP.PRODUTO DESCRICAO, SUM(QTDOPERACAO) QTD_VENDA, NVL(E.QTDESTQTOTLOCAIS,0) QTD_ESTOQUE, QC.COMPRADOR_CADASTRO COMPRADOR,
       CASE WHEN FV.SEQPRODUTO IN (SELECT Z.SEQPRODUTO FROM DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = FV.SEQPRODUTO AND Z.STATUSCOMPRA = 'A') THEN 'ATIVO' 
            WHEN FV.SEQPRODUTO IN (SELECT Z.SEQPRODUTO FROM DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = FV.SEQPRODUTO AND Z.STATUSCOMPRA = 'S') THEN 'SUSPENSO'
            ELSE 'INATIVO' END STATUS_COMPRA,
       CASE WHEN FV.SEQPRODUTO IN (SELECT Z.SEQPRODUTO FROM DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = FV.SEQPRODUTO AND Z.STATUSVENDA = 'A') THEN 'ATIVO' 
            WHEN FV.SEQPRODUTO IN (SELECT Z.SEQPRODUTO FROM DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = FV.SEQPRODUTO AND Z.STATUSVENDA = 'S') THEN 'SUSPENSO'
            ELSE 'INATIVO' END STATUS_VENDA,
       Y.MARCA, QP.FORNECEDOR_PRINCIPAL, C.CATEGORIAN3

FROM FATOG_VENDADIA@CONSINCODW FV 
  LEFT JOIN DIM_PRODUTO@CONSINCODW Y    ON FV.SEQPRODUTO = Y.SEQPRODUTO
  LEFT JOIN DIM_CATEGORIA@CONSINCODW C  ON C.SEQFAMILIA  = Y.SEQFAMILIA
  LEFT JOIN QLV_CATEGORIA@CONSINCODW QC ON QC.SEQFAMILIA = Y.SEQFAMILIA
  LEFT JOIN QLV_PRODUTO@CONSINCODW QP   ON QP.SEQPRODUTO = FV.SEQPRODUTO
  LEFT JOIN FATO_ESTOQUE@CONSINCODW E   ON E.SEQPRODUTO  = FV.SEQPRODUTO AND E.NROEMPRESA = FV.NROEMPRESA AND E.DTAESTOQUE = TRUNC(SYSDATE-1)

WHERE 
  FV.DTAOPERACAO BETWEEN :DT1 - 30 AND :DT1
  AND FV.CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911)
  AND QP.SEQFORNECEDOR_PRINCIPAL IN (#LS1)
  AND C.CATEGORIAN3 IN (#LS2)
  
GROUP BY FV.NROEMPRESA, FV.SEQPRODUTO, QP.PRODUTO, COMPRADOR_CADASTRO, QTDESTQTOTLOCAIS, Y.MARCA, FORNECEDOR_PRINCIPAL,CATEGORIAN3
ORDER BY 2,1
) WHERE STATUS_COMPRA LIKE (DECODE #LS3,'ATIVO','%ATIVO%', 'INATIVO','%INATIVO%','SUSPENSO','%SUSPENSO%','%%')

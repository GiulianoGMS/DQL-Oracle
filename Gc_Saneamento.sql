SELECT X.NROEMPRESA LOJA,
       X.SEQPRODUTO CODIGO_PRODUTO,
       MAX(O.CODACESSO) EAN,
       CONSINCO.FC5ESTOQUEDISPONIVEL (X.SEQPRODUTO,X.NROEMPRESA) ESTOQUEATUAL,
       Y.PRODUTO PRODUTO,
       '' FABRICANTE,
       Y.MARCA MARCA,
       TO_CHAR((SELECT T.DTAHORINCLUSAO
                 FROM MAP_PRODUTO T
                WHERE T.SEQPRODUTO = X.SEQPRODUTO), 
               'DD/MM/YYYY') DATA_CADASTRO,
       TO_CHAR((SELECT T.DTAULTENTRADA
                 FROM MRL_PRODUTOEMPRESA T
                WHERE T.SEQPRODUTO = X.SEQPRODUTO
                  AND T.NROEMPRESA = X.NROEMPRESA),
               'DD/MM/YYYY') DATA_ULT_ENTRADA,
       TO_CHAR((SELECT T.DTAULTCOMPRA
                 FROM MRL_PRODUTOEMPRESA T
                WHERE T.SEQPRODUTO = X.SEQPRODUTO
                  AND T.NROEMPRESA = X.NROEMPRESA),
               'DD/MM/YYYY') DATA_ULT_COMPRA,
       DECODE(Z.STATUSCOMPRA, 'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO') STATUS_COMPRA,
       DECODE(Z.STATUSVENDA,  'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO') STATUS_VENDA,
       C.CATEGORIAN1 NIVEL_01,
       C.CATEGORIAN2 NIVEL_02,
       C.CATEGORIAN3 NIVEL_03,
       C.CATEGORIAN4 NIVEL_04,
       C.CATEGORIAN5 NIVEL_05,
       SUM(X.QTDOPERACAO) QUANTIDADE,
       SUM((X.VLROPERACAO) * DECODE(X.TIPCGO, 'E', -1, 1)) VALOR_TOTAL,
       ROUND(SUM((X.VLROPERACAO - X.VVLRCTOLIQUIDO - X.VVLRIMPOSTOSAIDA -
                 NVL(X.VLRDESPOPERACIONALITEM, 0) - X.VLRCOMISSAO -
                 X.VLRVERBACOMPRA - X.VLRCALCIMPOSTOVDA) *
                 DECODE(X.TIPCGO, 'E', -1, 1)),
             2) LUCRATIVIDADE_TOTAL,
       SUM(X.VLRPROMOC * DECODE(X.TIPCGO, 'E', -1, 1)) PROMOCOES,
       ROUND(SUM(X.VVLRCTOLIQUIDO * DECODE(X.TIPCGO, 'E', -1, 1)), 2) CUSTO_LIQUIDO,
       ROUND(SUM(X.VVLRIMPOSTOSAIDA), 2) IMPOSTOS
  FROM FATOG_VENDADIA X
  LEFT JOIN DIM_PRODUTO Y
    ON (X.SEQPRODUTO = Y.SEQPRODUTO)
  LEFT JOIN DIM_PRODUTOEMPRESA Z
    ON (Z.SEQPRODUTO = Y.SEQPRODUTO AND Z.NROEMPRESA = X.NROEMPRESA)
  LEFT JOIN DIM_CATEGORIA C
    ON (C.SEQFAMILIA = Y.SEQFAMILIA)
  LEFT  JOIN DIM_PRODUTOCODIGO O 
    ON (O.SEQPRODUTO = X.SEQPRODUTO)
 WHERE X.DTAOPERACAO BETWEEN :DT1 AND :DT2
   AND X.CODGERALOPER IN (37, 48, 123, 610, 615, 613, 810, 916, 910, 911)
   AND X.NROEMPRESA IN (#LS1)
   AND C.CATEGORIAN1 IN (#LS2)
 GROUP BY X.NROEMPRESA,
          X.SEQPRODUTO,
          CONSINCO.FC5ESTOQUEDISPONIVEL (X.SEQPRODUTO,X.NROEMPRESA),
          Y.PRODUTO,
          Y.MARCA,
          DECODE(Z.STATUSCOMPRA, 'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO'),
          DECODE(Z.STATUSVENDA,  'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO'),
          C.CATEGORIAN1,
          C.CATEGORIAN2,
          C.CATEGORIAN3,
          C.CATEGORIAN4,
          C.CATEGORIAN5;
          
          -----------------------
          
 SELECT X.NROEMPRESA LOJA,
       X.SEQPRODUTO CODIGO_PRODUTO,
       MAX(O.CODACESSO) EAN,
       CONSINCO.FC5ESTOQUEDISPONIVEL (X.SEQPRODUTO,X.NROEMPRESA) ESTOQUEATUAL,
       Y.PRODUTO PRODUTO,
       '' FABRICANTE,
       Y.MARCA MARCA,
       TO_CHAR((SELECT T.DTAHORINCLUSAO
                 FROM MAP_PRODUTO T
                WHERE T.SEQPRODUTO = X.SEQPRODUTO), 
               'DD/MM/YYYY') DATA_CADASTRO,
       TO_CHAR((SELECT T.DTAULTENTRADA
                 FROM MRL_PRODUTOEMPRESA T
                WHERE T.SEQPRODUTO = X.SEQPRODUTO
                  AND T.NROEMPRESA = X.NROEMPRESA),
               'DD/MM/YYYY') DATA_ULT_ENTRADA,
       TO_CHAR((SELECT T.DTAULTCOMPRA
                 FROM MRL_PRODUTOEMPRESA T
                WHERE T.SEQPRODUTO = X.SEQPRODUTO
                  AND T.NROEMPRESA = X.NROEMPRESA),
               'DD/MM/YYYY') DATA_ULT_COMPRA,
       DECODE(Z.STATUSCOMPRA, 'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO') STATUS_COMPRA,
       DECODE(Z.STATUSVENDA,  'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO') STATUS_VENDA,
       C.CATEGORIAN1 NIVEL_01,
       C.CATEGORIAN2 NIVEL_02,
       C.CATEGORIAN3 NIVEL_03,
       C.CATEGORIAN4 NIVEL_04,
       C.CATEGORIAN5 NIVEL_05,
       SUM(X.QTDOPERACAO) QUANTIDADE,
       SUM((X.VLROPERACAO) * DECODE(X.TIPCGO, 'E', -1, 1)) VALOR_TOTAL,
       ROUND(SUM((X.VLROPERACAO - X.VVLRCTOLIQUIDO - X.VVLRIMPOSTOSAIDA -
                 NVL(X.VLRDESPOPERACIONALITEM, 0) - X.VLRCOMISSAO -
                 X.VLRVERBACOMPRA - X.VLRCALCIMPOSTOVDA) *
                 DECODE(X.TIPCGO, 'E', -1, 1)),
             2) LUCRATIVIDADE_TOTAL,
       SUM(X.VLRPROMOC * DECODE(X.TIPCGO, 'E', -1, 1)) PROMOCOES,
       ROUND(SUM(X.VVLRCTOLIQUIDO * DECODE(X.TIPCGO, 'E', -1, 1)), 2) CUSTO_LIQUIDO,
       ROUND(SUM(X.VVLRIMPOSTOSAIDA), 2) IMPOSTOS
  FROM FATOG_VENDADIA X
  LEFT JOIN DIM_PRODUTO Y
    ON (X.SEQPRODUTO = Y.SEQPRODUTO)
  LEFT JOIN DIM_PRODUTOEMPRESA Z
    ON (Z.SEQPRODUTO = Y.SEQPRODUTO AND Z.NROEMPRESA = X.NROEMPRESA)
  LEFT JOIN DIM_CATEGORIA C
    ON (C.SEQFAMILIA = Y.SEQFAMILIA)
  LEFT  JOIN DIM_PRODUTOCODIGO O 
    ON (O.SEQPRODUTO = X.SEQPRODUTO)
 WHERE X.DTAOPERACAO BETWEEN :DT1 AND :DT2
   AND X.CODGERALOPER IN (37, 48, 123, 610, 615, 613, 810, 916, 910, 911)
   AND X.NROEMPRESA IN (#LS1)
   AND C.CATEGORIAN3 IN (#LS2)
 GROUP BY X.NROEMPRESA,
          X.SEQPRODUTO,
          CONSINCO.FC5ESTOQUEDISPONIVEL (X.SEQPRODUTO,X.NROEMPRESA),
          Y.PRODUTO,
          Y.MARCA,
          DECODE(Z.STATUSCOMPRA, 'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO'),
          DECODE(Z.STATUSVENDA,  'A', 'ATIVO', 'I', 'INATIVO', 'S', 'SUSPENSO'),
          C.CATEGORIAN1,
          C.CATEGORIAN2,
          C.CATEGORIAN3,
          C.CATEGORIAN4,
          C.CATEGORIAN5;

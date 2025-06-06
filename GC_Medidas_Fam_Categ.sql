-- Tkt 554835

SELECT PLU, DESCRICAO, FAMILIA, EAN, ESTQLOJA, 
       TO_CHAR(ALTURA, 'FM999G999G990D99990', 'NLS_NUMERIC_CHARACTERS='',.''') ALTURA, 
       TO_CHAR(LARGURA, 'FM999G999G990D99990', 'NLS_NUMERIC_CHARACTERS='',.''') LARGURA, 
       TO_CHAR(PROFUNDIDADE, 'FM999G999G990D99990', 'NLS_NUMERIC_CHARACTERS='',.''') PROFUNDIDADE, 
       TO_CHAR(DTAULTENTRADA, 'DD/MM/YYYY') DTAULTENTRADA, CATEGORIAN3

  FROM (

SELECT P.SEQPRODUTO PLU, P.DESCCOMPLETA DESCRICAO, P.SEQFAMILIA FAMILIA, Z.CODACESSO EAN,
       X.ESTQLOJA, E.ALTURA, E.LARGURA, E.PROFUNDIDADE, 
       RANK() OVER (PARTITION BY P.SEQFAMILIA ORDER BY X.ESTQLOJA DESC) RK,
       X.DTAULTENTRADA, CATEGORIAN3

  FROM MAP_PRODUTO P INNER JOIN MAP_PRODCODIGO Z     ON Z.SEQPRODUTO = P.SEQPRODUTO AND Z.TIPCODIGO = 'E'
                     INNER JOIN MAP_FAMEMBALAGEM E   ON E.SEQFAMILIA = P.SEQFAMILIA
                     INNER JOIN MAP_FAMILIA F        ON F.SEQFAMILIA = P.SEQFAMILIA
                     INNER JOIN MRL_PRODUTOEMPRESA X ON X.SEQPRODUTO = P.SEQPRODUTO
                     INNER JOIN DIM_CATEGORIA@CONSINCODW C ON C.SEQFAMILIA = P.SEQFAMILIA
                     
 WHERE X.NROEMPRESA = 8
   AND E.QTDEMBALAGEM = 1
   AND ESTQLOJA > 0
   AND X.STATUSCOMPRA = 'A'
   
   ) WHERE RK = 1
   
   ORDER BY 2

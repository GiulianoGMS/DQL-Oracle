ALTER SESSION SET current_schema = CONSINCO;
/*
SELECT A.NROEMPRESA, A.NROPEDIDOSUPRIM PEDIDO, A.DTAEMISSAO, A.QTDTOTSOLICITADA,
       A.VLRTOTPEDIDO
FROM MSU_PEDIDOSUPRIM A WHERE A.NROPEDIDOSUPRIM = 3359988*/

SELECT B.NROEMPRESA LOJA, B.NROPEDIDOSUPRIM PEDIDO, B.DTAAPROVACAO DTA_PEDIDO, A.DTARECEBTO,
       (QTDSOLICITADA / QTDEMBALAGEM) QTD, TO_CHAR(B.VLRUNITARIO * QTDSOLICITADA, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR

FROM  Msu_Psitemreceber   B LEFT JOIN MSU_PEDIDOSUPRIM A ON A.NROPEDIDOSUPRIM = B.NROPEDIDOSUPRIM AND A.NROEMPRESA = B.NROEMPRESA
      LEFT JOIN MSU_PSITEMEXPEDIDO C ON A.NROPEDIDOSUPRIM = C.NROPEDIDOSUPRIM
      LEFT JOIN MAD_PEDVENDA D       ON C.NROPEDVENDA = D.NROPEDVENDA
WHERE B.NROPEDIDOSUPRIM = 3345131

ORDER BY 3 DESC

--- Consulta X Pedido

ALTER SESSION SET current_schema = CONSINCO;

SELECT  A.DTAEMISSAO DTA_PEDIDO, B.NROEMPRESA LOJA, B.NROPEDIDOSUPRIM PEDIDO, B.SEQPRODUTO PRODUTO,
       (QTDSOLICITADA / QTDEMBALAGEM) QTD, TO_CHAR(B.VLRUNITARIO * QTDSOLICITADA, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR

FROM  Msu_Psitemreceber   B LEFT JOIN MSU_PEDIDOSUPRIM A ON A.NROPEDIDOSUPRIM = B.NROPEDIDOSUPRIM AND A.NROEMPRESA = B.NROEMPRESA
      LEFT JOIN MSU_PSITEMEXPEDIDO C ON A.NROPEDIDOSUPRIM = C.NROPEDIDOSUPRIM
      LEFT JOIN MAD_PEDVENDA D       ON C.NROPEDVENDA = D.NROPEDVENDA
WHERE B.NROPEDIDOSUPRIM = 3306556

ORDER BY 3 DESC

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT G.NOMEREDUZIDO EMP, X.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO,
       DECODE(X.STATUSCOMPRA,'A','ATIVO','I','INATIVO','S','SUSPENSO') STATUS_COMPRA, Z.CATEGORIAN3
  
  FROM CONSINCO.MRL_PRODUTOEMPRESA X INNER JOIN CONSINCO.GE_EMPRESA  G ON X.NROEMPRESA = G.NROEMPRESA
                                     INNER JOIN CONSINCO.MAP_PRODUTO M ON M.SEQPRODUTO = X.SEQPRODUTO
                                     LEFT  JOIN DIM_CATEGORIA        Z ON M.SEQFAMILIA = Z.SEQFAMILIA
 WHERE X.NROEMPRESA  IN  (#LS1)
   AND Z.CATEGORIAN3 IN  (#LS2)
 ORDER BY 2,1

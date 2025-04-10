SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/ *
  FROM REMARCAPROMOCOES@INFOPROCMSSQL X
 WHERE 1=1
   AND SYSDATE -1 BETWEEN DTINICIO AND DTFIM
   AND X.TIPODESCONTO  = 4
   AND X.PROMOCAOLIVRE = 0
   AND EXISTS (SELECT LPAD(C.CODACESSO,14,0) FROM CONSINCO.MRL_PROMOCAO A INNER JOIN CONSINCO.MRL_PROMOCAOITEM B ON A.SEQPROMOCAO = B.SEQPROMOCAO AND B.NROEMPRESA = A.NROEMPRESA 
                                                   INNER JOIN CONSINCO.MAP_PRODCODIGO   C ON C.SEQPRODUTO = B.SEQPRODUTO AND C.TIPCODIGO = 'E'
    WHERE A.DTAINICIO = DATE '2024-01-23' 
      AND A.NROEMPRESA = X.CODLOJA
      AND A.SEQPROMOCAO = 171261
      AND LPAD(C.CODACESSO,14,0) = CODIGOPRODUTO);
   
   
   

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT NROEMPRESA LOJA, C.SEQPRODUTO PLU, X.CODACESSO EAN, Z.DESCCOMPLETA DESCRICAO, C.DTAVALIDADE DTA_VALIDADE 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  FROM MAD_CARGARECITEM C INNER JOIN MAP_PRODUTO Z ON Z.SEQPRODUTO = C.SEQPRODUTO
                          INNER JOIN MAP_PRODCODIGO X ON X.SEQPRODUTO = C.SEQPRODUTO AND X.TIPCODIGO = 'E'
                          
 WHERE C.DTAVALIDADE BETWEEN :DT1 AND :DT2
   AND NROEMPRESA IN (#LS1)
   
ORDER BY 1,3

SELECT DISTINCT S.NROEMPRESA, X.SEQPRODUTO PLU, X.DESCCOMPLETA, 
       1 QTD_UNI,
       TO_NUMBER(Z.QTDEMBALAGEM) QTD_EMB_PACK, Z.CODACESSO EAN_PACK,
       DECODE(S.STATUSVENDA, 'A', 'ATIVO', 'I', 'INATIVO') STATUS_VENDA_PACK,
       TO_NUMBER(E.ESTQLOJA) ESTOQUE_PROD,
       TO_CHAR(X.DTAHORINCLUSAO, 'DD/MM/YYYY') DTA_INCLUSAO
       
  FROM MAP_PRODCODIGO Z INNER JOIN MAP_PRODUTO X    ON X.SEQPRODUTO = Z.SEQPRODUTO
                        INNER JOIN MRL_PRODEMPSEG S ON S.SEQPRODUTO = X.SEQPRODUTO 
                                                   AND S.NROEMPRESA = #LS1
                                                   AND S.QTDEMBALAGEM = Z.QTDEMBALAGEM 
                                                   AND S.NROSEGMENTO = (SELECT NROSEGMENTOPRINC FROM MAX_EMPRESA M WHERE M.NROEMPRESA = S.NROEMPRESA)
                                                   AND DECODE(S.STATUSVENDA, 'I', 'Inativo', 'Ativo') IN (#LS3)
                                              
                                                   
                        INNER JOIN MRL_PRODUTOEMPRESA E ON E.SEQPRODUTO = Z.SEQPRODUTO AND E.NROEMPRESA = #LS1
                        INNER JOIN (SELECT SEQPRODUTO, CODACESSO, QTDEMBALAGEM FROM MAP_PRODCODIGO Z2 
                                     WHERE Z2.QTDEMBALAGEM = 1
                                       AND Z2.TIPCODIGO = 'E' 
                                       AND Z2.INDUTILVENDA = 'S') ZZ ON ZZ.SEQPRODUTO = Z.SEQPRODUTO
                        INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = X.SEQFAMILIA
                        INNER JOIN MAX_COMPRADOR C ON C.SEQCOMPRADOR = F.SEQCOMPRADOR
                                       
 WHERE Z.QTDEMBALAGEM > 1
   AND Z.INDUTILVENDA = 'S'
   AND TIPCODIGO = 'E'
   AND E.ESTQLOJA > DECODE(:LS2, 'Indiferente', -99999, 'Com Estoque', 0)
   AND COMPRADOR IN (#LS4)
    
ORDER BY 3,5
ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT/*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
       X.NROEMPRESA EMP, X.SEQPRODUTO PLU, DESCCOMPLETA DESC_PROD, 
       DC.CATEGORIAN1 CATEGORIA, F.SEQFORNECEDOR||' - '||G.NOMERAZAO FORNEC, COMPRADOR,
       TO_NUMBER(X.ESTQTROCA) QTD_AVARIA,
       A.DTAHORLANCTO,
       ROUND(SYSDATE - (A.DTAHORLANCTO)) QTD_DIAS_ULT_ENT
                        
  FROM MRL_PRODUTOEMPRESA X INNER JOIN MAP_PRODUTO P   ON P.SEQPRODUTO = X.SEQPRODUTO
                            LEFT JOIN  DIM_CATEGORIA@CONSINCODW DC ON DC.SEQFAMILIA = P.SEQFAMILIA
                            INNER JOIN MAP_FAMFORNEC F ON F.SEQFAMILIA = P.SEQFAMILIA AND F.PRINCIPAL = 'S'
                            INNER JOIN GE_PESSOA G     ON G.SEQPESSOA = F.SEQFORNECEDOR
                            INNER JOIN MAP_FAMDIVISAO FD ON FD.SEQFAMILIA = P.SEQFAMILIA
                            INNER JOIN MAX_COMPRADOR MC ON MC.SEQCOMPRADOR = FD.SEQCOMPRADOR
                            INNER JOIN MRL_LOCAL L ON L.NROEMPRESA = X.NROEMPRESA AND L.LOCAL = 'AVARIA'
                            INNER JOIN MRL_LANCTOESTOQUE A ON A.SEQPRODUTO = X.SEQPRODUTO AND A.NROEMPRESA = X.NROEMPRESA AND A.LOCAL = L.SEQLOCAL
 WHERE 1=1
   AND ESTQTROCA != 0
   AND X.NROEMPRESA IN (#LS2)
   AND DC.CATEGORIAN1 IN (#LS3)
   AND COMPRADOR IN (#LS4)
   
   HAVING ROUND(SYSDATE - MAX(A.DTAHORLANCTO)) >= DECODE(:LS1, 'Ultima Entrada Maior Que 30 Dias',30,
                                              'Tudo',1)
   
   /*GROUP BY X.NROEMPRESA, X.SEQPRODUTO, DESCCOMPLETA, DC.CATEGORIAN1, F.SEQFORNECEDOR||' - '||G.NOMERAZAO, COMPRADOR, X.ESTQTROCA*/
   ORDER BY 2,1
   
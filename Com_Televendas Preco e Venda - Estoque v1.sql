SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/ X.NROEMPRESA LOJA, X.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO_PRODUTO, COMPRADOR,
       ROUND(ESTQLOJA / F.PADRAOEMBCOMPRA,2) ESTQ_CX, ESTQLOJA ESTQ_UNI,
       ROUND(fCalculaEstqDias(X.NROEMPRESA, X.SEQPRODUTO, 1),1) EST_DIAS,
       X.CMULTVLRNF VLR_CUSTO,
       S.PRECOVALIDNORMAL PRECO_VAREJO,
       S.PRECOVALIDPROMOC PRECO_PROMOC_VAREJO,
      (SELECT ROUND(MGMPRECOVALIDO,2) FROM MAXV_MGMBASEPRODSEG Y WHERE Y.SEQPRODUTO = X.SEQPRODUTO AND Y.NROEMPRESA = X.NROEMPRESA AND Y.NROSEGMENTO = S.NROSEGMENTO AND Y.QTDEMBALAGEM = 1) MARGEM_VAREJO,
      CASE WHEN QTD2 IS NOT NULL THEN (SELECT ROUND(MGMPRECOVALIDO,2) FROM MAXV_MGMBASEPRODSEG Y WHERE Y.SEQPRODUTO = X.SEQPRODUTO AND Y.NROEMPRESA = X.NROEMPRESA AND Y.NROSEGMENTO = S.NROSEGMENTO AND Y.QTDEMBALAGEM = QTD2) ELSE 0 END MARGEM_VAREJO,
       QTD2, PRECO_UNI_EMB2 PRECO_ATAC_EMB2,
       QTD3, PRECO_UNI_EMB3 PRECO_ATAC_EMB3,
       QTD4, PRECO_UNI_EMB4 PRECO_ATAC_EMB4
       

  FROM MRL_PRODUTOEMPRESA X INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = X.SEQPRODUTO
                             LEFT JOIN MAP_PRODCODIGO C ON C.SEQPRODUTO = P.SEQPRODUTO AND C.TIPCODIGO = 'E'
                            INNER JOIN MRL_PRODEMPSEG S ON S.SEQPRODUTO = X.SEQPRODUTO AND S.NROEMPRESA = X.NROEMPRESA
                            INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA
                            INNER JOIN MAP_FAMILIA FF ON FF.SEQFAMILIA = P.SEQFAMILIA
                            INNER JOIN MAX_EMPRESA E  ON E.NROEMPRESA = X.NROEMPRESA AND E.NROSEGMENTOPRINC = S.NROSEGMENTO
                            INNER JOIN MAX_COMPRADOR M ON M.SEQCOMPRADOR = F.SEQCOMPRADOR
                             LEFT JOIN (SELECT PLU,  
                                               QTD_EMB1 QTD1, PRECO_UNI_EMB1, NROEMPRESA, NROSEGMENTO,
                                               QTD_EMB2 QTD2, PRECO_UNI_EMB2, 
                                               QTD_EMB3 QTD3, PRECO_UNI_EMB3, 
                                               QTD_EMB4 QTD4, PRECO_UNI_EMB4
                                               
                                          FROM (

                                        SELECT SUB.SEQPRODUTO PLU,
                                               MAX(CASE WHEN RN = 1 THEN QTDEMBALAGEM END) QTD_EMB1,
                                               MAX(CASE WHEN RN = 1 THEN ROUND(PRECOVALIDNORMAL/QTDEMBALAGEM,2) END) PRECO_UNI_EMB1,
                                               MAX(CASE WHEN RN = 2 THEN QTDEMBALAGEM END) QTD_EMB2,
                                               MAX(CASE WHEN RN = 2 THEN ROUND(PRECOVALIDNORMAL/QTDEMBALAGEM,2) END) PRECO_UNI_EMB2,
                                               MAX(CASE WHEN RN = 3 THEN QTDEMBALAGEM END) QTD_EMB3,
                                               MAX(CASE WHEN RN = 3 THEN ROUND(PRECOVALIDNORMAL/QTDEMBALAGEM,2) END) PRECO_UNI_EMB3,
                                               MAX(CASE WHEN RN = 4 THEN QTDEMBALAGEM END) QTD_EMB4,
                                               MAX(CASE WHEN RN = 4 THEN ROUND(PRECOVALIDNORMAL/QTDEMBALAGEM,2) END) PRECO_UNI_EMB4,
                                               SUB.NROEMPRESA, SUB.NROSEGMENTO
                                                   
                                          FROM (SELECT SEQPRODUTO,
                                                       QTDEMBALAGEM,
                                                       PRECOVALIDNORMAL,
                                                       ROW_NUMBER() OVER(PARTITION BY SEQPRODUTO ORDER BY QTDEMBALAGEM) AS RN, NROEMPRESA, NROSEGMENTO
                                                  FROM MRL_PRODEMPSEG X 
                                                 WHERE 1=1
                                                   AND STATUSVENDA = 'A'
                                                   AND NROEMPRESA  = #LS1
                                                   AND X.NROSEGMENTO = (SELECT E.NROSEGMENTOPRINC FROM MAX_EMPRESA E WHERE E.NROEMPRESA = X.NROEMPRESA)
                                               )
                                                   
                                                   SUB INNER JOIN MAP_PRODUTO P     ON P.SEQPRODUTO = SUB.SEQPRODUTO 
                                                       INNER JOIN MRL_PRODUTOEMPRESA A ON A.SEQPRODUTO = SUB.SEQPRODUTO AND A.NROEMPRESA = #LS1
                                                   
                                         GROUP BY SUB.SEQPRODUTO,SUB.NROEMPRESA, SUB.NROSEGMENTO)
                                         
                                         WHERE 1=1) ATAC ON ATAC.NROEMPRESA = X.NROEMPRESA AND ATAC.PLU = X.SEQPRODUTO AND ATAC.NROSEGMENTO = S.NROSEGMENTO
                            
 WHERE X.NROEMPRESA   = #LS1
   AND S.QTDEMBALAGEM = 1
   AND S.STATUSVENDA = 'A'
   AND P.DESCCOMPLETA NOT LIKE '1%' AND DESCCOMPLETA NOT LIKE 'Z%' AND DESCCOMPLETA NOT LIKE '2%' AND DESCCOMPLETA NOT LIKE '4%'
   
   GROUP BY X.SEQPRODUTO, DESCCOMPLETA, COMPRADOR,
       ESTQLOJA / F.PADRAOEMBCOMPRA, ESTQLOJA,
       X.CMULTVLRNF,
       S.PRECOVALIDNORMAL,
       S.PRECOVALIDPROMOC,
       QTD2, PRECO_UNI_EMB2,
       QTD3, PRECO_UNI_EMB3,
       QTD4, PRECO_UNI_EMB4, ROUND(fCalculaEstqDias(X.NROEMPRESA, X.SEQPRODUTO, 1),1), X.NROEMPRESA, S.NROSEGMENTO
       
       ORDER BY 3
       
       ;
       
       
       

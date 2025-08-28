SELECT X.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO_PRODUTO, COMPRADOR,
       ESTQLOJA / F.PADRAOEMBCOMPRA ESTQ_CX, ESTQLOJA ESTQ_UNI,
       ROUND(fCalculaEstqDias(X.NROEMPRESA, X.SEQPRODUTO, 1),1) EST_DIAS,
       X.CMULTVLRNF VLR_CUSTO,
       S.PRECOVALIDNORMAL VLR_VENDA_UNI,
       S.PRECOVALIDPROMOC VLR_PROMO_UNI,
       QTD2, PRECO_UNI_EMB2,
       QTD3, PRECO_UNI_EMB3,
       QTD4, PRECO_UNI_EMB4
       

  FROM MRL_PRODUTOEMPRESA X INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = X.SEQPRODUTO
                             LEFT JOIN MAP_PRODCODIGO C ON C.SEQPRODUTO = P.SEQPRODUTO AND C.TIPCODIGO = 'E'
                            INNER JOIN MRL_PRODEMPSEG S ON S.SEQPRODUTO = X.SEQPRODUTO AND S.NROEMPRESA = X.NROEMPRESA AND S.NROSEGMENTO = 9
                            INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA
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
                                                   AND NROEMPRESA  = 56
                                                   AND NROSEGMENTO = (SELECT NROSEGMENTO FROM MON_SEGMENTO X WHERE SEGMENTO = 'TELEVENDAS')
                                               )
                                                   
                                                   SUB INNER JOIN MAP_PRODUTO P     ON P.SEQPRODUTO = SUB.SEQPRODUTO 
                                                       INNER JOIN MRL_PRODUTOEMPRESA A ON A.SEQPRODUTO = SUB.SEQPRODUTO AND A.NROEMPRESA = 56
                                                   
                                         GROUP BY SUB.SEQPRODUTO,SUB.NROEMPRESA, SUB.NROSEGMENTO)
                                         
                                         WHERE 1=1) ATAC ON ATAC.NROEMPRESA = X.NROEMPRESA AND ATAC.PLU = X.SEQPRODUTO AND ATAC.NROSEGMENTO = S.NROSEGMENTO
                            
 WHERE X.NROEMPRESA   = 56
   AND S.QTDEMBALAGEM = 1
   AND S.STATUSVENDA = 'A'
   
   GROUP BY X.SEQPRODUTO, DESCCOMPLETA, COMPRADOR,
       ESTQLOJA / F.PADRAOEMBCOMPRA, ESTQLOJA,
       X.CMULTVLRNF,
       S.PRECOVALIDNORMAL,
       S.PRECOVALIDPROMOC,
       QTD2, PRECO_UNI_EMB2,
       QTD3, PRECO_UNI_EMB3,
       QTD4, PRECO_UNI_EMB4, ROUND(fCalculaEstqDias(X.NROEMPRESA, X.SEQPRODUTO, 1),1)
       
       ORDER BY 2
       

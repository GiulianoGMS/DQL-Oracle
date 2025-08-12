SELECT LISTAGG(CODACESSO, ', ') WITHIN GROUP (ORDER BY X.SEQPRODUTO)  EAN, X.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO_PRODUTO,
       CATEGORIAN2 CATEGORIA_NIVEL_2,  ESTQLOJA,
       TRUNC(SYSDATE) - X.DTAULTENTRADA DIAS_ULT_ENTRADA, 
       X.CMULTVLRNF VLR_CTO_UNI,
       S.STATUSVENDA STATUS,
       S.PRECOVALIDNORMAL VLR_VENDA_UNI,
       S.PRECOVALIDPROMOC VLR_PROMO_UNI,
       TO_CHAR(NAGF_INICIOPROMETIQUETA(X.NROEMPRESA, S.SEQPRODUTO, S.PRECOVALIDPROMOC), 'DD/MM/YYYY') INICIO_PROMO,
       TO_CHAR(NAGF_FIMPROMETIQUETA(X.NROEMPRESA, S.SEQPRODUTO, S.PRECOVALIDPROMOC), 'DD/MM/YYYY') FIM_PROMO,
       QTD2, PRECO_UNI_EMB2,
       QTD3, PRECO_UNI_EMB3,
       QTD4, PRECO_UNI_EMB4
       

  FROM MRL_PRODUTOEMPRESA X INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = X.SEQPRODUTO
                             LEFT JOIN MAP_PRODCODIGO C ON C.SEQPRODUTO = P.SEQPRODUTO AND C.TIPCODIGO = 'E'
                            INNER JOIN MRL_PRODEMPSEG S ON S.SEQPRODUTO = X.SEQPRODUTO AND S.NROEMPRESA = X.NROEMPRESA
                            INNER JOIN DIM_CATEGORIA@CONSINCODW C ON C.SEQFAMILIA = P.SEQFAMILIA
                            INNER JOIN MON_SEGMENTO G ON G.NROSEGMENTO = S.NROSEGMENTO
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
                                                   AND NROSEGMENTO = (SELECT NROSEGMENTO FROM MON_SEGMENTO X WHERE SEGMENTO = :LS2)
                                               )
                                                   
                                                   SUB INNER JOIN MAP_PRODUTO P     ON P.SEQPRODUTO = SUB.SEQPRODUTO 
                                                       INNER JOIN MRL_PRODUTOEMPRESA A ON A.SEQPRODUTO = SUB.SEQPRODUTO AND A.NROEMPRESA = #LS1
                                                   
                                         GROUP BY SUB.SEQPRODUTO,SUB.NROEMPRESA, SUB.NROSEGMENTO)
                                         
                                         WHERE 1=1) ATAC ON ATAC.NROEMPRESA = X.NROEMPRESA AND ATAC.PLU = X.SEQPRODUTO AND ATAC.NROSEGMENTO = S.NROSEGMENTO
                            
 WHERE X.NROEMPRESA   = #LS1
   AND G.NROSEGMENTO     = (SELECT NROSEGMENTO FROM MON_SEGMENTO X WHERE SEGMENTO = :LS2)
   AND S.QTDEMBALAGEM = 1
   
 GROUP BY X.SEQPRODUTO, DESCCOMPLETA, CATEGORIAN2, ESTQLOJA, TRUNC(SYSDATE) - X.DTAULTENTRADA, CMULTVLRNF, S.PRECOVALIDNORMAL, PRECOVALIDPROMOC, S.QTDEMBALAGEM, STATUSVENDA, QTD2, QTD3, QTD4, PRECO_UNI_EMB2, PRECO_UNI_EMB3, PRECO_UNI_EMB4, NAGF_INICIOPROMETIQUETA(X.NROEMPRESA, S.SEQPRODUTO, S.PRECOVALIDPROMOC) ,
       NAGF_FIMPROMETIQUETA(X.NROEMPRESA, S.SEQPRODUTO, S.PRECOVALIDPROMOC)

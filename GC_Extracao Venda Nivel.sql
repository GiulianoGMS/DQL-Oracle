SELECT TO_CHAR(FV.DTAENTRADASAIDA, 'YYYY') DATA,QC.categoria_nivel_1,
                                                QC.categoria_nivel_2,
                                                QC.categoria_nivel_3,
                                                QC.categoria_nivel_4,
                                                QC.categoria_nivel_5,
                                                QC.categoria_nivel_6,
                                                FV.NROEMPRESA EMPRESA,
                                                SUM(FV.QTDITEM)                                                               VENDA_QTD,
                                                TO_CHAR(SUM(FV.VLRITEM), 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_TOTAL
                
FROM CONSINCO.MADMV_ABCDISTRIBPROD FV --LEFT JOIN QLV_PRODUTO   QP ON QP.seqproduto = FV.SEQPRODUTO
                       LEFT JOIN QLV_CATEGORIA@CONSINCODW QC ON QC.seqfamilia = FV.SEQFAMILIA
 
WHERE FV.DTAENTRADASAIDA BETWEEN DATE '2022-01-01' AND DATE '2022-11-30'
  AND FV.NROEMPRESA <= 53 AND FV.NROSEGMENTO IN (1,4,7,2,3)
  AND FV.CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911)
  
                       GROUP BY TO_CHAR(FV.DTAENTRADASAIDA, 'YYYY'),
                                                QC.categoria_nivel_1,
                                                QC.categoria_nivel_2,
                                                QC.categoria_nivel_3,
                                                QC.categoria_nivel_4,
                                                QC.categoria_nivel_5,
                                                QC.categoria_nivel_6,
                                                FV.NROEMPRESA
                                              

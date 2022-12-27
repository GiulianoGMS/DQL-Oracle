SELECT TO_CHAR(FV.DTAOPERACAO, 'MM/YYYY') DATA, QC.categoria_nivel_1,
                                                QC.categoria_nivel_2,
                                                QC.categoria_nivel_3,
                                                QC.categoria_nivel_4,
                                                QC.categoria_nivel_5,
                                                QC.categoria_nivel_6,
                                                FV.NROEMPRESA EMPRESA,
                                                SUM(FV.QTDOPERACAO)       VENDA_QTD,
                                                SUM(FV.VVLROPERACAOBRUTO) VALOR_TOTAL

FROM FATOG_VENDADIA FV LEFT JOIN QLV_PRODUTO   QP ON QP.seqproduto = FV.SEQPRODUTO
                       LEFT JOIN QLV_CATEGORIA QC ON QC.seqfamilia = QP.seqproduto

WHERE FV.DTAOPERACAO BETWEEN DATE '2021-01-01' AND DATE '2022-11-30'
                       
                       GROUP BY TO_CHAR(FV.DTAOPERACAO, 'MM/YYYY'), QC.categoria_nivel_1,
                                                QC.categoria_nivel_2,
                                                QC.categoria_nivel_3,
                                                QC.categoria_nivel_4,
                                                QC.categoria_nivel_5,
                                                QC.categoria_nivel_6,
                                                QC.categoria_nivel_7,
                                                FV.NROEMPRESA 
ORDER BY 1,2,3,4,5,6,7,8

-- Visão Geral

select PERIODO,
       COMPRADOR,
       round(ABASTECIMENTO_AUTOMATICO, 2) AUTOMATICO,
       round(TRASNSFERENCIA_MANUAL, 2) MANUAL, 
       round(ABASTECIMENTO_AUTOMATICO /
             (TRASNSFERENCIA_MANUAL + ABASTECIMENTO_AUTOMATICO) * 100) "%PART ABAS AUTOMATICO"
  from (SELECT X.COMPRADOR,
               to_char(x.DATA_FECHAMENTO, 'YYYY-MM') PERIODO,
               SUM(X.AUTOMATICO) ABASTECIMENTO_AUTOMATICO,
               SUM(X.MANUAL) TRASNSFERENCIA_MANUAL
        
          FROM CONSINCO.NAGV_ABASTAUTOM_CONTROLE X
        
         WHERE X.DATA_FECHAMENTO BETWEEN '01-JUN-2023' AND SYSDATE
         GROUP BY X.COMPRADOR, to_char(x.DATA_FECHAMENTO, 'YYYY-MM'))
 ORDER BY 1, 2

-- Por Lote

SELECT DISTINCT T.SEQPRODUTO, Z.DESCCOMPLETA , SUM(NVL(QTDPEDIDA,0) / T.QTDEMBALAGEM) VOLUME, COMPRADOR
FROM CONSINCO.MAC_GERCOMPRAITEM t INNER JOIN CONSINCO.MAP_PRODUTO Z ON T.SEQPRODUTO = Z.SEQPRODUTO
                                                             inner join consinco.map_familia c on (c.seqfamilia = Z.seqfamilia)
                                                             inner join consinco.map_famdivisao jj on (jj.seqfamilia = c.seqfamilia and jj.nrodivisao = 1)
                                                             inner join consinco.max_comprador e on (e.seqcomprador = jj.seqcomprador)
WHERE t.SEQGERCOMPRA = 242139 AND T.QTDPEDIDA > 0
  AND T.NROEMPRESA < 300

GROUP BY T.SEQPRODUTO, DESCCOMPLETA, COMPRADOR
ORDER BY 2 


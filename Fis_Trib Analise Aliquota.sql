SELECT DISTINCT X.NROTRIBUTACAO, Z.TRIBUTACAO DESCRICAO, X.PERALIQUOTA ALIQUOTA,
       DECODE(NROREGTRIBUTACAO, 0, 'NORMAL', 2, 'FABRIC/ATAC') REGIME,
       DECODE(X.TIPTRIBUTACAO, 
      'EI','Entrada Industria', 'ED', 'Entrada Distrubuidor', 'EM','Entrada Microempresa','SC','Saída Contribuinte','SD','Saida Distribuidor','SI','Saída Industria','SM','Saida Microempresa','SN','Saida Não Contribuinte') Tipo_Regime
FROM CONSINCO.MAP_TRIBUTACAOUF X INNER JOIN CONSINCO.MAP_TRIBUTACAO Z ON X.NROTRIBUTACAO = Z.NROTRIBUTACAO 
WHERE UFCLIENTEFORNEC NOT IN ('SP','RJ') AND PERALIQUOTA != 4  AND X.NROREGTRIBUTACAO IN (0,2) AND TIPTRIBUTACAO IN ('EI','ED') AND Z.TRIBUTACAO LIKE 'IM%'
   OR UFCLIENTEFORNEC NOT IN ('SP','RJ') AND PERALIQUOTA != 12 AND X.NROREGTRIBUTACAO IN (0,2) AND TIPTRIBUTACAO IN ('EI','ED') AND Z.TRIBUTACAO LIKE 'ST%'

ORDER BY 1
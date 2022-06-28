ALTER SESSION SET current_schema = CONSINCO;

SELECT FP.SEQENVIO, FP.TIPOARQUIVO, COUNT(1), SUM(Vlrlancamento)                                                                                                                                                             

FROM FIV_PAGTOELETRPENDARQUIVO FP
 
WHERE EXISTS  ( 
      SELECT  1 
      FROM  FI_PROGPAGAMENTO X 
      WHERE X.SEQENVIO = FP.SEQENVIO 
      AND X.DTAPROGRAMACAO BETWEEN DATE '2022-06-01' AND DATE '2022-07-01')   
 
GROUP BY  TIPOARQUIVO, SEQENVIO
 
ORDER BY  TIPOARQUIVO;

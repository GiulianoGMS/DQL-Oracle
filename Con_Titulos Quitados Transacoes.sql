ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT A.SEQTITULO, C.NRODOCUMENTO, C.NROEMPRESA, NULL NSU, NULL DTAMOVIMENTO,
       NULL DTACONCILIADO, NULL DTAPAGAMENTO, 
       TO_CHAR(SUM(A.VALOR),   'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_TOTAL, 
       TO_CHAR(SUM(B.VLRPAGO), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_SEMTAXA, 
       TO_CHAR(SUM(B.VLRTAXA1),'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VLRTAXA1, 
       TO_CHAR(SUM(B.VLRTAXA2),'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VLRTAXA2 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
FROM FI_TITULONSU A,FI_TITULO C, 
   (SELECT X.SEQTITULONSU,
   X.SEQTITULO,
   SUM(X.VLRPAGO) VLRPAGO,
   SUM(X.VLRTAXA1) VLRTAXA1,
   SUM(X.VLRTAXA2) VLRTAXA2,
   MIN(X.DTAPAGAMENTO) DTAPAGAMENTO,
   MIN(X.ARQUIVO) ARQUIVO
   FROM FIV_LINHAARQUIVOTITNUS X
   WHERE X.SEQTITULONSU IS NOT NULL
   AND X.STATUS = 'Q'
   GROUP BY X.SEQTITULONSU, X.SEQTITULO) B 

WHERE A.SEQTITULO        = B.SEQTITULO(+)
      AND A.SEQTITULONSU = B.SEQTITULONSU(+)
      AND A.SEQTITULO    = C.SEQTITULO (+)
      AND A.SEQTITULO    = :NR1 
      
      GROUP BY A.SEQTITULO, C.NRODOCUMENTO, C.NROEMPRESA
      
      UNION ALL
      
      SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL
      
      UNION ALL

SELECT A.SEQTITULO, C.NRODOCUMENTO, C.NROEMPRESA, A.NSU, 
       TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       TO_CHAR(A.DTACONCILIADO,'DD/MM/YYYY') DTACONCILIADO, 
       TO_CHAR(B.DTAPAGAMENTO, 'DD/MM/YYYY') DTAPAGAMENTO, 
       TO_CHAR((A.VALOR),   'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_TOTAL, 
       TO_CHAR((B.VLRPAGO), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_SEMTAXA, 
       TO_CHAR((B.VLRTAXA1),'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VLRTAXA1, 
       TO_CHAR((B.VLRTAXA2),'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VLRTAXA2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
FROM FI_TITULONSU A,FI_TITULO C, 
 (SELECT X.SEQTITULONSU,
 X.SEQTITULO,
 SUM(X.VLRPAGO) VLRPAGO,
 SUM(X.VLRTAXA1) VLRTAXA1,
 SUM(X.VLRTAXA2) VLRTAXA2,
 MIN(X.DTAPAGAMENTO) DTAPAGAMENTO,
 MIN(X.ARQUIVO) ARQUIVO
 FROM FIV_LINHAARQUIVOTITNUS X
 WHERE X.SEQTITULONSU IS NOT NULL
 AND X.STATUS = 'Q'
 GROUP BY X.SEQTITULONSU, X.SEQTITULO) B 

WHERE A.SEQTITULO        = B.SEQTITULO(+)
      AND A.SEQTITULONSU = B.SEQTITULONSU(+)
      AND A.SEQTITULO    = C.SEQTITULO (+)
      AND A.SEQTITULO    = :NR1 '634338946'
      
    

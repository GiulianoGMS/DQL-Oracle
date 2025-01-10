ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT CTH.NROEMPRESA EMP, CTH.NROPROCESSO, CTH.DTALANCTO, CTH.TIPOLANCTO LCT, CTH.VLRLANCAMENTO, CTH.HISTORICO, 
       OP.CODOPERACAO, OP.DESCRICAO OPERACAO, CR.DESCRICAO||' - '||CR.SEQCTACORRENTE CONTA
  FROM (
SELECT NROPROCESSO, COUNT(NROPROCESSO) ODR
  FROM FI_CTACORLANCA C
 
 WHERE 1=1
   AND TRUNC(C.DTALANCTO) BETWEEN :DT1 AND :DT2
   AND C.OPCANCELADA IS NULL
   AND C.TIPOLANCTO = 'C'
   AND C.NROEMPRESA IN (#LS1)
       
       GROUP BY NROPROCESSO
       
       ) X INNER JOIN (SELECT * FROM FI_CTACORLANCA H WHERE H.TIPOLANCTO = 'H') H  ON H.NROPROCESSO   = X.NROPROCESSO
           INNER JOIN FI_CTACORLANCA CTH                                           ON CTH.NROPROCESSO = X.NROPROCESSO
                                                                                  AND CTH.OPCANCELADA IS NULL
                                                                                  AND CTH.TIPOLANCTO  = 'H' /* Somente Nulo */
                                                                                  AND CTH.CODOPERACAO BETWEEN 122 AND 129
           INNER JOIN FI_OPERACAO OP                                               ON OP.CODOPERACAO  = CTH.CODOPERACAO
           INNER JOIN FI_CTACORRENTE CR                                            ON CR.SEQCTACORRENTE = CTH.SEQCTACORRENTE
       
 WHERE ODR = 1 /* Puxa só 1 linha de crédio */

UNION ALL

SELECT DISTINCT CTC.NROEMPRESA, CTC.NROPROCESSO, CTC.DTALANCTO, CTC.TIPOLANCTO, CTC.VLRLANCAMENTO, CTC.HISTORICO, 
       OP.CODOPERACAO, OP.DESCRICAO OPERACAO, CR.DESCRICAO||' - '||CR.SEQCTACORRENTE CONTA
  FROM (
SELECT NROPROCESSO, COUNT(NROPROCESSO) ODR
  FROM FI_CTACORLANCA C
 
 WHERE 1=1
   AND TRUNC(C.DTALANCTO) BETWEEN :DT1 AND :DT2
   AND C.OPCANCELADA IS NULL
   AND C.TIPOLANCTO = 'C'
   AND C.NROEMPRESA IN (#LS1)
       
       GROUP BY NROPROCESSO
       
       ) X INNER JOIN (SELECT * FROM FI_CTACORLANCA H WHERE H.TIPOLANCTO = 'H') H  ON H.NROPROCESSO   = X.NROPROCESSO
           INNER JOIN FI_CTACORLANCA CTC                                           ON CTC.NROPROCESSO = X.NROPROCESSO
                                                                                  AND CTC.OPCANCELADA IS NULL
                                                                                  AND CTC.TIPOLANCTO  = 'C' /* Somente Credito */
           INNER JOIN FI_OPERACAO OP                                               ON OP.CODOPERACAO  = CTC.CODOPERACAO
           INNER JOIN FI_CTACORRENTE CR                                            ON CR.SEQCTACORRENTE = CTC.SEQCTACORRENTE
       
 WHERE ODR = 1 /* Puxa só 1 linha de crédio */

ORDER BY 2,4;



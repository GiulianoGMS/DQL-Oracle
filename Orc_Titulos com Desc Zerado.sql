ALTER SESSION SET current_schema = CONSINCO;

SELECT FI.NROEMPRESA EMP, GE.NOMERAZAO||' - '||FI.SEQPESSOA FORNECEDOR,
       CASE WHEN TO_CHAR(FI.NRODOCUMENTO) = TO_CHAR(FI.NROTITULO) THEN TO_CHAR(FI.NRODOCUMENTO) 
            ELSE 'DOC: '||TO_CHAR(FI.NRODOCUMENTO)||' | TIT: '||TO_CHAR(FI.NROTITULO) END DOCUMENTO, FI.CODESPECIE,
       TO_CHAR(FI.DTAVENCIMENTO, 'DD-MM-YYYY') DTAVENCIMENTO, TO_CHAR(FI.DTAINCLUSAO, 'DD-MM-YYYY') DTAINCLUSAO, 
       FI.VLRORIGINAL, FC.PERCDESCCONTRATO, FC.VLRDESCCONTRATO
       
FROM FI_TITULO FI LEFT JOIN FI_COMPLTITULO FC ON FI.SEQTITULO = FC.SEQTITULO, GE_PESSOA GE
WHERE FC.VLRDESCCONTRATO = 0
  AND GE.SEQPESSOA = FI.SEQPESSOA
  AND FI.DTAINCLUSAO BETWEEN :DT1 AND :DT2
  AND UPPER(GE.NOMERAZAO) LIKE UPPER ('%#LT1%') 
  AND CODESPECIE IN (:LS1)
  
ORDER BY FI.NROEMPRESA, FI.DTAINCLUSAO, FI.SEQPESSOA;
ALTER SESSION SET current_schema = CONSINCO;

-- Consulta SEQNOTA para conferir LOG

SELECT SEQNOTA, A.NROPROCESSO, A.* FROM CONSINCO.OR_NFDESPESA A 
WHERE A.NRONOTA = -- Numero NF 75552

-- Log Nf Despesas

SELECT * FROM LOG_NFDESPESA
WHERE SEQNOTA = -- SEQNOTA ref NF -- 510190
ORDER BY DTAALTERACAO DESC;

-- Temos um JOB que integra todas notas que ja estiverem lançadas no sistema

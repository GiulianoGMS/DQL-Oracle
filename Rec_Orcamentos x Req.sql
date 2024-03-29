ALTER SESSION SET current_schema = CONSINCO;

SELECT X.NROEMPRESA, X.NRONOTA, X.SEQPESSOA||' - '||CC.NOMERAZAO FORNECEDOR, TO_CHAR(X.DTAEMISSAO, 'DD/MM/YYYY') DATA_EMISSAO, 'Data requisição igual data de entrada' INCONSISTENCIA,
       TO_CHAR(X.VALOR, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR_NF, X.*
FROM CONSINCO.OR_NFDESPESA X LEFT JOIN CONSINCO.OR_NFDESPESAREQ Y ON X.SEQNOTA = Y.SEQNOTA
                             LEFT JOIN CONSINCO.OR_REQUISICAO Z ON Y.SEQREQUISICAO = Z.SEQREQUISICAO
                             LEFT JOIN GE_PESSOA CC ON X.SEQPESSOA = CC.SEQPESSOA
WHERE X.DTAENTRADA = Z.DTAINCLUSAO
  AND X.DTAEMISSAO BETWEEN SYSDATE -100 AND SYSDATE
  AND X.NROEMPRESA = 8
  

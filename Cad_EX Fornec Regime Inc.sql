ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT Z.SEQFORNECEDOR||' - '||NOMERAZAO FORNEC, UF, R.DESCRICAO
  FROM MAF_FORNECDIVISAO Z INNER JOIN GE_PESSOA X ON X.SEQPESSOA = Z.SEQFORNECEDOR AND X.UF = 'EX'
                           INNER JOIN CONSINCO.MON_REGIMETRIBUTACAO R ON R.NROREGTRIBUTACAO = Z.NROREGTRIBUTACAO
 
  WHERE Z.NROREGTRIBUTACAO != 8

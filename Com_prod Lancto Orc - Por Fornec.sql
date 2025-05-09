ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT A.NROEMPRESA,
       TO_CHAR(A.DTAENTRADA, 'MM') MES_ENTRADA,
       A.SEQPESSOA COD_FORNEC,
       C.NOMERAZAO,
       B.CODPRODUTO,
       B.QUANTIDADE,
       B.DESCRICAO,
       SUM(B.VLRTOTAL) VALOR

  FROM CONSINCO.OR_NFDESPESA      A,
       CONSINCO.OR_NFITENSDESPESA B,
       CONSINCO.GE_PESSOA         C
 WHERE A.SEQNOTA = B.SEQNOTA
       AND A.NROEMPRESA = B.NROEMPRESA
       AND A.SEQPESSOA = C.SEQPESSOA
       AND A.SEQPESSOA = :NR1
       AND DTAENTRADA BETWEEN :DT1 AND :DT2
   
  GROUP BY 
    A.NROEMPRESA,
       TO_CHAR(A.DTAENTRADA, 'MM'),
       A.SEQPESSOA,
       C.NOMERAZAO,
       B.CODPRODUTO,
       B.QUANTIDADE,
       B.DESCRICAO
       
       ORDER BY 7,2

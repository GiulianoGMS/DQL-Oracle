SELECT DISTINCT AA.*, 
       CASE WHEN '#LS1' IS NULL THEN 'TODAS AS EMPRESAS' ELSE TO_CHAR(B.NROEMPRESA) END EMP2, 
       TO_CHAR(:DT1, 'DD/MM/YYYY') DT1, TO_CHAR(:DT2, 'DD/MM/YYYY') DT2

  FROM GE_EMPRESA B LEFT JOIN (SELECT A.NROEMPRESA EMPRESA,
       A.NRONOTA NOTA,
       A.SERIE SERIE,
     
  (SELECT G.DESCRICAO
          FROM CONSINCO.ABA_HISTORICO G
         WHERE G.SEQHISTORICO = A.CODHISTORICO) HISTORICO,
       TO_CHAR(A.DTAEMISSAO, 'DD/MM/YYYY') EMISSAO,
       TO_CHAR(A.DTAENTRADA, 'DD/MM/YYYY') ENTRADA,
       A.CGO CGO,
       A.CFOP,
   
    (SELECT Y.NOMERAZAO
          FROM CONSINCO.GE_PESSOA Y
         WHERE Y.SEQPESSOA = A.SEQPESSOA) RAZAO,
       TO_CHAR(A.VALOR, 'FM999G999G999D90', 'nls_numeric_characters='',.''') VALOR,
       (SELECT COUNT(DISTINCT(A.SEQNOTA))
         
 FROM CONSINCO.OR_NFDESPESA A
         WHERE A.CODMODELO IN (01, 06, 21, 22, 28, 29)
               AND A.DTAENTRADA BETWEEN :DT1 AND :DT2
               AND A.NROEMPRESA IN (#LS1)) QTD_TOTAL,
    
   (SELECT TO_CHAR(SUM(A.VALOR),
                       'FM999G999G999D90',
                       'nls_numeric_characters='',.''')
          FROM CONSINCO.OR_NFDESPESA A
         WHERE A.CODMODELO IN (01, 06, 21, 22, 28, 29)
               AND A.DTAENTRADA BETWEEN :DT1 AND :DT2
               AND A.NROEMPRESA IN (#LS1)) VALOR_TOTAL,
       TO_CHAR(:DT1, 'DD/MM/YYYY') DATA_INICIAL,
       TO_CHAR(:DT2, 'DD/MM/YYYY') DATA_FINAL
        FROM CONSINCO.OR_NFDESPESA A
       
        WHERE A.CODMODELO IN (01, 06, 21, 22, 28, 29)
       AND A.DTAENTRADA BETWEEN :DT1 AND :DT2
       AND A.NROEMPRESA IN (#LS1)
       
       ) AA ON AA.EMPRESA = B.NROEMPRESA

       WHERE B.NROEMPRESA IN (#LS1)
 ORDER BY 1

SELECT * FROM (

SELECT F.SEQFORNECEDOR COD_FORNEC,
       X.NOMERAZAO,
       DECODE(F.TIPFORNECEDOR,
              'I',
              'Industria',
              'D',
              'Distribuidor',
              'S',
              'Prestador de Serviços') TIPO_FORNECEDOR,
       X.EMAIL || CASE
         WHEN X.EMAILNFE IS NOT NULL
              AND NVL(X.EMAIL, 'Z') != NVL(X.EMAILNFE, 'X') THEN
         CASE WHEN X.EMAIL IS NULL THEN
          X.EMAILNFE
         ELSE
          ', ' || X.EMAILNFE
       END END EMAIL
  FROM MAF_FORNECEDOR F INNER JOIN GE_PESSOA X ON X.SEQPESSOA = F.SEQFORNECEDOR

 WHERE SEQFORNECEDOR > 999
       AND X.STATUS = 'A'
)

WHERE TIPO_FORNECEDOR IN (#LS1)
 ORDER BY 2 ASC

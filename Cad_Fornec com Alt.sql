-- Indya Mara - Fornec Hort Alt

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT NOMERAZAO||' - '||SEQPESSOA FORNECEDOR
       
  FROM MAF_FORNECEDOR X INNER JOIN GE_PESSOA G ON G.SEQPESSOA = X.SEQFORNECEDOR
 WHERE EXISTS (
       
       SELECT 1 FROM MAP_FAMFORNEC Y WHERE Y.SEQFAMILIA IN (
       -- Produto
          SELECT DISTINCT SEQFAMILIA
            FROM MAP_AUDITORIA Z INNER JOIN MAP_PRODUTO A ON Z.SEQIDENTIFICA = A.SEQPRODUTO
           WHERE 1 = 1
             AND EXISTS (SELECT 1
                    FROM MAP_PRODUTO P
                   WHERE EXISTS (SELECT 1
                            FROM DIM_CATEGORIA@CONSINCODW D
                           WHERE CATEGORIAN1 LIKE '%HORT%'
                             AND D.SEQFAMILIA = P.SEQFAMILIA)
                     AND P.SEQPRODUTO = SEQIDENTIFICA)
             AND Z.DTAAUDITORIA BETWEEN DATE '2024-03-21' AND DATE '2024-03-23'
             AND Z.TABELA IN ('MAP_FAMILIA','MAP_PRODUTO','MAP_FAMFORNEC','MAP_FAMDIVISAO','MAP_FAMDIVCATEG')
             --AND ORIGEM = 'PRODUTO'

          UNION ALL
       -- Familia
          SELECT DISTINCT SEQFAMILIA
            FROM MAP_AUDITORIA ZZ INNER JOIN MAP_PRODUTO A ON ZZ.SEQIDENTIFICA = A.SEQFAMILIA
           WHERE 1 = 1
             AND EXISTS (SELECT 2
                    FROM DIM_CATEGORIA@CONSINCODW D
                   WHERE CATEGORIAN1 LIKE '%HORT%'
                     AND D.SEQFAMILIA = ZZ.SEQIDENTIFICA)
             AND ZZ.DTAAUDITORIA BETWEEN DATE '2024-03-21' AND DATE '2024-03-23'
             AND ZZ.TABELA IN ('MAP_FAMILIA','MAP_PRODUTO','MAP_FAMFORNEC','MAP_FAMDIVISAO','MAP_FAMDIVCATEG'))
             --AND ORIGEM = 'FAMILIA'
             
           AND Y.SEQFORNECEDOR = X.SEQFORNECEDOR)
     AND STATUS = 'A'
     AND SEQPESSOA > 999
     

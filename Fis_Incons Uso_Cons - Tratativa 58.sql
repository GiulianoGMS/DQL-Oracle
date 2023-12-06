-- Inserir em MLFV_AUXNOTAFISCALINCONS

-- Ticket 325855 - Solic Dublia - Adicionado em 05/12/2023 por Giuliano
-- Tratativa Uso/Cons da regra 58 - Trataamento entre Fornecedores e Grupo - Por Razao

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                B.SEQAUXNFITEM AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                74 AS CODINCONSISTENC,
                'Item ' || B.SEQPRODUTO || ' está cadastrado com a Finalidade "Material de Uso e Consumo", portanto, só poderá ser lançado no CGO 02 (Fornec)' AS  MENSAGEM
  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON (A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL )
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON (C.SEQPRODUTO = B.SEQPRODUTO)
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO E ON (E.SEQFAMILIA = C.SEQFAMILIA)
  WHERE E.FINALIDADEFAMILIA = 'U'
  AND   A.CODGERALOPER != 2
  AND   A.SEQPESSOA > 999 -- Fornecedores fora Emp Grupo
  AND A.NROEMPRESA != 506

 UNION ALL

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                B.SEQAUXNFITEM AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                75 AS CODINCONSISTENC,
                CASE WHEN A.CODGERALOPER = 59 AND (SELECT NAGF_BUSCACGCEMP(A.SEQPESSOA) FROM DUAL)  = (SELECT NAGF_BUSCACGCEMP(A.NROEMPRESA) FROM DUAL)
                  THEN 'Item ' || B.SEQPRODUTO || ' está cadastrado com a Finalidade "Material de Uso e Consumo", portanto, só poderá ser lançado no CGO 61 (Mesma Razão)'
                     WHEN A.CODGERALOPER = 61 AND (SELECT NAGF_BUSCACGCEMP(A.SEQPESSOA) FROM DUAL) != (SELECT NAGF_BUSCACGCEMP(A.NROEMPRESA) FROM DUAL)
                  THEN 'Item ' || B.SEQPRODUTO || ' está cadastrado com a Finalidade "Material de Uso e Consumo", portanto, só poderá ser lançado no CGO 59 (Razão Diferente)' END
                 MENSAGEM
  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON (A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL )
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON (C.SEQPRODUTO = B.SEQPRODUTO)
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO E ON (E.SEQFAMILIA = C.SEQFAMILIA)
  WHERE E.FINALIDADEFAMILIA = 'U'
  AND  (A.CODGERALOPER = 59 AND (SELECT NAGF_BUSCACGCEMP(A.SEQPESSOA) FROM DUAL)  = (SELECT NAGF_BUSCACGCEMP(A.NROEMPRESA) FROM DUAL)  -- 59 e Mesma Razao
    OR  A.CODGERALOPER = 61 AND (SELECT NAGF_BUSCACGCEMP(A.SEQPESSOA) FROM DUAL) != (SELECT NAGF_BUSCACGCEMP(A.NROEMPRESA) FROM DUAL)) -- 61 e Mesma Razao
  AND   A.SEQPESSOA < 999
  AND A.NROEMPRESA != 506

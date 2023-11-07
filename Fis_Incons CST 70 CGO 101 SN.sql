-- Inserir em CONSINCO.MLFV_AUXNOTAFISCALINCONS

UNION ALL

-- Ticket 312166 - Solic Simone - Adicionado em 06/11/2023 por Giuliano
-- Barra CST 70 na bonif 101 e fornec Simples Nacional

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                71  AS CODINCONSISTENC,
                'Nota fiscal bonificada com produto monofásico, por favor entrar em contato com o Departamento Fiscal.'  MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA F ON F.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAF_FORNECEDOR FO ON FO.SEQFORNECEDOR = A.SEQPESSOA
                                    
 WHERE (F.SITUACAONFPIS = 70 OR F.SITUACAONFCOFINS = 70)
   AND A.DTAENTRADA > SYSDATE - 50
   AND A.CODGERALOPER = 101
   AND FO.MICROEMPRESA = 'S'

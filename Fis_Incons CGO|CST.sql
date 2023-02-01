-- Alteração na CONSINCO.MLFV_AUXNOTAFISCALINCONS

UNION ALL -- Trava para barrar entrada com CGO 200/900 e CST <> 000,020,040 - 01/02/2023 - Giuliano - Solic Danielle - Ticket 175967

SELECT DISTINCT(A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                62  AS CODINCONSISTENC,
                'Produto ST não permite entrada para este fornecedor'
                
                FROM consinco.MLF_AUXNOTAFISCAL A INNER JOIN consinco.Mlf_Auxnfitem b    ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL 
                                                  INNER JOIN CONSINCO.MAP_PRODUTO    P   ON P.SEQPRODUTO = B.SEQPRODUTO
                                                  INNER JOIN CONSINCO.MAP_FAMDIVISAO FF  ON FF.SEQFAMILIA = P.SEQFAMILIA
                                                  INNER JOIN CONSINCO.MAP_TRIBUTACAOUF T ON T.NROTRIBUTACAO = FF.NROTRIBUTACAO AND T.NROREGTRIBUTACAO = 0
                                           
WHERE A.CODGERALOPER IN (200,900) AND (B.SITUACAONF NOT IN (000,020,040) OR T.SITUACAONF NOT IN (000,020,040)) AND NUMERONF != 0 

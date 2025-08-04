-- Giuliano 04/08/2025
-- Ticket 613831
-- Barrar lançamento no local AVARIA, exceto CDs

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                89  AS CODINCONSISTENC,
                'Não é permitido o lançamento no local '||L.LOCAL||' para o produto '||B.SEQPRODUTO||' nesta operação, verifique!' MOTIVO
                
  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL  
                                    INNER JOIN MRL_LOCAL L ON L.SEQLOCAL = B.LOCATUESTQ AND L.NROEMPRESA = A.NROEMPRESA 

WHERE 1=1
  AND A.NROEMPRESA < 500 -- Exceto CDs
  AND A.DTAEMISSAO >= SYSDATE - 50
  AND L.LOCAL = 'AVARIA'

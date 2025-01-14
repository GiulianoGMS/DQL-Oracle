-- Adicionar em MLFV_AUXNOTAFISCALINCONS

-- Ticket 508143 - Adicionado por Giuliano em 06/01/2025
-- Regra: Valida o CGO de lançamento de acordo com o CGO de emissão da NF, para devoluções dos CDs 502 e 503
-- Se partiu de transferencia origem indireta (CGOs 94 ou 95) o CGO de lançamento da devolucao precisa ser 55
-- Se partiu de transferencia  origem direta (CGOs 64 ou 96) o CGO de lançamento da devolucao precisa ser 74
    
SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
               'B' AS BLOQAUTOR,
                85  AS CODINCONSISTENC,
               'CGO incorreto na operação, para lançamento desta devolução utilize o CGO: '||DECODE(X.CODGERALOPER, '55', '74 ou 79', '74', '55')||'.' MSG

    FROM MLF_AUXNOTAFISCAL X
  WHERE 1=1
    AND X.CODGERALOPER IN (55,74,79) -- Adicionado CGO 79 - Ticket 516610 em 14/01/25 - Giuliano Solic Danielle
    AND X.DTAEMISSAO > SYSDATE - 30
    AND X.SEQNFREF IS NOT NULL

    AND EXISTS (SELECT 1 FROM MLF_NOTAFISCAL Z
                        WHERE Z.SEQNF = X.SEQNFREF
                          AND Z.CODGERALOPER IN (29,32,51)
                          AND (X.CODGERALOPER IN (74,79) AND Z.CODGERALOPER IN (51) OR
                               X.CODGERALOPER = 55 AND Z.CODGERALOPER IN (29,32)))

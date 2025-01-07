-- Ticket 508798 - Adicionado por Giuliano em 07/01/2025
-- Validação de entrada de devolução de NF do grupo - CGOs 54 e 55 (Razao dif e mesma razao):

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
               'B' AS BLOQAUTOR,
                86  AS CODINCONSISTENC,
               'CGO Incorreto na operação, utilize o CGO correto: '||
               DECODE(X.CODGERALOPER, 55,54,54,55) MSG
               

    FROM MLF_AUXNOTAFISCAL X INNER JOIN MAX_EMPRESA B ON B.NROEMPRESA = X.NROEMPRESA
                             INNER JOIN MAX_EMPRESA C ON C.NROEMPRESA = X.SEQPESSOA
  WHERE 1=1
    AND X.DTAEMISSAO > SYSDATE - 50
    AND X.CODGERALOPER IN (54,55)
    AND (SUBSTR((LPAD(B.NROCGC,13,0)),0,9)  = SUBSTR((LPAD(C.NROCGC,13,0)),0,9) AND CODGERALOPER = 55  -- Mesma razao x CGO razao dif
     OR  SUBSTR((LPAD(B.NROCGC,13,0)),0,9) != SUBSTR((LPAD(C.NROCGC,13,0)),0,9) AND CODGERALOPER = 54) -- Razao dif x CGO mesma razao

UNION ALL 

-- Trava de devolução para notas emitidas pelo CGO incorreto (802):

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
               'B' AS BLOQAUTOR,
                87  AS CODINCONSISTENC,
               'NF de devolução emitida com CGO incorreto (802), solicite a correção da NF!' MSG

    FROM MLF_AUXNOTAFISCAL X
  WHERE 1=1
    AND X.DTAEMISSAO > SYSDATE - 50
    AND CODGERALOPER IN (54,55)
    AND EXISTS (SELECT * FROM CONSINCO.MLF_NOTAFISCAL Z
                        WHERE Z.NUMERONF = X.NUMERONF
                          AND Z.SEQPESSOA = X.NROEMPRESA
                          AND Z.NROEMPRESA = X.SEQPESSOA
                          AND Z.CODGERALOPER IN (802)
                          AND Z.DTAEMISSAO = X.DTAEMISSAO);

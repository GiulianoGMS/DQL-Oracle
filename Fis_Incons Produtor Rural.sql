-- Ticket 501071 - Adicionado por Giuliano em 19/12/2024
-- Regra: Barra utilização de CGO incorreto para o fornecedor específico - Produtor Rural

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                84  AS CODINCONSISTENC,
               'NF do fornec.: '||FANTASIA||' Produtor Rural com CGO incorreto.'

  FROM MLF_AUXNOTAFISCAL X INNER JOIN GE_PESSOA G ON G.SEQPESSOA = X.SEQPESSOA
  WHERE 1=1
    AND CODGERALOPER NOT IN (81,82,83,84,85)
    AND G.NROCGCCPF = 084208010001;
;

-- Alteração na CONSINCO.MLFV_AUXNOTAFISCALINCONS
-- Ticket 219089 - Solic. Simone | Adicionado por Giuliano em 20/04/2023 - Validação GNRE tipo DARE

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                65  AS CODINCONSISTENC,
                CASE WHEN CODOBRIGREC != '005' AND CODRECEITA NOT IN ('063-2','100-4') THEN 'O Codigo da obrigaCAO a recolher e o Codigo da Receita estao incorretos'
                  WHEN CODOBRIGREC != '005' THEN 'O Codigo da obrigaCAO a recolher esta incorreto'
                  WHEN CODRECEITA NOT IN ('063-2','100-4') THEN 'O Codigo da Receita esta incorreto' ELSE NULL END
                ||' na Guia de Recolhimento - Verificar com o Depto. Fiscal' MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_GNRE B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL

WHERE TIPOGUIA IN ('R','G') -- G GARE Solic por Neides em 01/11/2024 - Teams - Giuliano
  AND (CODOBRIGREC != '005' OR CODRECEITA NOT IN ('063-2','100-4'))

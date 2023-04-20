-- Alteração na CONSINCO.MLFV_AUXNOTAFISCALINCONS
-- Ticket 219089 - Solic. Simone | Adicionado por Giuliano em 20/04/2023 - Validação GNRE tipo DARE

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, 
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                65  AS CODINCONSISTENC,
                CASE WHEN CODOBRIGREC != '005' AND CODRECEITA NOT IN ('063-2','100-4') THEN 'O Código da obrigação a recolher e o Código da Receita estão incorretos' 
                  WHEN CODOBRIGREC != '005' THEN 'O Código da obrigação a recolher está incorreto'
                  WHEN CODRECEITA NOT IN ('063-2','100-4') THEN 'O Código da Receita está incorreto' ELSE NULL END 
                ||' na Guia de Recolhimento, Verifique!' MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_GNRE B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL

WHERE TIPOGUIA = 'R' AND (CODOBRIGREC != '005' OR CODRECEITA NOT IN ('063-2','100-4'))

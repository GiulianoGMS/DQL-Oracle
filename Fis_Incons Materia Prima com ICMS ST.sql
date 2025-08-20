UNION ALL

-- Giuliano 20/08/2025
-- Ticket 620520
-- Produto com finalidade Materua Prima não permite lancto com destaque de ICMS ST

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                90  AS CODINCONSISTENC,
                'Produto com finalidade Matéria Prima e com  Destaque de ICMS ST não permitido. Entre em contato com Departamnto Fiscal.' MENSAGEM

  FROM MLF_AUXNOTAFISCAL X INNER JOIN MLF_AUXNFITEM XI ON X.SEQAUXNOTAFISCAL = XI.SEQAUXNOTAFISCAL
                           INNER JOIN MAP_PRODUTO A ON A.SEQPRODUTO = XI.SEQPRODUTO
                               
 WHERE 1=1 
   AND NVL(XI.VLRICMSST,0) > 0
   AND X.DTAEMISSAO >= SYSDATE - 50
   AND EXISTS (SELECT 1 FROM MAP_FAMDIVISAO F WHERE F.FINALIDADEFAMILIA = 'P' AND F.SEQFAMILIA = A.SEQFAMILIA);

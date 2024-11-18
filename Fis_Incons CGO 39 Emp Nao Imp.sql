-- Adicionar em CONSINCO.MLFV_AUXNOTAFISCALINCONS

-- Ticket 480487 - Adicionado por Giuliano em 18/11/2024
-- Regra: Não permite lancto com emissao pelo CGO 39 que não seja os CDs 502 e 503

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                83  AS CODINCONSISTENC,
               'NF emitida com CGO incorreto (39) para a empresa '||X.NROEMPRESA||' - Solicite a correção'

  FROM MLF_AUXNOTAFISCAL X INNER JOIN MLF_AUXNFITEM XI ON X.SEQAUXNOTAFISCAL = XI.SEQAUXNOTAFISCAL
                           INNER JOIN MAP_PRODUTO MP ON MP.SEQPRODUTO = XI.SEQPRODUTO
                           INNER JOIN MAP_FAMILIA MF ON MF.SEQFAMILIA = MP.SEQFAMILIA
  WHERE 1=1
    AND EXISTS (SELECT 1 FROM MLF_NOTAFISCAL D WHERE D.CODGERALOPER = 39
                                                 AND D.SEQPESSOA NOT IN (502,503)
                                                 AND D.NFECHAVEACESSO = X.NFECHAVEACESSO)
    

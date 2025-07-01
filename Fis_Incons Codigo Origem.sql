-- Incluir em MLFV_AUXNOTAFISCALINCONS
-- Giuliano 01/07/2025
-- Valida Codigo origem do lancto x cadastro
   
SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
       DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                89  AS CODINCONSISTENC,
               'Cod Origem no lançamento está divergende do cadastro. Reimporte a NF para que seja atualizado! Cod.Origem Lancto: '||B.CODORIGEMTRIB||' Cad.: '||D.CODORIGEMTRIB  MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                 

WHERE 1=1
  AND B.CODORIGEMTRIB != D.CODORIGEMTRIB
  AND A.SEQPESSOA > 999
  AND A.DTAEMISSAO >= SYSDATE - 50

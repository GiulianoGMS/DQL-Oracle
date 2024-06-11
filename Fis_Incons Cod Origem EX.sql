-- Adicionar em CONSINCO.MLFV_AUXNOTAFISCALINCONS
-- Adicionado por Giuliano para tratar CodOrigem EX -17/01/24
-- PD EXIBE_ORIGEM_MERCADORIA

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                76  AS CODINCONSISTENC,
                'Cod. Origem da Mercadoria Oriunda EX deve ser 1. PLU: '||B.SEQPRODUTO MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.GE_PESSOA G ON G.SEQPESSOA = A.SEQPESSOA
                                    INNER JOIN CONSINCO.MAP_PRODUTO P ON P.SEQPRODUTO = B.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA
    
WHERE G.UF = 'EX'
  AND A.CODGERALOPER IN (43,5)
  AND F.CODORIGEMTRIB != 1 -- Olhar a tributacao da familia pois é o considerado na emissao

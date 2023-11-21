-- Inserir em MLFV_AUXNOTAFISCALINCONS

UNION ALL

-- Ticket 320466 - Solic Danielle - Adicionado em 21/11/2023 por Giuliano
-- Barra Cod. Origem NULO no sistema
   
SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                72  AS CODINCONSISTENC,
                'Produto: '||B.SEQPRODUTO||' s/Cod.Origem - Abrir chamado para o Depto Cad.Trib.para correção XML: '||L.M014_DM_ORIG_ICMS||' -  C5 sem informação' MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)

WHERE D.CODORIGEMTRIB IS NULL

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Ticket 206722 - Adicionado por Giuliano - Solic Danielle 20/03
-- Regra: Trava 4 dígitos do NCM diferentes entre XML e C5

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                64  AS CODINCONSISTENC,
                'Produto '||B.SEQPRODUTO||' com NCM incorreto, abrir chamado para o Depto. Fiscal Cad. Trib. para correção - XML: '||M014_CD_NCM||' - C5: '||E.CODNBMSH MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)

WHERE SUBSTR(M014_CD_NCM,0,4) != SUBSTR(E.CODNBMSH,0,4) AND A.SEQPESSOA > 999

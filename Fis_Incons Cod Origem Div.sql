-- Ticket 204660 - Adicionado por Giuliano - Solic Danielle 30/03
-- Regra: Trava Cod Origem XML = 0 e C5 1,2,3,8 || OU || XML: 1,2,3,8 e C5 0,4,5,7
-- Ultima atualizacao em 21/11/2023 - Ticket 512625 -- Penultima Ticket 320474
-- Alterado em 25/06/24 por Giuliano - Ticket 417539 - Barrar todas divergencias
-- Alterado em 28/06/24 por Giuliano - Ticket 419280 - Altera regra para FLV

SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
       DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                65  AS CODINCONSISTENC,
                'Prod: '||B.SEQPRODUTO||' - '||C.DESCREDUZIDA||' - Cod. Origem incorreto, abrir chamado para Depto. Fiscal Cad. Trib. para correcao - XML: '||L.M014_DM_ORIG_ICMS||' - Cad: '||D.CODORIGEMTRIB  MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)
                                    --INNER JOIN DIM_CATEGORIA@CONSINCODW DC ON DC.SEQFAMILIA = E.SEQFAMILIA

-- Alterado em 25/06/24 por Giuliano - Ticket 417539 - Barrar todas divergencias

WHERE NVL(L.M014_DM_ORIG_ICMS,1) != NVL(D.CODORIGEMTRIB,2)
  AND A.SEQPESSOA > 999
-- Ticket 512625 - 5 x 0 = X x X = Passa
-- Minha logica: Se o DECODE do XML retornar X e o DECODE da C5 Também, não vai barrar
  AND DECODE(NVL(L.M014_DM_ORIG_ICMS,1), 5, 'X', 0, 'X', 1) 
  !=  DECODE(NVL(D.CODORIGEMTRIB,2)    , 5, 'X', 0, 'X', 2) 
--
  AND A.DTAEMISSAO > SYSDATE - 50
--
-- Alterado em 28/06/24 por Giuliano - Ticket 419280 - Altera regra para FLV
  AND NOT EXISTS (SELECT 1 FROM DIM_CATEGORIA@CONSINCODW DC WHERE DC.SEQFAMILIA = C.SEQFAMILIA AND DC.CATEGORIAN1 = 'HORTIFRUTI')
--
   OR EXISTS (SELECT 1 FROM DIM_CATEGORIA@CONSINCODW DC WHERE DC.SEQFAMILIA = C.SEQFAMILIA AND DC.CATEGORIAN1 = 'HORTIFRUTI')
  AND A.SEQPESSOA > 999
  AND A.DTAEMISSAO > SYSDATE - 50

  AND(NVL(L.M014_DM_ORIG_ICMS,1) IN (2,3,8)   AND NVL(D.CODORIGEMTRIB,2) IN (0,4,5,7)
   OR NVL(L.M014_DM_ORIG_ICMS,1) IN (0,4,5,7) AND NVL(D.CODORIGEMTRIB,2) IN (2,3,8))
--

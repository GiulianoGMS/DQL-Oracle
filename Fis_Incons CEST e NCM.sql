-- Inserir em CONSINCO.MLFV_AUXNOTAFISCALINCONS

-- Ticket 324275 - Solic Simone - Adicionado em 04/12/2023 por Giuliano
-- Barra CEST NULO / CEST ou NCM divergente do cad no sistema
-- Retirado validacao do NCM

-- Ticket 324275 - Solic Simone - Adicionado em 04/12/2023 por Giuliano
-- Barra CEST NULO / CEST ou NCM divergente do cad no sistema
-- Retirado validacao do NCM Temporariamente

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                73  AS CODINCONSISTENC,
                CASE WHEN L.CODCEST IS NULL                                                                    THEN 'Cod. CEST do produto '||
                  B.SEQPRODUTO||' no XML está NULO - Abrir chamado para do Departamento Fiscal - CEST XML: '||NVL(TO_CHAR(L.CODCEST), 'NULO')||' - C5: '||E.CODCEST
                    -- WHEN NVL(L.CODCEST,0) != NVL(E.CODCEST,0) AND NVL(L.M014_CD_NCM,0) != NVL(CODNBMSH,0)   THEN 'Codigo CEST e NCM do produto '||B.SEQPRODUTO||' no  XML estão divergentes do cadastro no sistema - Abrir chamado para o Depto Cadastro Tributário'
                     WHEN NVL(L.CODCEST,0) != NVL(E.CODCEST,0) /*AND NVL(L.M014_CD_NCM,0)  = NVL(CODNBMSH,0) */THEN 'Cod. CEST do produto '||
                  B.SEQPRODUTO||' está divergente do cadastro no sistema - Abrir chamado para o Depto Cadastro Tributário - CEST XML: '||L.CODCEST||' - C5: '||E.CODCEST
                    -- WHEN NVL(L.CODCEST,0)  = NVL(E.CODCEST,0) AND NVL(L.M014_CD_NCM,0) != NVL(CODNBMSH,0)   THEN 'Codigo NCM do produto '||B.SEQPRODUTO||' está divergente do cadastro no sistema - Abrir chamado para o Depto Cadastro Tributário'
                       END AS MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)

WHERE A.CODGERALOPER = 1
  AND L.M014_DM_TRIB_ICMS IN (1,9,8) -- De/Para na Function fc5_RetIndSituacaoNF_NFe - Regra Barra CST 10 70 60 respectivamente na clausula
                                     -- CST 202 e 500 (Simples Nacional) sera tratado no OR abaixo pois muda a regra
  -- AND A.NROEMPRESA = 501 -- Inicialmente apenas CD
  AND (NVL(L.CODCEST,0) != NVL(E.CODCEST,1))-- OR NVL(L.M014_CD_NCM,0) != NVL(CODNBMSH,0))
  -- Trata SN
  OR A.CODGERALOPER = 1
 AND EXISTS(SELECT SEQFORNECEDOR FROM MAF_FORNECEDOR SN WHERE SN.MICROEMPRESA = 'S' AND SEQFORNECEDOR = A.SEQPESSOA)
 AND M014_DM_TRIB_ICMS IN (0,24)
 AND (NVL(L.CODCEST,0) != NVL(E.CODCEST,1))-- OR NVL(L.M014_CD_NCM,0) != NVL(CODNBMSH,0))

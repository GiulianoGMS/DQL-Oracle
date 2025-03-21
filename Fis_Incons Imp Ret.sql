ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Adicionar em MLFV_AUXNOTAFISCALINCONS

-- Criado por Giuliano em 29/01/2024 - Solic Neides Ticket 341549
-- Barra Imp Ret Nulo ou Zerado com CST 60

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR, -- SOLICITACAO SILENE 19/02/2024 TEAMSN
                77  AS CODINCONSISTENC,
                'O(s) Campo(s): '||
                --CASE WHEN NVL(L.M014_VL_OP_PROP_DIST,0) = 0 THEN 'vICMSSubstituto' ELSE NULL END||
                CASE WHEN NVL(L.M014_VL_BC_ST_RET,0)    = 0 THEN ' vBCSTRet'       ELSE NULL END||
                CASE WHEN NVL(L.M014_VL_ICMS_ST_RET,0)  = 0 THEN ' vICMSSTRet'     ELSE NULL END||
                CASE WHEN NVL(M014_VL_OP_PROP_DIST,0)   = 0 THEN 'vICMSSubstituto' ELSE NULL END||
                --CASE WHEN M014_VL_BC_FCP_RET   IS NULL THEN ' vBCFCPSTRet'    ELSE NULL END||
                --CASE WHEN M014_VL_FCP_RET      IS NULL THEN ' vFCPSTRet'      ELSE NULL END||
                ' do produto '||B.SEQPRODUTO||' esta(o) nulo(s) no XML! Entre em contato com o Departamento Fiscal'
                MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)

WHERE A.CODGERALOPER = 1
  -- AND A.NROEMPRESA IN (501,11,8,26,1,7,9,14,22,23,25,28,31,40,46) -- Solicitadas por Neides
  AND A.SEQPESSOA NOT IN (SELECT SEQPESSOA FROM GE_PESSOA G WHERE G.NROCGCCPF = 236433150110) -- Criar De/Para Posteriormente
  -- De/Para na Function fc5_RetIndSituacaoNF_NFe - Regra Barra CST 60
  AND (L.M014_DM_TRIB_ICMS IN (8)
  -- Acrescentando SN - Ticket 421458 - Giuliano 22/07/2024
   OR EXISTS(SELECT 1 FROM MAF_FORNECEDOR SN WHERE SN.MICROEMPRESA = 'S' AND SEQFORNECEDOR = A.SEQPESSOA)
      AND M014_CD_CFOP IN (5405)) -- Apenas 5405 Solic Neides 10/09/24 Teams
  -- Criterios que nao podem estar nulos
  AND (NVL(L.M014_VL_OP_PROP_DIST,0) = 0 AND A.NROEMPRESA IN (36,53)  -- vICMSSubstituto -- Retirado tkt 440544
   OR (NVL(L.M014_VL_BC_ST_RET,0)    = 0  -- vBCSTRet
   OR  NVL(L.M014_VL_ICMS_ST_RET,0)  = 0))  -- vICMSSTRet
 --OR  L.M014_VL_BC_FCP_RET   IS NULL  -- vBCFCPSTRet -- Removidos - Solic Neides
 --OR  L.M014_VL_FCP_RET      IS NULL) -- vFCPSTRet   -- ^

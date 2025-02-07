-- Ticket 482006 | Adicionado por Giuliano em 07/02/2025
-- Solic Fiscal | Barrar ICMS SN sem valor no XML de fornec SN com Perc parametrizado no cadastro do fornec

SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
       DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                88  AS CODINCONSISTENC,
               'Fornecedor SN sem valor ICMS SN no XML! - Solicitar a troca da Nota Fiscal.'
                                                       
                
  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)
                                    INNER JOIN MAF_FORNECEDOR F ON F.SEQFORNECEDOR = A.SEQPESSOA
                                    INNER JOIN CONSINCO.MAF_FORNECDIVISAO FD ON FD.SEQFORNECEDOR = F.SEQFORNECEDOR
                                    
 WHERE F.MICROEMPRESA = 'S'
   AND A.CODGERALOPER = 1
   AND NVL(L.M014_CD_CFOP,0) = 5102
   AND NVL(FD.PERALIQICMSSIMPLESNAC,0) > 0
   -- Deve travar ICMS SN = 0
   AND (NVL(M014_VL_PERC_CRED_SN,0) = 0 OR NVL(M014_VL_CRED_ICMS_SN,0) = 0)
                          

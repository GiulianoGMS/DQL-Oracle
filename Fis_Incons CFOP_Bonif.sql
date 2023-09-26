-- Adicionado na view CONSINCO.MLFV_AUXNOTAFISCALINCONS
-- Ticket 291664 - Solic Dublia | Adicionado em 26/09/2023 por Giuliano

SELECT  /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4') */
          DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, 
          A.NUMERONF,
          A.NROEMPRESA,
          B.SEQAUXNFITEM AS SEQAUXNFITEM,
          'B' AS BLOQAUTOR,
          68 AS CODINCONSISTENC,
          'Produto: '||B.SEQPRODUTO||' Com CFOP: '||M014_CD_CFOP||' apenas pode ser lançado com CGO de Bonificação. Entre em contato com seu apoio' MENSAGEM
  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON (A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL )
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON (C.SEQPRODUTO = B.SEQPRODUTO)
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON (E.SEQFAMILIA = C.SEQFAMILIA)
                                    INNER JOIN NAGV_FORNTIPO F ON (F.SEQFORNECEDOR = A.SEQPESSOA) --- VIEW TIPO FORNECEDOR
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)
                                                                             
 WHERE M014_CD_CFOP IN (5910,6910) AND A.CODGERALOPER NOT IN (101,128,143,239,208)

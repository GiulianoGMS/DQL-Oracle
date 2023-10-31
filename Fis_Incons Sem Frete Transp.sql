-- Adicionar em MLFV_AUXNOTAFISCALINCONS

UNION ALL

-- Ticket 308911 - Solic Neides - Adicionado em 31/10/2023 por Giuliano
-- Barra XML sem emissão/ocorrencia de transporte (Cod. 9)

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                69  AS CODINCONSISTENC,
                'XML sem ocorrencia de transporte - Solicite a nota correta para o fornecedor - Duvidas entre contato setor Fiscal' MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN CONSINCO.TMP_M006_TRANSPORTE T ON T.M000_ID_NF = K.M000_ID_NF
                                    
 WHERE M006_DM_FRETE = 9
   AND A.DTAENTRADA > SYSDATE - 50

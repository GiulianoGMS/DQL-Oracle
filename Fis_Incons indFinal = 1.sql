-- Adicionar em MLFV_AUXNOTAFISCALINCONS

UNION ALL

-- Ticket 306519 - Solic Simone - Adicionado em 31/10/2023 por Giuliano
-- Barra indFinal = 1 - Consumidor Final - No CGO 01

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                70  AS CODINCONSISTENC,
                'Indicador de operação da nota fiscal ( consumidor final ) divergente da finalidade do CGO - Solicitar a troca da nota' MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)

 WHERE 1=1
   AND K.M000_INDFINAL = 1
   AND A.CODGERALOPER  IN (1, 101, 143, 208, 239, 900) -- Ajustado em 06/02/24 TIcket 366778 - Solic Simone
   AND A.DTAENTRADA > SYSDATE - 100

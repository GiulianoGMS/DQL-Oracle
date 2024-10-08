-- Adicionar em MLFV_AUXNOTAFISCALINCONS

-- Criado por Giuliano em 13/05/2024 - Solic Comprador Junior/Sandra Maceron - FLV
-- Barrar vinculação de pedidos com data de emissão maior que data de emissão da NF, apenas FLV
 
SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                78  AS CODINCONSISTENC,
                'A Data do pedido '||B.NROPEDIDOSUPRIM||' vinculado ao produto '||B.SEQPRODUTO||' ('||TO_CHAR(PS.DTAEMISSAO, 'DD/MM/YYYY')||')'||
                ' é MAIOR que a data de emissão da NF ('||TO_CHAR(A.DTAEMISSAO, 'DD/MM/YYYY')||')' AS MENSAGEM

  FROM CONSINCO.MLF_AUXNOTAFISCAL A INNER JOIN CONSINCO.MLF_AUXNFITEM B ON A.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                    INNER JOIN CONSINCO.MAP_PRODUTO C ON B.SEQPRODUTO = C.SEQPRODUTO
                                    INNER JOIN CONSINCO.MAP_FAMILIA E ON E.SEQFAMILIA = C.SEQFAMILIA
                                    INNER JOIN CONSINCO.MAP_FAMDIVISAO D ON D.SEQFAMILIA = E.SEQFAMILIA
                                    INNER JOIN TMP_M000_NF K ON (K.M000_NR_CHAVE_ACESSO = A.NFECHAVEACESSO)
                                    INNER JOIN TMP_M014_ITEM L ON (L.M000_ID_NF = K.M000_ID_NF AND L.M014_NR_ITEM = B.SEQITEMNFXML)
                                    INNER JOIN MAX_COMPRADOR CP ON CP.SEQCOMPRADOR = D.SEQCOMPRADOR 
                                    INNER JOIN MSU_PEDIDOSUPRIM PS ON PS.NROPEDIDOSUPRIM = B.NROPEDIDOSUPRIM AND PS.NROEMPRESA = A.NROEMPRESA 

WHERE 1=1
  AND CP.COMPRADOR = 'EQUIPE FLV'
  AND PS.DTAEMISSAO > A.DTAEMISSAO
  AND A.DTAEMISSAO > SYSDATE - 100
  --AND A.NUMERONF = 714577 

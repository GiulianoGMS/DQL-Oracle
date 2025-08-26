SELECT S.NROEMPRESA LOJA,
       S.NROPEDIDOSUPRIM NRO_PEDIDO,
       C.COMPRADOR,
       S.SEQFORNECEDOR COD_FORNEC,
       GE.NOMERAZAO RAZAO_FORNEC,
       S.PZOPAGAMENTO,
       DECODE(MF.TIPODTABASEVENCTO, 'F', 'Base Faturamento', 'E','Base Emissao',' R','Base Lançamento', 'S','Base Saida') TIPO_BASE_VENCTO,
       TO_CHAR(S.DTAEMISSAO, 'DD/MM/YYYY') DTA_EMISSAO,
       TO_CHAR(S.DTARECEBTO, 'DD/MM/YYYY') DTA_RECEB_NO_PED,
       TO_CHAR(MIN((SELECT X.DTAHORLANCTO FROM MLF_NOTAFISCAL X WHERE X.SEQAUXNOTAFISCAL = R.SEQAUXNOTAFISCAL)), 'DD/MM/YYYY') DTA_RECEBIMENTO_NF,
       S.VLRTOTPEDIDO,
       CASE WHEN S.VLRTOTPEDIDO - NVL((SELECT SUM(
                                 ROUND(NVL(A.VLRPRODUTO,0),6)    + 
                                 ROUND(NVL(A.VLRIPI,0),6)        +
                                 ROUND(NVL(A.VLRICMSST,0),6)     +
                                 ROUND(NVL(A.VLRFRETE,0),6)      +
                                 ROUND(NVL(A.VLRVENDOR,0),6)     +
                                 ROUND(NVL(A.VLRISS,0),6)        +
                                 ROUND(NVL(A.VLRIRRF,0),6)       -
                                 ROUND(NVL(A.VLRDESCONTO,0),6)   +
                                 ROUND(NVL(A.VLRDESPESA,0),6)    + 
                                 ROUND(NVL(A.VLRDESPNFITEM,0),6) +
                                 ROUND(NVL(A.VLRFCPST,0),6)) FROM MSU_PSITEMRECEBIDO A WHERE A.NROEMPRESA = S.NROEMPRESA AND A.NROPEDIDOSUPRIM = S.NROPEDIDOSUPRIM AND A.CENTRALLOJA = S.CENTRALLOJA),0) 
                      - NVL(S.VLRTOTCANCELADO,0) < 1 THEN 0 ELSE
       S.VLRTOTPEDIDO - NVL((SELECT SUM(
                                 ROUND(NVL(A.VLRPRODUTO,0),6)    + 
                                 ROUND(NVL(A.VLRIPI,0),6)        +
                                 ROUND(NVL(A.VLRICMSST,0),6)     +
                                 ROUND(NVL(A.VLRFRETE,0),6)      +
                                 ROUND(NVL(A.VLRVENDOR,0),6)     +
                                 ROUND(NVL(A.VLRISS,0),6)        +
                                 ROUND(NVL(A.VLRIRRF,0),6)       -
                                 ROUND(NVL(A.VLRDESCONTO,0),6)   +
                                 ROUND(NVL(A.VLRDESPESA,0),6)    +
                                 ROUND(NVL(A.VLRDESPNFITEM,0),6) +
                                 ROUND(NVL(A.VLRFCPST,0),6)) FROM MSU_PSITEMRECEBIDO A WHERE A.NROEMPRESA = S.NROEMPRESA AND A.NROPEDIDOSUPRIM = S.NROPEDIDOSUPRIM AND A.CENTRALLOJA = S.CENTRALLOJA) 
                      - NVL(S.VLRTOTCANCELADO,0),0) END SALDO_ABERTO,
                      
       NVL(S.VLRTOTCANCELADO,0) VLR_CANCELADO
       
   FROM CONSINCO.MSU_PEDIDOSUPRIM S INNER JOIN MSU_PSITEMRECEBER PR ON PR.NROPEDIDOSUPRIM = S.NROPEDIDOSUPRIM AND PR.NROEMPRESA = S.NROEMPRESA AND PR.CENTRALLOJA = S.CENTRALLOJA
                                     LEFT JOIN MSU_PSITEMRECEBIDO R ON R.NROPEDIDOSUPRIM = S.NROPEDIDOSUPRIM AND R.NROEMPRESA = S.NROEMPRESA AND R.CENTRALLOJA = S.CENTRALLOJA AND R.SEQPRODUTO = PR.SEQPRODUTO
                                    INNER JOIN MAX_COMPRADOR C ON C.SEQCOMPRADOR = S.SEQCOMPRADOR
                                    INNER JOIN GE_PESSOA GE    ON GE.SEQPESSOA   = S.SEQFORNECEDOR
                                    INNER JOIN MAF_FORNECDIVISAO MF ON MF.SEQFORNECEDOR = S.SEQFORNECEDOR
                       
 WHERE 1=1
   AND TRUNC(S.DTAHORINCLUSAO) BETWEEN :DT1 AND :DT2
   
   AND S.SEQFORNECEDOR IN (115712,
                           120118,
                           113948,
                           116452,
                           2479390,
                           2540644,
                           115549,
                           1894254,
                           1035467,
                           1967775,
                           128859,
                           118200,
                           120056)
    AND C.COMPRADOR IN (#LS1)
                          
  GROUP BY S.NROEMPRESA, S.NROPEDIDOSUPRIM, C.COMPRADOR, S.SEQFORNECEDOR, GE.NOMERAZAO, S.PZOPAGAMENTO, S.DTAEMISSAO, S.VLRTOTPEDIDO, S.VLRTOTCANCELADO, S.CENTRALLOJA, MF.TIPODTABASEVENCTO, S.DTARECEBTO
  ORDER BY 1,2;
  

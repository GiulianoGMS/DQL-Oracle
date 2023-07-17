ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT P.NROEMPRESA EMPRESA, PI.SEQPRODUTO PLU, M.DESCCOMPLETA DESCRICAO, 
                TO_CHAR(P.DTAINICIO,'DD/MM/YYYY')||' Até '||TO_CHAR(P.DTAFIM, 'DD/MM/YYYY')  PERIODO_PROMO,
                CASE WHEN P.DTAGERACAOPROMOC IS NULL THEN 'Promoção Não Gerada' ELSE 'Ativa' END STATUS_PROMO,
                  TO_CHAR(CASE WHEN PS.PRECOGERPROMOC > 0 THEN PS.PRECOGERPROMOC ELSE PS.PRECOGERNORMAL END, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') PRECO_PROMO
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
FROM MRL_PROMOCAOITEM PI LEFT JOIN MRL_PROMOCAO    P ON PI.NROEMPRESA = P.NROEMPRESA  AND PI.SEQPROMOCAO = P.SEQPROMOCAO AND PI.CENTRALLOJA = P.CENTRALLOJA AND PI.NROSEGMENTO = P.NROSEGMENTO
                         LEFT JOIN MRL_PRODEMPSEG PS ON PS.SEQPRODUTO = PI.SEQPRODUTO AND PS.NROSEGMENTO = PI.NROSEGMENTO AND PS.NROEMPRESA = PI.NROEMPRESA AND PS.QTDEMBALAGEM = PI.QTDEMBALAGEM
                         LEFT JOIN MAP_PRODCODIGO MP ON MP.SEQPRODUTO = PI.SEQPRODUTO AND MP.TIPCODIGO = 'E'
                         INNER JOIN MAP_PRODUTO    M ON M.SEQPRODUTO  = PI.SEQPRODUTO
                         LEFT JOIN MAP_FAMFORNEC   F ON F.SEQFAMILIA  = M.SEQFAMILIA  AND F.PRINCIPAL = 'S'
                         INNER JOIN GE_PESSOA      G ON G.SEQPESSOA   = F.SEQFORNECEDOR 
 
WHERE P.NROEMPRESA  IN (#LS1)                         
  AND NVL( P.TIPOPROMOC, 'N')  IN ('N','F', 'A', 'S') 
  AND P.NROSEGMENTO IN (5,8)
  AND PI.QTDEMBALAGEM = 1
  AND :DT1
   BETWEEN DTAINICIO AND DTAFIM
  
  ORDER BY 1,3 DESC 

  

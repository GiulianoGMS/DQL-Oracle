ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT G.NOMERAZAO Fornecedor, MP.CODACESSO EAN, M.DESCCOMPLETA DESCRICAO, 
       NVL(PI.QTDTOTALVDA/PI.QTDEMBALAGEM,0) QTD_VENDA, PS.PRECOVALIDPROMOC/PI.QTDEMBALAGEM PRECO_PROMO, 
       (PS.PRECOVALIDNORMAL/PI.QTDEMBALAGEM)-(PI.PRECOPROMOCIONAL/PI.QTDEMBALAGEM) Sell_Out, P.DTAINICIO INICIO, P.DTAFIM FIM
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
FROM MRL_PROMOCAOITEM PI LEFT JOIN MRL_PROMOCAO    P ON PI.NROEMPRESA = P.NROEMPRESA  AND PI.SEQPROMOCAO = P.SEQPROMOCAO AND PI.CENTRALLOJA = P.CENTRALLOJA AND PI.NROSEGMENTO = P.NROSEGMENTO
                         LEFT JOIN MRL_PRODEMPSEG PS ON PS.SEQPRODUTO = PI.SEQPRODUTO AND PS.NROSEGMENTO = PI.NROSEGMENTO AND PS.NROEMPRESA = PI.NROEMPRESA AND PS.QTDEMBALAGEM = PI.QTDEMBALAGEM
                         LEFT JOIN MAP_PRODCODIGO MP ON MP.SEQPRODUTO = PI.SEQPRODUTO AND MP.TIPCODIGO = 'E'
                         INNER JOIN MAP_PRODUTO    M ON M.SEQPRODUTO  = PI.SEQPRODUTO
                         LEFT JOIN MAP_FAMFORNEC   F ON F.SEQFAMILIA  = M.SEQFAMILIA  AND F.PRINCIPAL = 'S'
                         INNER JOIN GE_PESSOA      G ON G.SEQPESSOA   = F.SEQFORNECEDOR 
 
WHERE P.NROEMPRESA    = '1'                         
  AND NVL( P.TIPOPROMOC, 'N')  IN ('N','F', 'A', 'S') 
  AND P.NROSEGMENTO IN (2,4)
  AND DTAFIM > SYSDATE  
  AND P.DTAGERACAOPROMOC IS NOT NULL -- Promoções Geradas
  
  ORDER BY 1,3 DESC 
  

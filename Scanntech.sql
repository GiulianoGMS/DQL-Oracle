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
 
WHERE P.NROEMPRESA    = '8'                         
  AND NVL( P.TIPOPROMOC, 'N')  IN ('N','F', 'A', 'S') 
  AND P.SEQPROMOCAO = 144806
  AND P.NROSEGMENTO IN (2,5)
  AND DTAFIM > SYSDATE
  AND P.DTAGERACAOPROMOC IS NOT NULL -- Promoções Geradas
  
  ORDER BY 1,3 DESC

-- Por encarte

SELECT  DISTINCT G.NOMERAZAO Fornecedor, MP.CODACESSO EAN, M.DESCCOMPLETA DESCRICAO,
        PS.PRECOVALIDNORMAL/PR.QTDEMBALAGEM PRECO_NORMAL, 
        PR.PRECOPROMOC/PR.QTDEMBALAGEM PRECO_PROMO, 
        ' - 'Sell_Out, E.DTAINICIO INICIO, E.DTAFIM FIM
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
FROM MRL_ENCARTE E INNER JOIN MRL_ENCARTEPRODUTO  EP     ON EP.SEQENCARTE = E.SEQENCARTE
                   INNER JOIN MRL_ENCARTEEMP      EM     ON EM.SEQENCARTE = E.SEQENCARTE
                   INNER JOIN MRL_ENCARTEPRODUTOPRECO PR ON PR.SEQENCARTE = E.SEQENCARTE  AND PR.SEQPRODUTO = EP.SEQPRODUTO
                   INNER JOIN MRL_PRODEMPSEG      PS     ON PS.SEQPRODUTO = EP.SEQPRODUTO AND PS.NROEMPRESA = EM.NROEMPRESA AND PS.QTDEMBALAGEM = PR.QTDEMBALAGEM AND PS.NROSEGMENTO = PR.NROAGRUPAMENTO AND PS.STATUSVENDA = 'A'
                   LEFT JOIN  MAP_PRODCODIGO MP ON MP.SEQPRODUTO = EP.SEQPRODUTO AND MP.TIPCODIGO = 'E'
                   INNER JOIN MAP_PRODUTO     M ON M.SEQPRODUTO  = EP.SEQPRODUTO
                   LEFT JOIN  MAP_FAMFORNEC   F ON F.SEQFAMILIA  = M.SEQFAMILIA  AND F.PRINCIPAL = 'S'
                   INNER JOIN GE_PESSOA       G ON G.SEQPESSOA   = F.SEQFORNECEDOR 
 
WHERE E.SEQENCARTE = 18257 
  --AND PR.NROAGRUPAMENTO = 2 -- 2 SP 3 RJ 4 MIXTER 7 HIBRIDO
  AND PS.PRECOVALIDNORMAL IS NOT NULL  
  AND PR.PRECOPROMOC > 0
  ORDER BY 3,2 ASC  

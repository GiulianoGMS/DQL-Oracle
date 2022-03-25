/* Faltam Medidas a definir */

ALTER SESSION SET current_schema = CONSINCO;

SELECT A.SEQPRODUTO PLU, B.CODACESSO EAN, A.DESCCOMPLETA, F.MARCA, D.NOMERAZAO FORNECEDOR,
       G.STATUS STATUS_VENDA,
       A.DTAHORINCLUSAO, /* CONSINCO.MAP_FAMEMBALAGEM 'MEDIDAS'*/
       CASE WHEN A.INDINTEGRAECOMMERCE  IS NULL THEN 'N' ELSE A.INDINTEGRAECOMMERCE  END INTEGRA_ECOMM, 
       CASE WHEN A.PERSIMILIARECOMMERCE IS NULL THEN 'N' ELSE A.PERSIMILIARECOMMERCE END PERM_SIMILAR_ECOMM

FROM CONSINCO.MAP_PRODUTO A
       LEFT JOIN (SELECT SEQPRODUTO, CODACESSO FROM MAP_PRODCODIGO WHERE TIPCODIGO = 'E') B ON A.SEQPRODUTO = B.SEQPRODUTO
       LEFT JOIN (MAP_FAMFORNEC C LEFT JOIN GE_PESSOA D ON C.SEQFORNECEDOR = D.SEQPESSOA)   ON A.SEQFAMILIA = C.SEQFAMILIA
       LEFT JOIN ((MAP_FAMILIA  E LEFT JOIN MAP_MARCA F ON E.SEQMARCA = F.SEQMARCA))        ON A.SEQFAMILIA = E.SEQFAMILIA
       LEFT JOIN (SELECT DISTINCT(SEQPRODUTO), 
       CASE WHEN SEQPRODUTO IN (SELECT DISTINCT(SEQPRODUTO) FROM MRL_PRODUTOEMPRESA WHERE STATUSCOMPRA = 'A') 
       THEN 'ATIVO' ELSE 'INATIVO' END STATUS
       FROM MRL_PRODUTOEMPRESA) G                                                           ON A.SEQPRODUTO = G.SEQPRODUTO 
       
WHERE C.PRINCIPAL = 'S'
ORDER BY 3;
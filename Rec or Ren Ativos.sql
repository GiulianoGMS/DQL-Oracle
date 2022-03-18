ALTER SESSION SET current_schema = CONSINCO;

SELECT DISTINCT a.SEQRECEITARENDTO COD_RECEITA, d.CODACESSO COD_BALANCA, a.SEQPRODUTO COD_PLU, b.DESCCOMPLETA Descricao,
       a.QTDUNIDPRODUZIDA Qtd_Produzida_Final                                                                                                                                                                                                                                                                                                          
FROM   MRL_RRPRODUTOFINAL a, MAP_PRODUTO b, MRL_RECEITARENDTO c, MAP_PRODCODIGO d
WHERE  b.SEQPRODUTO = a.SEQPRODUTO
  AND  a.SEQPRODUTO = d.SEQPRODUTO
  AND  b.SEQPRODUTO = d.SEQPRODUTO
  AND  b.DESCCOMPLETA LIKE /* '%PAD/%' OR b.DESCCOMPLETA LIKE */ '%PAD/%'
  AND  a.STATUS = 'A'
  AND  c.STATUSRECRENDTO = 'A'
  AND  a.SEQRECEITARENDTO = c.SEQRECEITARENDTO;

 /*
SELECT seqreceitarendto, seqproduto, desccompleta 
FROM map_produto LEFT JOIN mrl_rrprodutofinal USING (SEQPRODUTO) 
WHERE map_produto.desccompleta LIKE '%PAD/%'
AND seqproduto NOT IN (SELECT SEQPRODUTO FROM consinco.mrl_rrcomponente)
AND seqreceitarendto is NULL;
*/

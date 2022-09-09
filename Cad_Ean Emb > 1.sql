ALTER SESSION SET current_schema = CONSINCO;

select a.seqproduto, b.desccompleta, a.codacesso, a.qtdembalagem, TO_CHAR(B.DTAHORINCLUSAO, 'DD/MM/YYYY') DTA_INCLUSAO, B.USUARIOINCLUSAO
 from map_prodcodigo a, map_produto b
where a.tipcodigo = 'E'
and   a.seqproduto = b.seqproduto
and a.qtdembalagem > 1
and B.DTAHORINCLUSAO BETWEEN :DT1 AND :DT2
order by 4,1;

--

SELECT DISTINCT a.seqproduto, b.desccompleta, TO_CHAR(B.DTAHORINCLUSAO, 'DD/MM/YYYY') DTA_INCLUSAO, B.USUARIOINCLUSAO
FROM consinco.map_prodcodigo a, consinco.map_produto b, CONSINCO.MAP_FAMDIVISAO C
where a.seqproduto = b.seqproduto 
AND C.SEQFAMILIA = B.SEQFAMILIA
and a.indutilvenda = 'N'
AND A.TIPCODIGO IN ('E','B') 
AND C.FINALIDADEFAMILIA = 'R' 
AND B.DTAHORINCLUSAO BETWEEN :DT1 AND :DT2;

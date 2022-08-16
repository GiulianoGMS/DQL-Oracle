ALTER SESSION SET current_schema = CONSINCO;

select  a.seqproduto, b.desccompleta, decode(a.tipcodigo, 'B', 'INTERNO', 'E', 'EAN') TIPO_CODIGO, a.codacesso CODIGO, B.DTAHORINCLUSAO DTA_INCLUSAO, B.USUARIOINCLUSAO USUARIO_INCLUSAO
  from map_prodcodigo a, map_produto b
 Where a.indutilvenda = 'N'
 and a.seqproduto = b.seqproduto
and b.desccompleta not like '%EXCLUIR%'
and b.desccompleta not like '%FRETE%'
and b.desccompleta not like '%DESP%'
   and a.tipcodigo in ('E', 'B')
   AND B.DTAHORINCLUSAO BETWEEN :DT1 AND :DT2
   order by b.desccompleta;

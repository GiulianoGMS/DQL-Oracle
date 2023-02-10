select distinct (a.seqproduto),
         a.desccompleta,
         e.seqpessoa || '/' || e.nomerazao as Fornecedor,
         d.comprador as Comprador,
         decode (c.finalidadefamilia,
'P', 'Matéria-Prima', 
'B', 'Brinde',
'U', 'Material de Uso e Consumo',
'A', 'Ativo Imobilizado',
'S', 'Serviços',
'G', 'Seguro',
'F', 'Frete',
'D', 'Despesas',
'V', 'Aproveitamento',
'L', 'Vale/Recibo',
'E', 'Embalagem',
'C', 'Produto em Processo',
'Q', 'Produto Acabado',
'T', 'Subproduto',
'I', 'Produto Intermediário',
'O', 'Outros insumos',
'J', 'Adjudicação Cred ICMS',
'N', 'Rest Cred Trib',
'M', 'Complemento Antecipado',
'X', 'Garantia Estendida', 
'Z', 'Vale Gás',
'R', 'Mercadoria para Revenda',
'H', 'Complemento de Imposto') as Finalidade_familia,
to_char(a.dtahorinclusao, 'DD/MM/YYYY hh24:mi:ss') as dtainclusao, x.codcest CEST, W.NROTRIBUTACAO||' - '||W.TRIBUTACAO TRIBUTACAO,
(select p.lista ||'-'|| p.descricao from consinco.max_atributofixo p where x.situacaonfpis = p.lista and p.tipatributofixo = 'SIT_TRIBUT_PIS') PIS_ENTRADA,
       (select p.lista ||'-'|| p.descricao from consinco.max_atributofixo p where x.situacaonfcofins = p.lista and p.tipatributofixo = 'SIT_TRIBUT_COFINS') COFINS_ENTRADA
    from map_produto       a LEFT JOIN MAP_FAMILIA X ON A.SEQFAMILIA = X.SEQFAMILIA LEFT JOIN MAP_FAMDIVISAO Y ON A.SEQFAMILIA = Y.SEQFAMILIA LEFT JOIN MAP_TRIBUTACAO W ON W.NROTRIBUTACAO = Y.NROTRIBUTACAO,
         map_famfornec     b,
         map_famdivisao    c,
         max_comprador     d,
         ge_pessoa         e
   where a.seqfamilia = b.seqfamilia
     and b.seqfamilia = c.seqfamilia
     and a.seqfamilia = c.seqfamilia
     and c.seqcomprador  = d.seqcomprador
     and b.seqfornecedor = e.seqpessoa
     and b.principal     = 'S'
         and TRUNC (a.dtahorinclusao) BETWEEN  :DT1 AND :DT2
order by 4

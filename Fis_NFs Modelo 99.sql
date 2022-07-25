select distinct a.nroempresa, 
       a.nronota, 
       to_char(a.dtaemissao,'DD/MM/YYYY') data_emissao,
       to_char(a.dtaentrada,'DD/MM/YYYY')  data_entrada,
       a.seqpessoa,
       c.nomerazao fornecedor, 
       a.codhistorico natureza_desp, 
       f.descricao desc_natureza,
       x.codproduto plu,
       y.descricao desc_produto, 
       FA.SITUACAONFPIS PS.DESCRICAO PIS, 
       FA.SITUACAONFCOFINS COFINS,
       a.valor, A.OBSERVACAO OBSERVACAO_FISCAL

from consinco.or_nfdespesa a left join consinco.or_nfitensdespesa b on (a.seqnota=b.seqnota )
                             left join consinco.ge_pessoa c on (a.seqpessoa=c.seqpessoa)
                             left join consinco.aba_historico f on (f.seqhistorico=a.codhistorico)
                             left join consinco.rf_paramnatnfdesp x on x.codhistorico = a.codhistorico
                             left join consinco.orv_produto y            on x.codproduto =  y.codproduto
                             LEFT JOIN CONSINCO.MAP_PRODUTO M ON Y.SEQPRODUTO = M.SEQPRODUTO
                             LEFT JOIN CONSINCO.MAP_FAMILIA FA ON M.SEQFAMILIA = FA.SEQFAMILIA
                           /*  LEFT JOIN CONSINCO.MAX_SITUACAONFPIS PS ON PS.SITUACAONFPIS = FA.SITUACAONFPIS
                             LEFT JOIN CONSINCO.MAX_SITUACAONFCOFINS CS ON CS.SITUACAONFCOFINS = FA.SITUACAONFCOFINS*/
where a.Cgo = 6
AND A.CODMODELO = 99
and a.dtaentrada between :DT1 and :DT2
and a.nroempresa in (#LS1)
order by 1,4,5

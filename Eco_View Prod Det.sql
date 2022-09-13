CREATE OR REPLACE VIEW CONSINCO.NAGV_PRODDET_ECOMMERCE AS

select concat(TO_CHAR(LPAD(j.nrocgc,12,'0')),TO_CHAR(LPAD(j.digcgc,2,'0'))) as CNPJ,
       NVL(CONSINCO.fBuscaEANECOMMERCEMIN(X.SEQPRODUTO),LPAD(X.SEQPRODUTO,6,'0')) AS codigo_barra,
       y.SEQPRODUTO AS plu,
       nvl((select M.Marca from consinco.map_marca m where m.seqmarca = Y.seqmarca),'--')  AS Marca,
       INITCAP(Y.nomeproduto) AS Nome,
       ROUND(round(nvl(X.precovalidnormal, X.precogernormal) / X.qtdembalagem * X.qtdembalagem, 2),2) vlr_produto,
       E.QTDESTOQUE AS qtd_estoque_atual,
       case
         when g.pesavel = 'S' then 'KG' else 'UN' end as unit,
       ROUND(round(nvl(X.precovalidpromoc, X.precogerpromoc) / X.qtdembalagem * X.qtdembalagem, 2),2) vlr_promocao,
       NVL(CASE WHEN z.categoriaN1 IS NULL THEN z.categoriaN2 ELSE z.categoriaN1 END,'--') AS Departamento,
       NVL(z.categoriaN2,'--') AS Categoria,
       NVL(z.categoriaN3,'--') AS Subcategoria from
consinco.mrl_prodempseg x inner join consinco.MADV_PRODUTO_ECM y on (x.seqproduto = y.seqproduto and x.qtdembalagem = 1 and x.nrosegmento = 5)
                                                              left join consinco.Ge_Empresa j on x.nroempresa = j.nroempresa
                                                              left join consinco.etlv_categoria z on (z.seqfamilia = Y.seqfamilia and z.nrodivisao = 1)
                                                              left join CONSINCO.MADV_ESTOQUE_ECM E on (e.nroempresa = x.nroempresa and e.seqproduto = y.seqproduto)
                                                              left join consinco.map_familia g on (g.seqfamilia = y.seqfamilia)
                                                             left join RemarcaPromocoes@infoproc w on (w.codloja = x.nroempresa
                                                             and lpad(NVL(CONSINCO.fBuscaEANECOMMERCEMIN(X.SEQPRODUTO),LPAD(X.SEQPRODUTO,6,'0')),14,0) =  w.codigoproduto
                                                             and w.dtfim >= trunc(sysdate) )
where 1=1
and x.nroempresa in (1,2,3,7,12,25,46,51,9,11,23,36)

SELECT * FROM CONSINCO.NAGV_PRODDET_ECOMMERCE

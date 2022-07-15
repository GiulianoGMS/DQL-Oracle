ALTER SESSION SET current_schema = CONSINCO;

select distinct (d.seqproduto),
                d.desccompleta,
                decode(e.tipcodigo, 'E', 'EAN', 'D', 'DUN', 'F', 'FOR') TIPOCOD,
                f.embalagem || ' ' || f.qtdembalagem as Embalagem,
                e.codacesso,
                c.nomerazao FORNECEDOR,
                g.comprador,
                a.principal,
                decode(w.statuscompra, 'I', 'INATIVO', 'A', 'ATIVO') STATUS_COMPRA,
                y.descricao DESC_SEGMENTO,
                NVL(((SELECT SUM(AA.ESTOQUE) FROM MRL_PRODLOCAL AA, MRL_LOCAL BB, MRL_PRODUTOEMPRESA CC
                     WHERE AA.SEQLOCAL = BB.SEQLOCAL
                     AND AA.SEQPRODUTO = D.SEQPRODUTO
                     AND BB.TIPLOCAL = 'L' AND aA.nroempresa = bB.nroempresa and cC.seqproduto = Aa.seqproduto and cC.nroempresa = Aa.nroempresa) / F.QTDEMBALAGEM),0) ESTOQUE_LOJA,
                NVL(((SELECT SUM(AA.ESTOQUE) FROM MRL_PRODLOCAL AA, MRL_LOCAL BB, MRL_PRODUTOEMPRESA CC
                     WHERE AA.SEQLOCAL = BB.SEQLOCAL
                     AND AA.SEQPRODUTO = D.SEQPRODUTO
                     AND BB.TIPLOCAL = 'T' AND aA.nroempresa = bB.nroempresa and cC.seqproduto = Aa.seqproduto and cC.nroempresa = Aa.nroempresa) / F.QTDEMBALAGEM),0)ESTOQUE_AVARIA,    
                NVL(((SELECT SUM(AA.ESTOQUE) FROM MRL_PRODLOCAL AA, MRL_LOCAL BB, MRL_PRODUTOEMPRESA CC
                     WHERE AA.SEQLOCAL = BB.SEQLOCAL
                     AND AA.SEQPRODUTO = D.SEQPRODUTO
                     AND BB.TIPLOCAL = 'O' AND aA.nroempresa = bB.nroempresa and cC.seqproduto = Aa.seqproduto and cC.nroempresa = Aa.nroempresa) / F.QTDEMBALAGEM),0) ESTOQUE_OUTROS,    
                NVL(((SELECT SUM(AA.ESTOQUE) FROM MRL_PRODLOCAL AA, MRL_LOCAL BB, MRL_PRODUTOEMPRESA CC
                     WHERE AA.SEQLOCAL = BB.SEQLOCAL
                     AND AA.SEQPRODUTO = D.SEQPRODUTO
                     AND BB.TIPLOCAL = 'D' AND aA.nroempresa = bB.nroempresa and cC.seqproduto = Aa.seqproduto and cC.nroempresa = Aa.nroempresa) / F.QTDEMBALAGEM),0)ESTOQUE_CD
                
  from consinco.map_famfornec      a,
       consinco.map_familia        b,
       consinco.ge_pessoa          c,
       consinco.map_produto        d,
       consinco.map_prodcodigo     e,
       consinco.map_famembalagem   f,
       consinco.map_famdivisao     h,
       consinco.max_comprador      g,
       consinco.mrl_produtoempresa W,
       consinco.maf_segtofornec    y

  where a.seqfamilia = b.seqfamilia 
   and a.seqfamilia = h.seqfamilia
   and a.nrosegfornec = y.nrosegfornec (+)
   and b.seqfamilia = h.seqfamilia 
   and a.seqfornecedor = c.seqpessoa
   and a.seqfamilia = d.seqfamilia
   and d.seqproduto = e.seqproduto 
   and a.seqfamilia = f.seqfamilia
   and e.qtdembalagem = f.qtdembalagem
   and h.seqcomprador = g.seqcomprador 
   and e.tipcodigo in ('E', 'D', 'F')
   and w.seqproduto = d.seqproduto
   and w.seqproduto = e.seqproduto
   and w.nroempresa = 501   
   and NVL(y.descricao,'OUTROS') in (#LS2)  
   and a.seqfornecedor = :NR1
   and g.comprador in (#LS1)
 order by d.seqproduto, d.desccompleta, 4 DESC;

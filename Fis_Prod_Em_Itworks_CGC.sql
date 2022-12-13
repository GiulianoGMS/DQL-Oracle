ALTER SESSION SET current_schema = CONSINCO;

-- CGC não pode estar com 4 digitos

UPDATE MAP_PRODCODIGO A SET A.CGCFORNEC = 464726 WHERE A.SEQFAMILIA IN (93800,93801,93802) AND A.CGCFORNEC = 4647;
COMMIT;

select lpad(c.nrocgccpf, 12, 0) || lpad(c.digcgccpf, 2, 0) CNPJCPF, C.NOMERAZAO, (rpad(a.cgcfornec,6, 0)),rpad(c.nrocgccpf, 6),
       a.codacesso PRODUTOEMITENTE,
       a.seqproduto PRODUTO,
 (select y.embalagem from map_famdivisao x, map_famembalagem y where x.seqfamilia = y.seqfamilia and x.seqfamilia = b.seqfamilia and x.padraoembcompra = y.qtdembalagem) UnidadeCompra,
 a.qtdembalagem FATORCONVESTOQUE,
-- (select x.padraoembcompra from map_famdivisao x where x.seqfamilia = b.seqfamilia and x.nrodivisao = 1) ,
 (select decode(k.finalidadefamilia,'R','1','E','2','U','3','A','4','H','5','D','7','O','7','1') from map_famdivisao k where k.seqfamilia = b.seqfamilia and k.nrodivisao = 1)USONFENTRADA,
    pro.dtahorinclusao,
    pro.dtahoralteracao

  --  (select pro.dtahorinclusao from map_produto pro where pro.seqfamilia = b.seqfamilia and pro.seqproduto = a.seqproduto) dtahorinclusao,
  --      (select pro.dtahoralteracao from map_produto pro where pro.seqfamilia = b.seqfamilia and pro.seqproduto = a.seqproduto) dtahoralteracao

  from         map_prodcodigo a inner join map_familia b  on (a.seqfamilia = b.seqfamilia)
                       inner join ge_pessoa c    on (rpad(a.cgcfornec,6, 0) = Rpad(c.nrocgccpf, 6,0) and c.status = 'A')
                       inner join consinco.map_produto  pro on ( pro.seqproduto = a.seqproduto )
 where a.tipcodigo in ('F')
 AND A.SEQPRODUTO = 251855
 -- and c.seqpessoa in (Select MAP_FAMFORNEC.SEQFORNECEDOR From MAP_FAMFORNEC Where SEQFAMILIA = b.seqfamilia)
order by 2
;

-- Atualiza dtahora alteracao para integrar na ItWorks

UPDATE CONSINCO.MAP_PRODUTO PRO SET PRO.DTAHORALTERACAO = SYSDATE WHERE PRO.SEQFAMILIA IN (93800,93801,93802);
COMMIT;

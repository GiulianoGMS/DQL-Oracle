ALTER SESSION SET current_schema = CONSINCO;

CREATE OR REPLACE VIEW consinco.nagv_emitenteitworks AS

SELECT DISTINCT X.* FROM (

select lpad(c.nrocgccpf, 12, 0) || lpad(c.digcgccpf, 2, 0) CNPJCPF,
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
                       inner join ge_pessoa c    on (rpad(a.cgcfornec,6, 0) = rpad(c.nrocgccpf, 6) and c.status = 'A')
                       inner join consinco.map_produto  pro on ( pro.seqproduto = a.seqproduto )
 where a.tipcodigo in ('F')
 -- and c.seqpessoa in (Select MAP_FAMFORNEC.SEQFORNECEDOR From MAP_FAMFORNEC Where SEQFAMILIA = b.seqfamilia)
 
UNION ALL -- Alteração para atender fornecedores que possuem apenas CNPJ e 0 a esquerda

SELECT lpad(c.nrocgccpf, 12, 0) || lpad(c.digcgccpf, 2, 0) CNPJCPF,
       a.codacesso PRODUTOEMITENTE,
       a.seqproduto PRODUTO,
 (select y.embalagem from map_famdivisao x, map_famembalagem y where x.seqfamilia = y.seqfamilia and x.seqfamilia = b.seqfamilia and x.padraoembcompra = y.qtdembalagem) UnidadeCompra,
 a.qtdembalagem FATORCONVESTOQUE,
 (select decode(k.finalidadefamilia,'R','1','E','2','U','3','A','4','H','5','D','7','O','7','1') from map_famdivisao k where k.seqfamilia = b.seqfamilia and k.nrodivisao = 1)USONFENTRADA,
    pro.dtahorinclusao,
    pro.dtahoralteracao

FROM map_prodcodigo a INNER JOIN map_familia b  on (a.seqfamilia = b.seqfamilia)
                      INNER JOIN ge_pessoa c    on (Lpad(a.cgcfornec,5, 0) = LPAD(Lpad(C.NROCGCCPF,9, 0),5,0) and c.status = 'A') AND LENGTH(A.CGCFORNEC) = 4
                      INNER JOIN consinco.map_produto  pro on ( pro.seqproduto = a.seqproduto )
WHERE a.tipcodigo in ('F')
  AND C.SEQPESSOA IN (SELECT F.SEQFORNECEDOR FROM CONSINCO.MAP_FAMFORNEC F WHERE F.SEQFAMILIA = A.SEQFAMILIA)

) X
  
order by 2

;

-- Atualiza dtahora alteracao para integrar na ItWorks

UPDATE CONSINCO.MAP_PRODUTO PRO SET PRO.DTAHORALTERACAO = SYSDATE WHERE PRO.SEQFAMILIA IN (93800,93801,93802);
COMMIT;

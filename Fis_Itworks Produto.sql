create or replace view nagv_produtoitworks as
select a.seqproduto as Produto, --PRODUTO    ---- Alterado por Cipolla para adequar ao layout da IT Works - 20/10/2017 - Diversos Campos
       case when to_char(b.seqproduto) = to_char(b.codacesso) then null else b.codacesso end CB,
       --case when b.tipcodigo = 'E' then b.codacesso else null end  CB, --C¿DIGO DE BARRAS - Solicita¿¿o Incluir Codigo interno Silene 22/11 chamado 14877
       a.descreduzida as APELIDO, --APELIDO
       a.desccompleta as DESCRICAO, --DESCRICAO
       a.descreduzida as DESCRICAOFISCAL, ---- DESCRICAOFISCAL
  --     0 QtdeUnitICMSValorPauta, Retirado conforme chamado 24336 - Solicita¿¿o Silene.
      (select y.embalagem from map_famembalagem y
         where y.seqfamilia = a.seqfamilia
           and y.seqfamilia = b.seqfamilia
           and y.seqfamilia = c.seqfamilia
           and y.qtdembalagem = b.qtdembalagem) UnidadeEstoque, --UnidadeEstoque
       (select y.embalagem from map_famembalagem y
         where y.seqfamilia = a.seqfamilia
           and y.seqfamilia = b.seqfamilia
           and y.seqfamilia = c.seqfamilia
           and y.qtdembalagem = b.qtdembalagem) UnidadeComercial, --UnidadeComercial
       decode(c.finalidadefamilia,'R','00','P','01','A','08','U','07','P','01','D','99','S','09','F','09','H','99','E','02','B','99','O','07','M','99') TipoItem, --TipoItem
       decode(c.finalidadefamilia,'O','N','E','S','U','S') Essencial_pisconfins, --TipoItem

       ----- Dois primeiros digitos do NCM
       (select lpad(z.codnbmsh, 2) from map_familia z
        where a.seqfamilia = z.seqfamilia
          and b.seqfamilia = z.seqfamilia
          and c.seqfamilia = z.seqfamilia) GENEROITEM,--GeneroItem
       0 CodigoServico, ---- CodigoServico
       c.codorigemtrib ORIGEMMERCADORIA, --OrigemMercadoria
       0 ContaContabil, ---- ContaContabil
       ---- Quatro Primeiros Digitos do NCM
       (select lpad(z.codnbmsh, 4) from map_familia z
        where a.seqfamilia = z.seqfamilia
          and b.seqfamilia = z.seqfamilia
          and c.seqfamilia = z.seqfamilia) CAPITULO, --capitulo
       ---- Quatro ultimos digitos do NCM
       (select SubStr(x.codnbmsh,(length(x.codnbmsh)-3),4) from map_familia x
        where a.seqfamilia = x.seqfamilia
          and b.seqfamilia = x.seqfamilia
          and c.seqfamilia = x.seqfamilia) ITEM,
       0 INDICADORPROPRIEDADE, --IndicadorPropriedade
       null CnpjCpfPropriedade, --CnpjCpfPropriedade,
       'N' FLAGCOMBUSTIVEL, --FlagCombustivel
       null cProdANP, --cProdANP
       '01' ArmazemSped, --ArmazemSped
       'N' IgnorarDivergICMS, --IgnorarDivergICMS
        null Departamento, ---- Departamento
        null Setor,           ----- Setor
        null Grupo,     ----- Grupo
        null SubGrupo, ---- Subgrupo
             (select y.qtdembalagem from map_famembalagem y
         where y.seqfamilia = a.seqfamilia
           and y.seqfamilia = b.seqfamilia
           and y.seqfamilia = c.seqfamilia
           and y.qtdembalagem = b.qtdembalagem)  FATORCONVCOMERCIAL,
         a.seqfamilia, --Familia
           (select decode(x.statuscompra,'A','ATIVO','I','INATIVO')  from mrl_produtoempresa x where x.nroempresa = 8 and x.seqproduto = a.seqproduto) COMPRA,
        (select decode(nvl(f.statusvenda,'A'),'A','ATIVO','I','INATIVO') from mrl_prodempseg f where f.nroempresa = 8 and f.seqproduto = a.seqproduto and f.nrosegmento = 2 and f.qtdembalagem = b.qtdembalagem) VENDA,
         a.seqprodutobase PRODUTO_PAI,
         a.dtahorinclusao dtahorinclusao,
         a.dtahoralteracao dtahoralteracao
  from consinco.map_produto a inner join consinco.map_prodcodigo b on (a.seqproduto = b.seqproduto and a.seqfamilia = b.seqfamilia)
                     inner join consinco.map_famdivisao c on (a.seqfamilia = c.seqfamilia)
   and b.tipcodigo in ('E','B','D')
  order by a.seqproduto, b.tipcodigo
;

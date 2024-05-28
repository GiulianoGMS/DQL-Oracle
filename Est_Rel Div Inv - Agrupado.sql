Select /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
 MRLV_INVRELDIVERG_nag.seqinvlote LOTE,
 MRLV_INVRELDIVERG_nag.NROEMPRESA LOJA,
 TO_CHAR(CONSINCO.MRLV_INVRELDIVERG_nag.dtahorcongestoque, 'DD/MM/YYYY') DTA_CONGELAMENTO,
 MRLV_INVRELDIVERG_nag.SEQPRODUTO PLU,
 MRLV_INVRELDIVERG_nag.DESCCOMPLETA PRODUTO,
 MRLV_INVRELDIVERG_nag.embvenda EMBALAGEM,
 MRLV_INVRELDIVERG_nag.QTDCONGELADA * MRLV_INVRELDIVERG_nag.QTDEMBALAGEM /
 NVL(MRLV_INVRELDIVERG_nag.PADRAOEMBVENDA, 1) QTDE_CONGELADA,
 (case
   when NVL(((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                              sum(cc.qtdcontagem2 * cc.qtdembalagem),
                              sum(cc.qtdcontagem1 * cc.qtdembalagem),
                              0)
                from CONSINCO.mrl_invcontagem cc
               where cc.seqinvlote = MRLV_INVRELDIVERG_nag.seqinvlote
                 and cc.nroempresa = MRLV_INVRELDIVERG_nag.nroempresa
                 and cc.seqproduto = MRLV_INVRELDIVERG_nag.seqproduto
                 and 0 = 0
                 and nvl(cc.nroloteprod, 0) =
                     nvl(MRLV_INVRELDIVERG_nag.nroloteprod, 0)
                 and (cc.codinvarea in
                     (select number1 from CONSINCO.gex_dadostemporarios) or
                     not exists((select number1
                                   from CONSINCO.gex_dadostemporarios)))) /
            MRLV_INVRELDIVERG_nag.QTDEMBALAGEM),
            0) > 0 then
    NVL(((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                          sum(cc.qtdcontagem2 * cc.qtdembalagem),
                          sum(cc.qtdcontagem1 * cc.qtdembalagem),
                          0)
            from CONSINCO.mrl_invcontagem cc
           where cc.seqinvlote = MRLV_INVRELDIVERG_nag.seqinvlote
             and cc.nroempresa = MRLV_INVRELDIVERG_nag.nroempresa
             and cc.seqproduto = MRLV_INVRELDIVERG_nag.seqproduto
             and 0 = 0
             and nvl(cc.nroloteprod, 0) =
                 nvl(MRLV_INVRELDIVERG_nag.nroloteprod, 0)
             and (cc.codinvarea in
                 (select number1 from CONSINCO.gex_dadostemporarios) or
                 not
                  exists((select number1 from CONSINCO.gex_dadostemporarios)))) /
        MRLV_INVRELDIVERG_nag.QTDEMBALAGEM),
        0)
   else
    0
 end / C.PADRAOEMBVENDA) QTD_CONTAGEM,
 
 ((((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                     sum(cc.qtdcontagem2 * cc.qtdembalagem),
                     sum(cc.qtdcontagem1 * cc.qtdembalagem),
                     0)
       from CONSINCO.mrl_invcontagem cc
      where cc.seqinvlote = MRLV_INVRELDIVERG_nag.seqinvlote
        and cc.nroempresa = MRLV_INVRELDIVERG_nag.nroempresa
        and cc.seqproduto = MRLV_INVRELDIVERG_nag.seqproduto
        and 0 = 0
        and nvl(cc.nroloteprod, 0) =
            nvl(MRLV_INVRELDIVERG_nag.nroloteprod, 0)
        and (cc.codinvarea in
            (select number1 from CONSINCO.gex_dadostemporarios) or
            not exists((select number1 from CONSINCO.gex_dadostemporarios)))) -
 QTDCONGELADAUNIT) / MRLV_INVRELDIVERG_nag.QTDEMBALAGEM)) QTDE_DIVERGENTE,
 case
   when (MRLV_INVRELDIVERG_nag.QTDCONGELADA *
        MRLV_INVRELDIVERG_nag.QTDEMBALAGEM /
        NVL(MRLV_INVRELDIVERG_nag.PADRAOEMBVENDA, 1)) = 0 then
    0
   else
    MRLV_INVRELDIVERG_nag.CUSBRUTCONGELADO
 end as CUSTO_BRUTO,
 case
   when (MRLV_INVRELDIVERG_nag.QTDCONGELADA *
        MRLV_INVRELDIVERG_nag.QTDEMBALAGEM /
        NVL(MRLV_INVRELDIVERG_nag.PADRAOEMBVENDA, 1)) = 0 then
    0
   else
    MRLV_INVRELDIVERG_nag.cusliqcongelado
 end CUSTO_LIQUIDO,
 case
   when (MRLV_INVRELDIVERG_nag.QTDCONGELADA *
        MRLV_INVRELDIVERG_nag.QTDEMBALAGEM /
        NVL(MRLV_INVRELDIVERG_nag.PADRAOEMBVENDA, 1)) = 0 then
    0
   else
    MRLV_INVRELDIVERG_nag.PRECOVDACONGELADO
 end PRECO
  From CONSINCO.MRLV_INVRELDIVERG_nag,
       CONSINCO.MAP_PRODUTO           B,
       CONSINCO.MAD_FAMSEGMENTO       C
 Where 1=1 
 AND  MRLV_INVRELDIVERG_nag.NROEMPRESA IN (#LS1)
   AND MRLV_INVRELDIVERG_nag.SEQPRODUTO = B.SEQPRODUTO
   AND MRLV_INVRELDIVERG_nag.STATUS != 'C'
   And B.SEQFAMILIA = C.SEQFAMILIA
   AND C.NROSEGMENTO = MRLV_INVRELDIVERG_nag.nrosegmento
   AND MRLV_INVRELDIVERG_nag.QTDEMBALAGEM =
       DECODE(MRLV_INVRELDIVERG_nag.EXIBE_MENOR_EMB,
              'S',
              CONSINCO.FMINEMBFAMILIA(b.SEQFAMILIA),
              NVL(CONSINCO.fRetEmbInvent(MRLV_INVRELDIVERG_nag.SEQPRODUTO,
                                         MRLV_INVRELDIVERG_nag.SEQINVLOTE,
                                         MRLV_INVRELDIVERG_nag.NROEMPRESA,
                                         MRLV_INVRELDIVERG_nag.PADRAOEMBVENDA),
                  MRLV_INVRELDIVERG_nag.PADRAOEMBVENDA))
   AND ((NVL((((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                                sum(cc.qtdcontagem2 * cc.qtdembalagem),
                                sum(cc.qtdcontagem1 * cc.qtdembalagem),
                                0)
                  from CONSINCO.mrl_invcontagem cc
                 where cc.seqinvlote = MRLV_INVRELDIVERG_nag.seqinvlote
                   and cc.nroempresa = MRLV_INVRELDIVERG_nag.nroempresa
                   and cc.seqproduto = MRLV_INVRELDIVERG_nag.seqproduto
                   and 0 = 0
                   and nvl(cc.nroloteprod, 0) =
                       nvl(MRLV_INVRELDIVERG_nag.nroloteprod, 0)
                   and (cc.codinvarea in
                       (select number1 from CONSINCO.gex_dadostemporarios) or
                       not exists((select number1
                                     from CONSINCO.gex_dadostemporarios)))) -
             QTDCONGELADAUNIT) / MRLV_INVRELDIVERG_nag.QTDEMBALAGEM),
             0) != 0) OR (MRLV_INVRELDIVERG_nag.QTDSEMCONTAGEM <= 0) OR
       (exists (select *
                   from CONSINCO.MRL_InvProduto b
                  where MRLV_INVRELDIVERG_nag.seqinvlote = b.seqinvlote
                    and MRLV_INVRELDIVERG_nag.seqproduto = b.seqproduto
                    and MRLV_INVRELDIVERG_nag.nroempresa = b.nroempresa
                    and b.qtdcongelada <> 0
                    and not exists (select *
                           from CONSINCO.MRL_InvContagem c
                          where b.nroempresa = c.nroempresa
                            and b.seqinvlote = c.seqinvlote
                            and b.seqproduto = c.seqproduto
                            and c.qtdcontagem1 = 0))) OR
       (MRLV_INVRELDIVERG_nag.QTDSEMCONTAGEM > 0 AND
       ((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                           sum(cc.qtdcontagem2 * cc.qtdembalagem),
                           sum(cc.qtdcontagem1 * cc.qtdembalagem),
                           0)
             from CONSINCO.mrl_invcontagem cc
            where cc.seqinvlote = MRLV_INVRELDIVERG_nag.seqinvlote
              and cc.nroempresa = MRLV_INVRELDIVERG_nag.nroempresa
              and cc.seqproduto = MRLV_INVRELDIVERG_nag.seqproduto
              and 0 = 0
              and nvl(cc.nroloteprod, 0) =
                  nvl(MRLV_INVRELDIVERG_nag.nroloteprod, 0)
              and (cc.codinvarea in
                  (select number1 from CONSINCO.gex_dadostemporarios) or
                  not
                   exists((select number1 from CONSINCO.gex_dadostemporarios)))) /
       MRLV_INVRELDIVERG_nag.QTDEMBALAGEM) = 0))
   AND UPPER(MRLV_INVRELDIVERG_nag.descinvlote) LIKE
       '%' || UPPER('#LT1') || '%'
      AND MRLV_INVRELDIVERG_nag.dtahorgeracao BETWEEN :DT1 AND :DT2
   AND MRLV_INVRELDIVERG_nag.NIVELHIERARQUIA = 1
   AND MRLV_INVRELDIVERG_nag.INDVALIDACAO != 'M'
 Order By NULL, MRLV_INVRELDIVERG_nag.DESCCOMPLETA

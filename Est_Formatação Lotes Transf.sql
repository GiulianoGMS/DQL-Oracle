ALTER SESSION SET current_schema = CONSINCO;

SELECT CODPOS LOJA_OCORRENCIA  FROM ( 
SELECT '0000000'||LPAD(PC.CODACESSO,13,0)||REPLACE(LPAD(((((SELECT COALESCE(SUM(cc.qtdcontagem3 * cc.qtdembalagem),
                          sum(cc.qtdcontagem2 * cc.qtdembalagem),
                          sum(cc.qtdcontagem1 * cc.qtdembalagem),
                          0)
            from CONSINCO.mrl_invcontagem cc
           where cc.seqinvlote = MRLV_INVRELDIVERG.seqinvlote
             and cc.nroempresa = MRLV_INVRELDIVERG.nroempresa
             and cc.seqproduto = MRLV_INVRELDIVERG.seqproduto
             and 0 = 0
             and nvl(cc.nroloteprod, 0) =
                 nvl(MRLV_INVRELDIVERG.nroloteprod, 0)
             and (cc.codinvarea in
                 (select number1 from CONSINCO.gex_dadostemporarios) or
                 not exists((select number1 from CONSINCO.gex_dadostemporarios)))) -
       QTDCONGELADAUNIT) / MRLV_INVRELDIVERG.QTDEMBALAGEM)),8,0),'-','') CODPOS, B.SEQPRODUTO,
       
       ((((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                          sum(cc.qtdcontagem2 * cc.qtdembalagem),
                          sum(cc.qtdcontagem1 * cc.qtdembalagem),
                          0)
            from CONSINCO.mrl_invcontagem cc
           where cc.seqinvlote = MRLV_INVRELDIVERG.seqinvlote
             and cc.nroempresa = MRLV_INVRELDIVERG.nroempresa
             and cc.seqproduto = MRLV_INVRELDIVERG.seqproduto
             and 0 = 0
             and nvl(cc.nroloteprod, 0) =
                 nvl(MRLV_INVRELDIVERG.nroloteprod, 0)
             and (cc.codinvarea in
                 (select number1 from CONSINCO.gex_dadostemporarios) or
                 not exists((select number1 from CONSINCO.gex_dadostemporarios)))) -
       QTDCONGELADAUNIT) / MRLV_INVRELDIVERG.QTDEMBALAGEM)) DIVERG, B.DESCCOMPLETA
                   
  FROM CONSINCO.MRLV_INVRELDIVERG,
       CONSINCO.MAD_FAMSEGMENTO   C,
       CONSINCO.MAP_PRODUTO       B LEFT JOIN (SELECT PCC.SEQPRODUTO, PCC.CODACESSO, ROW_NUMBER() OVER(PARTITION BY PCC.SEQPRODUTO ORDER BY PCC.SEQPRODUTO) ODR FROM
       CONSINCO.MAP_PRODCODIGO PCC WHERE PCC.QTDEMBALAGEM = 1 AND PCC.TIPCODIGO IN ('E', 'B')) PC ON B.SEQPRODUTO = PC.SEQPRODUTO AND PC.ODR = 1
       
 
 WHERE MRLV_INVRELDIVERG.NROEMPRESA = 1
   AND MRLV_INVRELDIVERG.SEQPRODUTO = B.SEQPRODUTO
   AND MRLV_INVRELDIVERG.STATUS != 'C'

   And B.SEQFAMILIA = C.SEQFAMILIA
   AND C.NROSEGMENTO = MRLV_INVRELDIVERG.nrosegmento
   AND MRLV_INVRELDIVERG.QTDEMBALAGEM =
       DECODE(MRLV_INVRELDIVERG.EXIBE_MENOR_EMB,
              'S',
              CONSINCO.FMINEMBFAMILIA(b.SEQFAMILIA),
              NVL(CONSINCO.fRetEmbInvent(MRLV_INVRELDIVERG.SEQPRODUTO,
                                         MRLV_INVRELDIVERG.SEQINVLOTE,
                                         MRLV_INVRELDIVERG.NROEMPRESA,
                                         MRLV_INVRELDIVERG.PADRAOEMBVENDA),
                  MRLV_INVRELDIVERG.PADRAOEMBVENDA))
   AND ((NVL((((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                                sum(cc.qtdcontagem2 * cc.qtdembalagem),
                                sum(cc.qtdcontagem1 * cc.qtdembalagem),
                                0)
                  from CONSINCO.mrl_invcontagem cc
                 where cc.seqinvlote = MRLV_INVRELDIVERG.seqinvlote
                   and cc.nroempresa = MRLV_INVRELDIVERG.nroempresa
                   and cc.seqproduto = MRLV_INVRELDIVERG.seqproduto
                   and 0 = 0
                   and nvl(cc.nroloteprod, 0) =
                       nvl(MRLV_INVRELDIVERG.nroloteprod, 0)
                   and (cc.codinvarea in
                       (select number1 from CONSINCO.gex_dadostemporarios) or
                       not exists((select number1
                                     from CONSINCO.gex_dadostemporarios)))) -
             QTDCONGELADAUNIT) / MRLV_INVRELDIVERG.QTDEMBALAGEM),
             0) != 0) OR (MRLV_INVRELDIVERG.QTDSEMCONTAGEM <= 0) OR
       (exists (select *
                   from CONSINCO.MRL_InvProduto b
                  where MRLV_INVRELDIVERG.seqinvlote = b.seqinvlote
                    and MRLV_INVRELDIVERG.seqproduto = b.seqproduto
                    and MRLV_INVRELDIVERG.nroempresa = b.nroempresa
                    and b.qtdcongelada <> 0
                    and not exists (select *
                           from CONSINCO.MRL_InvContagem c
                          where b.nroempresa = c.nroempresa
                            and b.seqinvlote = c.seqinvlote
                            and b.seqproduto = c.seqproduto
                            and c.qtdcontagem1 = 0))) OR
       (MRLV_INVRELDIVERG.QTDSEMCONTAGEM > 0 AND
       ((select coalesce(sum(cc.qtdcontagem3 * cc.qtdembalagem),
                           sum(cc.qtdcontagem2 * cc.qtdembalagem),
                           sum(cc.qtdcontagem1 * cc.qtdembalagem),
                           0)
             from CONSINCO.mrl_invcontagem cc
            where cc.seqinvlote = MRLV_INVRELDIVERG.seqinvlote
              and cc.nroempresa = MRLV_INVRELDIVERG.nroempresa
              and cc.seqproduto = MRLV_INVRELDIVERG.seqproduto
              and 0 = 0
              and nvl(cc.nroloteprod, 0) =
                  nvl(MRLV_INVRELDIVERG.nroloteprod, 0)
              and (cc.codinvarea in
                  (select number1 from CONSINCO.gex_dadostemporarios) or
                  not
                   exists((select number1 from CONSINCO.gex_dadostemporarios)))) /
       MRLV_INVRELDIVERG.QTDEMBALAGEM) = 0))
   AND MRLV_INVRELDIVERG.SEQINVLOTE = 429
   AND MRLV_INVRELDIVERG.NIVELHIERARQUIA = 1
Order By NULL, MRLV_INVRELDIVERG.DESCCOMPLETA )
 
WHERE DIVERG < 0;

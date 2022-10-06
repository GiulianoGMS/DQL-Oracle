create or replace view mrlv_etiq_nagumo_atacarejo as
select distinct(a.nroempresa),  a.seqproduto,          a.codacesso,
              a.qtdetiqueta,           a.dtaprominicio,       a.dtapromfim,
              a.codacessopadrao,       a.embalagempadrao,     a.padraoembvenda,
              a.precoembpadrao,        a.tipoetiqueta,        a.tipopreco,
              a.desccompleta,          a.descreduzida,        a.qtdembalagem1,
              a.qtdembalagem2,         a.qtdembalagem3,       a.qtdembalagem4,
              a.qtdembalagem5,         a.codacesso1,          a.codacesso2,
              a.codacesso3,            a.codacesso4,          a.codacesso5,
              a.preco1,                a.preco2,              a.preco3,
              a.preco4,                a.preco5,              a.precomin,
              a.precomax,              a.embalagem1,          a.embalagem2,
              a.embalagem3,            a.embalagem4,          a.embalagem5,
              a.multeqpemb1,           a.qtdunidemb1,         a.multeqpemb2,
              a.qtdunidemb2,           a.multeqpemb3,         a.qtdunidemb3,
              a.multeqpemb4,           a.qtdunidemb4,         a.multeqpemb5,
              a.qtdunidemb5,           a.multeqpembpadrao,    a.qtdunidembpadrao,
              a.dtabasepreco,          a.tipocodigo,          a.descpromapartirde1,
              a.descpromapartirde2,    a.descpromapartirde3,  a.descpromapartirde4,
              a.descpromapartirde5,

              case when a.preco1 >= a.precoembpadrao or (nvl(h.precovalidpromoc,0) = 0)  then
                '^XA' || '^PRA^FS' || '^LH00,00^FS'|| '^BY2^FS' || '^PQ' || nvl(a.qtdetiqueta, 1) || '^FS'
       || case


----------- Quando estiver na oferta e quando oferta foi MENOR que pre¿¿o normal
             when (nvl(h.precovalidpromoc,0) > 0) and (nvl(h.precovalidpromoc,0))  < trunc((a.precovalidnormal/a.padraoembvenda),2)
               then
             --and a.preco1 is not null and a.preco2 is not null then -- segundo e terceira condicao desligada
         chr(13) || chr(10) || '^FO18,30^APN,90,40^FD'|| substr(a.Desccompleta,0,40) || '^FS' -- Descri¿¿¿¿o Maior
       --chr(13) || chr(10) ||'^FO18,34^AQN,60,10^FD'|| substr(a.Desccompleta,0,40) || '^FS' -- Descri¿¿¿¿o Menor
         ||chr(13) || chr(10) || '^FO38,210^BEN,30^FD'  ||  a.codacessopadrao ||'^FS' -- ean etq oferta
         ||chr(13)|| chr(10)||'^FO560,20^A0N,80,80^FDOFERTA^FS'||'^FS'
         ||chr(13)|| chr(10)||'^FO480,100^A0N,170,120^FD' || lpad(trunc(h.precovalidpromoc), 4, ' ' ) || ',' || lpad((h.precovalidpromoc - trunc(h.precovalidpromoc)) * 100, 2, 0)|| '^FS'
         ||chr(13)|| chr(10)||'^FO535,010^GB300,270,140,B,3^FR^FS' --FUNDO PRETO
         ||chr(13)|| chr(10)||'^FO18,07^AQN,20,20^FD' ||  decode(a.dtaprominicio,null,  null,'Val Prom.: ' || to_char(a.dtaprominicio,
         'dd/mm/yy') || ' a ' ||to_char(a.dtapromfim, 'dd/mm/yy'))||'^FS'
         || chr(13) || chr(10) || '^FO03,265^A0N,13,16^FD'||'LOJA:'|| B.nomereduzido || '^FS'
         || chr(13) || chr(10) || '^FO155,265^A0N,13,16^FD' ||  to_char(sysdate, 'dd/mm/yy hh24:mi') || '^FS'
         || chr(13) || chr(10) || '^FO260,265^A0N,13,16^FD'  || 'PROD:'|| a.seqproduto ||'^FS' -- COD INTERNO
         || chr(13) || chr(10) || '^FO65,120^GB250,85,4^FR^FS' --gd preco a partir de
        -- || chr(13) || chr(10) || '^^FO0150,88^APN,020,020^FD'|| 'A PARTIR DE' ||' ' || (A.Qtdembalagem1)  || ' ' || 'UNID'  ||'^FS' --PALAVRA A PARTIR DE
         || chr(13) || chr(10) || '^FO080,130^APN,030,030^FD'||'R$'||'^FS' --R$ DO preco normal
         || chr(13) || chr(10) || '^^FO110,125^APN,70,70^FD' || lpad(trunc(h.precovalidnormal), 4, ' ' ) || ',' || lpad((h.precovalidnormal - trunc(h.precovalidnormal)) * 100, 2, '0') ||'^FS' -- Preco Normal

----PREÇO POR KG ou LI ou etc...
||    (CASE WHEN
       K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
       THEN
CHR(13) || CHR(10) || '^FO550,255^A0N,20,19^FD' ||/* '*PRECO PAGO POR ' || J.MULTEQPEMBALAGEM ||' R$   '*/ 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'
                                                                                                                                                                                                                                                                    when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g'
                                                                                                                                                                                                                                                                     ELSE K.MULTEQPEMBALAGEM END ||' R$ '
      || DECODE(SIGN(K.PRECOGERPROMOC/*J.PRECOGERNORMAL*/),+1,
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

         ||chr(13)|| chr(10)||'^FO380,120^A0N,55,55^FDPOR^FS||^FS'  --POR
         ---QR CODE Etiqueta Oferta
         || chr(13) || chr(10) || '^FO0390,0165^BQ,2,4^FDLA,:p:' || (select distinct(r.codigo || ':vp:' || r.codigo_preco)
                                                                        from rub.rub_produto r
                                                                        where R.id_loja = g.nroempresa
                                                                        AND R.codigo = a.seqproduto) || '^FS'
---------------INICIO PRECO UNICO normal ou promo¿¿¿¿o for MAIOR que Normal
         when /*round (a.preco1/a.qtdembalagem1,2) = trunc((a.precoembpadrao/a.padraoembvenda),2) or*/
           (nvl(a.precovalidpromoc,0) > trunc((a.precovalidnormal/a.padraoembvenda),2))
           then
         chr(13) || chr(10) || '^FO18,007^ATN,5,5^FD'|| substr(a.Desccompleta,0,40) || '^FS'
      || chr(13) || chr(10) || '^FO050,200^BY2.4^BEN,30,Y,N^FD' || a.codacessopadrao ||'^FS' --ean cod barras
      --- QR CODE Etiquera Normal
      || chr(13) || chr(10) || '^FO050,075^BQ,2,4^FDLA,:p:' || (select distinct(r.codigo || ':vp:' || r.codigo_preco)
                                                                        from rub.rub_produto r
                                                                        where R.id_loja = g.nroempresa
                                                                        AND R.codigo = a.seqproduto) || '^FS'
      || chr(13) || chr(10) ||'^FO180,100^A0N,110,60^FDR$^FS' ||'^FS' -- R$
      || chr(13) || chr(10) ||'^FO350,90^A0N,170,130^FD'|| lpad(trunc(a.precoembpadrao), 4, ' ' ) || ',' || --preco normal
                                                           lpad((a.precoembpadrao - trunc(a.precoembpadrao)) * 100, 2, '0')|| '^FS'

----PREÇO POR KG ou LI ou etc...
||    (CASE WHEN
       K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
       THEN
CHR(13) || CHR(10) || '^FO550,255^A0N,20,19^FD' ||/* '*PRECO PAGO POR ' || J.MULTEQPEMBALAGEM ||' R$   '*/'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'
                                                                                                                                                                                                                                                                    when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g'
                                                                                                                                                                                                                                                                     ELSE K.MULTEQPEMBALAGEM END ||' R$ '
      || DECODE(SIGN(K.PRECOGERPROMOC/*J.PRECOGERNORMAL*/),+1,
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

      || chr(13) || chr(10) || '^FO03,265^A0N,13,16^FD'||'LOJA:'|| B.nomereduzido || '^FS'
      || chr(13) || chr(10) || '^FO160,265^A0N,13,16^FD' ||  to_char(sysdate, 'dd/mm/yy hh24:mi') || '^FS'
      || chr(13) || chr(10) || '^FO260,265^A0N,13,16^FD'  || 'PROD:'|| a.seqproduto ||'^FS' -- COD INTERNO


 ------------INICIO PRECO UNICO Caso NAO esteja em oferta e tenha precos dif por embalagens
         when trunc(a.preco1/a.qtdembalagem1,2) = trunc((a.precoembpadrao/a.padraoembvenda),2) and (nvl(a.precovalidpromoc,0) = 0)
           then
         chr(13) || chr(10) || '^FO18,007^ATN,5,5^FD'|| substr(a.Desccompleta,0,40) || '^FS'
    --  || chr(13) || chr(10) || '^FO050,200^BY2.4^BEN,30,Y,N^FD' || a.codacessopadrao ||'^FS' --ean cod barras
       || chr(13) || chr(10) ||decode(length(i.codacesso),13, '^FO050,200^BY2.4^BEN,30,Y,N^FD', '^FO050,200^BY2.4^BCN,30,Y,N^FD' ) || i.codacesso ||'^FS' --ean cod barras barras
        --- QR CODE Etiquera Normal
      || chr(13) || chr(10) || '^FO050,075^BQ,2,4^FDLA,:p:' || (select distinct(r.codigo || ':vp:' || r.codigo_preco)
                                                                        from rub.rub_produto r
                                                                        where R.id_loja = g.nroempresa
                                                                        AND R.codigo = a.seqproduto) || '^FS'
      || chr(13) || chr(10) ||'^FO180,100^A0N,110,60^FDR$^FS' ||'^FS' -- R$
      || chr(13) || chr(10) ||'^FO350,90^A0N,170,130^FD'|| lpad(trunc(a.precoembpadrao), 4, ' ' ) || ',' || --preco normal
                                                           lpad((a.precoembpadrao - trunc(a.precoembpadrao)) * 100, 2, '0')|| '^FS'

----PREÇO POR KG
||    (CASE WHEN
       K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
       THEN
CHR(13) || CHR(10) || '^FO550,255^A0N,20,19^FD' || /*'*PRECO PAGO POR ' || J.MULTEQPEMBALAGEM ||' R$   '*/ 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'
                                                                                                                                                                                                                                                                    when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g'
                                                                                                                                                                                                                                                                     ELSE K.MULTEQPEMBALAGEM END ||' R$ '
      || DECODE(SIGN(K.PRECOGERPROMOC/*J.PRECOGERNORMAL*/),+1,
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

      || chr(13) || chr(10) || '^FO03,265^A0N,13,16^FD'||'LOJA:'|| b.nomereduzido || '^FS'
      || chr(13) || chr(10) || '^FO160,265^A0N,13,16^FD' ||  to_char(sysdate, 'dd/mm/yy hh24:mi') || '^FS'
      || chr(13) || chr(10) || '^FO260,265^A0N,13,16^FD'  || 'PROD:'|| a.seqproduto ||'^FS' -- COD INTERNO
      ---FO645,265^A0N,13,16^FD


---- INICIO DA ETIQUETA PREÇO UNICO PARA PRODUTOS PESAVEIS QUANDO O MESMO TIVER PREÇO DIF POR EMBALAGEM

when j.pesavel = 'S' and trunc(a.preco1/a.qtdembalagem1,2) <> trunc((a.precoembpadrao/a.padraoembvenda),2) and (nvl(a.precovalidpromoc,0) = 0)
           then
         chr(13) || chr(10) || '^FO18,007^ATN,5,5^FD'|| substr(a.Desccompleta,0,40) || '^FS'
    --  || chr(13) || chr(10) || '^FO050,200^BY2.4^BEN,30,Y,N^FD' || a.codacessopadrao ||'^FS' --ean cod barras
       || chr(13) || chr(10) ||decode(length(i.codacesso),13, '^FO050,200^BY2.4^BEN,30,Y,N^FD', '^FO050,200^BY2.4^BCN,30,Y,N^FD' ) || i.codacesso ||'^FS' --ean cod barras barras
        --- QR CODE Etiquera Normal
      || chr(13) || chr(10) || '^FO050,075^BQ,2,4^FDLA,:p:' || (select distinct(r.codigo || ':vp:' || r.codigo_preco)
                                                                        from rub.rub_produto r
                                                                        where R.id_loja = g.nroempresa
                                                                        AND R.codigo = a.seqproduto) || '^FS'
      || chr(13) || chr(10) ||'^FO180,100^A0N,110,60^FDR$^FS' ||'^FS' -- R$
      || chr(13) || chr(10) ||'^FO350,90^A0N,170,130^FD'|| lpad(trunc(a.precoembpadrao), 4, ' ' ) || ',' || --preco normal
                                                           lpad((a.precoembpadrao - trunc(a.precoembpadrao)) * 100, 2, '0')|| '^FS'

----PREÇO POR KG
||    (CASE WHEN
       K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
       THEN
CHR(13) || CHR(10) || '^FO550,255^A0N,20,19^FD' || /*'*PRECO PAGO POR ' || J.MULTEQPEMBALAGEM ||' R$   '*/ 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'
                                                                                                                                                                                                                                                                    when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g'
                                                                                                                                                                                                                                                                     ELSE K.MULTEQPEMBALAGEM END ||' R$ '
      || DECODE(SIGN(K.PRECOGERPROMOC/*J.PRECOGERNORMAL*/),+1,
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
       TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

      || chr(13) || chr(10) || '^FO03,265^A0N,13,16^FD'||'LOJA:'|| b.nomereduzido || '^FS'
      || chr(13) || chr(10) || '^FO160,265^A0N,13,16^FD' ||  to_char(sysdate, 'dd/mm/yy hh24:mi') || '^FS'
      || chr(13) || chr(10) || '^FO260,265^A0N,13,16^FD'  || 'PROD:'|| a.seqproduto ||'^FS' -- COD INTERNO


--Fim da Etiqueta
|| chr(13) || chr(10) || '^XZ'
--|| chr(13) || chr(10) linha


--------------------------------------------- inicio de etiqueta com preco diferenciado por embalagem ------------
                else
                decode(a.tipopreco, 'V',
                      --- pre¿o valido
                     decode(nvl(h.precovalidpromoc,0), 0,
                            -- Pre¿o Normal
                            '^XA^PQ' || nvl(a.qtdetiqueta, 1) || ',,,' || '^FS^LL360^FS'                                                         || chr(13) || chr(10) ||
                            '^FO030,190^BEN,25,Y,N^FD' || a.codacesso  || '^FS'                                                                  || chr(13) || chr(10) ||
                            '^FO10,20^A0N,40,40^FD'  || a.desccompleta || ' ' || e.embalagem || '-' || e.qtdembalagem ||  '^FS'                                                                  || chr(13) || chr(10) ||
                            '^FO30,150^A0N,30,30^FD' || b.nomereduzido || '^FS'                                                                  || chr(13) || chr(10) ||
                            '^FO30,260^A0N,25,25^FD' || to_char(sysdate, 'DD/MM/YY HH24:MI:SS')
                                                     || '-' || 'PROD:'
                                                     || decode(j.pesavel, 'S', a.codacesso, a.seqproduto) || '^FS'                               || chr(13) || chr(10) ||
                            '^FO280,80^A0N,30,30^FDVAREJO'|| '^FS'                                                                               || chr(13) || chr(10) ||
                            '^FO260,120^A0N,25,25^FDUnidade Avulsa' || '^FS'                                                                     || chr(13) || chr(10) ||
                            '^FO470,105^A0N,30,30^FD' || 'R$' || '^FS'                                                                           || chr(13) || chr(10) ||
                            '^FO550,80^A0N,70,70^FD' || lpad(trunc(h.precovalidnormal), 4, ' ' ) || ',' ||
                                                        lpad((h.precovalidnormal - trunc(h.precovalidnormal)) * 100, 2, '0') || '^FS'            || chr(13) || chr(10) ||  -- R$ Varejo

                            '^FO650,90^A0N,090,40^FD'                                                                                            || chr(13) || chr(10) ||  -- Pre¿o Varejo
                            '^FO470,195^A0N,30,30^FD' || 'R$' || '^FS'                                                                           || chr(13) || chr(10) ||  -- R$ Atacado
                            '^FO280,180^A0N,30,30^FD' || 'ATACADO' || '^FS'                                                                      || chr(13) || chr(10) ||
                            '^FO260,210^A0N,25,25^FDA partir de ' ||  lpad(to_char(a.qtdembalagem1),2,0) || ' UN' ||'^FS'                                                                    || chr(13) || chr(10) ||
                            '^FO550,170^A0N,70,70^FD' ||
                            case when e.qtdembalagem = 1 then
                                 decode(nvl(g.precoatac,0),0,
                                       (lpad(trunc((a.preco1 / a.qtdembalagem1)), 4, ' ') || ',' ||
                                        lpad((trunc((a.preco1 / a.qtdembalagem1),2) -
                                        trunc((a.preco1 / a.qtdembalagem1))) * 100, 2, 0)),
                                       (lpad(trunc((g.precoatac)), 4, ' ') || ',' ||
                                        lpad((trunc((g.precoatac),2) -
                                        trunc((g.precoatac))) * 100, 2, 0)))||'^FR^FS'

||CHR(13) || CHR(10) || '^FO605,235^A0N,15,15^FD' || 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = ' LI ' THEN ' L ' when  K.MULTEQPEMBALAGEM = ' GR ' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||' R$ '
|| DECODE(SIGN(A.PRECO1),+1,
   TRANSLATE(TO_CHAR(ROUND(((A.PRECO1/A.QTDEMBALAGEM1)/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')
)
|| CHR(13) || CHR(10) || '' ||'^FR^FS'
                             else

                                 lpad(trunc(h.precovalidnormal), 4, ' ' ) || ',' ||
                                 lpad((h.precovalidnormal - trunc(h.precovalidnormal)) * 100, 2, '0')
                              end

                                                ----PREÇO POR KG ou LI ou etc...
||(CASE WHEN
K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
THEN
CHR(13) || CHR(10) || '^FO605,145^A0N,15,15^FD' || 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'  when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||' R$ '
|| DECODE(SIGN(K.PRECOGERPROMOC /*K.PRECOGERNORMAL*/),+1,
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

                            || '^FS'                                                                                                             || chr(13) || chr(10) ||  -- Pre¿o Atacado
                            '^FO650,200^A0N,090,40^FD' ||'^FS'                                                                                   || chr(13) || chr(10) ||  -- Pre¿o Atacado
                            -- quadro
                            '^FO240,70^GB575,185,4^FS' /* moldura */                                                                             || chr(13) || chr(10) ||
                            '^FO240,160^GB575,0,4^FS'  /* linha horizontal */                                                                    || chr(13) || chr(10) ||
                            '^FO450,70^GB0,180,4^FS'|| chr(13) || chr(10) ||
                            '^XZ',
                            -- Pre¿o Promo¿¿o
                            case when (nvl(h.precovalidpromoc,0) >= nvl(h.precovalidnormal,0)) then
                                      '^XA^PQ' || nvl(a.qtdetiqueta, 1) || ',,,' || '^FS^LL360^FS'                                               || chr(13) || chr(10) ||
                                      '^FO030,190^BEN,25,Y,N^FD' || a.codacesso || '^FS'                                                         || chr(13) || chr(10) ||
                                      '^FO10,20^A0N,40,40^FD'  || a.desccompleta || ' ' || e.embalagem || '-' || e.qtdembalagem || '^FS'                                                        || chr(13) || chr(10) ||
                                      '^FO30,150^A0N,30,30^FD' || b.nomereduzido || '^FS'                                                        || chr(13) || chr(10) ||
                                      '^FO30,260^A0N,25,25^FD' || to_char(sysdate, 'DD/MM/YY HH24:MI:SS')
                                                               || '-' || 'PROD:'
                                                               || decode(j.pesavel, 'S', a.codacesso, a.seqproduto) || '^FS'                     || chr(13) || chr(10) ||
                                      '^FO280,80^A0N,30,30^FDVAREJO'|| '^FS'                                                                     || chr(13) || chr(10) ||
                                      '^FO260,120^A0N,25,25^FDUnidade Avulsa' || '^FS'                                                           || chr(13) || chr(10) ||
                                      '^FO470,105^A0N,30,30^FD' || 'R$' || '^FS'                                                                 || chr(13) || chr(10) ||
                                      '^FO550,80^A0N,70,70^FD' || lpad(trunc(h.precovalidpromoc), 4, ' ' ) || ',' ||
                                                                  lpad((h.precovalidpromoc - trunc(h.precovalidpromoc)) * 100, 2, '0') || '^FS'  || chr(13) || chr(10) ||  -- R$ Varejo


                                      '^FO650,90^A0N,090,40^FD'                                                                                  || chr(13) || chr(10) ||  -- Pre¿o Varejo
                                      '^FO470,195^A0N,30,30^FD' || 'R$' || '^FS'                                                                 || chr(13) || chr(10) ||  -- R$ Atacado
                                      '^FO280,180^A0N,30,30^FD' || 'ATACADO' || '^FS'                                                            || chr(13) || chr(10) ||
                                      '^FO260,210^A0N,25,25^FDA partir de ' || lpad(to_char(a.qtdembalagem1),2,0)  || ' UN' ||'^FS'                                                          || chr(13) || chr(10) ||
                                      '^FO550,170^A0N,70,70^FD' ||
                                      case when  e.qtdembalagem = 1 then
                                           decode(nvl(g.precoatac,0),0,
                                                 (lpad(trunc((a.preco1 / a.qtdembalagem1)), 4, ' ') || ',' ||
                                                  lpad((trunc((a.preco1 / a.qtdembalagem1),2) -
                                                  trunc((a.preco1 / a.qtdembalagem1))) * 100, 2, 0)),
                                                 (lpad(trunc((g.precoatac)), 4, ' ') || ',' ||
                                                  lpad((trunc((g.precoatac),2) -
                                                  trunc((g.precoatac))) * 100, 2, 0)))||'^FR^FS'

||CHR(13) || CHR(10) || '^FO605,235^A0N,15,15^FD' || 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'  when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||'R$ '
|| DECODE(SIGN(A.PRECO1),+1,
  TRANSLATE(TO_CHAR(ROUND(((A.PRECO1/A.QTDEMBALAGEM1)/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')
)
|| CHR(13) || CHR(10) || '' ||'^FR^FS'
                                        else

                                           lpad(trunc(h.precovalidpromoc), 4, ' ' ) || ',' ||
                                           lpad((h.precovalidpromoc - trunc(h.precovalidpromoc)) * 100, 2, '0')
                                        end

                  ----PREÇO POR KG ou LI ou etc...
||(CASE WHEN
K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
THEN
CHR(13) || CHR(10) || '^FO605,145^A0N,15,15^FD' || 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L' when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||'R$ '
|| DECODE(SIGN(K.PRECOGERPROMOC /*K.PRECOGERNORMAL*/),+1,
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

                                        || '^FS'                                                                                                 || chr(13) || chr(10) ||  -- Pre¿o Atacado
                                       '^FO650,200^A0N,090,40^FD' ||'^FS'                                                                        || chr(13) || chr(10) ||  -- Pre¿o Atacado
                                      -- quadro
                                      '^FO240,70^GB575,185,4^FS' /* moldura */                                                                   || chr(13) || chr(10) ||
                                      '^FO240,160^GB575,0,4^FS'  /* linha horizontal */                                                          || chr(13) || chr(10) ||
                                      '^FO450,70^GB0,180,4^FS'|| chr(13) || chr(10) ||
                                      '^XZ'
                            else
                                      '^XA^PQ' || nvl(a.qtdetiqueta, 1) || ',,,' || '^FS^LL290^FS'                                               || chr(13) || chr(10) ||
                                      '^FO550,20^A0N,80,80^FDOFERTA^FS' ||'^FS'                                                                  || chr(13) || chr(10) ||
                                      '^FO015,090^A0N,40,40^FD' || a.desccompleta ||' ' || e.embalagem || '-' || e.qtdembalagem || '^FS'         || chr(13) || chr(10) ||
                                      '^FO015,250^A0N,30,30^FD'  || b.nomereduzido ||'^FS'                                                       || chr(13) || chr(10) ||
                                      '^FO015,125^GB425,090,005^FS' || '^FS'                                                                     || chr(13) || chr(10) ||
                                      '^FO035,150^A0N,40,40^FDDE R$^FS' ||'^FS'                                                                  || chr(13) || chr(10) ||
                                      '^FO160,140^A0N,80,60^FD'|| lpad(trunc(h.precovalidnormal), 4, ' ' ) || ',' ||
                                                                   lpad((h.precovalidnormal - trunc(h.precovalidnormal)) * 100, 2, '0') ||'^FS'  || chr(13) || chr(10) ||
                  ----PREÇO POR KG ou LI ou etc...
(CASE WHEN
K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
THEN
CHR(13) || CHR(10) || '^FO605,245^A0N,15,15^FD' || 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'   when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||' R$ '
|| DECODE(SIGN(K.PRECOGERPROMOC /*K.PRECOGERNORMAL*/),+1,
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')/*,
TRANSLATE(TO_CHAR(ROUND((A.PRECO1/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')*/)
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'||

                                      '^FO015,220^A0N,30,30^FDCOD:^FS' || '^FS'                                                                  || chr(13) || chr(10) ||
                                      '^FO080,220^A0N,30,30^FD' || a.codacesso ||'^FS'                                                           || chr(13) || chr(10) ||
                                      '^FO420,220^A0N,40,40^FDPOR R$^FS' || '^FS'                                                                || chr(13) || chr(10) ||
                                      '^FO480,110^A0N,150,120^FD' || lpad(trunc(h.precovalidpromoc), 4, ' ' ) || ',' ||
                                                                     lpad((h.precovalidpromoc - trunc(h.precovalidpromoc)) * 100, 2, 0)|| '^FS'  || chr(13) || chr(10) ||
                                      '^FO30,10^AQN,20,20^FD' ||  decode(a.dtaprominicio,
                                                                         null,  null,
                                                                         'Val Prom.: ' || to_char(a.dtaprominicio, 'dd/mm/yy ') || 'a ' ||
                                                                         to_char(a.dtapromfim, 'dd/mm/yy ')) || '^FS'                            || chr(13) || chr(10) ||

                                      '^XZ'
                               end),

                     -- pre¿o gerado
                     decode(nvl(h.precogerpromoc,0), 0,
                            -- Pre¿o Normal
                            '^XA^PQ' || nvl(a.qtdetiqueta, 1) || ',,,' || '^FS^LL360^FS'                                                         || chr(13) || chr(10) ||
                            '^FO030,190^BEN,25,Y,N^FD' || a.codacesso  || '^FS'                                                                  || chr(13) || chr(10) ||
                            '^FO10,20^A0N,40,40^FD'  || a.desccompleta || ' ' || e.embalagem || '-' || e.qtdembalagem ||  '^FS'                                                                  || chr(13) || chr(10) ||
                            '^FO30,150^A0N,30,30^FD' || b.nomereduzido || '^FS'                                                                  || chr(13) || chr(10) ||
                            '^FO30,260^A0N,25,25^FD' || to_char(sysdate, 'DD/MM/YY HH24:MI:SS')
                                                     || '-' || 'PROD:'
                                                     || decode(j.pesavel, 'S', a.codacesso, a.seqproduto) || '^FS'                               || chr(13) || chr(10) ||
                            '^FO280,80^A0N,30,30^FDVAREJO'|| '^FS'                                                                               || chr(13) || chr(10) ||
                            '^FO260,120^A0N,25,25^FDUnidade Avulsa' || '^FS'                                                                     || chr(13) || chr(10) ||
                            '^FO470,105^A0N,30,30^FD' || 'R$' || '^FS'                                                                           || chr(13) || chr(10) ||
                            '^FO550,80^A0N,70,70^FD' || lpad(trunc(h.precogernormal), 4, ' ' ) || ',' ||
                                                        lpad((h.precogernormal - trunc(h.precogernormal)) * 100, 2, '0') || '^FS'                || chr(13) || chr(10) ||  -- R$ Varejo


                            '^FO650,90^A0N,090,40^FD'                                                                                            || chr(13) || chr(10) ||  -- Pre¿o Varejo
                            '^FO470,195^A0N,30,30^FD' || 'R$' || '^FS'                                                                           || chr(13) || chr(10) ||  -- R$ Atacado
                            '^FO280,180^A0N,30,30^FD' || 'ATACADO' || '^FS'                                                                      || chr(13) || chr(10) ||
                            '^FO260,210^A0N,25,25^FDA partir de ' ||  lpad(to_char(a.qtdembalagem1),2,0) ||' UN' ||'^FS'                                                                    || chr(13) || chr(10) ||
                            '^FO550,170^A0N,70,70^FD' ||
                            case when e.qtdembalagem = 1 then
                                 decode(nvl(g.precoatacger,0),0,
                                       (lpad(trunc((a.preco1 / a.qtdembalagem1)), 4, ' ') || ',' ||
                                        lpad((trunc((a.preco1 / a.qtdembalagem1),2) -
                                        trunc((a.preco1 / a.qtdembalagem1))) * 100, 2, 0)),
                                       (lpad(trunc((g.precoatacger)), 4, ' ') || ',' ||
                                        lpad((trunc((g.precoatacger),2) -
                                        trunc((g.precoatacger))) * 100, 2, 0)))||'^FR^FS'

||CHR(13) || CHR(10) || '^FO605,235^A0N,15,15^FD' || 'Nesta Embalagem ' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'  when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||' R$ '
|| DECODE(SIGN(A.PRECO1),+1,
   TRANSLATE(TO_CHAR(ROUND(((A.PRECO1/A.QTDEMBALAGEM1)/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')
)
|| CHR(13) || CHR(10) || '' ||'^FR^FS'
                                        else

                                 lpad(trunc(h.precogernormal), 4, ' ' ) || ',' ||
                                 lpad((h.precogernormal - trunc(h.precogernormal)) * 100, 2, '0')
                              end

                  ----PREÇO POR KG ou LI ou etc...
||(CASE WHEN
K.MULTEQPEMB IS NOT NULL  OR K.MULTEQPEMBALAGEM IS NOT NULL
THEN
CHR(13) || CHR(10) || '^FO605,145^A0N,15,15^FD' || 'Nesta Embalagem' || CASE WHEN K.MULTEQPEMBALAGEM = 'LI' THEN 'L'   when  K.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE K.MULTEQPEMBALAGEM END ||' R$ '
|| DECODE(SIGN(K.PRECOGERPROMOC /*K.PRECOGERNORMAL*/),+1,
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERPROMOC/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
TRANSLATE(TO_CHAR(ROUND((K.PRECOGERNORMAL/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')/*,
TRANSLATE(TO_CHAR(ROUND((A.PRECO1/(K.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')*/)
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

                            || '^FS'                                                                                                             || chr(13) || chr(10) ||  -- Pre¿o Atacado
                            '^FO650,200^A0N,090,40^FD' ||'^FS'                                                                                   || chr(13) || chr(10) ||  -- Pre¿o Atacado
                            -- quadro
                            '^FO240,70^GB575,185,4^FS' /* moldura */                                                                             || chr(13) || chr(10) ||
                            '^FO240,160^GB575,0,4^FS'  /* linha horizontal */                                                                    || chr(13) || chr(10) ||
                            '^FO450,70^GB0,180,4^FS'|| chr(13) || chr(10) ||
                            '^XZ' ))
  end                          end

|| chr(13) || chr(10) || '^XZ'
|| chr(13) || chr(10) linha



       from   consinco.mrlx_baseetiquetaprod a,
              consinco.ge_empresa            b,
              consinco.map_produto           p,
              consinco.map_famembalagem      e,
              consinco.mrl_produtoempresa    f,
              (select round((mrl_prodempseg.precovalidnormal /
                      mrl_prodempseg.qtdembalagem),2) precoatac,
                      round((mrl_prodempseg.precogernormal /
                      mrl_prodempseg.qtdembalagem),2) precoatacger,
                      mrl_prodempseg.seqproduto,
                      mrl_prodempseg.nroempresa,
                      min(mrl_prodempseg.qtdembalagem) qtdembalagem
               from   consinco.mrl_prodempseg
               where  mrl_prodempseg.qtdembalagem <> 1
               and    mrl_prodempseg.precovalidnormal <> 0
               and    mrl_prodempseg.Statusvenda = 'A'
               and    mrl_prodempseg.qtdembalagem =  (select min (emps.qtdembalagem)
                                                      from mrl_prodempseg     emps
                                                      where emps.seqproduto   = mrl_prodempseg.seqproduto
                                                      and   emps.nroempresa   = mrl_prodempseg.nroempresa
                                                      and   emps.nrosegmento  = mrl_prodempseg.nrosegmento
                                                      and   emps.precovalidnormal <> 0
                                                      and   emps.qtdembalagem > 1)
               group by mrl_prodempseg.precovalidnormal /
                        mrl_prodempseg.qtdembalagem,
                        mrl_prodempseg.precogernormal /
                        mrl_prodempseg.qtdembalagem,
                        mrl_prodempseg.seqproduto,
                        mrl_prodempseg.nroempresa) g,
               consinco.mrl_prodempseg       h,
               consinco.map_prodcodigo       i,
               consinco.map_familia          j,
               consinco.mrlv_baseetiquetaprod k

       where  a.seqproduto          =    p.seqproduto
       and    e.seqfamilia          =    p.seqfamilia
       and    a.seqproduto          =    f.seqproduto
       and    a.nroempresa          =    f.nroempresa
       and    a.nroempresa          =    b.nroempresa
       and    b.nroempresa          =    f.nroempresa
       and    a.seqproduto          =    g.seqproduto(+)
       and    a.nroempresa          =    g.nroempresa(+)
       and    a.seqproduto          =    h.seqproduto
       and    a.nroempresa          =    h.nroempresa
       and    a.nrosegmento         =    h.nrosegmento
       and    h.qtdembalagem        =    i.qtdembalagem
       and    a.codacesso           =    i.codacesso
       and    e.seqfamilia          =    p.seqfamilia
       and    e.qtdembalagem        =    i.qtdembalagem
       and    i.seqfamilia          =    j.seqfamilia

       and not exists (select 1
           FROM Mrl_Encarte A1, Mrl_Encarteemp A2, Mrl_Encarteproduto A3
          WHERE Trunc(SYSDATE) BETWEEN Nvl(A3.Dtavigenciaini, A1.Dtainicio) AND
                Nvl(A3.Dtavigenciafim, A1.Dtafim)
            AND A1.Seqencarte = A2.Seqencarte
            AND A1.Seqencarte = A3.Seqencarte
            AND nvl(A3.Precocartaoproprio,0) > 0
            AND A2.NROEMPRESA = a.NROEMPRESA
            AND A3.SEQPRODUTO = a.SEQPRODUTO)

      --and nvl(h.precovalidpromoc,0)=0
-----------------------------------------------------------
      and a.nroempresa = k.nroempresa
      and a.seqproduto = k.seqproduto
      and a.nrosegmento = k.nrosegmento
      and b.nroempresa = k.nroempresa
      and p.seqproduto = k.seqproduto
      and p.seqfamilia = k.seqfamilia
      and e.seqfamilia = k.seqfamilia
      and e.qtdembalagem = k.qtdembalagem
      and f.seqproduto = k.seqproduto
      and f.nroempresa = k.nroempresa
      and f.nrogondola = k.nrogondola
      and h.seqproduto = k.seqproduto
      and h.nrosegmento = k.nrosegmento
      and h.nroempresa = k.nroempresa
      and h.qtdembalagem = k.qtdembalagem
      and i.seqfamilia = k.seqfamilia
      and i.qtdembalagem = k.qtdembalagem
      and i.seqproduto = k.seqproduto
      and j.seqfamilia = k.seqfamilia
;

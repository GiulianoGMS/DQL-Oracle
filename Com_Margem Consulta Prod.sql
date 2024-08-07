-- Margem da Consulta Produtos, por Categoria

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT NROEMPRESA, SEQPRODUTO, DESCCOMPLETA, CATEG CATEGORIA, ROUND(MIN(MGMPRECOMINVDAEMPRESA),2) MARGEM_MIN, ROUND(MAX(MGMPRECOMAXVDAEMPRESA),2) MARGEM_MAX FROM (

SELECT X.SEQPRODUTO, X.NROEMPRESA, QC.CATEGORIA_COMPLETA CATEG, A.DESCCOMPLETA,DECODE (( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
           CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                ((F.PERALIQUOTAIPI + 100) / 100)
           ELSE 1
           END, 2 ) ), 0, 0,
               ((( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                    CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                          ((F.PERALIQUOTAIPI + 100) / 100)
                    ELSE 1
                    END, 2) ) - (
               (( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                         ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2 ) ) *
               ( 
               CASE WHEN F.INDUTILCUSTOMESBASE = 'S' AND F.UTILOFICIOCSTBRUTOBASEST = 'S' THEN
                  0
               ELSE
                   DECODE(M.METODOPRECIFICACAO, 'B', 0, 'I', 0, F.PERALIQUOTAICMS + NVL(F.PERALIQFCPICMS, 0))
               END  / 100))
               +
               ((DECODE(NVL((SELECT PG.INDUTILCUSTOPRECIFCOMER FROM MAX_PARAMGERAL PG), 'N'), 'N', (B.CMULTVLRNF + B.CMULTIPI -
                DECODE(M.METODOPRECIFICACAO, 'L', B.CMULTCREDICMS + NVL(B.CMULTCREDIPI,0) +
                                                    NVL(B.CMULTCREDPIS, 0) + NVL(B.CMULTCREDCOFINS, 0),
                                              'I', NVL(B.CMULTCREDPIS, 0)
                                                  + NVL(B.CMULTCREDCOFINS, 0), 0)
               + B.CMULTICMSST + B.CMULTDESPNF + B.CMULTDESPFORANF - B.CMULTDCTOFORANF -
               VLRVERBA),
               (B.CMULTVLRNFPRES + B.CMULTIPIPRES -
                DECODE(M.METODOPRECIFICACAO, 'L', B.CMULTCREDICMSPRES + NVL(B.CMULTCREDIPIPRES,0) + NVL(B.CMULTCREDPISPRES, 0)
                                                                  + NVL(B.CMULTCREDCOFINSPRES, 0),
                                              'I', NVL(B.CMULTCREDPISPRES, 0)
                                                  + NVL(B.CMULTCREDCOFINSPRES, 0), 0)
               + B.CMULTICMSSTPRES + B.CMULTDESPNFPRES + B.CMULTDESPFORANFPRES - B.CMULTDESCVERBASELLINPRES - B.CMULTVLRDESCCONTRATOPRES + B.CMULTVLRDESCCONTRATOPISPRES + B.CMULTVLRDESCCONTRATOCOFINSPRES -
               (FC_CUSTOPRECIFCOMERVERBA(VLRVERBA, 0, H.NROEMPRESA) * (-1)) - FC_CUSTOPRECIFCOMERVBASELLOUT(X.SEQPRODUTO, H.NROEMPRESA) +
               NVL(B.VLRPRORATADIAPRECIF, 0))) * X.QTDEMBALAGEM) +
               CASE WHEN F.INDUTILCUSTOMESBASE = 'S' AND F.UTILOFICIOCSTBRUTOBASEST = 'S' AND F.INDCENARIO = 'N' THEN -- RC 121966
                    NVL((FCUSTOPONDERADOBASEICMS(TRUNC(SYSDATE), A.SEQPRODUTO, B.NROEMPRESA, C.NROTRIBUTACAO, F.NROREGTRIBUTACAO, 'C') * X.QTDEMBALAGEM), 0) *( DECODE(M.METODOPRECIFICACAO, 'L',
                               F.PERALIQUOTAICMS + NVL(F.PERALIQFCPICMS, 0), 0) / 100)
               ELSE 0
               END) * CASE WHEN PROP.VALOR = 'S' AND A.PROPQTDPERDAAUTO IS NOT NULL THEN
                             A.PROPQTDPERDAAUTO
                           WHEN PROP.VALOR = 'S' AND A.SEQPRODUTOBASE IS NOT NULL AND NVL(A.PROPQTDPRODUTOBASE,1) != 1 THEN
                             NVL(A.PROPQTDPRODUTOBASE,1)
                           WHEN (A.SEQPRODUTOBASE IS NOT NULL AND M.UTILACRESCCUSTPRODRELAC = 'S') THEN NVL(A.PERCACRESCCUSTORELACVIG,1)
                           ELSE 1
                      END
               +
               (( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               (DECODE(Q.USACOMREPEMDESP, 'T', 0,DECODE(DECODE(P.TIPOCALCCOMISSAOSEG,
                              'E',
                              H.TIPOCALCCOMISSAO,
                              NVL(P.TIPOCALCCOMISSAOSEG, H.TIPOCALCCOMISSAO)),
                       'F',
                       NVL(O.PERCOMISSAONORMALFS, NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0))),
                       'T',
                       COALESCE(E.PERCCOMISSAONORMAL, O.PERCOMISSAONORMALFS, TO_NUMBER(NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))),
                       'R',
                       NVL(P.PERCOMISSAOSEG, 0),
                       NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))) +
                DECODE(Q.GER1_12AVOSCOMPRECO,
                       'S',
                       ((DECODE(Q.USACOMREPEMDESP, 'T', 0,DECODE(DECODE(P.TIPOCALCCOMISSAOSEG,
                                       'E',
                                       H.TIPOCALCCOMISSAO,
                                       NVL(P.TIPOCALCCOMISSAOSEG, H.TIPOCALCCOMISSAO)),
                                'F',
                                NVL(O.PERCOMISSAONORMALFS, NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0))),
                                'T',
                                COALESCE(E.PERCCOMISSAONORMAL, O.PERCOMISSAONORMALFS, TO_NUMBER(NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))),
                                'R',
                                NVL(P.PERCOMISSAOSEG, 0),
                                NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))))) / 12, 0) +
               (DECODE(NVL(M.TIPCALCMARGEM, M.TIPDIVISAO), 'A', N.PERDESPCLASSIFABC,
                                          NVL(O.PERDESPESASEGMENTO, NVL(C.PERDESPESADIVISAO, NVL(H.PERDESPOPERACIONAL, 0))))
               +
               DECODE(M.METODOPRECIFICACAO, 'B', 0,
               FBASEPISCOFINS(F.PERALIQUOTAPIS, F.PERALIQUOTACOFINS, F.PERALIQUOTAICMS, F.PERALIQFCPICMS, H.INDSUBTRAIICMSBASEPISCOFINS) +
                    H.PERCPMF + H.PERIR + H.PEROUTROIMPOSTO +
                    CASE WHEN F.INDSOMAIPIBASEICMS||ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SSS' THEN
                      (F.PERALIQUOTAICMS + DECODE(F.PERALIQICMSCALCPRECO, NULL, F.PERALIQFCPICMS, 0)) * F.PERALIQUOTAIPI / 100
                    ELSE 0 END +
                    (CASE WHEN C.INDMERCENQUADST = 'S' AND DECODE(NVL(ES.INDCALCICMSEFETIVOSUGPRECO, 'N'), 'S', ES.INDCALCICMSEFETIVOSUGPRECO, P.INDCALCICMSEFETIVOSUGPRECO) = 'S' AND F.INDCALCICMSEFETIVO = 'S' THEN
                         NVL((SELECT (NVL(G.ALIQPADRAOICMS, 0)+NVL(G.ALIQPADRAOFEM, 0))
                                FROM MAP_FAMALIQPADRAOUF G
                               WHERE G.SEQFAMILIA = L.SEQFAMILIA
                                 AND G.UF         = H.UF) * (100 - NVL(F.PERREDBCICMSEFET, 0)) /100, 0)
                     ELSE 0
                     END) + 
                    NVL(DECODE(NVL(F.INDCALCSTEMBUTPROD, 'N'), 'S', F.PERALIQUOTAICMSST + (F.PERALIQUOTAICMSST * F.PERACRESCST / 100),0),0)))) / 100))) / (
               ( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                  CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                       ((F.PERALIQUOTAIPI + 100) / 100)
                  ELSE 1
                  END, 2) ) -
               DECODE(M.METODOCALCRENTAB, 'L', (
               (( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               ( 
               CASE WHEN F.INDUTILCUSTOMESBASE = 'S' AND F.UTILOFICIOCSTBRUTOBASEST = 'S' THEN
                  0
               ELSE DECODE(M.METODOPRECIFICACAO, 'B', 0, 'I', 0, F.PERALIQUOTAICMS + NVL(F.PERALIQFCPICMS, 0))
               END / 100))
               +
               (( ROUND( (FMINPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               DECODE(M.METODOPRECIFICACAO, 'B', 0,
                FBASEPISCOFINS(F.PERALIQUOTAPIS, F.PERALIQUOTACOFINS, F.PERALIQUOTAICMS, F.PERALIQFCPICMS, H.INDSUBTRAIICMSBASEPISCOFINS) +
                    H.PERCPMF + H.PERIR + H.PEROUTROIMPOSTO +
                    CASE WHEN F.INDSOMAIPIBASEICMS||ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SSS' THEN
                      (F.PERALIQUOTAICMS + DECODE(F.PERALIQICMSCALCPRECO, NULL, F.PERALIQFCPICMS, 0)) * F.PERALIQUOTAIPI / 100
                    ELSE 0 END +
                    (CASE WHEN C.INDMERCENQUADST = 'S' AND DECODE(NVL(ES.INDCALCICMSEFETIVOSUGPRECO, 'N'), 'S', ES.INDCALCICMSEFETIVOSUGPRECO, P.INDCALCICMSEFETIVOSUGPRECO) = 'S' AND F.INDCALCICMSEFETIVO = 'S' THEN
                         NVL((SELECT (NVL(G.ALIQPADRAOICMS, 0)+NVL(G.ALIQPADRAOFEM, 0))
                                FROM MAP_FAMALIQPADRAOUF G
                               WHERE G.SEQFAMILIA = L.SEQFAMILIA
                                 AND G.UF         = H.UF) * (100 - NVL(F.PERREDBCICMSEFET, 0)) /100, 0)
                     ELSE 0
                     END) +
                    NVL(DECODE(NVL(F.INDCALCSTEMBUTPROD, 'N'), 'S', F.PERALIQUOTAICMSST + (F.PERALIQUOTAICMSST * F.PERACRESCST / 100),0),0)))/*))*/ / 100), 0) ) ) * 100)
AS MGMPRECOMINVDAEMPRESA,
DECODE (( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
           CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                ((F.PERALIQUOTAIPI + 100) / 100)
           ELSE 1
           END, 2) ), 0, 0,
               ((( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                    CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                         ((F.PERALIQUOTAIPI + 100) / 100)
                    ELSE 1
                    END, 2) ) - (
               (( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               (DECODE(M.METODOPRECIFICACAO, 'B', 0, 'I', 0,
               CASE WHEN F.INDUTILCUSTOMESBASE = 'S' AND F.UTILOFICIOCSTBRUTOBASEST = 'S' THEN
                  0
               ELSE
                  F.PERALIQUOTAICMS + NVL(F.PERALIQFCPICMS, 0)
               END
                       ) / 100))
               +
               ((DECODE(NVL((SELECT PG.INDUTILCUSTOPRECIFCOMER FROM MAX_PARAMGERAL PG), 'N'), 'N', (B.CMULTVLRNF + B.CMULTIPI -
                DECODE(M.METODOPRECIFICACAO, 'L', B.CMULTCREDICMS + NVL(B.CMULTCREDIPI,0) +
                                                    NVL(B.CMULTCREDPIS, 0) + NVL(B.CMULTCREDCOFINS, 0),
                                              'I', NVL(B.CMULTCREDPIS, 0)
                                                  + NVL(B.CMULTCREDCOFINS, 0), 0)
               + B.CMULTICMSST + B.CMULTDESPNF + B.CMULTDESPFORANF - B.CMULTDCTOFORANF -
               VLRVERBA),
               (B.CMULTVLRNFPRES + B.CMULTIPIPRES -
                DECODE(M.METODOPRECIFICACAO, 'L', B.CMULTCREDICMSPRES + NVL(B.CMULTCREDIPIPRES,0) + NVL(B.CMULTCREDPISPRES, 0)
                                                                  + NVL(B.CMULTCREDCOFINSPRES, 0),
                                              'I', NVL(B.CMULTCREDPISPRES, 0)
                                                  + NVL(B.CMULTCREDCOFINSPRES, 0), 0)
               + B.CMULTICMSSTPRES + B.CMULTDESPNFPRES + B.CMULTDESPFORANFPRES - B.CMULTDESCVERBASELLINPRES - B.CMULTVLRDESCCONTRATOPRES + B.CMULTVLRDESCCONTRATOPISPRES + B.CMULTVLRDESCCONTRATOCOFINSPRES -
               (FC_CUSTOPRECIFCOMERVERBA(VLRVERBA, 0, H.NROEMPRESA) * (-1)) - FC_CUSTOPRECIFCOMERVBASELLOUT(X.SEQPRODUTO, H.NROEMPRESA) +
               NVL(B.VLRPRORATADIAPRECIF, 0))) * X.QTDEMBALAGEM) +
               CASE WHEN F.INDUTILCUSTOMESBASE = 'S' AND F.UTILOFICIOCSTBRUTOBASEST = 'S' AND F.INDCENARIO = 'N' THEN -- RC 121966
                    NVL((FCUSTOPONDERADOBASEICMS(TRUNC(SYSDATE), A.SEQPRODUTO, B.NROEMPRESA, C.NROTRIBUTACAO, F.NROREGTRIBUTACAO, 'C') * X.QTDEMBALAGEM), 0) *( DECODE(M.METODOPRECIFICACAO, 'L',
                               F.PERALIQUOTAICMS + NVL(F.PERALIQFCPICMS, 0), 0) / 100)
               ELSE 0
               END)
               *
               CASE
                  WHEN PROP.VALOR = 'S' AND A.PROPQTDPERDAAUTO IS NOT NULL THEN
                    A.PROPQTDPERDAAUTO
                  WHEN PROP.VALOR = 'S' AND A.SEQPRODUTOBASE IS NOT NULL AND NVL( A.PROPQTDPRODUTOBASE, 1 ) != 1 THEN
                    NVL( A.PROPQTDPRODUTOBASE, 1 )
                  WHEN ( A.SEQPRODUTOBASE IS NOT NULL AND M.UTILACRESCCUSTPRODRELAC = 'S' ) THEN
                    NVL( A.PERCACRESCCUSTORELACVIG, 1 )
                  ELSE
                    1
               END
                +
               (( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               (DECODE(Q.USACOMREPEMDESP, 'T', 0,DECODE(DECODE(P.TIPOCALCCOMISSAOSEG,
                              'E',
                              H.TIPOCALCCOMISSAO,
                              NVL(P.TIPOCALCCOMISSAOSEG, H.TIPOCALCCOMISSAO)), 
                       'F',
                       NVL(O.PERCOMISSAONORMALFS, NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0))),
                       'T',
                       COALESCE(E.PERCCOMISSAONORMAL, O.PERCOMISSAONORMALFS, TO_NUMBER(NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))),
                       'R',
                       NVL(P.PERCOMISSAOSEG, 0),
                       NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))) +
                DECODE(Q.GER1_12AVOSCOMPRECO,
                       'S',
                       ((DECODE(Q.USACOMREPEMDESP, 'T', 0,DECODE(DECODE(P.TIPOCALCCOMISSAOSEG,
                                       'E',
                                       H.TIPOCALCCOMISSAO,
                                       NVL(P.TIPOCALCCOMISSAOSEG, H.TIPOCALCCOMISSAO)),
                                'F',
                                NVL(O.PERCOMISSAONORMALFS, NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0))),
                                'T',
                                COALESCE(E.PERCCOMISSAONORMAL, O.PERCOMISSAONORMALFS, TO_NUMBER(NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))),
                                'R',
                                NVL(P.PERCOMISSAOSEG, 0),
                                NVL(DECODE(Q.USACOMREPEMDESP, 'S', NULL, N.PERCOMNORMALREP), NVL(N.PERCOMISSAONORMAL, 0)))))) / 12, 0) +
               (DECODE(NVL(M.TIPCALCMARGEM, M.TIPDIVISAO), 'A', N.PERDESPCLASSIFABC,
                                           NVL(O.PERDESPESASEGMENTO, NVL(C.PERDESPESADIVISAO, NVL(H.PERDESPOPERACIONAL, 0))))
               +
               DECODE(M.METODOPRECIFICACAO, 'B', 0,
               FBASEPISCOFINS(F.PERALIQUOTAPIS, F.PERALIQUOTACOFINS, F.PERALIQUOTAICMS, F.PERALIQFCPICMS, H.INDSUBTRAIICMSBASEPISCOFINS) +
                    H.PERCPMF + H.PERIR + H.PEROUTROIMPOSTO +
                    CASE WHEN F.INDSOMAIPIBASEICMS||ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SSS' THEN
                      (F.PERALIQUOTAICMS + DECODE(F.PERALIQICMSCALCPRECO, NULL, F.PERALIQFCPICMS, 0)) * F.PERALIQUOTAIPI / 100
                    ELSE 0 END +
                    (CASE WHEN C.INDMERCENQUADST = 'S' AND DECODE(NVL(ES.INDCALCICMSEFETIVOSUGPRECO, 'N'), 'S', ES.INDCALCICMSEFETIVOSUGPRECO, P.INDCALCICMSEFETIVOSUGPRECO) = 'S' AND F.INDCALCICMSEFETIVO = 'S' THEN
                         NVL((SELECT (NVL(G.ALIQPADRAOICMS, 0)+NVL(G.ALIQPADRAOFEM, 0))
                                FROM MAP_FAMALIQPADRAOUF G
                               WHERE G.SEQFAMILIA = L.SEQFAMILIA
                                 AND G.UF         = H.UF) * (100 - NVL(F.PERREDBCICMSEFET, 0)) /100, 0)
                     ELSE 0
                     END) + 
                    NVL(DECODE(NVL(F.INDCALCSTEMBUTPROD, 'N'), 'S', F.PERALIQUOTAICMSST + (F.PERALIQUOTAICMSST * F.PERACRESCST / 100),0),0)))) / 100))) /
               (( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) -
               DECODE(M.METODOCALCRENTAB, 'L', (
               (( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               (DECODE(M.METODOPRECIFICACAO, 'B', 0, 'I', 0,
               CASE WHEN F.INDUTILCUSTOMESBASE = 'S' AND F.UTILOFICIOCSTBRUTOBASEST = 'S' THEN
                  0
               ELSE
                  F.PERALIQUOTAICMS + NVL(F.PERALIQFCPICMS, 0)
               END
                      ) / 100))
               +
               (( ROUND((FMAXPRECOPRODEMP(X.SEQPRODUTO, X.NROEMPRESA) * X.QTDEMBALAGEM) /
                   CASE WHEN ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SS' THEN
                        ((F.PERALIQUOTAIPI + 100) / 100)
                   ELSE 1
                   END, 2) ) *
               DECODE(M.METODOPRECIFICACAO, 'B', 0,
               FBASEPISCOFINS(F.PERALIQUOTAPIS, F.PERALIQUOTACOFINS, F.PERALIQUOTAICMS, F.PERALIQFCPICMS, H.INDSUBTRAIICMSBASEPISCOFINS) +
                    H.PERCPMF + H.PERIR + H.PEROUTROIMPOSTO +
                    CASE WHEN F.INDSOMAIPIBASEICMS||ES.INDACRESCEIPISUGESTAOPRECO||H.INDFATURAIPI = 'SSS' THEN
                      (F.PERALIQUOTAICMS + DECODE(F.PERALIQICMSCALCPRECO, NULL, F.PERALIQFCPICMS, 0)) * F.PERALIQUOTAIPI / 100
                    ELSE 0 END +
                    (CASE WHEN C.INDMERCENQUADST = 'S' AND DECODE(NVL(ES.INDCALCICMSEFETIVOSUGPRECO, 'N'), 'S', ES.INDCALCICMSEFETIVOSUGPRECO, P.INDCALCICMSEFETIVOSUGPRECO) = 'S' AND F.INDCALCICMSEFETIVO = 'S' THEN
                         NVL((SELECT (NVL(G.ALIQPADRAOICMS, 0)+NVL(G.ALIQPADRAOFEM, 0))
                                FROM MAP_FAMALIQPADRAOUF G
                               WHERE G.SEQFAMILIA = L.SEQFAMILIA
                                 AND G.UF         = H.UF) * (100 - NVL(F.PERREDBCICMSEFET, 0)) /100, 0)
                     ELSE 0
                     END) + 
                    NVL(DECODE(NVL(F.INDCALCSTEMBUTPROD, 'N'), 'S', F.PERALIQUOTAICMSST + (F.PERALIQUOTAICMSST * F.PERACRESCST / 100),0),0)))/*))*/ / 100), 0) ) )
                     * 100)
AS MGMPRECOMAXVDAEMPRESA
FROM MAX_EMPRESA H,
     MAP_PRODUTO A INNER JOIN QLV_CATEGORIA@CONSINCODW QC ON A.SEQFAMILIA = QC.SEQFAMILIA AND QC.CATEGORIA_NIVEL_1 = 'BEBIDAS',
                   --INNER JOIN MRL_PRODUTOEMPRESA PE ON PE.SEQPRODUTO = A.SEQPRODUTO AND X.NROEMPRESA = PE.NROEMPRESA AND PE.STATUSCOMPRA = 'A',
     MRL_PRODUTOEMPRESA B,
     MAP_FAMDIVISAO C,
     MAP_FAMDIVCATEG D,
     MAP_CATEGORIA E,
     MAP_FAMEMBALAGEM I,
     MAP_FAMEMBALAGEM J,
     MAP_FAMEMBALAGEM K,
     MAP_FAMEMBALAGEM TR,
     MAP_FAMILIA L,
     MRL_PRODEMPSEG X,
     MAX_DIVISAO M,
     MAD_FAMSEGMENTO O,
     MAP_CLASSIFABC N,
     MAD_SEGMENTO P, MAD_PARAMETRO Q,
     MAP_FAMFORNEC R,
     MAX_PARAMETRO PD,
     MAX_EMPRESASEG ES,
     MAX_PARAMETRO PROP,
     TABLE(PKG_MAD_ADMPRECO.FBUSCATEMPSIMULACAOPRECO()) TEMP,
     TABLE(PKG_CARREGAIMPOSTO.FC_BUSCATRIBUTACAO(PNSEQPRODUTO       => A.SEQPRODUTO,
                                                 PSENTRADASAIDA     => 'S',
                                                 PNNROTRIBUTACAO    => C.NROTRIBUTACAO,
                                                 PSTIPTRIBUTACAO    => NVL(TEMP.TIPTRIBUTACAO, NVL(P.TIPTRIBUTACAOSUGPRECO, DECODE(M.TIPDIVISAO, 'A','SC','SN'))),
                                                 PNNROREGTRIBUTACAO => NVL(H.NROREGTRIBUTACAO, 0),
                                                 PSUFEMPRESA        => NVL(H.UFFORMACAOPRECO, H.UF),
                                                 PSUFCLIENTEFORN    => NVL(P.UFPADRAOSUGPRECO, H.UF),
                                                 PNNROEMPRESA       => H.NROEMPRESA,
                                                 PNORIGEM           => 3,
                                                 PDDATABASE         => TRUNC(SYSDATE))) F,
      (SELECT AA.SEQPRODUTO, AA.NROEMPRESA,
              NVL(FC5VLRVERBA(AA.SEQPRODUTO, AA.NROEMPRESA,NULL, NULL,'A'), 0) AS VLRVERBA
         FROM MRL_PRODUTOEMPRESA AA ) T
WHERE B.NROEMPRESA        =  H.NROEMPRESA
AND  A.SEQPRODUTO        =  B.SEQPRODUTO
AND  C.SEQFAMILIA        =  A.SEQFAMILIA
AND  C.NRODIVISAO        =  H.NRODIVISAO
AND  D.SEQFAMILIA        =  A.SEQFAMILIA
AND  D.NRODIVISAO        =  H.NRODIVISAO
AND  D.STATUS            =  'A'
AND  E.SEQCATEGORIA      =  D.SEQCATEGORIA
AND  E.TIPCATEGORIA      =  'M'
AND  E.ACTFAMILIA        =  'S'
AND  E.NRODIVISAO        =  H.NRODIVISAO
AND  E.STATUSCATEGOR     = 'A'
AND  I.SEQFAMILIA        =  A.SEQFAMILIA
AND  I.QTDEMBALAGEM      =  NVL(R.PADRAOEMBCOMPRAFORNEC, C.PADRAOEMBCOMPRA)
AND  J.SEQFAMILIA        =  O.SEQFAMILIA
AND  J.QTDEMBALAGEM      =  O.PADRAOEMBVENDA
AND  K.SEQFAMILIA        =  A.SEQFAMILIA
AND  K.QTDEMBALAGEM      =  X.QTDEMBALAGEM
AND  TR.SEQFAMILIA       =  A.SEQFAMILIA
AND  TR.QTDEMBALAGEM     =  NVL(C.PADRAOEMBTRANSF, O.PADRAOEMBVENDA)
AND  L.SEQFAMILIA        =  A.SEQFAMILIA
AND  X.SEQPRODUTO        =  A.SEQPRODUTO
AND  X.NROEMPRESA        =  H.NROEMPRESA
AND  M.NRODIVISAO        =  H.NRODIVISAO
AND  O.SEQFAMILIA        =  A.SEQFAMILIA
AND  O.NROSEGMENTO       =  X.NROSEGMENTO
AND  N.NROSEGMENTO       =  O.NROSEGMENTO
AND  N.CLASSIFCOMERCABC  =  O.CLASSIFCOMERCABC
AND  X.NROSEGMENTO       =  P.NROSEGMENTO
AND  Q.NROEMPRESA        =  H.NROEMPRESA
AND  R.SEQFAMILIA        =  A.SEQFAMILIA
AND  M.NRODIVISAO         = P.NRODIVISAO
AND  PD.GRUPO            =  'PRODUTO'
AND  PD.PARAMETRO        =  'UTIL_FORMA_ABASTEC_PROD'
AND  PD.NROEMPRESA       =  0
AND  ES.NROEMPRESA       =  X.NROEMPRESA
AND  ES.NROSEGMENTO      =  X.NROSEGMENTO
AND  PROP.GRUPO          =  'CONSULTA_PROD'
AND  PROP.PARAMETRO      =  'UTILIZ_PERC_PROP_BAIXA_PROD'
AND  PROP.NROEMPRESA     =  0
AND  B.SEQPRODUTO        =  T.SEQPRODUTO
AND  B.NROEMPRESA        =  T.NROEMPRESA
AND R.ROWID =  COALESCE(
                 (SELECT MIN(ID)
                    FROM MAXX_SELECROWID
                        WHERE MAXX_SELECROWID.SEQUENCIA = 4
                     AND MAXX_SELECROWID.SEQFAMILIA = R.SEQFAMILIA),
                 (SELECT MIN(M.ROWID)
                    FROM MAP_FAMFORNEC M
                   WHERE M.SEQFAMILIA = R.SEQFAMILIA
                     AND M.PRINCIPAL = 'S')
                 )
  -- PDs
      --AND X.SEQPRODUTO = 209881
      AND X.NROSEGMENTO IN (2,4,8) 
      AND X.NROEMPRESA = 1
      )

GROUP BY NROEMPRESA, SEQPRODUTO, DESCCOMPLETA, CATEG

ORDER BY 1,3


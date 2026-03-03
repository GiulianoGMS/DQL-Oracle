SELECT /*TO_CHAR(:DT1, 'DD/MM/YYYY') ||' - '|| TO_CHAR(:DT2, 'DD/MM/YYYY') DATA_FILTRO,*/ TIPO,
       LOJA, CFOP,

       'R$ '||TO_CHAR(SUM(VALOR_TOTAL_NF),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') VALOR_TOTAL_NF,
       'R$ '||TO_CHAR(SUM(ICMS),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') ICMS,
       'R$ '||TO_CHAR(SUM(PIS),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') PIS,
       'R$ '||TO_CHAR(SUM(COFINS),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') COFINS,
       'R$ '||TO_CHAR(SUM(CBS),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') CBS,
       'R$ '||TO_CHAR(SUM(IBS_UF),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') IBS_UF,
       'R$ '||TO_CHAR(SUM(IBS_MUN),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') IBS_MUN,
       'R$ '||TO_CHAR(SUM(VLR_IS),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') VLR_IS,
       'R$ '||TO_CHAR(SUM(FCP_ST),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') FCP_ST,
       'R$ '||TO_CHAR(SUM(IPI),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') IPI,
       'R$ '||TO_CHAR(SUM(ICMS_ST),'FM999G999G990D90','NLS_NUMERIC_CHARACTERS='',.''') ICMS_ST

FROM (

    /* ================= ENTRADA ================= */
    SELECT 'Entrada' TIPO,
           X.NROEMPRESA LOJA,
           I.CFOP,
           NVL(I.VLR,0) VALOR_TOTAL_NF,
           NVL(I.ICMS,0) ICMS,
           NVL(I.PIS,0) PIS,
           NVL(I.COFINS,0) COFINS,
           NVL(I.CBS,0) CBS,
           NVL(I.IBS_UF,0) IBS_UF,
           NVL(I.IBS_MUN,0) IBS_MUN,
           NVL(I.VLR_IS,0) VLR_IS,
           NVL(I.FCP_ST,0) FCP_ST,
           NVL(I.IPI,0) IPI,
           NVL(I.ICMS_ST,0) ICMS_ST
    FROM MLF_NOTAFISCAL X
    LEFT JOIN (
        SELECT b.SEQNF,
               b.CFOP,

               SUM(
                CASE 
                    WHEN a.apporigem = 26 THEN
                          (b.vlritem)
                          - NVL(b.vlrdescitem, 0)
                          - NVL(b.vlrissretido, 0)
                          - NVL(b.vlrinss, 0)
                          - NVL(b.vlrir, 0)
                          - NVL(b.vlrcsll, 0)
                          - DECODE('N','S',
                                   DECODE(b.INDRETPIS,'S', NVL(b.vlrpisretido, 0),0),
                                   NVL(b.vlrpis, 0))
                          - DECODE('N','S',
                                   DECODE(b.INDRETCOFINS,'S', NVL(b.vlrcofinsretido, 0),0),
                                   NVL(b.vlrcofins, 0))

                    ELSE
                        (
                            CASE
                                WHEN NVL(a.indimportexport,'N') = 'S'
                                     AND NVL(a.indtotnfigualbicms,'N') = 'S'
                                THEN
                                    NVL(b.bascalcicms, 0)
                                    + NVL(b.vlrtotisento, 0)
                                    + NVL(b.vlrtotoutra, 0)

                                WHEN NVL(a.indimportexport,'N') = 'S'
                                     AND NVL(a.indtotnfigualbicms,'N') = 'N'
                                THEN
                                    (b.vlritem
                                     + NVL(b.vlrdesptributitem,0)
                                     + NVL(b.vlrdespntributitem,0)
                                     + NVL(b.vlripi,0)
                                     + NVL(b.vlricmsretido,0)
                                     + NVL(b.vlricmsst,0)
                                     - NVL(b.vlrabatimento,0)
                                     - NVL(b.vlrdescitem,0)
                                     - NVL(b.vlrdescsuframa,0)
                                     + ABS(NVL(b.VLRICMS,0))
                                     + NVL(b.vlrfcpst,0)
                                     + CASE
                                           WHEN b.indconsideraimposto = 'S'
                                           THEN fc_RetornaImpReformaTotal(
                                                    pnVlrimpostoibsmun     => b.Vlrimpostoibsmun,
                                                    pnVlrimpostoibsuf      => b.Vlrimpostoibsuf,
                                                    pnVlrimpostocbs        => b.Vlrimpostocbs,
                                                    pnVlrimpostois         => b.Vlrimpostois,
                                                    pnVlrimpostoibsmunCred => b.Vlrimpostoibsmun,
                                                    pnVlrimpostoibsufCred  => b.Vlrimpostoibsuf,
                                                    pnVlrimpostocbsCred    => b.Vlrimpostocbs,
                                                    pnVlrimpostoisCred     => b.Vlrimpostois,
                                                    psTipoCalculo          => 'N',
                                                    psTipoCusto            => 'B')
                                           ELSE 0
                                       END)

                                ELSE
                                    (b.vlritem
                                     + NVL(b.vlrdesptributitem,0)
                                     + NVL(b.vlrdespntributitem,0)
                                     + NVL(b.vlripi,0)
                                     + NVL(b.vlricmsretido,0)
                                     + NVL(b.vlricmsst,0)
                                     - NVL(b.vlrabatimento,0)
                                     - NVL(b.vlrdescitem,0)
                                     - NVL(b.vlrdescsuframa,0)
                                     + NVL(b.vlrfcpst,0)
                                     + CASE
                                           WHEN b.indconsideraimposto = 'S'
                                           THEN fc_RetornaImpReformaTotal(
                                                    pnVlrimpostoibsmun     => b.Vlrimpostoibsmun,
                                                    pnVlrimpostoibsuf      => b.Vlrimpostoibsuf,
                                                    pnVlrimpostocbs        => b.Vlrimpostocbs,
                                                    pnVlrimpostois         => b.Vlrimpostois,
                                                    pnVlrimpostoibsmunCred => b.Vlrimpostoibsmun,
                                                    pnVlrimpostoibsufCred  => b.Vlrimpostoibsuf,
                                                    pnVlrimpostocbsCred    => b.Vlrimpostocbs,
                                                    pnVlrimpostoisCred     => b.Vlrimpostois,
                                                    psTipoCalculo          => 'N',
                                                    psTipoCusto            => 'B')
                                           ELSE 0
                                       END)
                            END
                        )
                END
               ) VLR,

               SUM(NVL(VLRICMS,0)) ICMS,
               SUM(NVL(b.VLRPIS,0)) PIS,
               SUM(NVL(b.VLRCOFINS,0)) COFINS,
               SUM(NVL(b.VLRIMPOSTOCBS,0)) CBS,
               SUM(NVL(b.VLRIMPOSTOIBSUF,0)) IBS_UF,
               SUM(NVL(b.VLRIMPOSTOIBSMUN,0)) IBS_MUN,
               SUM(NVL(b.VLRIMPOSTOIS,0)) VLR_IS,
               SUM(NVL(b.VLRFCPST,0)) FCP_ST,
               SUM(NVL(VLRIPI,0)) IPI,
               SUM(NVL(VLRICMSST,0)) ICMS_ST

        FROM MLF_NFITEM b
        JOIN MLF_NOTAFISCAL a ON a.SEQNF = b.SEQNF
        GROUP BY b.SEQNF, b.CFOP
    ) I ON I.SEQNF = X.SEQNF

    WHERE X.NROEMPRESA IN (#LS1)
      AND X.TIPNOTAFISCAL = 'E'
      AND X.STATUSNF != 'C'
      AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2


    UNION ALL

    /* ================= SAIDA MLF ================= */
    SELECT 'Saida' TIPO,
           X.NROEMPRESA LOJA, I.CFOP,
           FVALORTOTALNF(X.ROWID,'N') VALOR_TOTAL_NF,
           NVL(I.ICMS,0) ICMS,
           NVL(I.PIS,0) PIS,
           NVL(I.COFINS,0) COFINS,
           NVL(I.CBS,0) CBS,
           NVL(I.IBS_UF,0) IBS_UF,
           NVL(I.IBS_MUN,0) IBS_MUN,
           NVL(I.VLR_IS,0) VLR_IS,
           NVL(I.FCP_ST,0) FCP_ST,
           NVL(I.IPI,0) IPI,
           NVL(I.ICMS_ST,0) ICMS_ST
    FROM MLF_NOTAFISCAL X
    LEFT JOIN (
        SELECT SEQNF, CFOP,
               SUM(VLRICMS) ICMS,
               SUM(VLRPIS) PIS,
               SUM(VLRCOFINS) COFINS,
               SUM(VLRIMPOSTOCBS) CBS,
               SUM(VLRIMPOSTOIBSUF) IBS_UF,
               SUM(VLRIMPOSTOIBSMUN) IBS_MUN,
               SUM(VLRIMPOSTOIS) VLR_IS,
               SUM(VLRFCPST) FCP_ST,
               SUM(VLRIPI) IPI,
               SUM(VLRICMSST) ICMS_ST
        FROM MLF_NFITEM
        GROUP BY SEQNF, CFOP
    ) I ON I.SEQNF = X.SEQNF
    WHERE X.NROEMPRESA IN (#LS1)
      AND X.TIPNOTAFISCAL = 'S'
      AND X.STATUSNFE = 4
      AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2


    UNION ALL

    /* ================= SAIDA MFL ================= */
    SELECT 'Saida' TIPO, 
           X.NROEMPRESA LOJA, I.CFOP,
           vlr vlr,
           NVL(I.ICMS,0) ICMS,
           NVL(I.PIS,0) PIS,
           NVL(I.COFINS,0) COFINS,
           NVL(I.CBS,0) CBS,
           NVL(I.IBS_UF,0) IBS_UF,
           NVL(I.IBS_MUN,0) IBS_MUN,
           NVL(I.VLR_IS,0) VLR_IS,
           NVL(I.FCP_ST,0) FCP_ST,
           NVL(I.IPI,0) IPI,
           NVL(I.ICMS_ST,0) ICMS_ST
    FROM MFL_DOCTOFISCAL X 
    LEFT JOIN (
        SELECT SEQNF, CFOP,
               sum( case when nvl(b.indcomptotnfremessa,'S') = 'N' then 0
                     else b.vlritem + nvl(b.vlracrescimo, 0) - nvl(b.vlrdesconto, 0)- round(nvl(0, 0), 2)
                     end
                   ) vlr,
               SUM(NVL(VLRICMS,0)) ICMS,
               SUM(NVL(VLRPIS,0)) PIS,
               SUM(NVL(VLRCOFINS,0)) COFINS,
               SUM(NVL(VLRIMPOSTOCBS,0)) CBS,
               SUM(NVL(VLRIMPOSTOIBSUF,0)) IBS_UF,
               SUM(NVL(VLRIMPOSTOIBSMUN,0)) IBS_MUN,
               SUM(NVL(VLRIMPOSTOIS,0)) VLR_IS,
               SUM(NVL(VLRFCPST,0)) FCP_ST,
               SUM(NVL(VLRIPI,0)) IPI,
               SUM(NVL(VLRICMSST,0)) ICMS_ST
        FROM MFL_DFITEM b WHERE B.STATUSITEM != 'C'
        GROUP BY SEQNF, CFOP
    ) I ON I.SEQNF = X.SEQNF
    WHERE X.NROEMPRESA IN (#LS1)
      AND X.STATUSNFE = 4
      AND X.STATUSDF = 'V'
      AND X.DTAMOVIMENTO BETWEEN :DT1 AND :DT2

)
GROUP BY TIPO, LOJA, CFOP
ORDER BY LOJA, TIPO;

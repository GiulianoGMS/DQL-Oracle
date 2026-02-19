SELECT TIPO,
       LOJA,
       SUM(VALOR_TOTAL_NF) VALOR_TOTAL_NF,
       SUM(ICMS) ICMS,
       SUM(PIS) PIS,
       SUM(COFINS) COFINS,
       SUM(CBS) CBS,
       SUM(IBS_UF) IBS_UF,
       SUM(IBS_MUN) IBS_MUN,
       SUM(VLR_IS) VLR_IS,
       SUM(FCP_ST) FCP_ST,
       SUM(IPI) IPI,
       SUM(ICMS_ST) ICMS_ST
  FROM (
        
        SELECT 'Entrada' TIPO,
                X.NROEMPRESA LOJA,
                SUM(FVALORTOTALNF(X.ROWID, 'N')) VALOR_TOTAL_NF,
                SUM(NVL(XI.VLRICMS, 0)) ICMS,
                SUM(NVL(XI.VLRPIS, 0)) PIS,
                SUM(NVL(XI.VLRCOFINS, 0)) COFINS,
                SUM(NVL(XI.VLRIMPOSTOCBS, 0)) CBS,
                SUM(NVL(XI.VLRIMPOSTOIBSUF, 0)) IBS_UF,
                SUM(NVL(XI.VLRIMPOSTOIBSMUN, 0)) IBS_MUN,
                SUM(NVL(XI.VLRIMPOSTOIS, 0)) VLR_IS,
                SUM(NVL(XI.VLRFCPST, 0)) FCP_ST,
                SUM(NVL(XI.VLRIPI, 0)) IPI,
                SUM(NVL(XI.VLRICMSST,0)) ICMS_ST
          FROM MLF_NOTAFISCAL X
         INNER JOIN MLF_NFITEM XI
            ON XI.SEQNF = X.SEQNF
         WHERE X.NROEMPRESA IN (#LS1)
           AND X.TIPNOTAFISCAL = 'E'
           AND X.DTAENTRADA BETWEEN :DT1 AND :DT2
         GROUP BY X.NROEMPRESA
        
        UNION ALL
        
        SELECT 'Saida' TIPO,
                X.NROEMPRESA LOJA,
                SUM(FVALORTOTALNF(X.ROWID, 'N')) VALOR_TOTAL_NF,
                SUM(NVL(XI.VLRICMS, 0)) ICMS,
                SUM(NVL(XI.VLRPIS, 0)) PIS,
                SUM(NVL(XI.VLRCOFINS, 0)) COFINS,
                SUM(NVL(XI.VLRIMPOSTOCBS, 0)) CBS,
                SUM(NVL(XI.VLRIMPOSTOIBSUF, 0)) IBS_UF,
                SUM(NVL(XI.VLRIMPOSTOIBSMUN, 0)) IBS_MUN,
                SUM(NVL(XI.VLRIMPOSTOIS, 0)) VLR_IS,
                SUM(NVL(XI.VLRFCPST, 0)) FCP_ST,
                SUM(NVL(XI.VLRIPI, 0)) IPI,
                SUM(NVL(XI.VLRICMSST,0)) ICMS_ST
          FROM MLF_NOTAFISCAL X
         INNER JOIN MLF_NFITEM XI
            ON XI.SEQNF = X.SEQNF
         WHERE X.DTAEMISSAO BETWEEN :DT1 AND :DT2
           AND X.TIPNOTAFISCAL = 'S'
           AND X.STATUSNFE = 4
           AND X.NROEMPRESA IN (#LS1)
         GROUP BY X.NROEMPRESA
        
        UNION ALL
        
        SELECT 'Saida' TIPO,
                X.NROEMPRESA LOJA,
                SUM(FVALORTOTALNF(X.ROWID, 'D')) VALOR_TOTAL_NF,
                SUM(NVL(XI.VLRICMS, 0)) ICMS,
                SUM(NVL(XI.VLRPIS, 0)) PIS,
                SUM(NVL(XI.VLRCOFINS, 0)) COFINS,
                SUM(NVL(XI.VLRIMPOSTOCBS, 0)) CBS,
                SUM(NVL(XI.VLRIMPOSTOIBSUF, 0)) IBS_UF,
                SUM(NVL(XI.VLRIMPOSTOIBSMUN, 0)) IBS_MUN,
                SUM(NVL(XI.VLRIMPOSTOIS, 0)) VLR_IS,
                SUM(NVL(XI.VLRFCPST, 0)) FCP_ST,
                SUM(NVL(XI.VLRIPI, 0)) IPI,
                SUM(NVL(XI.VLRICMSST,0)) ICMS_ST
          FROM MFL_DOCTOFISCAL X
         INNER JOIN MFL_DFITEM XI
            ON XI.SEQNF = X.SEQNF
         WHERE X.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
           AND X.STATUSNFE = 4
           AND X.NROEMPRESA IN (#LS1)
         GROUP BY X.NROEMPRESA
        
        )
 GROUP BY TIPO, LOJA
 ORDER BY LOJA, TIPO;

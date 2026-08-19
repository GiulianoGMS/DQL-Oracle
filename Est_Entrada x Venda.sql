SELECT /*+ OPTIMIZER_FEATURES_ENABLE('11.2.0.4') */
       MES,
       NROEMPRESA,
       SEQPRODUTO,
       DESCCOMPLETA,
       SUM(QTD_ENTRADA) AS QTD_ENTRADA,
       SUM(QTD_VENDA)   AS QTD_VENDA
FROM
(
    /* ============================================================
       ENTRADAS
       ============================================================ */
    SELECT
        T.MES,
        X.NROEMPRESA,
        XI.SEQPRODUTO,
        P.DESCCOMPLETA,
        XI.QUANTIDADE AS QTD_ENTRADA,
        0 AS QTD_VENDA
    FROM MLF_NOTAFISCAL X INNER JOIN MLF_NFITEM XI ON XI.SEQNF = X.SEQNF
                          INNER JOIN DIM_TEMPO T ON T.DTA = X.DTAENTRADA
                          INNER JOIN MAP_PRODUTO P
        ON P.SEQPRODUTO = XI.SEQPRODUTO
    WHERE X.NROEMPRESA IN (11,59)
      AND X.CODGERALOPER != 38
      AND X.DTAENTRADA >= DATE '2026-01-01'
      AND (
             P.DESCCOMPLETA LIKE '%VAC%PIC%'
          OR P.DESCCOMPLETA LIKE '%VAC%FILE%MI%'
      )
      
   

    UNION ALL

    /* ============================================================
       VENDAS
       ============================================================ */
    SELECT
        T.MES,
        X.NROEMPRESA,
        XI.SEQPRODUTO,
        P.DESCCOMPLETA,
        0 AS QTD_ENTRADA,
        XI.QUANTIDADE AS QTD_VENDA
    FROM MFL_DOCTOFISCAL X INNER JOIN MFL_DFITEM XI ON XI.SEQNF = X.SEQNF
                           INNER JOIN DIM_TEMPO T ON T.DTA = X.DTAMOVIMENTO
                           INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = XI.SEQPRODUTO
    WHERE X.NROEMPRESA IN (11,59)
      AND X.STATUSDF = 'V'
      AND X.DTAMOVIMENTO >= DATE '2026-01-01'
      AND (
             P.DESCCOMPLETA LIKE '%VAC%PIC%'
          OR P.DESCCOMPLETA LIKE '%VAC%FILE%MI%'
      )
 
)
GROUP BY
    MES,
    NROEMPRESA,
    SEQPRODUTO,
    DESCCOMPLETA
ORDER BY
    MES,
    NROEMPRESA,
    SEQPRODUTO;

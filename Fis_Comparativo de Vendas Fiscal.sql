SELECT *
  FROM (SELECT DTAMOVIMENTO,
               
               NROEMPRESA,
               
               'R$ ' || TO_CHAR(SUM((VLRVENDA)),
                                'FM999G999G999D90',
                                'NLS_NUMERIC_CHARACTERS='',.''') VENDA,
               
               ORIGEM,
               TO_CHAR(:DT1, 'DD/MM/YYYY') DATA_INICIO,
               TO_CHAR(:DT2, 'DD/MM/YYYY') DATA_FIM
        
          FROM (SELECT TO_CHAR(C.DTAMOVIMENTO, 'mm/yyyy') DTAMOVIMENTO,
                       
                       C.NROEMPRESA,
                       SUM(D.VLRITEM) - SUM(D.VLRDESCONTO) VLRVENDA,
                       'mfl_dfitem' ORIGEM
                
                  FROM MFL_DOCTOFISCAL C, MFL_DFITEM D
                
                 WHERE C.SEQNF = D.SEQNF
                       AND C.NROEMPRESA IN (#LS1)
                       AND C.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
                       AND D.STATUSITEM = 'V'
                       AND C.CODGERALOPER IN (810, 910)
                
                 GROUP BY C.DTAMOVIMENTO, C.NROEMPRESA
                
                UNION ALL
                
                SELECT TO_CHAR(F.DTAMOVIMENTO, 'mm/yyyy'),
                       F.NROEMPRESA,
                       SUM(F.VLRLANCAMENTO),
                       'pdv_doctopagto'
                
                  FROM PDV_DOCTO E, PDV_DOCTOPAGTO F
                 WHERE E.SEQDOCTO = F.SEQDOCTO
                       AND E.NROEMPRESA IN (#LS1)
                       AND E.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
                       AND E.TIPODOCTO = 'CF'
                       AND E.STATUSDOCTO = 'V'
                       AND F.STATUSPAGTO = 'F'
                       AND E.CODGERALOPER IN (810, 910)
                
                 GROUP BY F.DTAMOVIMENTO, F.NROEMPRESA
                
                UNION ALL
                
                SELECT TO_CHAR(F.DTAMOVIMENTO, 'mm/yyyy'),
                       F.NROEMPRESA,
                       SUM(F.VALOR),
                       'xml'
                
                  FROM C5_LOG_XML F
                
                 WHERE F.NROEMPRESA IN (#LS1)
                       AND F.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
                 GROUP BY F.DTAMOVIMENTO, F.NROEMPRESA)
        
         GROUP BY DTAMOVIMENTO, NROEMPRESA, ORIGEM
        
        UNION ALL
        
        SELECT NULL,
               TO_NUMBER(#LS1) NROEMPRESA,
               NULL VENDA,
               NULL ORIGEM,
               TO_CHAR(:DT1, 'DD/MM/YYYY') DATA_INICIO,
               TO_CHAR(:DT2, 'DD/MM/YYYY') DATA_FIM
        
          FROM DUAL
        
         ORDER BY 1, 2, 4)

 WHERE DTAMOVIMENTO IS NULL
       AND ROWNUM = 1
       OR DTAMOVIMENTO IS NOT NULL

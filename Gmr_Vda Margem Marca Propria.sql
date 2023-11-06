ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT E.NOMEREDUZIDO EMPRESA,
       (SELECT SUM((DECODE('N',
                   'S',
                   AA3.VLRITEMSEMDESC,
                   'V',
                   AA3.VLRITEMSEMDESC,
                   AA3.VLRITEM) -
           (DECODE('N',
                    'S',
                    AA3.VLRDEVOLITEMSEMDESC,
                    'V',
                    AA3.VLRDEVOLITEMSEMDESC,
                    AA3.VLRDEVOLITEM))))
   
    FROM MADMV_ABCDISTRIBPROD AA3, MAP_FAMEMBALAGEM K, MAX_EMPRESA E, MAX_DIVISAO DV, MAP_PRODACRESCCUSTORELAC PR, MAP_PRODUTO PB, MAP_PRODUTO A 
   
  WHERE AA3.DTAENTRADASAIDA BETWEEN :DT1 AND :DT2
    AND K.SEQFAMILIA = A.SEQFAMILIA
    AND PB.SEQPRODUTO = AA3.SEQPRODUTO
    AND A.SEQPRODUTO = AA3.SEQPRODUTO
    AND AA3.NRODIVISAO = DV.NRODIVISAO
    AND AA3.SEQPRODUTO = PR.SEQPRODUTO(+)
    AND AA3.DTAENTRADASAIDA = PR.DTAMOVIMENTACAO(+)
    AND K.QTDEMBALAGEM = 1
    AND AA3.NROEMPRESA = E.NROEMPRESA
    AND AA3.NROEMPRESA = A3.NROEMPRESA
    AND DECODE(AA3.TIPTABELA, 'S', AA3.CGOACMCOMPRAVENDA, AA3.ACMCOMPRAVENDA) IN ( 'S', 'I' )
    AND A.SEQPRODUTO = :NR1)
    
    VLRVDA_PROD,
    
    ---------------========================
    
    (SELECT ROUND((
       
       SUM(ROUND(AA3.VLRITEM - NVL(AA3.VLRIPIPRECOVDA, 0) -
                 ((((AA3.CMDIAVLRNF + AA3.CMDIAIPI - AA3.CMDIACREDICMS -
                 NVL(AA3.CMDIACREDPIS, 0) - NVL(AA3.CMDIACREDCOFINS, 0) +
                 AA3.CMDIAICMSST + AA3.CMDIADESPNF + AA3.CMDIADESPFORANF -
                 (AA3.CMDIADCTOFORANF - CASE
                   WHEN 'L' = 'L' THEN
                    0
                   ELSE
                    AA3.CMULTIMPOSTOPRESUM
                 END)) *
                 DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) * CASE
                   WHEN DV.UTILACRESCCUSTPRODRELAC = 'S' AND
                        PB.SEQPRODUTOBASE IS NOT NULL THEN
                    COALESCE(PR.PERCACRESCCUSTORELACVIG, 1)
                   ELSE
                    1
                 END) * AA3.QTDITEM) - NVL(AA3.VLREMBDESCRESSARCST, 0) - CASE
                   WHEN 'N' = 'S' THEN
                    AA3.VLRDESCACORDOVERBAPDV
                   ELSE
                    0
                 END) - (DECODE(AA3.ACMCOMPRAVENDA,
                                'I',
                                0,
                                AA3.ICMSITEM + NVL(AA3.VLRFCPICMS, 0) +
                                AA3.PISITEM + AA3.COFINSITEM)) -
                 (DECODE(AA3.ACMCOMPRAVENDA,
                         'I',
                         (AA3.VLRITEM * (AA3.PERCPMF + AA3.PEROUTROIMPOSTO) / 100),
                         DECODE(AA3.QTDVDACDIA * AA3.QTDITEM,
                                0,
                                0,
                                AA3.VLRIMPOSTOVDA / AA3.QTDVDACDIA * AA3.QTDITEM))) -
                 (NVL(AA3.VLRDESPOPERACIONALITEM,
                      DECODE(AA3.QTDVDACDIA * AA3.QTDITEM,
                             0,
                             0,
                             AA3.VLRDESPESAVDA / AA3.QTDVDACDIA * AA3.QTDITEM))) +
                 (DECODE(AA3.QTDVDACDIA * AA3.QTDITEM,
                         0,
                         0,
                         AA3.VLRVERBAVDA *
                         DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) /
                         AA3.QTDVDACDIA * AA3.QTDITEM)) -
                 AA3.VLRTOTCOMISSAOITEM - 0 - NVL(AA3.VLRICMSSTEMBUTPROD, 0) -
                 AA3.VLRDEVOLITEM - NVL(AA3.VLRIPIPRECODEVOL, 0) +
                 (((AA3.CMDIAVLRNF + AA3.CMDIAIPI - AA3.CMDIACREDICMS -
                 NVL(AA3.CMDIACREDPIS, 0) - NVL(AA3.CMDIACREDCOFINS, 0) +
                 AA3.CMDIAICMSST + AA3.CMDIADESPNF + AA3.CMDIADESPFORANF -
                 (AA3.CMDIADCTOFORANF - CASE
                   WHEN 'L' = 'L' THEN
                    0
                   ELSE
                    AA3.CMULTIMPOSTOPRESUM
                 END)) *
                 DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) * CASE
                   WHEN DV.UTILACRESCCUSTPRODRELAC = 'S' AND
                        PB.SEQPRODUTOBASE IS NOT NULL THEN
                    COALESCE(PR.PERCACRESCCUSTORELACVIG, 1)
                   ELSE
                    1
                 END) * AA3.QTDDEVOLITEM) +
                 (DECODE(AA3.ACMCOMPRAVENDA,
                         'I',
                         0,
                         AA3.ICMSDEVOLITEM + NVL(AA3.DVLRFCPICMS, 0) +
                         AA3.PISDEVOLITEM + AA3.COFINSDEVOLITEM)) +
                 (DECODE(AA3.ACMCOMPRAVENDA,
                         'I',
                         (AA3.VLRDEVOLITEM *
                         (AA3.PERCPMF + AA3.PEROUTROIMPOSTO) / 100),
                         DECODE(AA3.QTDVDACDIA * AA3.QTDDEVOLITEM,
                                0,
                                0,
                                AA3.VLRIMPOSTOVDA / AA3.QTDVDACDIA *
                                AA3.QTDDEVOLITEM))) +
                 NVL(AA3.VLRDESPOPERACIONALITEMDEVOL,
                     (DECODE(AA3.QTDVDACDIA * AA3.QTDDEVOLITEM,
                             0,
                             0,
                             AA3.VLRDESPESAVDA / AA3.QTDVDACDIA *
                             AA3.QTDDEVOLITEM))) -
                 (DECODE(AA3.QTDVDACDIA * AA3.QTDDEVOLITEM,
                         0,
                         0,
                         0 *
                         DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) /
                         AA3.QTDVDACDIA * AA3.QTDDEVOLITEM)) +
                 AA3.VLRTOTCOMISSAOITEMDEVOL + 0 +
                 NVL(AA3.VLRICMSSTEMBUTPRODDEV, 0),
                 2)) / SUM((DECODE('N',
                   'S',
                   AA3.VLRITEMSEMDESC,
                   'V',
                   AA3.VLRITEMSEMDESC,
                   AA3.VLRITEM) -
           (DECODE('N',
                    'S',
                    AA3.VLRDEVOLITEMSEMDESC,
                    'V',
                    AA3.VLRDEVOLITEMSEMDESC,
                    AA3.VLRDEVOLITEM))))) * 100,2)
                    
   FROM MADMV_ABCDISTRIBPROD AA3, MAP_FAMEMBALAGEM K, MAX_EMPRESA E, MAX_DIVISAO DV, MAP_PRODACRESCCUSTORELAC PR, MAP_PRODUTO PB, MAP_PRODUTO A 
   
  WHERE AA3.DTAENTRADASAIDA BETWEEN :DT1 AND :DT2
    AND K.SEQFAMILIA = A.SEQFAMILIA
    AND PB.SEQPRODUTO = AA3.SEQPRODUTO
    AND A.SEQPRODUTO = AA3.SEQPRODUTO
    AND AA3.NRODIVISAO = DV.NRODIVISAO
    AND AA3.SEQPRODUTO = PR.SEQPRODUTO(+)
    AND AA3.DTAENTRADASAIDA = PR.DTAMOVIMENTACAO(+)
    AND K.QTDEMBALAGEM = 1
    AND AA3.NROEMPRESA = E.NROEMPRESA
    AND AA3.NROEMPRESA = A3.NROEMPRESA
    AND DECODE(AA3.TIPTABELA, 'S', AA3.CGOACMCOMPRAVENDA, AA3.ACMCOMPRAVENDA) IN ( 'S', 'I' )
    AND AA3.SEQPRODUTO = :NR1) 
    MARGEM_PROD,
    
    ---------------========================

       SUM((DECODE('N',
                   'S',
                   A3.VLRITEMSEMDESC,
                   'V',
                   A3.VLRITEMSEMDESC,
                   A3.VLRITEM) -
           (DECODE('N',
                    'S',
                    A3.VLRDEVOLITEMSEMDESC,
                    'V',
                    A3.VLRDEVOLITEMSEMDESC,
                    A3.VLRDEVOLITEM)))) AS VLRVENDA_CATEG, 
    ROUND((
       
       SUM(ROUND(A3.VLRITEM - NVL(A3.VLRIPIPRECOVDA, 0) -
                 ((((A3.CMDIAVLRNF + A3.CMDIAIPI - A3.CMDIACREDICMS -
                 NVL(A3.CMDIACREDPIS, 0) - NVL(A3.CMDIACREDCOFINS, 0) +
                 A3.CMDIAICMSST + A3.CMDIADESPNF + A3.CMDIADESPFORANF -
                 (A3.CMDIADCTOFORANF - CASE
                   WHEN 'L' = 'L' THEN
                    0
                   ELSE
                    A3.CMULTIMPOSTOPRESUM
                 END)) *
                 DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) * CASE
                   WHEN DV.UTILACRESCCUSTPRODRELAC = 'S' AND
                        PB.SEQPRODUTOBASE IS NOT NULL THEN
                    COALESCE(PR.PERCACRESCCUSTORELACVIG, 1)
                   ELSE
                    1
                 END) * A3.QTDITEM) - NVL(A3.VLREMBDESCRESSARCST, 0) - CASE
                   WHEN 'N' = 'S' THEN
                    A3.VLRDESCACORDOVERBAPDV
                   ELSE
                    0
                 END) - (DECODE(A3.ACMCOMPRAVENDA,
                                'I',
                                0,
                                A3.ICMSITEM + NVL(A3.VLRFCPICMS, 0) +
                                A3.PISITEM + A3.COFINSITEM)) -
                 (DECODE(A3.ACMCOMPRAVENDA,
                         'I',
                         (A3.VLRITEM * (A3.PERCPMF + A3.PEROUTROIMPOSTO) / 100),
                         DECODE(A3.QTDVDACDIA * A3.QTDITEM,
                                0,
                                0,
                                A3.VLRIMPOSTOVDA / A3.QTDVDACDIA * A3.QTDITEM))) -
                 (NVL(A3.VLRDESPOPERACIONALITEM,
                      DECODE(A3.QTDVDACDIA * A3.QTDITEM,
                             0,
                             0,
                             A3.VLRDESPESAVDA / A3.QTDVDACDIA * A3.QTDITEM))) +
                 (DECODE(A3.QTDVDACDIA * A3.QTDITEM,
                         0,
                         0,
                         A3.VLRVERBAVDA *
                         DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) /
                         A3.QTDVDACDIA * A3.QTDITEM)) -
                 A3.VLRTOTCOMISSAOITEM - 0 - NVL(A3.VLRICMSSTEMBUTPROD, 0) -
                 A3.VLRDEVOLITEM - NVL(A3.VLRIPIPRECODEVOL, 0) +
                 (((A3.CMDIAVLRNF + A3.CMDIAIPI - A3.CMDIACREDICMS -
                 NVL(A3.CMDIACREDPIS, 0) - NVL(A3.CMDIACREDCOFINS, 0) +
                 A3.CMDIAICMSST + A3.CMDIADESPNF + A3.CMDIADESPFORANF -
                 (A3.CMDIADCTOFORANF - CASE
                   WHEN 'L' = 'L' THEN
                    0
                   ELSE
                    A3.CMULTIMPOSTOPRESUM
                 END)) *
                 DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) * CASE
                   WHEN DV.UTILACRESCCUSTPRODRELAC = 'S' AND
                        PB.SEQPRODUTOBASE IS NOT NULL THEN
                    COALESCE(PR.PERCACRESCCUSTORELACVIG, 1)
                   ELSE
                    1
                 END) * A3.QTDDEVOLITEM) +
                 (DECODE(A3.ACMCOMPRAVENDA,
                         'I',
                         0,
                         A3.ICMSDEVOLITEM + NVL(A3.DVLRFCPICMS, 0) +
                         A3.PISDEVOLITEM + A3.COFINSDEVOLITEM)) +
                 (DECODE(A3.ACMCOMPRAVENDA,
                         'I',
                         (A3.VLRDEVOLITEM *
                         (A3.PERCPMF + A3.PEROUTROIMPOSTO) / 100),
                         DECODE(A3.QTDVDACDIA * A3.QTDDEVOLITEM,
                                0,
                                0,
                                A3.VLRIMPOSTOVDA / A3.QTDVDACDIA *
                                A3.QTDDEVOLITEM))) +
                 NVL(A3.VLRDESPOPERACIONALITEMDEVOL,
                     (DECODE(A3.QTDVDACDIA * A3.QTDDEVOLITEM,
                             0,
                             0,
                             A3.VLRDESPESAVDA / A3.QTDVDACDIA *
                             A3.QTDDEVOLITEM))) -
                 (DECODE(A3.QTDVDACDIA * A3.QTDDEVOLITEM,
                         0,
                         0,
                         0 *
                         DECODE('S', 'N', 1, NVL(PB.PROPQTDPRODUTOBASE, 1)) /
                         A3.QTDVDACDIA * A3.QTDDEVOLITEM)) +
                 A3.VLRTOTCOMISSAOITEMDEVOL + 0 +
                 NVL(A3.VLRICMSSTEMBUTPRODDEV, 0),
                 2)) / SUM((DECODE('N',
                   'S',
                   A3.VLRITEMSEMDESC,
                   'V',
                   A3.VLRITEMSEMDESC,
                   A3.VLRITEM) -
           (DECODE('N',
                    'S',
                    A3.VLRDEVOLITEMSEMDESC,
                    'V',
                    A3.VLRDEVOLITEMSEMDESC,
                    A3.VLRDEVOLITEM))))) * 100,2) MARGEM_CATEG
                    
   FROM MADMV_ABCDISTRIBPROD A3, MAP_FAMEMBALAGEM K, MAX_EMPRESA E, MAX_DIVISAO DV, MAP_PRODACRESCCUSTORELAC PR, MAP_PRODUTO PB, MAP_PRODUTO A 
   
  WHERE A3.DTAENTRADASAIDA BETWEEN :DT1 AND :DT2
    AND K.SEQFAMILIA = A.SEQFAMILIA
    AND PB.SEQPRODUTO = A3.SEQPRODUTO
    AND A.SEQPRODUTO = A3.SEQPRODUTO
    AND A3.NRODIVISAO = DV.NRODIVISAO
    AND A3.SEQPRODUTO = PR.SEQPRODUTO(+)
    AND A3.DTAENTRADASAIDA = PR.DTAMOVIMENTACAO(+)
    AND K.QTDEMBALAGEM = 1
    AND A3.NROEMPRESA = E.NROEMPRESA
    AND DECODE(A3.TIPTABELA, 'S', A3.CGOACMCOMPRAVENDA, A3.ACMCOMPRAVENDA) IN ( 'S', 'I' )
    AND A3.SEQPRODUTO IN (SELECT SEQPRODUTO FROM MAP_PRODUTO X WHERE SEQFAMILIA IN (SELECT SEQFAMILIA FROM DIM_CATEGORIA@CONSINCODW X WHERE CATEGORIAN3 = #LS1))

    GROUP BY A3.NROEMPRESA, E.NROEMPRESA,
    E.NOMEREDUZIDO,
    E.NROEMPRESA,
    E.NOMEREDUZIDO,
    E.NOMEREDUZIDO,
    TO_NUMBER( NULL ),
    TO_NUMBER( NULL ),
    TO_NUMBER( NULL ),
    NULL

    ORDER BY 1

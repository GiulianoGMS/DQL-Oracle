-- QRP em https://github.com/GiulianoGMS/QRPs/blob/main/RelNfsEntradasV2.QRP

SELECT NROEMPRESA, 'R$ '||TO_CHAR(SUM(VALORNF), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALORNF, INICIO, FIM, 
(SELECT A.NOMEREDUZIDO FROM GE_EMPRESA A WHERE A.NROEMPRESA = AA.NROEMPRESA) EMPRESA, CODGERAL, COUNT(1) QTD FROM (

SELECT DISTINCT XX.*
  FROM (SELECT NUMERONF,
               MODELONF,
               CGO,
               NROEMPRESA,
               NOMERAZAO,
               DTAENTRADA,
               VALORNF,
               ORIGEM,
               TO_CHAR(:DT1, 'DD/MM/YYYY') AS INICIO,
               TO_CHAR(:DT2, 'DD/MM/YYYY') AS FIM,
               NVL(:LS1, 'TODOS') EMPRESA,
               NVL(:LS2, 'TODOS') CODGERAL
        
          FROM (SELECT NUMERONF,
                       (SELECT F.MODELONF
                          FROM CONSINCO.MLF_NOTAFISCAL F
                         WHERE F.SEQNF = CONSINCO.MLFV_NFRECEBIDAEMP.SEQNF) MODELONF,
                       CODGERALOPER AS CGO,
                       NROEMPRESA,
                       TO_CHAR(DTAENTRADA, 'DD/MM/YYYY') DTAENTRADA,
                       MLFV_NFRECEBIDAEMP.SEQFORNECEDOR || ' - ' || NOMERAZAO AS NOMERAZAO,
                       SUM(CONSINCO.FVALORTOTALITEMNF(ID_NF, ID_ITEMNF, 'N')) AS VALORNF,
                       'COMERCIAL' ORIGEM
                  FROM CONSINCO.MLFV_NFRECEBIDAEMP
                 WHERE NRODIVISAO = 1
                   AND (SELECT F.STATUSNF
                          FROM CONSINCO.MLF_NOTAFISCAL F
                         WHERE F.SEQNF = CONSINCO.MLFV_NFRECEBIDAEMP.SEQNF) <> 'C'
                   AND NOMEREDUZIDO IN (#LS1)
                   AND CODGERALOPER IN (#LS2)
                   AND CODGERALOPER NOT IN (612, 67)
                   AND DTARECEBIMENTO BETWEEN :DT1 AND :DT2
                   AND CODGERALOPER != 05
                 GROUP BY DTAENTRADA,
                          NUMERONF,
                          SEQFORNECEDOR,
                          NOMERAZAO,
                          CODGERALOPER,
                          SEQNF,
                          NROEMPRESA
                
                UNION ALL
                
                SELECT K.NRONOTA AS NUMERONF,
                       K.CODMODELO AS MODELONF,
                       K.CGO,
                       K.NROEMPRESA,
                       TO_CHAR(K.DTAENTRADA, 'DD/MM/YYYY') DTAENTRADA,
                       (SELECT L.NOMERAZAO
                          FROM CONSINCO.GE_PESSOA L
                         WHERE L.SEQPESSOA = K.SEQPESSOA) RAZAO,
                       (K.VALOR - NVL(K.VLRDESCONTOS, 0)) VALORNF,
                       'ORÇAMENTO' ORIGEM
                  FROM CONSINCO.OR_NFDESPESA K
                 INNER JOIN CONSINCO.GE_EMPRESA KK
                    ON (K.NROEMPRESA = KK.NROEMPRESA)
                 INNER JOIN CONSINCO.GE_CGO CGO
                    ON (K.CGO = CGO.CGO)
                 WHERE K.SITUACAO = 'I'
                   AND K.DTAENTRADA BETWEEN :DT1 AND :DT2
                   AND K.CGO NOT IN (999, 8, 9)
                   AND K.CODMODELO NOT IN (99)
                   AND K.CGO IN (#LS2)
                   AND KK.NOMEREDUZIDO IN (#LS1)
                   AND K.CGO != 05
                UNION ALL
                
                SELECT G.NUMERONF,
                       G.MODELONF,
                       G.CODGERALOPER,
                       G.NROEMPRESA,
                       TO_CHAR(G.DTAENTRADA, 'DD/MM/YYYY') DTAENTRADA,
                       (SELECT L.SEQPESSOA || ' - ' || L.NOMERAZAO
                          FROM CONSINCO.GE_PESSOA L
                         WHERE L.SEQPESSOA = G.SEQPESSOA) RAZAO,
                       CASE
                         WHEN G.CODGERALOPER IN (67) THEN
                          CASE
                            WHEN SUM(GG.VLRICMSST + GG.VLRFCPST + GG.VLRITEM) = 0 THEN
                             SUM(GG.VLRIPI)
                            ELSE
                             SUM(GG.VLRICMSST + GG.VLRFCPST + GG.VLRITEM)
                          END
                         WHEN G.CODGERALOPER IN (929) THEN
                          SUM(NVL(GG.VLRICMSST, 0) + NVL(GG.VLRFCPST, 0))
                         WHEN G.CODGERALOPER IN (612, 614, 616) THEN
                          SUM(GG.VLRITEM + GG.VLRDESPNTRIBUTITEM +
                              GG.VLRDESPTRIBUTITEM)
                         ELSE
                          SUM(GG.VLRITEM)
                       END VALORNF,
                       'COMERCIAL' ORIGEM
                  FROM CONSINCO.MLF_NOTAFISCAL G
                 INNER JOIN CONSINCO.MLF_NFITEM GG
                    ON (GG.SEQNF = G.SEQNF)
                 INNER JOIN CONSINCO.GE_EMPRESA EMP
                    ON (EMP.NROEMPRESA = G.NROEMPRESA)
                 WHERE EMP.NOMEREDUZIDO IN (#LS1)
                   AND G.CODGERALOPER IN
                       (67, 201, 929, 612, 614, 132, 201, 214, 215, 616, 134)
                   AND G.STATUSNF = 'V'
                   AND G.DTAENTRADA BETWEEN :DT1 AND :DT2
                   AND G.CODGERALOPER != 05
                 GROUP BY G.NUMERONF,
                          G.MODELONF,
                          G.CODGERALOPER,
                          G.NROEMPRESA,
                          G.DTAENTRADA,
                          G.SEQPESSOA
                
                )) XX
 WHERE CGO IN (#LS2)
 ORDER BY 4, 1
) AA
GROUP BY NROEMPRESA, INICIO, FIM, EMPRESA, CODGERAL

ORDER BY 1

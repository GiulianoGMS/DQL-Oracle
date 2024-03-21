-- QRP em https://github.com/GiulianoGMS/QRPs/blob/main/RelNfsSaidasV2.QRP

SELECT NROEMPRESA, CGO||' - '||CG.DESCRICAO,
       SUM(VALORNF) VALORNF, INICIO, FIM, 
(SELECT A.NOMEREDUZIDO FROM GE_EMPRESA A WHERE A.NROEMPRESA = AA.NROEMPRESA) EMPRESA, CGOS, COUNT(1) QTD FROM (

SELECT NUMERONF,
       MODELONF,
       CGO,
       NROEMPRESA,
       NOMERAZAO,
       DTAEMISSAO DTAENTRADA,
       VALORNF,
       ORIGEM,
       TO_CHAR(:DT1, 'DD/MM/YYYY') AS INICIO,
       TO_CHAR(:DT2, 'DD/MM/YYYY') AS FIM,
       NVL(:LS1, 'TODOS') EMPRESA,
       NVL(:LS2, 'TODOS') CGOS

  FROM (SELECT A.NUMERONF,
               A.MODELONF,
               A.CODGERALOPER CGO,
               A.NROEMPRESA,
               B.NOMERAZAO,
               TO_CHAR(A.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
               SUM(X.VLRITEM + NVL(X.VLRFCPST, 0) + X.VLRIPI +
                           X.VLRICMSST + X.VLRDESPNTRIBUTITEM +
                           NVL(X.VLRDESPTRIBUTITEM, 0)) - SUM(X.VLRDESCITEM) VALORNF,
               'SAIDANF' ORIGEM,
               A.SEQPESSOA
          FROM CONSINCO.MLF_NOTAFISCAL A
         INNER JOIN CONSINCO.GE_PESSOA B
            ON (A.SEQPESSOA = B.SEQPESSOA)
         INNER JOIN CONSINCO.MLF_NFITEM X
            ON (A.SEQNF = X.SEQNF)
         INNER JOIN CONSINCO.MAX_EMPRESA XX
            ON (A.NROEMPRESA = XX.NROEMPRESA)
              
           AND NVL(A.STATUSNFE, 4) = '4'
           AND A.TIPNOTAFISCAL = 'S'
           AND A.CODGERALOPER NOT IN (11)
           AND XX.NOMEREDUZIDO IN (#LS1)
           AND A.CODGERALOPER IN (#LS2)
           AND A.DTAEMISSAO BETWEEN :DT1 AND :DT2
         GROUP BY A.NUMERONF,
                  A.CODGERALOPER,
                  A.NROEMPRESA,
                  A.STATUSNFE,
                  A.SEQPESSOA,
                  B.NOMERAZAO,
                  A.MODELONF,
                  A.DTAEMISSAO
        
        UNION ALL
        
        SELECT A.NUMERODF,
               A.MODELODF,
               A.CODGERALOPER CGO,
               A.NROEMPRESA,
               B.NOMERAZAO,
               TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAENTRADA,
               SUM(X.VLRITEM + X.VLRACRESCIMO - X.VLRDESCONTO) VALORNF,
               'COMERCIAL' ORIGEM,
               A.SEQPESSOA
          FROM CONSINCO.MFL_DOCTOFISCAL A
         INNER JOIN CONSINCO.GE_PESSOA B
            ON (A.SEQPESSOA = B.SEQPESSOA)
         INNER JOIN CONSINCO.MFL_DFITEM X
            ON (A.SEQNF = X.SEQNF)
         INNER JOIN CONSINCO.MAX_EMPRESA XX
            ON (A.NROEMPRESA = XX.NROEMPRESA)
           AND NVL(A.STATUSNFE, 4) = '4'
           AND A.SERIEDF != 'CF'
           AND EXISTS (SELECT *
                  FROM GE_CGO G
                 WHERE G.CGO = A.CODGERALOPER
                   AND G.ENTRADASAIDA = 'S')
           AND XX.NOMEREDUZIDO IN (#LS1)
           AND A.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
           AND A.CODGERALOPER IN (#LS2)
         GROUP BY A.NUMERODF,
                  A.CODGERALOPER,
                  A.NROEMPRESA,
                  A.STATUSNFE,
                  A.SEQPESSOA,
                  B.NOMERAZAO,
                  A.MODELODF,
                  A.DTAMOVIMENTO)
 ORDER BY 1, 5, 4
 ) AA INNER JOIN MAX_CODGERALOPER CG ON CG.CODGERALOPER = AA.CGO
GROUP BY NROEMPRESA, INICIO, FIM, EMPRESA, CGOS, CGO||' - '||DESCRICAO

ORDER BY 1

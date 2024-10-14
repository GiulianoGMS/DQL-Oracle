
SELECT /*+OPTIMIZER_FEATURES_ENABLE('19.1.0')*/
       TO_CHAR(G.DTAENTRADA, 'MM') MES,
       TO_CHAR(G.DTAENTRADA, 'YYYY') ANO,
       --GE.SEQPESSOA||' - '||GE.NOMERAZAO FORNEC,
       COUNT(DISTINCT GG.SEQPRODUTO) QTD_PROD_TOT,
       COUNT(DISTINCT G.SEQNF) QTD_NFS_TOT,
       COUNT(DISTINCT LG.SEQPRODUTO) QTD_PROD_INC,
       COUNT(DISTINCT LG.NUMERONF) QTD_NFS_INC,
       ROUND(((COUNT(DISTINCT LG.SEQPRODUTO) / COUNT(DISTINCT GG.SEQPRODUTO)) * 100),2) PERC_PROD_INC,
       ROUND((COUNT(DISTINCT LG.NUMERONF) / COUNT(DISTINCT G.SEQNF)) * 100,2) PERC_NFS_INC
       
  FROM CONSINCO.MLF_NOTAFISCAL G INNER JOIN CONSINCO.MLF_NFITEM GG       ON GG.SEQNF        = G.SEQNF
                                 INNER JOIN CONSINCO.MAX_CODGERALOPER C  ON C.CODGERALOPER  = G.CODGERALOPER
                                 INNER JOIN GE_PESSOA GE ON GE.SEQPESSOA = G.SEQPESSOA
                                  LEFT JOIN NAGT_INCONSISTRECEBTO_LOG LG ON LG.NUMERONF     = G.NUMERONF
                                                                        AND LG.NROEMPRESA   = G.NROEMPRESA
                                                                        AND LG.CODINCONSIST = 75
                                                                        AND LG.SEQAUXNFITEM = GG.SEQITEMNF
                                                                        AND LG.SEQPRODUTO   = GG.SEQPRODUTO
                                                                        AND GG.QUANTIDADE =
                                                                              TO_NUMBER(REPLACE(REGEXP_SUBSTR(LG.DESCRICAO, '\(([^)]+)\)', 1, 1, NULL, 1),',',''))
                                                                              -- Na aplicacao: 
                                                                              -- TO_NUMBER(REPLACE(TRIM(REPLACE(REGEXP_SUBSTR(LG.DESCRICAO, '\(([^)]+)\)', 1, 1, NULL, 1),',','')),'.',',')) 
 WHERE 1=1
   AND C.TIPCGO = 'E'
   AND G.STATUSNF = 'V' 
   AND G.DTAENTRADA BETWEEN DATE '2024-08-01' AND SYSDATE
   AND G.CODGERALOPER IN (1,67, 929, 612, 614, 132, 214, 215, 616)
   
 GROUP BY TO_CHAR(G.DTAENTRADA, 'MM'),
          TO_CHAR(G.DTAENTRADA, 'YYYY')--, GE.SEQPESSOA||' - '||GE.NOMERAZAO
          
 ORDER BY TO_CHAR(G.DTAENTRADA, 'YYYY'),
          TO_CHAR(G.DTAENTRADA, 'MM');
  
 

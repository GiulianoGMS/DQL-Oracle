-- Ticket 509353

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT 'Regra 1' REGRA, X.NROTRIBUTACAO TRIB, TRIBUTACAO DESCRICAO, X.UFEMPRESA UF, X.PERACRESCST, X.PERALIQUOTAST, X.PERTRIBUTST, XC.SITUACAONF CST_SC
  FROM MAP_TRIBUTACAOUF X INNER JOIN MAP_TRIBUTACAO M ON M.NROTRIBUTACAO = X.NROTRIBUTACAO
                          INNER JOIN (SELECT *
                                        FROM MAP_TRIBUTACAOUF XC
                                       WHERE 1=1
                                         AND XC.TIPTRIBUTACAO = 'SC'
                                         AND XC.SITUACAONF != '060') XC ON XC.UFEMPRESA = X.UFEMPRESA
                                                                       AND XC.UFEMPRESA = XC.UFCLIENTEFORNEC
                                                                       AND XC.NROREGTRIBUTACAO = X.NROREGTRIBUTACAO
                                                                       AND XC.NROTRIBUTACAO = X.NROTRIBUTACAO
 WHERE 1=1
   AND X.TIPTRIBUTACAO = 'EI'
   AND X.UFEMPRESA IN ('SP','RJ')
   AND X.NROREGTRIBUTACAO = 0
   AND X.UFEMPRESA = X.UFCLIENTEFORNEC
   AND (NVL(X.PERACRESCST,0) > 0 OR NVL(X.PERALIQUOTAST,0) > 0 OR NVL(X.PERTRIBUTST,0) > 0)
   
UNION ALL
      SELECT NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL FROM DUAL
UNION ALL

SELECT 'Regra 2' REGRA, X.NROTRIBUTACAO TRIB, TRIBUTACAO DESCRICAO, X.UFEMPRESA UF, X.PERACRESCST, X.PERALIQUOTAST, X.PERTRIBUTST, XC.SITUACAONF CST_SC
  FROM MAP_TRIBUTACAOUF X INNER JOIN MAP_TRIBUTACAO M ON M.NROTRIBUTACAO = X.NROTRIBUTACAO
                          INNER JOIN (SELECT *
                                        FROM MAP_TRIBUTACAOUF XC
                                       WHERE 1=1
                                         AND XC.TIPTRIBUTACAO = 'SC'
                                         AND XC.SITUACAONF NOT IN ('000','020','040','041','051')) XC ON XC.UFEMPRESA = X.UFEMPRESA
                                                                       AND XC.UFEMPRESA = XC.UFCLIENTEFORNEC
                                                                       AND XC.NROREGTRIBUTACAO = X.NROREGTRIBUTACAO
                                                                       AND XC.NROTRIBUTACAO = X.NROTRIBUTACAO
 WHERE 1=1
   AND X.TIPTRIBUTACAO = 'EI'
   AND X.UFEMPRESA IN ('SP','RJ')
   AND X.NROREGTRIBUTACAO = 0
   AND X.UFEMPRESA = X.UFCLIENTEFORNEC
   AND (NVL(X.PERACRESCST,0) = 0 OR NVL(X.PERALIQUOTAST,0) = 0 OR NVL(X.PERTRIBUTST,0) = 0)
   
   
                      

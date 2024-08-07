ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT X.SEQENCARTE NROENCARTE, E.NROEMPRESA, 
       TO_CHAR(X.DTAHRAALTERACAO, 'DD/MM/YYYY HH24:MI') DTA_ALT_PROD, X.USUALTERACAO USU_ALT_PROD,
       TO_CHAR(Z.DTAALTERACAO, 'DD/MM/YYYY HH24:MI') DTA_ALT_ENCARTE, Z.USUALTERACAO USU_ALT_ENCARTE
        
  FROM MRL_ENCARTEPRODUTO X INNER JOIN MRL_ENCARTE Z ON X.SEQENCARTE = Z.SEQENCARTE
                            INNER JOIN CONSINCO.MRL_ENCARTEEMP E ON E.SEQENCARTE = X.SEQENCARTE
                            
 WHERE X.SEQENCARTE = #NR1
   AND E.NROEMPRESA IN (#LS1)

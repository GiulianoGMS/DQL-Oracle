SELECT MAX_PARAMETRO.INDREPLICACAO, MAX_PARAMETRO.INDGEROUREPLICACAO, MAX_PARAMETRO.NROEMPRESA, MAX_PARAMETRO.GRUPO, MAX_PARAMETRO.PARAMETRO, MAX_PARAMETRO.TIPODADO, MAX_PARAMETRO.VALOR, MAX_PARAMETRO.DTAHORALTERACAO, MAX_PARAMETRO.USUALTERACAO, MAX_PARAMETRO.COMENTARIO                                                                                                                                                                                                                                                                                                                                                       
FROM CONSINCO.MAX_PARAMETRO 
WHERE  (NROEMPRESA IN (SELECT NROEMPRESA FROM CONSINCO.MAX_EMPRESA WHERE STATUS = 'A' ) 
    OR  NROEMPRESA = 0 )  
AND COMENTARIO LIKE '%RECEBIMENTO%' -- Desc comentario ou PARAMETRO -- Descricao Parametro
AND GRUPO =        'GER_COMPRAS'       -- Grupo                  
ORDER BY PARAMETRO, NROEMPRESA, GRUPO

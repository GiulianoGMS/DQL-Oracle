SELECT * FROM (
SELECT MAP_FAMDIVISAO.NRODIVISAO, MAP_FAMDIVISAO.SEQFAMILIA, A.FAMILIA, MAX_DIVISAO.DIVISAO, 
       SUBSTR( fNomeCompletoCategoria( MAP_FAMDIVISAO.SEQFAMILIA, MAP_FAMDIVISAO.NRODIVISAO ), 0, 240 ) A      
                                                                                                                                                                                                                                                                                                                                                                                                                                    
FROM MAP_FAMDIVISAO, MAX_DIVISAO, MAP_FAMILIA A
 
WHERE MAP_FAMDIVISAO.NRODIVISAO = MAX_DIVISAO.NRODIVISAO 
      AND A.SEQFAMILIA = MAP_FAMDIVISAO.SEQFAMILIA

ORDER BY MAX_DIVISAO.DIVISAO)
WHERE A IS NULL;

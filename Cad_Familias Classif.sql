ALTER SESSION SET current_schema = CONSINCO;

SELECT * FROM (
SELECT MAP_FAMDIVISAO.NRODIVISAO, MAP_FAMDIVISAO.SEQFAMILIA, A.FAMILIA, MAX_DIVISAO.DIVISAO, 
       SUBSTR( fNomeCompletoCategoria( MAP_FAMDIVISAO.SEQFAMILIA, MAP_FAMDIVISAO.NRODIVISAO ), 0, 240 ) DIVISAO_CATEG     
                                                                                                                                                                                                                                                                                                                                                                                                                                    
FROM MAP_FAMDIVISAO, MAX_DIVISAO, MAP_FAMILIA A
 
WHERE MAP_FAMDIVISAO.NRODIVISAO = MAX_DIVISAO.NRODIVISAO 
      AND A.SEQFAMILIA = MAP_FAMDIVISAO.SEQFAMILIA

ORDER BY 3) X

WHERE X.DIVISAO_CATEG LIKE '%CLASSIF%'

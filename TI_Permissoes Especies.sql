ALTER SESSION SET current_schema = CONSINCO;

SELECT  DISTINCT CODESPECIE, FI_ESPECIE.DESCRICAO 
          FROM  FI_ESPECIE, FI_FILTRORELATRIB B 
          WHERE   B.SEQFILTROREL(+) = Null            
          AND FI_ESPECIE.CODESPECIE = B.VLRATRIBUTO(+) 
          AND B.IDATRIBUTO(+) = 24 
          AND   OBRIGDIREITO = 'O'             
          AND   NROEMPRESAMAE IN (  SELECT  DISTINCT A.NROEMPRESAMAE 
      FROM  FI_PARAMETRO A 
      WHERE   A.NROEMPRESA IN ( 601 )  ) 
          AND   ( TIPOESPECIE = 'T' Or TIPOESPECIE = 'C' ) 
           AND CODESPECIE IN (  
SELECT  FI_ESPECIE.CODESPECIE 
FROM  FI_ESPECIE 
WHERE   FI_ESPECIE.NROEMPRESAMAE = '601'                 
  AND   PKG_SEGPERMISSAO.SegurancaGEUsuarioPerm('135'         ,  
            '601'                      ,  
                                              'FISEGESPECIE',  
                                              FI_ESPECIE.SEQESPECIE,  
                                              '8'           ,  
            '6') = 1  )  
            
            AND CODESPECIE NOT LIKE '%IMPOPP%'
          ORDER BY CODESPECIE 
          
        --  SELECT * FROM GE_USUARIO C WHERE C.NOME LIKE '%Simone Eguti%'

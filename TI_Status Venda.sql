UPDATE CONSINCO.MRL_PRODEMPSEG A
          SET  A.STATUSVENDA   = 'I',
               A.USUALTERACAO  = 'GIGOMES',
               A.INDREPLICACAO = 'S',
               A.DTAALTERACAO  = SYSDATE,
               A.MARGEMLUCROPRODEMPSEG = Null,
               A.DTAAPROVASTATUSVDA    = Null,
               A.USUAPROVASTATUSVDA    = Null  
               
       WHERE A.NROEMPRESA   = 31
         AND A.NROSEGMENTO  = 5
         AND A.STATUSVENDA  = 'A'
        ;
             
COMMIT;

SELECT * FROM CONSINCO.MRL_PRODEMPSEG A
                       
       WHERE A.NROEMPRESA   = 31
         AND A.NROSEGMENTO  = 5
         AND A.STATUSVENDA  = 'A'
        ;

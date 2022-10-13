-- Seta NULO Telefones + DDDs < 11 digitos ou Telefones com '000000000' OU '111111111'

UPDATE GE_PESSOA A SET FONEDDD1 = NULL,
                       FONENRO1 = NULL,
                       FONEDDD2 = NULL,
                       FONENRO2 = NULL,
                       FONEDDD3 = NULL,
                       FONENRO3 = NULL,
                       FAXDDD   = NULL,
                       FAXNRO   = NULL
                 WHERE FISICAJURIDICA = 'F'
                   AND (LENGTH(NVL(A.FONEDDD1,0)) + LENGTH(NVL(A.FONENRO1,0))) < 11
                    OR FONENRO1 LIKE '%000000000%'
                    OR FONENRO1 LIKE '%111111111%';
                   
                   COMMIT;
                   
SELECT * FROM GE_PESSOA A
 WHERE (NVL(LENGTH(A.FONEDDD1),0) + NVL(LENGTH(A.FONENRO1),0)) < 11
                 OR FONENRO1 LIKE '%000000000%'
                 OR FONENRO1 LIKE '%111111111%'

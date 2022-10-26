-- Seta NULO Telefones + DDDs < 11 digitos ou Telefones com '000000000' OU '111111111'


UPDATE CONSINCO.GE_PESSOA A SET FONEDDD1 = NULL, FONENRO1 = NULL,
                                FONEDDD2 = NULL, FONENRO2 = NULL,
                                FONEDDD3 = NULL, FONENRO3 = NULL,
                                FAXDDD   = NULL, FAXNRO   = NULL

                 WHERE -- A.SEQPESSOA = 299441 Exemplo meu próprio cadastro 
                   AND A.FISICAJURIDICA = 'F' AND (LENGTH(NVL(A.FONEDDD1,0)) + LENGTH(NVL(A.FONENRO1,0))) < 10
                    OR A.FISICAJURIDICA = 'F' AND (LENGTH(NVL(A.FONEDDD1,0)) + LENGTH(NVL(A.FONENRO1,0))) > 12
                    OR A.FISICAJURIDICA = 'F' AND FONENRO1 LIKE '%000000000%'  
                    OR A.FISICAJURIDICA = 'F' AND FONENRO1 LIKE '%111111111%'  ;

COMMIT;


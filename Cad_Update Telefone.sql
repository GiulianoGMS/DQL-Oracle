-- Seta NULO Telefones + DDDs < 10, > 12 digitos ou Telefones com '000000000' OU '111111111'

UPDATE CONSINCO.GE_PESSOA A SET FONEDDD1 = NULL, FONENRO1 = NULL,
                                FONEDDD2 = NULL, FONENRO2 = NULL,
                                FONEDDD3 = NULL, FONENRO3 = NULL,
                                FAXDDD   = NULL, FAXNRO   = NULL

                 WHERE -- A.SEQPESSOA = 299441 Exemplo meu próprio cadastro 
                       A.FISICAJURIDICA = 'F' AND (LENGTH(NVL(A.FONEDDD1,0)) + LENGTH(NVL(A.FONENRO1,0))) < 10
                    OR A.FISICAJURIDICA = 'F' AND (LENGTH(NVL(A.FONEDDD1,0)) + LENGTH(NVL(A.FONENRO1,0))) > 12
                    OR A.FISICAJURIDICA = 'F' AND FONENRO1 LIKE '%000000000%'  
                    OR A.FISICAJURIDICA = 'F' AND FONENRO1 LIKE '%111111111%'  ;

COMMIT;

-- Thomé solicitou alteração na tabela aux dele de todos telefones com '0' para '11999999..'

UPDATE CONSINCODW.APP_CUSTOMER SET TELEFONE = 11999999999
WHERE TELEFONE = '0'

-- SELECT * FROM CONSINCODW.APP_CUSTOMER WHERE TELEFONE = 0; Confere

COMMIT;

-- Thomé solicitou retornar Alterações

/*UPDATE CONSINCODW.APP_CUSTOMER AA SET TELEFONE = 0

WHERE TELEFONE = 11999999999;

COMMIT; Não posso atualizar todos '119999..' porque ja exisitiam contatos com este número */

UPDATE APP_CUSTOMER X SET TELEFONE = (SELECT TELEFONE FROM APP_CUSTOMER_BACKUP Y WHERE Y.ID = X.ID AND Y.TELEFONE != X.TELEFONE)

WHERE X.ID IN (
SELECT A.ID FROM APP_CUSTOMER A LEFT JOIN APP_CUSTOMER_BACKUP B ON A.ID = B.ID
WHERE A.TELEFONE != B.TELEFONE
              );
              
COMMIT;




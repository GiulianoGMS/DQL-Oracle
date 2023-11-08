 UPDATE CONSINCO.MRL_PROMOCAOITEM C
    SET C.STATUS = 'A',
        C.USUALTERACAO = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL)
  WHERE C.SEQPROMOCAO = :NR1
    AND C.STATUS = 'I';
    
    COMMIT;
    
    SELECT 'Promocao Ativada Com Sucesso! Seqpromoção: '||:NR1 FROM DUAL
                          

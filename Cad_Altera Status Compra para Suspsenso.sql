update mrl_produtoempresa a
set a.statuscompra = 'S'
where a.seqproduto = :NR1;

UPDATE MAP_PRODEMPRSTATUS SET STATUSCOMPRA = 'S',
                              DTAHORALTERACAO = SYSDATE,
                              USUARIOALTERACAO = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
                              INDREPLICACAO = 'S',
                              INDGEROUREPLICACAO = NULL
          WHERE MAP_PRODEMPRSTATUS.SEQPRODUTO = :NR1;

COMMIT;
          
          SELECT 'Status alterado com Sucesso!' RETORNO FROM DUAL;

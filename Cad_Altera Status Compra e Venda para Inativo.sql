UPDATE mrl_prodempseg g
          set  g.statusvenda = 'I' ,  
               g.usualteracao = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
               g.indreplicacao = 'S',
               g.dtaalteracao = sysdate,
               g.MARGEMLUCROPRODEMPSEG =  Null,
               g.DTAAPROVASTATUSVDA    = Null,
               g.USUAPROVASTATUSVDA    = Null  
          where g.seqproduto = :NR1
          and g.statusvenda = 'A';

update mrl_produtoempresa a
set a.statuscompra = 'I'
where a.seqproduto = :NR1;

UPDATE MAP_PRODEMPRSTATUS SET STATUSCOMPRA = 'I',
                              DTAHORALTERACAO = SYSDATE,
                              USUARIOALTERACAO = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
                              INDREPLICACAO = 'S',
                              INDGEROUREPLICACAO = NULL
          WHERE MAP_PRODEMPRSTATUS.SEQPRODUTO = :NR1;

COMMIT;
          
          SELECT 'Status alterado com Sucesso!' RETORNO FROM DUAL;

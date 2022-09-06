UPDATE mrl_prodempseg g
          set  g.statusvenda = DECODE(#LS1,'Ativo','A','Inativo','I') ,  
               g.usualteracao = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
               g.indreplicacao = 'S',
               g.dtaalteracao = sysdate,
               g.MARGEMLUCROPRODEMPSEG =  Null,
               g.DTAAPROVASTATUSVDA    = Null,
               g.USUAPROVASTATUSVDA    = Null  
          where g.seqproduto = :NR1;

update mrl_produtoempresa a
set a.statuscompra = DECODE(#LS2,'Ativo','A','Inativo','I', 'Suspenso','S')
where a.seqproduto = :NR1;

UPDATE MAP_PRODEMPRSTATUS SET STATUSCOMPRA = DECODE(#LS2,'Ativo','A','Inativo','I', 'Suspenso','S') ,
                              DTAHORALTERACAO = SYSDATE,
                              USUARIOALTERACAO = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
                              INDREPLICACAO = 'S',
                              INDGEROUREPLICACAO = NULL
          WHERE MAP_PRODEMPRSTATUS.SEQPRODUTO = :NR1;

COMMIT;
          
          SELECT 'Status alterado com Sucesso! - PLU: '||TO_CHAR(:NR1)||' - Status Compra: '||'#LS2'|| ' - Status Venda: '||'#LS1'  RETORNO FROM DUAL;

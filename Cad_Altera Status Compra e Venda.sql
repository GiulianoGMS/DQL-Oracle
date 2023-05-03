UPDATE MRL_PRODEMPSEG G
          SET  G.STATUSVENDA = DECODE(#LS1,'Ativo','A','Inativo','I') ,  
               G.USUALTERACAO = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
               G.INDREPLICACAO = 'S',
               G.DTAALTERACAO = SYSDATE,
               G.MARGEMLUCROPRODEMPSEG =  NULL,
               G.DTAAPROVASTATUSVDA    = NULL,
               G.USUAPROVASTATUSVDA    = NULL  
               
       WHERE G.SEQPRODUTO = :NR1
         AND G.NROEMPRESA IN (#LS3); 

-----------------------------

UPDATE MRL_PRODUTOEMPRESA A
SET A.STATUSCOMPRA = DECODE(#LS2,'Ativo','A','Inativo','I', 'Suspenso','S')
WHERE A.SEQPRODUTO = :NR1
  AND A.NROEMPRESA IN (#LS3);
  
-----------------------------
  
UPDATE MAP_PRODEMPRSTATUS SET STATUSCOMPRA = DECODE(#LS2,'Ativo','A','Inativo','I', 'Suspenso','S') ,
                              DTAHORALTERACAO = SYSDATE,
                              USUARIOALTERACAO = (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
                              INDREPLICACAO = 'S',
                              INDGEROUREPLICACAO = NULL
          WHERE MAP_PRODEMPRSTATUS.SEQPRODUTO = :NR1
            AND NROEMPRESA IN (#LS3);

COMMIT;
          
          SELECT 'Status alterado com Sucesso! - Status Compra: '||'#LS2'|| ' - Status Venda: '||'#LS1'  RETORNO FROM DUAL

UNION ALL 

SELECT 'PLU: '||TO_CHAR(:NR1)||' - Produto: '||DESCCOMPLETA FROM MAP_PRODUTO WHERE SEQPRODUTO = :NR1;

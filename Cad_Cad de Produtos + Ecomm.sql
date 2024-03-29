SELECT DISTINCT A.SEQPRODUTO, 
                B.CODACESSO EAN, 
                A.DESCCOMPLETA NOME,
                CASE WHEN A.SEQPRODUTO IN (SELECT Z.SEQPRODUTO FROM CONSINCO.DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = A.SEQPRODUTO AND Z.STATUSCOMPRA = 'A') THEN 'ATIVO' 
                WHEN A.SEQPRODUTO      IN (SELECT Z.SEQPRODUTO FROM CONSINCO.DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = A.SEQPRODUTO AND Z.STATUSCOMPRA = 'S') THEN 'SUSPENSO'
                ELSE 'INATIVO' END STATUS_COMPRA,
                CASE WHEN A.SEQPRODUTO IN (SELECT Z.SEQPRODUTO FROM CONSINCO.DIM_PRODUTOEMPRESA Z WHERE Z.SEQPRODUTO = A.SEQPRODUTO AND Z.STATUSVENDA = 'A')  THEN 'ATIVO' 
                ELSE 'INATIVO' END STATUS_VENDA,
                TO_CHAR(A.DTAHORINCLUSAO,   'DD-MM-YYYY') DATA_CADASTRO,
                QL.CATEGORIA_NIVEL_1, QL.CATEGORIA_NIVEL_2, QL.CATEGORIA_NIVEL_3, QL.CATEGORIA_NIVEL_4, QL.CATEGORIA_NIVEL_5,
                A.DESCECOMMERCE DESC_ECOMM, A.NOMEPRODUTOECOMM NOME_ECOMM
       
FROM CONSINCO.MAP_PRODUTO A
       LEFT JOIN CONSINCO.MAP_PRODCODIGO B      ON A.SEQPRODUTO  = B.SEQPRODUTO AND B.TIPCODIGO = 'E'
       LEFT JOIN QLV_CATEGORIA@CONSINCODW QL    ON QL.SEQFAMILIA = A.SEQFAMILIA
        
ORDER BY 3 ASC;

SELECT  A.SEQPRODUTO, A.DESCCOMPLETA PRODUTO, A.SEQFAMILIA, MF.FAMILIA,
        B.CATEGORIA_NIVEL_1, B.CATEGORIA_NIVEL_2, B.CATEGORIA_NIVEL_3, B.CATEGORIA_NIVEL_4, B.CATEGORIA_NIVEL_5, B.CATEGORIA_NIVEL_6, B.CATEGORIA_NIVEL_7,
        Y.SEQFORNECEDOR, G.NOMERAZAO FORNECEDOR,
       (SELECT Z.SEQREDE FROM DIM_FORNECEDOR@BI Z WHERE Z.SEQFORNECEDOR = Y.SEQFORNECEDOR) SEQREDE,
        MARCA, CODACESSO EAN, B.SEQCOMPRADOR_CADASTRO, MC.COMPRADOR, MC.APELIDO, A.PZOVALIDADEDIASAIDA SHELF_LIFE
        
FROM CONSINCO.MAP_PRODUTO A LEFT JOIN QLV_CATEGORIA@CONSINCODW B  ON A.SEQFAMILIA    = B.SEQFAMILIA
                            LEFT JOIN CONSINCO.MAP_FAMDIVISAO  C  ON C.SEQFAMILIA    = A.SEQFAMILIA  
                            LEFT JOIN CONSINCO.MAX_COMPRADOR   MC ON MC.SEQCOMPRADOR = C.SEQCOMPRADOR
                           INNER JOIN CONSINCO.MAP_FAMILIA     MF ON MF.SEQFAMILIA   = A.SEQFAMILIA
                            LEFT JOIN CONSINCO.MAP_MARCA       MM ON MM.SEQMARCA     = MF.SEQMARCA         
                           INNER JOIN CONSINCO.MAP_FAMFORNEC   Y  ON Y.SEQFAMILIA    = A.SEQFAMILIA AND Y.PRINCIPAL = 'S'     
                           INNER JOIN CONSINCO.GE_PESSOA       G  ON G.SEQPESSOA     = Y.SEQFORNECEDOR
                            LEFT JOIN CONSINCO.MAP_PRODCODIGO  MP ON MP.SEQPRODUTO   = A.SEQPRODUTO AND MP.TIPCODIGO = 'E'
ORDER BY 1

/* CONSULTA ANTIGA:

select  a.seqproduto,
             a.produto,
            a.seqfamilia,
            a.familia,
            b.categoria_nivel_1,
            b.categoria_nivel_2,
           b.categoria_nivel_3,
           b.categoria_nivel_4,
           b.categoria_nivel_5,
           b.categoria_nivel_6,
           b.categoria_nivel_7,
           a.seqfornecedor,
           (select z.fornecedor from dim_fornecedor@bi z where z.seqfornecedor = a.seqfornecedor) Fornecedor,
            (select z.seqrede from dim_fornecedor@bi z where z.seqfornecedor = a.seqfornecedor) SEQREDE,
           a.marca,
           fbuscaeanproduto@bi(a.seqproduto) EAN,
           b.seqcomprador_cadastro,
           z.comprador,
           z.apelido
from dim_produto@bi a left join qlv_Categoria@bi b on (a.seqfamilia = b.seqfamilia)
                                    left join dim_comprador@bi z on (b.seqcomprador_cadastro = z.seqcomprador)
order by 1 */

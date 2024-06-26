SELECT DISTINCT A.SEQPRODUTO PLU, CODACESSO EAN, DESCCOMPLETA, C.NROTRIBUTACAO||' - '||D.TRIBUTACAO TRIBUTACAO, 
                QL.CATEGORIA_NIVEL_1, QL.CATEGORIA_NIVEL_2, QL.CATEGORIA_NIVEL_3, QL.CATEGORIA_NIVEL_4, QL.CATEGORIA_NIVEL_5,
                SUM(E.ESTQLOJA) ESTQLOJA, SUM(E.ESTQDEPOSITO) ESTQDEPOSITO, SUM(E.ESTQTROCA) ESTQAVARIA, SUM(E.ESTQOUTRO) ESTQOUTROS,
                NVL(SUM(F.QTDOPERACAO),0) VENDA_12MESES

  FROM CONSINCO.MAP_PRODUTO A LEFT JOIN CONSINCO.MAP_PRODCODIGO     B ON A.SEQPRODUTO    = B.SEQPRODUTO AND B.TIPCODIGO = 'E'
                              LEFT JOIN CONSINCO.MAP_FAMDIVISAO     C ON C.SEQFAMILIA    = A.SEQFAMILIA
                              LEFT JOIN CONSINCO.MAP_TRIBUTACAO     D ON D.NROTRIBUTACAO = C.NROTRIBUTACAO
                              LEFT JOIN QLV_CATEGORIA@CONSINCODW   QL ON QL.SEQFAMILIA   = A.SEQFAMILIA
                              LEFT JOIN CONSINCO.MRL_PRODUTOEMPRESA E ON E.SEQPRODUTO    = A.SEQPRODUTO
                              LEFT JOIN FATOG_VENDADIA@CONSINCODW   F ON F.SEQPRODUTO    = A.SEQPRODUTO AND F.CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911) AND F.DTAOPERACAO > SYSDATE - 365
                              
 WHERE (UPPER(TRIBUTACAO)     LIKE '%IMP%'  OR UPPER(TRIBUTACAO) LIKE 'IM%')
   AND  UPPER(TRIBUTACAO) NOT LIKE '%LIMP%'
                                
 GROUP BY A.SEQPRODUTO, CODACESSO, DESCCOMPLETA, C.NROTRIBUTACAO, D.TRIBUTACAO,
          QL.CATEGORIA_NIVEL_1, QL.CATEGORIA_NIVEL_2, QL.CATEGORIA_NIVEL_3, QL.CATEGORIA_NIVEL_4, QL.CATEGORIA_NIVEL_5
   
ORDER BY DESCCOMPLETA

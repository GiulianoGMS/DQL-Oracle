ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT X.NROEMPRESA,
                X.SEQPRODUTO PLU,
                DESCCOMPLETA,
               (SELECT MAX(CODACESSO) FROM MAP_PRODCODIGO B WHERE B.SEQPRODUTO = A.SEQPRODUTO AND B.INDUTILVENDA = 'S' AND B.TIPCODIGO = 'E') EAN,
                X.ESTQLOJA ESTOQUE,
                F.CATEGORIAN1 CATEGORIA01,
                F.CATEGORIAN2 CATEGORIA02,
                F.CATEGORIAN3 CATEGORIA03,
                F.CATEGORIAN4 CATEGORIA04,
                F.CATEGORIAN5 CATEGORIA05,
                G.SEQPESSOA ||' - '||NOMERAZAO FORNEC,
                X.DTAULTVENDA

  FROM CONSINCO.MRL_PRODUTOEMPRESA X INNER JOIN CONSINCO.MAP_PRODUTO A      ON A.SEQPRODUTO = X.SEQPRODUTO
                                     INNER JOIN CONSINCO.MAP_FAMILIA C      ON C.SEQFAMILIA = A.SEQFAMILIA
                                      LEFT JOIN DIM_CATEGORIA@CONSINCODW F  ON F.SEQFAMILIA = C.SEQFAMILIA
                                      LEFT JOIN CONSINCO.MAP_FAMFORNEC  GC  ON GC.SEQFAMILIA = A.SEQFAMILIA AND GC.PRINCIPAL = 'S'
                                     INNER JOIN CONSINCO.GE_PESSOA G        ON G.SEQPESSOA   = GC.SEQFORNECEDOR

 WHERE 1 = 1
   AND ESTQLOJA > 100
   AND NVL(PESAVEL,'N') != 'S'
   AND CATEGORIAN1 != 'USO'
   /*AND NOT EXISTS (SELECT 1
          FROM FATOG_VENDADIA@CONSINCODW VD 
         WHERE VD.SEQPRODUTO = X.SEQPRODUTO
           AND VD.NROEMPRESA = X.NROEMPRESA
           AND VD.DTAOPERACAO >= SYSDATE - 30)*/
   AND DTAULTVENDA < SYSDATE - 30
   AND X.NROEMPRESA IN (1,
                        7,
                        11,
                        17,
                        21,
                        22,
                        23,
                        25,
                        27,
                        26,
                        28,
                        29,
                        30,
                        32,
                        36,
                        38,
                        39,
                        41,
                        42,
                        43,
                        48,
                        46,
                        50,
                        51,
                        52,
                        55)
                        
 ORDER BY 1, 3

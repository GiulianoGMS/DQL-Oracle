SELECT /*+OPTIMIZER_FEATURES_ENABLE('19.1.0')*/
       DISTINCT X.SEQPRODUTO PLU, F.SEQFAMILIA COD_FAMILIA, DESCCOMPLETA,
       CASE WHEN UF = 'EX' THEN 'IMPORTADO' ELSE M.MARCA END TIPO,       TO_CHAR(X.DTAHORINCLUSAO, 'DD/MM/YYYY') DTA_CADASTRO,
       CASE WHEN NFL.SEQPRODUTO  IS NOT NULL THEN '7 - Recebido na Loja'
            WHEN FT.SEQPRODUTO   IS NOT NULL THEN '6 - '||DECODE(FT.SITUACAOPED, 'F','Emitido para Loja', 'S', 'Em Separação no CD', 'R', 'Em Separação no CD', 'A', 'Análise Comercial', 'L', 'Aguardando CD')
            WHEN NFI.SEQPRODUTO  IS NOT NULL THEN '5 - Recebido no CD - II' 
            WHEN NF5.SEQPRODUTO  IS NOT NULL THEN '5 - Recebido no CD - ID'                                     
            WHEN NF43.SEQPRODUTO IS NOT NULL THEN '4 - Produto no Porto' 
            WHEN PI.SEQPRODUTO   IS NOT NULL THEN '3 - Pedido Gerado - ID'
            WHEN PD.SEQPRODUTO   IS NOT NULL THEN '2 - Pedido Gerado - II'
           ELSE '1 - Novo ou Sem Pedido' END SITUACAO,
       CASE WHEN NFL.SEQPRODUTO  IS NOT NULL THEN NFL.DTAEMISSAO
            WHEN FT.SEQPRODUTO   IS NOT NULL THEN FT.DTAEMISSAO
            WHEN NFI.SEQPRODUTO  IS NOT NULL THEN NFI.DTAEMISSAO
            WHEN NF5.SEQPRODUTO  IS NOT NULL THEN NF5.DTAEMISSAO                                   
            WHEN NF43.SEQPRODUTO IS NOT NULL THEN NF43.DTAEMISSAO
            WHEN PI.SEQPRODUTO   IS NOT NULL THEN PI.DTAEMISSAO
            WHEN PD.SEQPRODUTO   IS NOT NULL THEN PD.DTAEMISSAO
           ELSE TO_DATE(X.DTAHORINCLUSAO, 'DD/MM/YY') END DATA
         
  FROM MAP_PRODUTO X INNER JOIN MAP_FAMILIA   F ON F.SEQFAMILIA = X.SEQFAMILIA
                     INNER JOIN MAP_MARCA     M ON M.SEQMARCA   = F.SEQMARCA
                     INNER JOIN MAP_FAMFORNEC Z ON Z.SEQFAMILIA = X.SEQFAMILIA
                     INNER JOIN GE_PESSOA     G ON G.SEQPESSOA = Z.SEQFORNECEDOR AND G.UF = 'EX'
                      /* NF de Acompanhamento - Porto */
                      LEFT JOIN (SELECT NI.SEQPRODUTO, MIN(N.DTAEMISSAO) DTAEMISSAO, N.CODGERALOPER
                                   FROM MLF_NOTAFISCAL N INNER JOIN MLF_NFITEM NI ON N.SEQNF = NI.SEQNF
                                  WHERE 1=1
                                    AND N.NROEMPRESA   IN (502,503)
                                    AND N.CODGERALOPER IN (43) 
                                    AND N.STATUSNF != 'C'
                                  GROUP BY NI.SEQPRODUTO, N.CODGERALOPER) NF43 ON NF43.SEQPRODUTO = X.SEQPRODUTO
                      /* NF de Entrade de Estoque no CD */
                      LEFT JOIN (SELECT NI.SEQPRODUTO, MIN(N.DTAEMISSAO) DTAEMISSAO, N.CODGERALOPER
                                   FROM MLF_NOTAFISCAL N INNER JOIN MLF_NFITEM NI ON N.SEQNF = NI.SEQNF
                                  WHERE 2=2 
                                    AND N.NROEMPRESA IN (502,503)
                                    AND N.CODGERALOPER IN (5)
                                    AND N.STATUSNF != 'C'
                                  GROUP BY NI.SEQPRODUTO, N.CODGERALOPER) NF5 ON NF5.SEQPRODUTO = X.SEQPRODUTO
                      /* Pedido de Importação Direta */
                      LEFT JOIN (SELECT SEQPRODUTO, MIN(TO_DATE(B.DTAINCLUSAO, 'DD/MM/YY')) DTAEMISSAO
                                   FROM MAD_PIPEDIMPORTPROD A INNER JOIN CONSINCO.MAD_PIPEDIDOIMPORT B ON A.SEQPEDIDOIMPORT = B.SEQPEDIDOIMPORT
                                                              INNER JOIN CONSINCO.MAD_PIPROCIMPORTACAO C ON C.NROPROCIMPORTACAO = B.NROPROCIMPORTACAO
                                                              INNER JOIN CONSINCO.MAD_DI D ON C.NUMERODI = D.NUMERODI
                                  WHERE 3=3
                                    AND SITUACAOPED = 'P'
                                  GROUP BY SEQPRODUTO) PI ON PI.SEQPRODUTO = X.SEQPRODUTO
                      /* Pedido de Importação Indireta */
                      LEFT JOIN (SELECT SEQPRODUTO, MIN(GC.DTAHORINCLUSAO) DTAEMISSAO
                                   FROM MAC_GERCOMPRA GC INNER JOIN MAC_GERCOMPRAITEM GCI ON GC.SEQGERCOMPRA = GCI.SEQGERCOMPRA
                                                         INNER JOIN CONSINCO.MAC_GERCOMPRAFORN GF ON GF.SEQGERCOMPRA = GC.SEQGERCOMPRA
                                  WHERE 4=4
                                    AND GC.SITUACAOLOTE = 'F'
                                    AND NROEMPRESA IN (502,503)
                                    AND GCI.SEQFORNECEDOR > 999
                                    AND GC.DTAHORINCLUSAO > DATE '2024-01-01'
                                    AND GC.DTAHORFECHAMENTO IS NOT NULL
                                    AND GC.TIPOLOTE = 'C'
                                  GROUP BY SEQPRODUTO) PD ON PD.SEQPRODUTO = X.SEQPRODUTO
                      /* NF de Entrade Importacao Indireta */
                      LEFT JOIN (SELECT NI.SEQPRODUTO, MIN(N.DTAEMISSAO) DTAEMISSAO, N.CODGERALOPER
                                   FROM MLF_NOTAFISCAL N INNER JOIN MLF_NFITEM NI ON N.SEQNF = NI.SEQNF
                                  WHERE 5=5
                                    AND N.NROEMPRESA IN (502,503)
                                    AND N.CODGERALOPER IN (1)
                                    AND N.STATUSNF != 'C'
                                  GROUP BY NI.SEQPRODUTO, N.CODGERALOPER) NFI ON NFI.SEQPRODUTO = X.SEQPRODUTO
                      /* Estoque - Indicador de Entrada na Loja */
                      /*LEFT JOIN (SELECT DISTINCT SEQPRODUTO, MIN(EM.DTAULTENTRCUSTO) DTAEMISSAO
                                   FROM MRL_PRODUTOEMPRESA EM
                                  WHERE 6=6 
                                    AND EM.ESTQLOJA != 0
                                  GROUP BY SEQPRODUTO) EST ON EST.SEQPRODUTO = X.SEQPRODUTO*/
                      /* Lancamento Lojas */
                      LEFT JOIN (SELECT NI.SEQPRODUTO, MIN(N.DTAENTRADA) DTAEMISSAO
                                   FROM MLF_NOTAFISCAL N INNER JOIN MLF_NFITEM NI ON N.SEQNF = NI.SEQNF
                                  WHERE 5=5
                                    AND (N.NROEMPRESA < 100 OR N.NROEMPRESA = 502)
                                    AND N.CODGERALOPER IN (29,64,51,50)
                                    AND N.STATUSNF != 'C'
                                  GROUP BY NI.SEQPRODUTO) NFL ON NFL.SEQPRODUTO = X.SEQPRODUTO                                  
                      /* Transferencia CD para Lojas */
                      LEFT JOIN (SELECT SEQPRODUTO, MIN(SITUACAOPED) SITUACAOPED, MIN(NVL(MD.DTABASEFATURAMENTO,MD.DTAINCLUSAO)) DTAEMISSAO
                                   FROM MAD_PEDVENDA MD INNER JOIN MAD_PEDVENDAITEM MDI ON MD.NROPEDVENDA = MDI.NROPEDVENDA
                                  WHERE 7=7
                                    AND MD.SITUACAOPED != 'C'
                                    AND NVL(NROEMPRESAORIGEM,MD.NROEMPRESA) IN (502,503)
                                    AND MD.DTAINCLUSAO > DATE '2024-01-01'
                                  GROUP BY SEQPRODUTO) FT ON FT.SEQPRODUTO = X.SEQPRODUTO
                                    
 WHERE 1=1
 
 /*AND MARCA = 'NAGUMO'
   AND DESCCOMPLETA NOT LIKE '%CESTA%'
   AND DESCCOMPLETA NOT LIKE '%CB%'*/
           
  ORDER BY 6,3

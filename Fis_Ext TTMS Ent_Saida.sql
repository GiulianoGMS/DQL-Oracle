SELECT X.CNPJ_EMITENTE, X.CHAVE, LPAD(G.NROCGCCPF,12,0)||LPAD(G.DIGCGCCPF,2,0) CNPJ_DESTINATARIO, X.CODIGO_ITEM COD_ITEM,
       X.DESC_ITEM, P.SEQFAMILIA COD_FAMILIA, FAMILIA DESC_FAMILIA, X.NCM, X.CFOP, X.ORIGEM_ICMS||X.CST_ICMS CST_ICMS, X.SITUACAONFIPI CST_IPI, X.CST_PIS, X.CST_COFINS,
       X.VLR_TOTAL_PRODUTOS, X.VLR_TOTAL_ICMS VLRICMS, X.VLRICMSST, X.VLRIPI, X.VLR_TOTAL_PIS VLRPIS, X.VLR_TOTAL_COFINS VLRCOFINS,
       FVALORTOTALNF(X.ID, 'N') VALOR_TOTAL_NF
       
  FROM NAGV_ENTRADAS X INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = X.CODIGO_ITEM 
                           INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA AND F.FINALIDADEFAMILIA = 'R'
                           INNER JOIN MAP_FAMILIA FA ON FA.SEQFAMILIA = P.SEQFAMILIA
                           INNER JOIN GE_PESSOA G ON G.SEQPESSOA = X.NROEMPRESA
                           
 WHERE X.PERIODO BETWEEN DATE '2025-08-01' AND DATE '2025-10-31'
   AND X.NROEMPRESA IN (SELECT SEQPESSOA
                          FROM GE_PESSOA G
                         WHERE LPAD(NROCGCCPF, 12, 0) || LPAD(DIGCGCCPF, 2, 0) IN
                               (07705530000184,
                                07705530000265,
                                07705530000346,
                                07705530000427,
                                07705530000508,
                                07705530000699,
                                07705530000770,
                                07705530000850,
                                07705530000931,
                                07705530001075,
                                07705530001237,
                                07705530001318,
                                07705530001407,
                                13941798000118,
                                15379804000110,
                                15379804000200,
                                15379973000179,
                                15379973000250,
                                03376054000144,
                                13941798000118)) 
                                
UNION ALL

SELECT X.CNPJ_EMITENTE, X.CHAVE, LPAD(G.NROCGCCPF,12,0)||LPAD(G.DIGCGCCPF,2,0) CNPJ_DESTINATARIO, X.CODIGO_ITEM COD_ITEM,
       X.DESC_ITEM, P.SEQFAMILIA COD_FAMILIA, FAMILIA DESC_FAMILIA, X.NCM, X.CFOP, X.ORIGEM_ICMS||X.CST_ICMS CST_ICMS, X.SITUACAONFIPI CST_IPI, X.CST_PIS, X.CST_COFINS,
       X.VLR_TOTAL_PRODUTOS, X.VLR_TOTAL_ICMS VLRICMS, X.VLRICMSST, X.VLRIPI, X.VLR_TOTAL_PIS VLRPIS, X.VLR_TOTAL_COFINS VLRCOFINS,
       FVALORTOTALNF(X.ID, X.TP) VALOR_TOTAL_NF
       
  FROM NAGV_SAIDAS   X INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = X.CODIGO_ITEM 
                           INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA AND F.FINALIDADEFAMILIA = 'R'
                           INNER JOIN MAP_FAMILIA FA ON FA.SEQFAMILIA = P.SEQFAMILIA
                           INNER JOIN GE_PESSOA G ON G.SEQPESSOA = X.NROEMPRESA
                           
 WHERE X.PERIODO BETWEEN DATE '2025-08-01' AND DATE '2025-10-31'
   AND X.NROEMPRESA IN (SELECT SEQPESSOA
                          FROM GE_PESSOA G
                         WHERE LPAD(NROCGCCPF, 12, 0) || LPAD(DIGCGCCPF, 2, 0) IN
                               (07705530000184,
                                07705530000265,
                                07705530000346,
                                07705530000427,
                                07705530000508,
                                07705530000699,
                                07705530000770,
                                07705530000850,
                                07705530000931,
                                07705530001075,
                                07705530001237,
                                07705530001318,
                                07705530001407,
                                13941798000118,
                                15379804000110,
                                15379804000200,
                                15379973000179,
                                15379973000250,
                                03376054000144,
                                13941798000118)) 
;


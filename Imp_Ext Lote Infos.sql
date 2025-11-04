-- XLS em https://github.com/GiulianoGMS/Excel-Files/blob/main/Rel_Aux_ImportacaoDireta.xlsx

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT A.SEQPEDIDOIMPORT NRO_PED,
       A.SEQPRODUTO PLU,
       C.CODACESSO REF,
       A.QTDEMBALAGEM,
       D.PESOLIQUIDO,
       A.QTDSOLICITADA QTD_PED,
       A.SEQFAMILIA FAM,
       A.VLRDESPADUANEIRA,
       B.DESCCOMPLETA,
       A.VLRITEM,
       A.VLRITEMCUSTO,
       A.PERALIQIPI,
       A.VLRPAUTAIPI,
       A.VLRIPI,
       A.PERIMPOSTIMPORT,
       A.VLRIMPIMPORT,
       A.VLRPIS,
       A.VLRCOFINS,
       A.VLRICMS,
       A.VLRICMSST,
       A.VLRDESPESA,
       A.VLRDESPESAFORA,
       A.VLRFCPICMS,
       A.VLRFCPST,
       T.PERPISDIF,
       T.PERCOFINSDIF,
       T.PERALIQUOTA / 100 * T.PERTRIBUTADO ALIQICMS
       
  FROM MAD_PIPEDIMPORTPROD A INNER JOIN MAP_PRODUTO B      ON A.SEQPRODUTO = B.SEQPRODUTO
                              LEFT JOIN MAP_PRODCODIGO C   ON C.SEQPRODUTO = A.SEQPRODUTO 
                                                          AND C.TIPCODIGO = 'F'
                             INNER JOIN MAP_FAMEMBALAGEM D ON D.SEQFAMILIA = B.SEQFAMILIA
                                                          AND D.QTDEMBALAGEM = A.QTDEMBALAGEM
                             INNER JOIN MAP_FAMDIVISAO F   ON F.SEQFAMILIA = B.SEQFAMILIA
                             INNER JOIN MAP_TRIBUTACAOUF T ON T.NROTRIBUTACAO = F.NROTRIBUTACAO AND T.NROREGTRIBUTACAO = 8 /*IMP DIRETA*/ 
                                                                                                AND T.UFEMPRESA = 'SP' 
                                                                                                AND T.UFCLIENTEFORNEC = 'EX' 
                                                                                                AND T.TIPTRIBUTACAO = 'EI'
 WHERE 1 = 1
   AND A.SEQPEDIDOIMPORT = '1664'
   
ORDER BY 10 DESC


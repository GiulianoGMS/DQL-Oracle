SELECT DISTINCT (A.SEQPRODUTO),
                A.DESCCOMPLETA,
                A.SEQFAMILIA COD_FAM,
                F.FAMILIA DESC_FAM,
                F.CODNBMSH NCM,
                R.CENARIOCBS,
                R.CENARIOIBSUF CENARIOIBS,
                E.SEQPESSOA || '/' || E.NOMERAZAO AS FORNECEDOR,
                D.COMPRADOR AS COMPRADOR,
                DECODE(C.FINALIDADEFAMILIA,
                       'P',
                       'Matéria-Prima',
                       'B',
                       'Brinde',
                       'U',
                       'Material de Uso e Consumo',
                       'A',
                       'Ativo Imobilizado',
                       'S',
                       'Serviços',
                       'G',
                       'Seguro',
                       'F',
                       'Frete',
                       'D',
                       'Despesas',
                       'V',
                       'Aproveitamento',
                       'L',
                       'Vale/Recibo',
                       'E',
                       'Embalagem',
                       'C',
                       'Produto em Processo',
                       'Q',
                       'Produto Acabado',
                       'T',
                       'Subproduto',
                       'I',
                       'Produto Intermediário',
                       'O',
                       'Outros insumos',
                       'J',
                       'Adjudicação Cred ICMS',
                       'N',
                       'Rest Cred Trib',
                       'M',
                       'Complemento Antecipado',
                       'X',
                       'Garantia Estendida',
                       'Z',
                       'Vale Gás',
                       'R',
                       'Mercadoria para Revenda',
                       'H',
                       'Complemento de Imposto') AS FINALIDADE_FAMILIA,
                TO_CHAR(A.DTAHORINCLUSAO, 'DD/MM/YYYY hh24:mi:ss') AS DTAINCLUSAO,
                X.CODCEST CEST,
                W.NROTRIBUTACAO || ' - ' || W.TRIBUTACAO TRIBUTACAO,
                (SELECT P.LISTA || '-' || P.DESCRICAO
                   FROM CONSINCO.MAX_ATRIBUTOFIXO P
                  WHERE X.SITUACAONFPIS = P.LISTA
                        AND P.TIPATRIBUTOFIXO = 'SIT_TRIBUT_PIS') PIS_ENTRADA,
                (SELECT P.LISTA || '-' || P.DESCRICAO
                   FROM CONSINCO.MAX_ATRIBUTOFIXO P
                  WHERE X.SITUACAONFCOFINS = P.LISTA
                        AND P.TIPATRIBUTOFIXO = 'SIT_TRIBUT_COFINS') COFINS_ENTRADA
  FROM MAP_PRODUTO A
  JOIN MAP_FAMFORNEC B ON B.SEQFAMILIA = A.SEQFAMILIA
                          AND B.PRINCIPAL = 'S'
  JOIN MAP_FAMDIVISAO C ON C.SEQFAMILIA = A.SEQFAMILIA
  JOIN MAX_COMPRADOR D ON D.SEQCOMPRADOR = C.SEQCOMPRADOR
  JOIN GE_PESSOA E ON E.SEQPESSOA = B.SEQFORNECEDOR
  JOIN MAP_FAMILIA F ON F.SEQFAMILIA = A.SEQFAMILIA
  LEFT JOIN MAP_FAMILIA X ON X.SEQFAMILIA = A.SEQFAMILIA
  LEFT JOIN MAP_FAMDIVISAO Y ON Y.SEQFAMILIA = A.SEQFAMILIA
  LEFT JOIN MAP_TRIBUTACAO W ON W.NROTRIBUTACAO = Y.NROTRIBUTACAO
  LEFT JOIN NAGV_BUSCA_CCT_PROD_NCM R ON R.PLU = A.SEQPRODUTO
 WHERE TRUNC(A.DTAHORINCLUSAO) BETWEEN :DT1 AND :DT2
      
       AND TRUNC(A.DTAHORINCLUSAO) BETWEEN :DT1 AND :DT2
 ORDER BY 4

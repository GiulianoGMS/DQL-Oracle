SELECT         TO_CHAR(A.DTAAUDITORIA,'DD/MM/YYYY') AS DTAAUDITORIA,
               'Status Compra' Campo, 
               B.SEQPRODUTO PLU, 
               B.DESCCOMPLETA DESCRICAO,
       DECODE (E.FINALIDADEFAMILIA,
       'P', 'MATÉRIA-PRIMA',
       'B', 'BRINDE',
       'U', 'MATERIAL DE USO E CONSUMO',
       'A', 'ATIVO IMOBILIZADO',
       'S', 'SERVIÇOS',
       'G', 'SEGURO',
       'F', 'FRETE',
       'D', 'DESPESAS',
       'V', 'APROVEITAMENTO',
       'L', 'VALE/RECIBO',
       'E', 'EMBALAGEM',
       'C', 'PRODUTO EM PROCESSO',
       'Q', 'PRODUTO ACABADO',
       'T', 'SUBPRODUTO',
       'I', 'PRODUTO INTERMEDIÁRIO',
       'O', 'OUTROS INSUMOS',
       'J', 'ADJUDICAÇÃO CRED ICMS',
       'N', 'REST CRED TRIB',
       'M', 'COMPLEMENTO ANTECIPADO',
       'X', 'GARANTIA ESTENDIDA',
       'Z', 'VALE GÁS',
       'R', 'MERCADORIA PARA REVENDA') AS FINALIDADE_FAMILIA, C.SEQFORNECEDOR||' - '||D.NOMERAZAO FORNECEDOR,
       MD.SEQCONTRATO NRO_CONTRATO

FROM CONSINCO.MAP_AUDITORIA A INNER JOIN CONSINCO.MAP_PRODUTO B ON (A.SEQIDENTIFICA = B.SEQPRODUTO)
                              LEFT JOIN CONSINCO.MAP_FAMFORNEC C ON (B.SEQFAMILIA = C.SEQFAMILIA) AND C.PRINCIPAL = 'S'
                              INNER JOIN CONSINCO.MAP_FAMDIVISAO E ON (B.SEQFAMILIA = E.SEQFAMILIA)
                              LEFT JOIN CONSINCO.GE_PESSOA D ON (C.SEQFORNECEDOR = D.SEQPESSOA)
                              INNER JOIN GE_REDEPESSOA R ON R.SEQPESSOA = C.SEQFORNECEDOR
                              INNER JOIN MGC_CONTRATO MC ON MC.SEQREDE = R.SEQREDE
                              INNER JOIN MGC_CONTRATODESCONTO MD ON MD.SEQCONTRATO = MC.SEQCONTRATO

WHERE A.CAMPO = 'STATUSCOMPRA'
AND A.VLRATUAL LIKE 'A%'
AND A.DTAAUDITORIA BETWEEN :DT1 AND :DT2
AND MD.INDDESCGERAL = 'N'
AND MC.STATUS = 'A'

GROUP BY       A.DTAAUDITORIA,
               B.SEQPRODUTO, 
               B.DESCCOMPLETA,
               E.FINALIDADEFAMILIA, C.SEQFORNECEDOR||' - '||D.NOMERAZAO,
               MD.SEQCONTRATO

ORDER BY 1, 4;

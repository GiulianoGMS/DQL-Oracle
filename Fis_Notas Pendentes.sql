SELECT TO_CHAR(NROEMPRESA) NROEMPRESA, NUMERONF, STATUS, DTA_EMISSAO, INDENVIACANCELAMENTO, TIPO
FROM (
    SELECT X.NROEMPRESA,
           X.NUMERONF,
           DECODE(X.STATUSNFE,
                  1,'Aguardando Processamento',2,'Aguardando Envio',3,'Aguardando Retorno',
                  4,'Autorizada',5,'Rejeitada',6,'Denegada',7,'Cancelada',8,'Nota Inutilizada',
                  10,'Erro validação',11,'Erro XML',12,'Erro envio',13,'Erro retorno',
                  19,'Pendente envio abortado',26,'Pendente retorno abortado',99,'Erro geral',
                  'Nota não enviada') STATUS,
           TO_CHAR(X.DTAEMISSAO,'DD/MM/YYYY') DTA_EMISSAO,
           X.INDENVIACANCELAMENTO,
           DECODE(X.TIPNOTAFISCAL,'E','Entrada','Saída') TIPO
      FROM MLFV_BASENFE X
     WHERE X.NROEMPRESA IN (#LS1) 
       AND (((X.STATUSNFE NOT IN (4,6,7,8) OR X.STATUSNFE IS NULL)
             AND X.INDENVIACANCELAMENTO = 'N'
             AND X.NFENROPROTENVIO IS NULL)
             OR X.INDENVIACANCELAMENTO = 'S')
       AND NOT EXISTS (SELECT 1 FROM MFL_NFELOG Y
                        WHERE Y.SEQNOTAFISCAL = X.SEQNOTAFISCAL
                          AND UPPER(Y.DESCRICAO) LIKE '%DENEGADA%')
       AND X.MODELO != '65'
       AND X.APPORIGEM != 26
       AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2
)
UNION ALL
SELECT NVL(:LS1, 'Todas'), NULL, 'Sem pendências', 'De: '||TO_CHAR(:DT1, 'DD/MM/YYYY')||' Até: '||TO_CHAR(:DT2, 'DD/MM/YYYY'), NULL, NULL FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM MLFV_BASENFE X
     WHERE X.NROEMPRESA IN ( #LS1 )
       AND (((X.STATUSNFE NOT IN (4,6,7,8) OR X.STATUSNFE IS NULL)
             AND X.INDENVIACANCELAMENTO = 'N'
             AND X.NFENROPROTENVIO IS NULL)
             OR X.INDENVIACANCELAMENTO = 'S')
       AND NOT EXISTS (SELECT 1 FROM MFL_NFELOG Y
                        WHERE Y.SEQNOTAFISCAL = X.SEQNOTAFISCAL
                          AND UPPER(Y.DESCRICAO) LIKE '%DENEGADA%')
       AND X.MODELO != '65'
       AND X.APPORIGEM != 26
       AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2
);

-- Ticket 484633

-- Nova Vs - Agrupada

SELECT * FROM (
SELECT PLU,
       DESCRICAO,
       TO_CHAR(DTAAUDITORIA, 'DD/MM/YYYY') DTA_ALTERACAO,
       USUARIO_ALTERACAO,
       CASE WHEN NROTRIBUTACAO_ANTERIOR IS NOT NULL 
         THEN NROTRIBUTACAO_ANTERIOR||' - '||(SELECT TRIBUTACAO FROM MAP_TRIBUTACAO T WHERE T.NROTRIBUTACAO = NROTRIBUTACAO_ANTERIOR) END TRIBUTACAO_ANTERIOR,
       CASE WHEN NROTRIBUTACAO_ANTERIOR IS NOT NULL 
         THEN NROTRIBUTACAO_NOVO||' - '||(SELECT TRIBUTACAO FROM MAP_TRIBUTACAO T WHERE T.NROTRIBUTACAO = NROTRIBUTACAO_NOVO) END NOVA_TRIBUTACAO,
       NCM_ANTERIOR,
       NCM_NOVO,
       CODCEST_ANTERIOR,
       CODCEST_NOVO,
       FINALIDADEFAMILIA_ANTERIOR,
       FINALIDADEFAMILIA_NOVO,
       
       
       CST_PIS_ENT_ANTERIOR,
       CST_PIS_ENT_PIS_NOVO,
       CST_PIS_SAI_ANTERIOR,
       CST_PIS_SAI_NOVO,
       CST_COFINS_ENT_ANTERIOR,
       CST_COFINS_ENT_NOVO,
       CST_COFINS_SAI_ANTERIOR,
       CST_COFINS_SAI_NOVO,
       CODORIGEM_ANTERIOR,
       CODORIGEM_NOVO
  FROM (
        
         SELECT DISTINCT SEQPRODUTO PLU,
                         DESCCOMPLETA DESCRICAO,
                         DTAAUDITORIA,
                         NVL(USUAUDITORIA, CASE WHEN MODULE = 'DBMS_SCHEDULER' THEN 'AUTOMATICO' ELSE NULL END) USUARIO_ALTERACAO,
                         MAX(CASE
                           WHEN CAMPO = 'NROTRIBUTACAO' THEN
                            C.VLRANTERIOR
                         END) NROTRIBUTACAO_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'NROTRIBUTACAO' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) NROTRIBUTACAO_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'CODNBMSH' THEN
                            C.VLRANTERIOR
                         END) NCM_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'CODNBMSH' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) NCM_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'CODCEST' THEN
                            C.VLRANTERIOR
                         END) CODCEST_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'CODCEST' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) CODCEST_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'FINALIDADEFAMILIA' THEN
                            C.VLRANTERIOR
                         END) FINALIDADEFAMILIA_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'FINALIDADEFAMILIA' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) FINALIDADEFAMILIA_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'ALIQUOTAIPI' THEN
                            C.VLRANTERIOR
                         END) ALIQUOTAIPI_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'ALIQUOTAIPI' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) ALIQUOTAIPI_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPIS' THEN
                            C.VLRANTERIOR
                         END) CST_PIS_ENT_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPIS' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) CST_PIS_ENT_PIS_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPISSAI' THEN
                            C.VLRANTERIOR
                         END) CST_PIS_SAI_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPISSAI' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) CST_PIS_SAI_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINS' THEN
                            C.VLRANTERIOR
                         END) CST_COFINS_ENT_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINS' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) CST_COFINS_ENT_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINSSAI' THEN
                            C.VLRANTERIOR
                         END) CST_COFINS_SAI_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINSSAI' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) CST_COFINS_SAI_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'CODORIGEMTRIB' THEN
                            C.VLRANTERIOR
                         END) CODORIGEM_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'CODORIGEMTRIB' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END) CODORIGEM_NOVO
        
          FROM MAP_PRODUTO A
         INNER JOIN MAP_FAMDIVISAO B
            ON A.SEQFAMILIA = B.SEQFAMILIA
         INNER JOIN MAP_AUDITORIA C
            ON C.SEQIDENTIFICA = B.SEQFAMILIA
               AND C.TABELA LIKE 'MAP_FAM%'
        
         WHERE 1=1
               AND C.DTAAUDITORIA BETWEEN :DT1 AND :DT2
               AND CAMPO IN ('CODCEST',
                             'CODNBMSH',
                             'SITUACAONFPIS',
                             'SITUACAONFCOFINS',
                             'FINALIDADEFAMILIA',
                             'CODORIGEMTRIB',
                             
                             'NROTRIBUTACAO',
                             'SITUACAONFPISSAI',
                             'SITUACAONFCOFINSSAI')
                             
         GROUP BY SEQPRODUTO, DESCCOMPLETA, DTAAUDITORIA, NVL(USUAUDITORIA, CASE WHEN MODULE = 'DBMS_SCHEDULER' THEN 'AUTOMATICO' ELSE NULL END)
        
         ORDER BY DTAAUDITORIA DESC) AA

 WHERE COALESCE(NROTRIBUTACAO_ANTERIOR,
       NCM_ANTERIOR,
       CODCEST_ANTERIOR,
       FINALIDADEFAMILIA_ANTERIOR,
       
       CST_PIS_ENT_ANTERIOR,
       CST_PIS_SAI_ANTERIOR,
       CST_COFINS_ENT_ANTERIOR,
       CST_COFINS_SAI_ANTERIOR,
       CODORIGEM_ANTERIOR) IS NOT NULL)

ORDER BY DESCRICAO

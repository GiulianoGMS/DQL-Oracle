-- Ticket 484633

SELECT PLU,
       DESCRICAO,
       TO_CHAR(DTAAUDITORIA, 'DD/MM/YYYY') DTA_ALTERACAO,
       USUARIO_ALTERACAO,
       NROTRIBUTACAO_ANTERIOR,
       NROTRIBUTACAO_NOVO,
       NCM_ANTERIOR,
       NCM_NOVO,
       CODCEST_ANTERIOR,
       CODCEST_NOVO,
       FINALIDADEFAMILIA_ANTERIOR,
       FINALIDADEFAMILIA_NOVO,
       ALIQUOTAIPI_ANTERIOR,
       ALIQUOTAIPI_NOVO,
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
                         C.DTAAUDITORIA,
                         USUAUDITORIA USUARIO_ALTERACAO,
                         CASE
                           WHEN CAMPO = 'NROTRIBUTACAO' THEN
                            C.VLRANTERIOR
                         END NROTRIBUTACAO_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'NROTRIBUTACAO' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END NROTRIBUTACAO_NOVO,
                         CASE
                           WHEN CAMPO = 'CODNBMSH' THEN
                            C.VLRANTERIOR
                         END NCM_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'CODNBMSH' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END NCM_NOVO,
                         CASE
                           WHEN CAMPO = 'CODCEST' THEN
                            C.VLRANTERIOR
                         END CODCEST_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'CODCEST' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END CODCEST_NOVO,
                         CASE
                           WHEN CAMPO = 'FINALIDADEFAMILIA' THEN
                            C.VLRANTERIOR
                         END FINALIDADEFAMILIA_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'FINALIDADEFAMILIA' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END FINALIDADEFAMILIA_NOVO,
                         CASE
                           WHEN CAMPO = 'ALIQUOTAIPI' THEN
                            C.VLRANTERIOR
                         END ALIQUOTAIPI_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'ALIQUOTAIPI' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END ALIQUOTAIPI_NOVO,
                         CASE
                           WHEN CAMPO = 'SITUACAONFPIS' THEN
                            C.VLRANTERIOR
                         END CST_PIS_ENT_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'SITUACAONFPIS' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END CST_PIS_ENT_PIS_NOVO,
                         CASE
                           WHEN CAMPO = 'SITUACAONFPISSAI' THEN
                            C.VLRANTERIOR
                         END CST_PIS_SAI_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'SITUACAONFPISSAI' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END CST_PIS_SAI_NOVO,
                         CASE
                           WHEN CAMPO = 'SITUACAONFCOFINS' THEN
                            C.VLRANTERIOR
                         END CST_COFINS_ENT_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'SITUACAONFCOFINS' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END CST_COFINS_ENT_NOVO,
                         CASE
                           WHEN CAMPO = 'SITUACAONFCOFINSSAI' THEN
                            C.VLRANTERIOR
                         END CST_COFINS_SAI_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'SITUACAONFCOFINSSAI' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END CST_COFINS_SAI_NOVO,
                         CASE
                           WHEN CAMPO = 'CODORIGEMTRIB' THEN
                            C.VLRANTERIOR
                         END CODORIGEM_ANTERIOR,
                         CASE
                           WHEN CAMPO = 'CODORIGEMTRIB' THEN
                            NVL(REGEXP_SUBSTR(C.VLRATUAL, '(\S*)(\s)'),
                                B.CODORIGEMTRIB)
                         END CODORIGEM_NOVO
        
          FROM MAP_PRODUTO A
         INNER JOIN MAP_FAMDIVISAO B
            ON A.SEQFAMILIA = B.SEQFAMILIA
         INNER JOIN MAP_AUDITORIA C
            ON C.SEQIDENTIFICA = B.SEQFAMILIA
               AND C.TABELA LIKE 'MAP_FAM%'
        
         WHERE SEQPRODUTO = :NR1
               AND C.DTAAUDITORIA > TRUNC(SYSDATE) - 180
               AND CAMPO IN ('CODCEST',
                             'CODNBMSH',
                             'SITUACAONFPIS',
                             'SITUACAONFCOFINS',
                             'FINALIDADEFAMILIA',
                             'CODORIGEMTRIB',
                             'ALIQUOTAIPI',
                             'NROTRIBUTACAO',
                             'SITUACAONFPISSAI',
                             'SITUACAONFCOFINSSAI')
        
         ORDER BY DTAAUDITORIA DESC) AA

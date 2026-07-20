SELECT * FROM (
SELECT * FROM (
SELECT PLU,
       DESCRICAO,
       'Troca de Atributo' TIPO_ALTERACAO,
       TO_CHAR(DTAAUDITORIA, 'DD/MM/YYYY') DTA_ALTERACAO,
       USUARIO_ALTERACAO,
       CASE WHEN NROTRIBUTACAO_ANTERIOR IS NOT NULL 
         THEN NROTRIBUTACAO_ANTERIOR||' - '||(SELECT TRIBUTACAO FROM MAP_TRIBUTACAO T WHERE T.NROTRIBUTACAO = NROTRIBUTACAO_ANTERIOR) END TRIBUTACAO_ANTERIOR,
       CASE WHEN NROTRIBUTACAO_ANTERIOR IS NOT NULL 
         THEN NROTRIBUTACAO_NOVO||' - '||(SELECT TRIBUTACAO FROM MAP_TRIBUTACAO T WHERE T.NROTRIBUTACAO = NROTRIBUTACAO_NOVO) END NOVA_TRIBUTACAO,
       NCM_ANTERIOR,
      /* NROTRIBUTACAO_ANTERIOR,
       NROTRIBUTACAO_NOVO,*/
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
                         COALESCE(USUAUDITORIA, CASE WHEN MODULE = 'DBMS_SCHEDULER' THEN 'AUTOMATICO' ELSE NULL END, OSUSER) USUARIO_ALTERACAO,
                         MAX(CASE
                           WHEN CAMPO = 'NROTRIBUTACAO' THEN
                            C.VLRANTERIOR
                         END) NROTRIBUTACAO_ANTERIOR,
                         MAX( CASE
                           WHEN CAMPO = 'NROTRIBUTACAO' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) NROTRIBUTACAO_NOVO, 
                         MAX(CASE
                           WHEN CAMPO = 'CODNBMSH' THEN
                            C.VLRANTERIOR
                         END) NCM_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'CODNBMSH' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) NCM_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'CODCEST' THEN
                            C.VLRANTERIOR
                         END) CODCEST_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'CODCEST' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) CODCEST_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'FINALIDADEFAMILIA' THEN
                            C.VLRANTERIOR
                         END) FINALIDADEFAMILIA_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'FINALIDADEFAMILIA' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) FINALIDADEFAMILIA_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'ALIQUOTAIPI' THEN
                            C.VLRANTERIOR
                         END) ALIQUOTAIPI_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'ALIQUOTAIPI' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) ALIQUOTAIPI_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPIS' THEN
                            C.VLRANTERIOR
                         END) CST_PIS_ENT_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPIS' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) CST_PIS_ENT_PIS_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPISSAI' THEN
                            C.VLRANTERIOR
                         END) CST_PIS_SAI_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFPISSAI' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) CST_PIS_SAI_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINS' THEN
                            C.VLRANTERIOR
                         END) CST_COFINS_ENT_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINS' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) CST_COFINS_ENT_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINSSAI' THEN
                            C.VLRANTERIOR
                         END) CST_COFINS_SAI_ANTERIOR,
                         MAX(CASE
                           WHEN CAMPO = 'SITUACAONFCOFINSSAI' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) CST_COFINS_SAI_NOVO,
                         MAX(CASE
                           WHEN CAMPO = 'CODORIGEMTRIB' THEN
                            C.VLRANTERIOR
                         END) CODORIGEM_ANTERIOR,
                         MAX( CASE
                           WHEN CAMPO = 'CODORIGEMTRIB' THEN NVL(SUBSTR(C.VLRATUAL, 0,INSTR(C.VLRATUAL, ' ') -1)
                         , VLRATUAL) END ) CODORIGEM_NOVO
        
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
                             
         GROUP BY SEQPRODUTO, DESCCOMPLETA, DTAAUDITORIA, COALESCE(USUAUDITORIA, CASE WHEN MODULE = 'DBMS_SCHEDULER' THEN 'AUTOMATICO' ELSE NULL END, OSUSER)
        
         ORDER BY DTAAUDITORIA DESC) AA

 WHERE COALESCE(NROTRIBUTACAO_ANTERIOR,
       NCM_ANTERIOR,
       CODCEST_ANTERIOR,
       FINALIDADEFAMILIA_ANTERIOR,
       
       CST_PIS_ENT_ANTERIOR,
       CST_PIS_SAI_ANTERIOR,
       CST_COFINS_ENT_ANTERIOR,
       CST_COFINS_SAI_ANTERIOR,
       CODORIGEM_ANTERIOR) IS NOT NULL
       
     )

UNION

SELECT SEQPRODUTO, DESCCOMPLETA, 'Alteração na tributação', 
       TO_CHAR(H.DTAHORALANCTO, 'DD/MM/YYYY'),
       H.USULANCTO, 
       TO_CHAR(F.NROTRIBUTACAO)||' - '||(SELECT TRIBUTACAO FROM MAP_TRIBUTACAO T WHERE T.NROTRIBUTACAO = F.NROTRIBUTACAO) AS TRIBUTACAO_ANTERIOR,
       TO_CHAR(F.NROTRIBUTACAO)||' - '||(SELECT TRIBUTACAO FROM MAP_TRIBUTACAO T WHERE T.NROTRIBUTACAO = F.NROTRIBUTACAO) AS NOVA_TRIBUTACAO,
       NULL AS NCM_ANTERIOR,
       NULL AS NCM_NOVO,
       NULL AS CODCEST_ANTERIOR,
       NULL AS CODCEST_NOVO,
       NULL AS FINALIDADEFAMILIA_ANTERIOR,
       NULL AS FINALIDADEFAMILIA_NOVO,
       NULL AS CST_PIS_ENT_ANTERIOR,
       NULL AS CST_PIS_ENT_PIS_NOVO,
       NULL AS CST_PIS_SAI_ANTERIOR,
       NULL AS CST_PIS_SAI_NOVO,
       NULL AS CST_COFINS_ENT_ANTERIOR,
       NULL AS CST_COFINS_ENT_NOVO,
       NULL AS CST_COFINS_SAI_ANTERIOR,
       NULL AS CST_COFINS_SAI_NOVO,
       NULL AS CODORIGEM_ANTERIOR,
       NULL AS CODORIGEM_NOVO
       FROM
       MAP_PRODUTO P INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA 
                     INNER JOIN (
    SELECT DTAHORALANCTO,
           USULANCTO,
           NROTRIBUTACAO
    FROM (
        SELECT X.*,
               ROW_NUMBER() OVER (
                   PARTITION BY NROTRIBUTACAO
                   ORDER BY DTAHORALANCTO DESC
               ) RN
        FROM MAP_TRIBUTACAOUFHIST X
        WHERE TRUNC(X.DTAHORALANCTO) BETWEEN :DT1 AND :DT2
          AND X.NROREGTRIBUTACAO = 0
    )
    WHERE RN = 1
) H
ON H.NROTRIBUTACAO = F.NROTRIBUTACAO
)

WHERE TIPO_ALTERACAO = DECODE(:LS2, 'Todas', TIPO_ALTERACAO, :LS2)
ORDER BY 1;

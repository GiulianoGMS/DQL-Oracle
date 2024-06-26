CREATE OR REPLACE VIEW CONSINCO.NAGV_PRODEXCLUSAOITWORKS_V2 AS
SELECT DISTINCT X.SEQIDENTIFICA PRODUTO,
       X.DESCCAMPO DECRICAO, 
       CASE WHEN IDENTIFICADOR LIKE '%EAN%' THEN 'EAN' WHEN IDENTIFICADOR LIKE '%DUN%' THEN 'DUN' WHEN UPPER(IDENTIFICADOR) LIKE '%INTERNO%' THEN 'INTERNO' END TIPO_CODIGOS,
       X.VLRANTERIOR CODIGO,
       X.DTAHORAUDITORIA DTAHORALTERACAO

  FROM CONSINCO.MAP_AUDITORIA X

 WHERE X.TABELA = 'MAP_PRODCODIGO'
   AND X.DESCCAMPO LIKE 'Exclus_o do c_digo de acesso'
   AND (IDENTIFICADOR LIKE '%EAN%' OR IDENTIFICADOR LIKE '%DUN%' OR UPPER(IDENTIFICADOR) LIKE '%INTERNO%')
;

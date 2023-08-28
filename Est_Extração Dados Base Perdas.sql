ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT /*+ PARALLEL(10) */ MES, ANO, EMP, CATEGORIA, 
       SUM(FURTO_20) FURTO_20, SUM(QUEBRAS) QUEBRAS, SUM(QID) QID, SUM(MOD_INVENTARIO) MOD_INVENTARIO, 
       SUM(MOD_OCORRENCIAS) MOD_OCORRENCIAS, SUM(AJUSTE_MANUAL) AJUSTE_MANUAL, SUM(PERDAS_SEM_JUST) PERDAS_SEM_JUST, SUM(FATURAMENTO) FATURAMENTO, SUM(QUEBRA_34) QUEBRA_34 FROM (

SELECT TO_CHAR(A.DTAENTRADASAIDA, 'MM') MES, TO_CHAR(A.DTAENTRADASAIDA, 'YYYY') ANO, A.NROEMPRESA EMP, G.CATEGORIA,
       NVL(CASE WHEN A.CODGERALOPER = 20 THEN ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) FURTO_20,
       NVL(CASE WHEN A.CODGERALOPER IN (30,35,46,47,62,63) THEN
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) QUEBRAS,
       NVL(CASE WHEN A.CODGERALOPER IN (20,34,30,35,46,47,62,63)   THEN 
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 ) 
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) QID,
       NVL(CASE WHEN A.CODGERALOPER IN (401,501) THEN 
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 ) 
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) MOD_INVENTARIO,
       NVL(CASE WHEN A.CODGERALOPER IN (403,503) THEN 
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) MOD_OCORRENCIAS,
       NVL(CASE WHEN A.CODGERALOPER IN (400,500) THEN
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) AJUSTE_MANUAL,
       NVL(CASE WHEN A.CODGERALOPER IN (71)      THEN 
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0) PERDAS_SEM_JUST,          
       NVL(CASE WHEN A.CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911)  THEN 
                                          ROUND(ABS(SUM( A.VLRSAIDAVENDA)),2)END,0) FATURAMENTO,
       NVL(CASE WHEN A.CODGERALOPER IN (34)      THEN 
                                          ROUND(ABS(SUM( A.VLRCTOBRUTOUNIT * ( ( A.QTDENTRADACOMPRA / 1 )
                                                                     + ( A.QTDENTRADAOUTRAS / 1 )
                                                                     - ( A.QTDSAIDAVENDA    / 1 )
                                                                     - ( A.QTDSAIDAOUTRAS   / 1 )))),2) END,0)  QUEBRA_34
          
  FROM MAXV_ABCMOVTOBASE_PROD A INNER JOIN MAP_FAMDIVISAO D     ON D.SEQFAMILIA    = A.SEQFAMILIA
                                INNER JOIN MRL_PRODUTOEMPRESA C ON C.SEQPRODUTO    = A.SEQPRODUTO   AND C.NROEMPRESA = A.NROEMPRESA
                                INNER JOIN MAP_FAMDIVCATEG U    ON U.SEQFAMILIA    = D.SEQFAMILIA   AND U.NRODIVISAO = D.NRODIVISAO
                                INNER JOIN MAXV_CATEGORIA G     ON G.SEQCATEGORIA  = U.SEQCATEGORIA AND G.NRODIVISAO = U.NRODIVISAO
 WHERE 1=1
 
   AND D.NRODIVISAO IN (1) 
   AND A.DTAENTRADASAIDA BETWEEN DATE '2023-05-01' AND DATE '2023-07-31'
   AND A.NRODIVISAO = D.NRODIVISAO
   --AND A.NROEMPRESA IN (1,2)
   AND U.STATUS = 'A'
   AND G.STATUSCATEGOR != 'I'
   AND G.TIPCATEGORIA = 'M'
   AND G.NIVELHIERARQUIA = 1 
   
  GROUP BY TO_CHAR(A.DTAENTRADASAIDA, 'MM'),  TO_CHAR(A.DTAENTRADASAIDA, 'YYYY'), A.NROEMPRESA, CATEGORIA, A.CODGERALOPER

  )
  
  GROUP BY MES, ANO, EMP, CATEGORIA
  ORDER BY EMP, CATEGORIA 

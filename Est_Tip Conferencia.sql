ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT B.NROCARGARECEB NRO_CARGA, 
       DECODE (nvl(B.seqatividadeusuario, 0), 0, 'GUIA CEGA', 'RF') AS TIPO_CONFERENCIA, 
       /*C.NUMERONF*/ A.DESCRICAO Descricao_Carga,  A.NROEMPRESA NRO_LOJA, A.DTAHORGERACAO DATA_GERACAO, A.USUGERACAO,
       DECODE (A.STATUSCARGA, 'G', 'Gerada',      'O', 'Conferência', 'L', 'Liberada',     'D', 'Conferência',      
                              'F', 'Finalizada',  'C', 'Cancelada',   'R', 'Conferência RF',    'Outros') AS STATUS                                                                                                                                                                                                                                                                                                                                                                              
FROM   MAD_CARGARECEB A, MAD_CARGARECITEM B, MAD_CARGARECEBNF C
WHERE  DTAHORGERACAO BETWEEN :DT1 AND :DT2
  AND  A.NROCARGARECEB = B.NROCARGARECEB
  AND  A.NROCARGARECEB = C.NROCARGARECEB
  AND  A.NROEMPRESA = B.NROEMPRESA
  AND  A.NROEMPRESA < 100
  AND  A.NROEMPRESA = C.NROEMPRESA
  AND  A.STATUSCARGA =
       CASE 
         WHEN :LS2 = 'Gerada'         THEN 'G'
         WHEN :LS2 = 'Conferência'    THEN 'O'
         WHEN :LS2 = 'Liberada'       THEN 'L'
         WHEN :LS2 = 'Finalizada'     THEN 'F'
         WHEN :LS2 = 'Cancelada'      THEN 'C'
         WHEN :LS2 = 'Conferência RF'  THEN 'R'
           ELSE A.STATUSCARGA
       END
 AND A.NROEMPRESA = 
       CASE 
         WHEN :LS1 >= 0  THEN  (:LS1)
           ELSE TO_CHAR ( A.NROEMPRESA)
          END
           ORDER BY 1;

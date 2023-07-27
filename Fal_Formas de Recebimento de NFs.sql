ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT C.NUMERONF, X.NROPEDIDOSUPRIM NROPEDIDO, 
       DECODE(F.TIPPEDIDOCOMPRA, 'T','Transferencia','C','Compra','E','Bonif','Outros') TIPO,
       A.NROEMPRESA LOJA, TO_CHAR(A.DTAHORGERACAO, 'DD/MM/YYYY') DATA,
       CASE WHEN EXISTS (SELECT 1 FROM MLF_AUXNFINCONSISTENCIA Y WHERE Y.SEQAUXNOTAFISCAL = F.SEQAUXNOTAFISCAL) THEN 'Sim' ELSE 'Não' END Liberado_Por_Senha,
       DECODE (nvl(B.SEQATIVIDADEUSUARIO, 0), 0, 'MANUAL', 'COLETOR') AS TIPO_CONFERENCIA
                                                                                                                                                                                                                                                                                                                                                                                
FROM   MAD_CARGARECEB A LEFT JOIN MAD_CARGARECEBNF C ON C.NROCARGARECEB = A.NROCARGARECEB AND C.NROEMPRESA = A.NROEMPRESA
                        LEFT JOIN MLF_NOTAFISCAL   F ON F.NROINTERNORECEB = A.NROCARGARECEB AND F.NUMERONF = C.NUMERONF
                        LEFT JOIN MSU_PSITEMRECEBIDO X ON X.SEQAUXNOTAFISCAL = F.SEQAUXNOTAFISCAL AND X.NROEMPRESA = F.NROEMPRESA
                       INNER JOIN MAX_CODGERALOPER Z ON Z.CODGERALOPER = F.CODGERALOPER AND Z.TIPCGO = 'E' AND Z.TIPDOCFISCAL != 'D',
                        MAD_CARGARECITEM B
                                                              
WHERE  DTAHORGERACAO BETWEEN :DT1 AND :DT2
  AND  A.NROCARGARECEB = B.NROCARGARECEB
  AND  A.NROEMPRESA = B.NROEMPRESA 
  AND  F.MODELONF != 0
  AND  A.NROEMPRESA IN (#LS1)
ORDER 
   BY 4,1

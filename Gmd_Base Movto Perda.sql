SELECT TO_CHAR(X.DTAENTRADASAIDA, 'DD/MM/YYYY') DATA_PROC, X.NROEMPRESA ID_LOJA, M.FANTASIA NOME_LOJA, X.SEQPRODUTO COD_PRODUTO,
       DESCCOMPLETA DESC_PRODUTO, X.CODGERALOPER COD_CGO, C.DESCRICAO NOME_CGO, 
       SUM(X.QTDSAIDAVENDA + X.QTDSAIDAOUTRAS) QTD_SAIDA, 
       ROUND(SUM(X.VLRSAIDAVENDA + X.VLRSAIDAOUTRAS),2) VLR_SAIDA, 
       CATEGORIAN1

  FROM MAXV_ABCMOVTOBASE_PROD X INNER JOIN MAX_EMPRESA M ON M.NROEMPRESA = X.NROEMPRESA
                                INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = X.SEQPRODUTO      
                                INNER JOIN MAX_CODGERALOPER C ON C.CODGERALOPER = X.CODGERALOPER   
                                INNER JOIN DIM_CATEGORIA@CONSINCODW CC ON CC.SEQFAMILIA = P.SEQFAMILIA                  
  
 WHERE X.DTAENTRADASAIDA BETWEEN :DT1 AND :DT2
   AND X.NROEMPRESA IN (#LS1)
   AND X.CODGERALOPER IN  (33, 49, 269, 270, 271, 272, 273, 274, 41, 110,
                           111, 112, 113, 114, 115, 24, 66, 21, 25, 90, 91)

 GROUP BY X.DTAENTRADASAIDA,
          X.NROEMPRESA,
          X.SEQPRODUTO,
          X.CODGERALOPER,
          M.FANTASIA,
          DESCCOMPLETA, 
          DESCRICAO,
          CATEGORIAN1

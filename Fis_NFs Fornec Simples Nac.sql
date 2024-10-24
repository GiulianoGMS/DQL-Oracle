ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT N.NROEMPRESA, N.NUMERONF, N.SEQPESSOA||' - '||NOMERAZAO FORNECEDOR, NI.SEQPRODUTO PLU, DESCCOMPLETA DESC_PROD, N.CODGERALOPER CGO,
                                 TO_CHAR(ROUND(NI.VLRPIS,2), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')             VLRPIS,
                                 TO_CHAR(ROUND(NI.PERALIQUOTAPIS,2), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')     PERALIQUOTAPIS,
                                 TO_CHAR(ROUND(NI.VLRCOFINS,2), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')          VLRCOFINS,
                                 TO_CHAR(ROUND(NI.PERALIQUOTACOFINS,2), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')  PERALIQUOTACOFINS,
                                 F.SITUACAONFPIS   ||' - '||(SELECT DESCRICAO FROM MAX_ATRIBUTOFIXO X WHERE X.LISTA = F.SITUACAONFPIS    AND TIPATRIBUTOFIXO = 'SIT_TRIBUT_COFINS')    ST_PIS, 
                                 F.SITUACAONFCOFINS||' - '||(SELECT DESCRICAO FROM MAX_ATRIBUTOFIXO X WHERE X.LISTA = F.SITUACAONFCOFINS AND TIPATRIBUTOFIXO = 'SIT_TRIBUT_COFINS') ST_COFINS
                                                         
  FROM MLF_NOTAFISCAL N INNER JOIN MLF_NFITEM NI ON N.SEQNF = NI.SEQNF
                        INNER JOIN GE_PESSOA  G  ON G.SEQPESSOA = N.SEQPESSOA
                        INNER JOIN MAP_PRODUTO M ON M.SEQPRODUTO = NI.SEQPRODUTO
                        INNER JOIN MAP_FAMILIA F ON F.SEQFAMILIA = M.SEQFAMILIA
                        
 WHERE EXISTS (SELECT 1 
                 FROM CONSINCO.MAF_FORNECEDOR X
                WHERE NVL(MICROEMPRESA, 'N') = DECODE(:LS3, 'Sim','S','Não','N') 
                  AND X.SEQFORNECEDOR = N.SEQPESSOA)
                  
   AND N.DTAENTRADA BETWEEN :DT1 AND :DT2
   AND N.NROEMPRESA   IN (#LS1)
   AND N.CODGERALOPER IN (#LS2)
   AND N.TIPNOTAFISCAL = 'E'
   AND N.STATUSNF != 'C'
   
   ORDER BY 1,2

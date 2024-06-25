-- Adicionar em MLFV_AUXNOTAFISCALINCONS
/*
-- Ticket 333365 - Solic Simone - Adicionado em 28/12/2023 por Giuliano
-- Validação EAN Tributavel - XML x C5
*/
-- Ticket 415219 | Adicionado por Giuliano em 25/06/2024
-- Solic Simone Fiscal - Barrar Ean Trib nulo no XML e existente na C5
   
SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                80  AS CODINCONSISTENC,
                'O Produto: '||B.SEQPRODUTO||' Está com a tag EAN Tributável NULA no XML! Ean(s) C5: '||
                LISTAGG(X2.CODACESSO, ', ')WITHIN GROUP(ORDER BY X2.SEQPRODUTO)||
                ' - Solicite a troca da nota. Dúvidas entrar em contato com o Depto Fiscal.' MSG
      
  FROM CONSINCO.MLF_AUXNOTAFISCAL X INNER JOIN CONSINCO.MLF_AUXNFITEM B ON X.SEQAUXNOTAFISCAL = B.SEQAUXNOTAFISCAL
                                 INNER JOIN TMP_M000_NF K         ON K.M000_NR_CHAVE_ACESSO = X.NFECHAVEACESSO
                                 INNER JOIN TMP_M014_ITEM L       ON L.M000_ID_NF = K.M000_ID_NF  AND L.M014_NR_ITEM = B.SEQITEMNFXML
                                 INNER JOIN MAP_PRODCODIGO X2     ON X2.SEQPRODUTO = B.SEQPRODUTO
                                 INNER JOIN MAP_PRODUTO P         ON P.SEQPRODUTO = B.SEQPRODUTO
                                 INNER JOIN GE_PESSOA G           ON G.SEQPESSOA = X.SEQPESSOA
                                 INNER JOIN MAP_FAMDIVISAO FD     ON FD.SEQFAMILIA = P.SEQFAMILIA

WHERE 1=1 
  AND NOT EXISTS (SELECT 1 FROM MAP_PRODCODIGO X 
                   WHERE X.SEQPRODUTO = B.SEQPRODUTO 
                   AND LPAD(X.CODACESSO,14,0) = LPAD(NVL(L.M014_CD_EAN_TRIB,0),14,0) 
                   AND X.TIPCODIGO = 'E'
                   AND X.INDUTILVENDA = 'S')
       
  AND X.CODGERALOPER = 1
  AND X.SEQPESSOA > 999
  --AND A.DTAENTRADA BETWEEN :DT1 AND :DT2
  AND FD.FINALIDADEFAMILIA = 'R'
  AND X2.TIPCODIGO = 'E'
  AND X2.INDUTILVENDA = 'S'
  -- Inicialmente ira validar apenas a tag nula no XML
  AND X2.CODACESSO IS NOT NULL AND M014_CD_EAN_TRIB IS NULL 
  --AND LPAD(X2.CODACESSO,14,0) != LPAD(NVL(L.M014_CD_EAN_TRIB,0),14,0)
  -- Inicialmente apenas 8 e 501
  AND X.NROEMPRESA IN (501,8)
  GROUP BY X.SEQAUXNOTAFISCAL, X.NUMERONF, X.NROEMPRESA, B.SEQPRODUTO
  

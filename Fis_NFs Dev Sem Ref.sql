SELECT X.SEQNF, X.NUMERONF, X.SEQPESSOA, X.NROEMPRESA, SEQPRODUTO, X.NFREFERENCIANRO, DTAEMISSAO
  FROM CONSINCO.MLF_NFITEM X INNER JOIN CONSINCO.MLF_NOTAFISCAL Z ON X.Seqnf = Z.SEQNF
 WHERE Z.CODGERALOPER = 802 
   AND X.NFREFERENCIANRO IS NULL 
   AND Z.DTAEMISSAO > DATE '2023-06-20'
   AND Z.STATUSNF != 'C'

ORDER BY SEQPRODUTO

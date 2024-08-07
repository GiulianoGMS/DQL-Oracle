ALTER SESSION SET current_schema = CONSINCO; 

-- Alegacao '"Percentual não bate com valor de contrato"'
-- Validando se houve desintegração
-- Pegando também seqauxnotafiscal para a consulta por item
-- PS.: Nao esqueca de ver se todos os itens da nota de fato estão em algum contrato

SELECT * FROM MLF_AUXNOTAFISCAL_LOG X 
 WHERE X.NUMERONF = 3222051 
   AND NROEMPRESA = 501 
   AND OPERACAO IN ('INS','DEL')
   
   ORDER BY 4 DESC

-- Log de alteração por item
  
SELECT * FROM MLF_AUXNFITEM_LOG Y
 WHERE Y.SEQAUXNOTAFISCAL = 5918097
   AND CAMPO IN ('VLRDESCCONTRATO')

-- Contrato

SELECT * FROM MGC_CONTRATO 
WHERE SEQREDE = 1061

-- Log Alterações Contrato

SELECT USUALTERACAO, DTAALTERACAO, A.* FROM CONSINCO.MGC_CONTRATOLOG A
WHERE SEQCONTRATO = 459
ORDER BY 2 DESC

-- Log Alterações por Categoria

SELECT * FROM CONSINCO.MGC_CONTRATOCATEGORIALOG
WHERE SEQCATEGORIA = 41141
ORDER BY 2 DESC 

-- Log Alterações NF

-- MLF_AUXNOTAFISCAL_LOG -- Log NF -- Encontra o SEQAUXNOTAFISCAL
-- MLF_AUXNFITEM_LOG -- Log por Item
  
select x.*
from consinco.mlf_auxnfitem_log x
where x.seqauxnotafiscal = 3567618
ORDER BY DTHRALTERACAO DESC

-- Log Contrato com Desconto

SELECT SEQCONTRATO, DESCRICAO, PERCDESCONTO, USUALTERACAO, DTAALTERACAO FROM MGC_CONTRATODESCONTOLOG WHERE SEQCONTRATO = 2902

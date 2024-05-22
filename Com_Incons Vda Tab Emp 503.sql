-- Criar crítica em MAD_CRITICAPEDCONFIG 

-- Inserir select em MADV_CRITICAPEDVENDA

-- Trava utilização errada de tabela de venda na Emp 503 - Importação

SELECT DISTINCT A.NROPEDVENDA, A.NROEMPRESA, 'Tabela de venda incorreta' CODCRITICA
   FROM CONSINCO.MAD_PEDVENDA A
   
   WHERE 1=1
   AND A.NROEMPRESA   = 503
   AND A.NROTABVENDA != 77
   AND A.CODGERALOPER = 64
   AND A.SITUACAOPED != 'C'

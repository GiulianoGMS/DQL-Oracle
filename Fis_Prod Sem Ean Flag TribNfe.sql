ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT X.NRONOTA, X.NROEMPRESA EMPRESA, X.SEQPESSOA||' - '||
      (SELECT NOMERAZAO FROM GE_PESSOA WHERE SEQPESSOA = X.SEQPESSOA) FORNECEDOR, -- Select para pegar o nome do fornecedor de acordo com o seqpessoa da tabela OR_NFDESPESA
       Z.MOTIVO INCONSISTENCIA,X.USUINCLUSAO USUARIO_INCLUSAO, 
       TO_CHAR(X.DTAINCLUSAO, 'DD/MM/YYYY') DATA_INCLUSAO -- TO_CHAR para formatar a data e ficar no formato correto na aplicação

  FROM CONSINCO.OR_NFDESPESA X INNER JOIN CONSINCO.OR_NFDESPESAINCONSIST Z ON X.SEQNOTA = Z.SEQNOTA -- Join para juntar a tabela de notas e a tabela de inconsistências, para pegar o motivo e apenas as notas que possuem inconsistencias

 WHERE Z.DTAASSINOU IS NULL   -- Notas que não tiveram as inconsistencias assinadas
   AND X.NROEMPRESA IN (#LS1) -- #LS1 é o select que a aplicação faz para buscar as empresas (filtro na query)
 
 ORDER BY 2,1

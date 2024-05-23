ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Tkt 403327

SELECT NROEMPRESA, X.SEQPESSOA||' - '||G.NOMERAZAO FORNEC, X.NROTITULO, CODESPECIE,
       TO_CHAR(DTAVENCIMENTO,'DD/MM/YYYY') DTAVENCIMENTO, 
       DECODE(ABERTOQUITADO, 'A','ABERTO','Q','QUITADO') SITUACAO,
       DECODE(A.TIPOPAGAMENTO,
             'FOR','Fornecedores',
             'DIV','Diversos',
             'SAL','Salário',
              NULL) DESCTIPOPAGAMENTO, 
       DECODE(A.FORMAPAGAMENTO, 
             'CHQ','Cheque',
             'CCC','Credito em Conta',
             'CCO','Credito Conta Online',
             'DCC','DOC Compensação',
             'OPG','Ordem de Pagamento',
             'TDC','TED - CIP',
             'TDS','TED - STR')FORMAPAGAMENTO
             
  FROM FI_TITULO X INNER JOIN FI_COMPLTITULO A ON A.SEQTITULO = X.SEQTITULO
                   INNER JOIN GE_PESSOA G      ON G.SEQPESSOA = X.SEQPESSOA
                   
 WHERE X.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
   AND OBRIGDIREITO = 'O'
   AND FORMAPAGAMENTO IN ('CHQ',
                          'CCC',
                          'CCO',
                          'DCC',
                          'OPG',
                          'TDC',
                          'TDS')

   AND NROEMPRESA IN (#LT1)
   
   ORDER BY 1,2
   
   

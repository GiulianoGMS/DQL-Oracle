ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Tkt 403327 

-- Nova Vs 3

SELECT X.NROEMPRESA LJ, X.SEQPESSOA||' - '||G.NOMERAZAO FORNEC, X.NROTITULO, X.CODESPECIE,
       TO_CHAR(X.DTAVENCIMENTO,'DD/MM/YYYY') DTAVENCIMENTO, 
       DECODE(ABERTOQUITADO, 'A','ABERTO','Q','QUITADO') ||
       CASE WHEN EXISTS (SELECT 1 FROM FI_AUTPAGTO AUT WHERE AUT.SEQTITULO = X.SEQTITULO) THEN ' - AUTORIZADO' ELSE NULL END SITUACAO_TIT,
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
             'TDS','TED - STR') FORMAPAGAMENTO, 
       CASE WHEN B.SITUACAO = 'C' THEN 'CANCELADA'
            WHEN B.SITUACAO = 'P' THEN 'PAGA' 
            WHEN B.SITUACAO = 'N' AND NVL(B.SEQENVIO,0) > 0 THEN 'ENVIADA'
            WHEN B.SITUACAO IS NULL THEN 'NÃO PROGRAMADA'
       ELSE 'PROGRAMADA' END SITUACAO_PAG,
       CASE WHEN B.SITUACAO = 'C' THEN NULL ELSE FC.NROBANCO END BANCO_ENVIO, FB.BANCO BANCO_RECEB 

  FROM FI_TITULO X  LEFT JOIN FI_COMPLTITULO A ON A.SEQTITULO = X.SEQTITULO
                   INNER JOIN GE_PESSOA G      ON G.SEQPESSOA = X.SEQPESSOA 
                    LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY SEQTITULO ORDER BY SITUACAO DESC) ODR, B.*
                                 FROM FI_PROGPAGAMENTO B) B ON B.SEQTITULO = X.SEQTITULO AND ODR = 1
                    LEFT JOIN FI_CTACORRENTE FC ON FC.SEQCTACORRENTE = B.SEQCTACORRENTE 
                    LEFT JOIN FIV_FORNCONTAPESSOA FB ON FB.SEQPESSOA = X.SEQPESSOA AND FB.SEQCONTA = A.SEQCONTA AND FB.SITUACAO = 'A'
                  /*LEFT JOIN CONSINCO.FI_RETPAGTOELETR FR ON FR.SEQENVIO = B.SEQENVIO*/
                  
 WHERE X.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
  AND OBRIGDIREITO = 'O'
   /* Filtra formas */  
   AND NVL(FORMAPAGAMENTO, 'X') !=  'TDS'
   AND(NVL(FORMAPAGAMENTO, 'X') IN ('CHQ',
                                    'CCO',
                                    'OPG',
                                    'TDC',
                                    'DCC')
   /* Se for CCC ou DCC, analisa o banco */ 
   OR FORMAPAGAMENTO IN ('CCC'/*, 'DCC'*/) AND (NVL(FC.NROBANCO,999) != NVL(FB.BANCO,888) OR B.SEQTITULO IS NULL)
   /* Se o pagto estiver cancelado */
   OR NVL(FORMAPAGAMENTO, 'X') IN  ('CHQ',
                                    'CCC', 
                                    'CCO',
                                    'DCC', 
                                    'OPG',
                                    'TDC')
                                    AND B.SITUACAO = 'C' AND ABERTOQUITADO = 'A'
                                    
   OR EXISTS (SELECT 1 FROM FI_AUTPAGTO AUT WHERE AUT.SEQTITULO = X.SEQTITULO  AND FORMAPAGAMENTO IS NULL))
   AND X.NROEMPRESA IN (#LS1)
   AND ABERTOQUITADO = 'A'
   AND X.CODESPECIE IN ('AGUA','ALUGPG','ANTREC','ATIVO','ATIVOC','ATIVEFU','COFINS','CRIPAG','CSSLL','DESP',
                        'DESPKM','DIVSOC','DUPP','DVRBEC','ENERGI','ESPORT','FATICD','FATNAG','FGTS','FGTSQT','FRETE','GNRE',
                        'ICMS','IMPOST','INSS','INSSNF','INTANG','IPI','IPTU','IR','IRRFFP','IRRFNF','ISSQN','ISSQNP','ISSST',
                        'LEIROU','MKFUNC','MKPREM','PAGEST','PCCNF','PIS','RECARG','REEMB','RESCIS','RETSOC','SEGURO','SERVPJ','SUPERT','TEL','VLDESC')
   ORDER BY 2;


-- Nova Vs 2

SELECT X.NROEMPRESA LJ, X.SEQPESSOA||' - '||G.NOMERAZAO FORNEC, X.NROTITULO, X.CODESPECIE,
       TO_CHAR(X.DTAVENCIMENTO,'DD/MM/YYYY') DTAVENCIMENTO, 
       DECODE(ABERTOQUITADO, 'A','ABERTO','Q','QUITADO') SITUACAO_TIT,
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
             'TDS','TED - STR') FORMAPAGAMENTO, 
       CASE WHEN B.SITUACAO = 'C' THEN 'CANCELADA'
            WHEN B.SITUACAO = 'P' THEN 'PAGA'
            WHEN B.SITUACAO = 'N' AND NVL(B.SEQENVIO,0) > 0 THEN 'ENVIADA'
            WHEN B.SITUACAO IS NULL THEN 'NÃO PROGRAMADA'
       ELSE 'PROGRAMADA' END SITUACAO_PAG,
       CASE WHEN B.SITUACAO = 'C' THEN NULL ELSE FC.NROBANCO END BANCO_ENVIO, FB.BANCO BANCO_RECEB

  FROM FI_TITULO X INNER JOIN FI_COMPLTITULO A ON A.SEQTITULO = X.SEQTITULO
                   INNER JOIN GE_PESSOA G      ON G.SEQPESSOA = X.SEQPESSOA
                    LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY SEQTITULO ORDER BY SITUACAO DESC) ODR, B.*
                                 FROM FI_PROGPAGAMENTO B) B ON B.SEQTITULO = X.SEQTITULO AND ODR = 1
                    LEFT JOIN FI_CTACORRENTE FC ON FC.SEQCTACORRENTE = B.SEQCTACORRENTE 
                    LEFT JOIN FIV_FORNCONTAPESSOA FB ON FB.SEQPESSOA = X.SEQPESSOA AND FB.SEQCONTA = A.SEQCONTA AND FB.SITUACAO = 'A'
                  /*LEFT JOIN CONSINCO.FI_RETPAGTOELETR FR ON FR.SEQENVIO = B.SEQENVIO*/
                  
 WHERE X.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
  AND OBRIGDIREITO = 'O'
   /* Filtra formas */  
   AND NVL(FORMAPAGAMENTO, 'X') !=  'TDS'
   AND(NVL(FORMAPAGAMENTO, 'X') IN ('CHQ',
                                    'CCO',
                                    'OPG',
                                    'TDC')
   /* Se for CCC ou DCC, analisa o banco */ 
   OR FORMAPAGAMENTO IN ('CCC', 'DCC') AND (NVL(FC.NROBANCO,999) != NVL(FB.BANCO,888) OR B.SEQTITULO IS NULL)
   /* Se o pagto estiver cancelado */
   OR NVL(FORMAPAGAMENTO, 'X') IN  ('CHQ',
                                    'CCC', 
                                    'CCO',
                                    'DCC', 
                                    'OPG',
                                    'TDC')
                                    AND B.SITUACAO = 'C' AND ABERTOQUITADO = 'A')
   AND X.NROEMPRESA IN (#LS1)
   AND ABERTOQUITADO = 'A'
   AND X.CODESPECIE IN ('AGUA','ALUGPG','ANTREC','ATIVO','ATIVOC','ATIVEFU','COFINS','CRIPAG','CSSLL','DESP',
                        'DESPKM','DIVSOC','DUPP','DVRBEC','ENERGI','ESPORT','FATICD','FATNAG','FGTS','FGTSQT','FRETE','GNRE',
                        'ICMS','IMPOST','INSS','INSSNF','INTANG','IPI','IPTU','IR','IRRFFP','IRRFNF','ISSQN','ISSQNP','ISSST',
                        'LEIROU','MKFUNC','MKPREM','PAGEST','PCCNF','PIS','RECARG','REEMB','RESCIS','RETSOC','SEGURO','SERVPJ','SUPERT','TEL','VLDESC')
   ORDER BY 1,2;
-- Nova Vs 1

SELECT X.SEQTITULO, X.NROEMPRESA, X.SEQPESSOA||' - '||G.NOMERAZAO FORNEC, X.NROTITULO, X.CODESPECIE,
       TO_CHAR(X.DTAVENCIMENTO,'DD/MM/YYYY') DTAVENCIMENTO, 
       DECODE(ABERTOQUITADO, 'A','ABERTO','Q','QUITADO') SITUACAO_TIT,
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
             'TDS','TED - STR') FORMAPAGAMENTO, 
       CASE WHEN B.SITUACAO = 'C' THEN 'CANCELADA'
            WHEN B.SITUACAO = 'P' THEN 'PAGA'
            WHEN B.SITUACAO = 'N' AND NVL(B.SEQENVIO,0) > 0 THEN 'ENVIADA'
            WHEN B.SITUACAO IS NULL THEN 'NÃO PROGRAMADA'
       ELSE 'PROGRAMADA' END SITUACAO_PAG,
       FC.NROBANCO BANCO_ENVIO, FB.BANCO BANCO_RECEB, A.USUALTERACAO
             
  FROM FI_TITULO X INNER JOIN FI_COMPLTITULO A ON A.SEQTITULO = X.SEQTITULO
                   INNER JOIN GE_PESSOA G      ON G.SEQPESSOA = X.SEQPESSOA
                    LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY SEQTITULO ORDER BY SITUACAO DESC) ODR, B.*
                                 FROM FI_PROGPAGAMENTO B) B ON B.SEQTITULO = X.SEQTITULO AND ODR = 1
                    LEFT JOIN FI_CTACORRENTE FC ON FC.SEQCTACORRENTE = B.SEQCTACORRENTE 
                    LEFT JOIN FIV_FORNCONTAPESSOA FB ON FB.SEQPESSOA = X.SEQPESSOA AND FB.SEQCONTA = A.SEQCONTA AND FB.SITUACAO = 'A'
                  /*LEFT JOIN CONSINCO.FI_RETPAGTOELETR FR ON FR.SEQENVIO = B.SEQENVIO*/
                  
 WHERE X.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
   AND OBRIGDIREITO = 'O'
   
   AND (FORMAPAGAMENTO IN ('CCC', 'DCC') AND (FC.NROBANCO != FB.BANCO)
    
    OR B.SEQPROGRAMACAO IS NULL
    OR NVL(B.SITUACAO, 'C') = 'C' AND ABERTOQUITADO = 'A')
   
   AND FORMAPAGAMENTO IN ('CHQ',
                          'CCC',
                          'CCO',
                          'DCC',
                          'OPG',
                          'TDC')

   AND X.NROEMPRESA IN (#LS1)
   
   AND X.CODESPECIE IN ('AGUA','ALUGPG','ANTREC','ATIVO','ATIVOC','ATIVEFU','COFINS','CRIPAG','CSSLL','DESP',
                        'DESPKM','DIVSOC','DUPP','DVRBEC','ENERGI','ESPORT','FATICD','FATNAG','FGTS','FGTSQT','FRETE','GNRE',
                        'ICMS','IMPOST','INSS','INSSNF','INTANG','IPI','IPTU','IR','IRRFFP','IRRFNF','ISSQN','ISSQNP','ISSST',
                        'LEIROU','MKFUNC','MKPREM','PAGEST','PCCNF','PIS','RECARG','REEMB','RESCIS','RETSOC','SEGURO','SERVPJ','SUPERT','TEL','VLDESC')
   ORDER BY 1,2;

-- Old

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Tkt 403327

SELECT X.SEQTITULO, X.NROEMPRESA, X.SEQPESSOA||' - '||G.NOMERAZAO FORNEC, X.NROTITULO, X.CODESPECIE,
       TO_CHAR(X.DTAVENCIMENTO,'DD/MM/YYYY') DTAVENCIMENTO, 
       DECODE(ABERTOQUITADO, 'A','ABERTO','Q','QUITADO') SITUACAO_TIT,
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
             'TDS','TED - STR') FORMAPAGAMENTO, 
       CASE WHEN B.SITUACAO = 'C' THEN 'CANCELADA'
            WHEN B.SITUACAO = 'P' THEN 'PAGA'
            WHEN B.SITUACAO = 'N' AND NVL(B.SEQENVIO,0) > 0 THEN 'ENVIADA'
            WHEN B.SITUACAO IS NULL THEN 'NÃO PROGRAMADA'
       ELSE 'PROGRAMADA' END SITUACAO_PAG, A.USUALTERACAO
             
  FROM FI_TITULO X INNER JOIN FI_COMPLTITULO A ON A.SEQTITULO = X.SEQTITULO
                   INNER JOIN GE_PESSOA G      ON G.SEQPESSOA = X.SEQPESSOA
                    LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY SEQTITULO ORDER BY SITUACAO DESC) ODR, B.*
                                 FROM FI_PROGPAGAMENTO B) B ON B.SEQTITULO = X.SEQTITULO AND ODR = 1
                    LEFT JOIN FI_CTACORRENTE FC ON FC.SEQCTACORRENTE = B.SEQCTACORRENTE 
                    LEFT JOIN FIV_FORNCONTAPESSOA FB ON FB.SEQPESSOA = X.SEQPESSOA AND FB.SITUACAO = 'A'
                    LEFT JOIN CONSINCO.FI_RETPAGTOELETR FR ON FR.SEQENVIO = B.SEQENVIO
                  
 WHERE X.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
   AND OBRIGDIREITO = 'O'
   
   AND (FORMAPAGAMENTO = 'CCC' AND FR.NROBANCO = 341 AND DESCRICAO NOT LIKE '%ITAU%'
    OR  FORMAPAGAMENTO = 'CCC' AND FR.NROBANCO = 237 AND DESCRICAO NOT LIKE '%BRAD%'
    OR  FORMAPAGAMENTO = 'CCC' AND FR.NROBANCO = 033 AND DESCRICAO NOT LIKE '%SANT%'
    
    OR B.SEQPROGRAMACAO IS NULL
    OR NVL(B.SITUACAO, 'C') = 'C' AND ABERTOQUITADO = 'A')
   
   AND FORMAPAGAMENTO IN ('CHQ',
                          'CCC',
                          'CCO',
                          'DCC',
                          'OPG',
                          'TDC')

   AND X.NROEMPRESA IN (#LS1)
   
   AND X.CODESPECIE IN ('AGUA','ALUGPG','ANTREC','ATIVO','ATIVOC','ATIVEFU','COFINS','CRIPAG','CSSLL','DESP',
                        'DESPKM','DIVSOC','DUPP','DVRBEC','ENERGI','ESPORT','FATICD','FATNAG','FGTS','FGTSQT','FRETE','GNRE',
                        'ICMS','IMPOST','INSS','INSSNF','INTANG','IPI','IPTU','IR','IRRFFP','IRRFNF','ISSQN','ISSQNP','ISSST',
                        'LEIROU','MKFUNC','MKPREM','PAGEST','PCCNF','PIS','RECARG','REEMB','RESCIS','RETSOC','SEGURO','SERVPJ','SUPERT','TEL','VLDESC')
   ORDER BY 1,2;
   
   

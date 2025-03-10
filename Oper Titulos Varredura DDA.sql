SELECT * FROM (

SELECT CASE  WHEN GE_PESSOA.SEQPESSOA IS NULL THEN FIV_DDATITULOSBUSCA.DESCFORNECEDOR ELSE GE_PESSOA.NOMERAZAO || ' - ' || GE_PESSOA.SEQPESSOA 
       END FORNECEDOR, SUBSTR(fc5maskcnpjcpf(FIV_DDATITULOSBUSCA.NROCNPJCPF, FIV_DDATITULOSBUSCA.DIGCNPJCPF, DECODE(FIV_DDATITULOSBUSCA.TIPODOC,
       'CNPJ', 'J', 'F') ), 1, 20) CNPJ,
       CASE WHEN FIV_DDATITULOSBUSCA.SEQTITULO IS NULL THEN NULL ELSE FI_TITULO.NROTITULO || '-' || FI_TITULO.SERIETITULO || '/' || FI_TITULO.NROPARCELA END Numero_Titulo,
       FIV_DDATITULOSBUSCA.SEUNUMERO, FIV_DDATITULOSBUSCA.NRODOCUMENTO DDA_NRODOC, 
       TO_CHAR(FIV_DDATITULOSBUSCA.VALORDOCUMENTO, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') DDA_VALOR, 
       TO_CHAR(FIV_DDATITULOSBUSCA.VALORDESCONTO1, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') DDA_VLRDESCONTO,
       TO_CHAR(FIV_DDATITULOSBUSCA.VALORABATIMENTO, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') DDA_VLRABATIMENTO, 
       TO_CHAR(FIV_DDATITULOSBUSCA.VALORDOCUMENTO - FIV_DDATITULOSBUSCA.VALORDESCONTO1 - FIV_DDATITULOSBUSCA.VALORABATIMENTO, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') DDA_VLRLIQUIDO,
       TO_CHAR(FI_TITULO.VLRNOMINAL, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') C5_VALOR,
       TO_CHAR(CASE WHEN FI_TITULO.SEQTITULO IS NULL THEN NULL ELSE NVL(PKG_FINANCEIRO.FIF_DESCONTO(FI_TITULO.SEQTITULO, FI_TITULO.DTAEMISSAO, 'N'), 0) END, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') C5_VLRDESCONTO,
       TO_CHAR(FI_TITULO.VLRPAGO, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') C5_VLRABATIMENTO,
       TO_CHAR(CASE WHEN FI_TITULO.SEQTITULO IS NULL THEN NULL ELSE FI_TITULO.VLRNOMINAL - FI_TITULO.VLRPAGO - NVL(PKG_FINANCEIRO.FIF_DESCONTO(FI_TITULO.SEQTITULO, FI_TITULO.DTAEMISSAO, 'N'), 0) END, 'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''') C5_VLRLIQUIDO, 
       TO_CHAR(FIV_DDATITULOSBUSCA.DTAEMISSAO, 'DD-MM-YYYY') EMISSAO, TO_CHAR(FIV_DDATITULOSBUSCA.DTAVENCIMENTO, 'DD-MM-YYYY') VENCIMENTO, 
       TO_CHAR(FIV_DDATITULOSBUSCA.DTAIMPORTACAO, 'DD-MM-YYYY') IMPORTACAO, 
       GE_BANCO.NROBANCO || ' - ' || GE_BANCO.RAZAOSOCIAL BANCO,  
       DECODE(FIV_DDATITULOSBUSCA.SEQTITULO,NULL,'Não','Sim') A,  
       CASE WHEN FIV_DDATITULOSBUSCA.SEQTITULO IS NULL THEN NULL ELSE DECODE(PKG_FINANCEIRO.FIF_TITAUTORIZADOPAGTO(FIV_DDATITULOSBUSCA.SEQTITULO),0,'Não','Sim') END P

FROM FIV_DDATITULOSBUSCA, GE_BANCO, FI_CTACORRENTE, GE_PESSOA, FI_COMPLTITULO, FI_TITULO 

Where  
  FIV_DDATITULOSBUSCA.NROBANCO = GE_BANCO.NROBANCO  
AND   FIV_DDATITULOSBUSCA.SEQCTACORRENTE = FI_CTACORRENTE.SEQCTACORRENTE 
AND FIV_DDATITULOSBUSCA.SEQPESSOA = GE_PESSOA.SEQPESSOA(+) 
AND FIV_DDATITULOSBUSCA.SEQIMPORTACAO = FI_COMPLTITULO.SEQIMPORTACAODDA(+) 
AND   FIV_DDATITULOSBUSCA.NROLINHA = FI_COMPLTITULO.NROLINHADDA(+) 
AND FI_COMPLTITULO.SEQTITULO = FI_TITULO.SEQTITULO(+) 
AND     FIV_DDATITULOSBUSCA.NROEMPRESAMAE = 601                 
AND FIV_DDATITULOSBUSCA.DTAVENCIMENTO BETWEEN :DT1 AND :DT2       
AND (FIV_DDATITULOSBUSCA.SEQPESSOA = :NR1 OR FIV_DDATITULOSBUSCA.NROCNPJCPF = (SELECT NROCGCCPF FROM GE_PESSOA WHERE SEQPESSOA = :NR1))                

ORDER BY 1,3 ) X

WHERE A LIKE (DECODE(:LS1,'Titulos Associados','Sim','Títulos NÃO Associados','Não','%%'))

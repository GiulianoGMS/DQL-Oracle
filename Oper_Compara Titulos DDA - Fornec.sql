SELECT *
FROM (
SELECT FORNECEDOR, LPAD(X.NROCNPJCPF, 12, 0) || LPAD(X.DIGCNPJCPF, 2, 0) CNPJ,
       GE.FANTASIA||CASE WHEN CNPJSAC IS NULL THEN NULL ELSE ' - Arquivo DDA na LJ '||CNPJSAC END
EMPRESA , X.CODESPECIE,

CASE WHEN TO_CHAR(DOC_C5) = TIT_C5 THEN TO_CHAR(DOC_C5) ELSE DOC_C5||' - Tit.: '||TIT_C5 END DOC_C5, 
CASE WHEN DIVERGENCIA IS NULL AND DOCTO IS NULL     THEN 'Titulo não encontrado' 
WHEN DIVERGENCIA IS NULL AND DOCTO IS NOT NULL THEN 'Título encontrado - '||CASE WHEN LPAD(X.NROCNPJCPF, 12, 0) = (SELECT MAX(LPAD(D.NROCGCCPF, 12, 0)) FROM GE_PESSOA D WHERE D.NROCGCCPF = X.NROCNPJCPF AND D.STATUS = 'A')
OR  LPAD(X.NROCNPJCPF,12,0)||LPAD(X.DIGCNPJCPF,2,0) IN
(SELECT LPAD(FR.NROCNPJCPF,12,0)||LPAD(FR.DIGCNPJCPF,2,0) FROM FI_DDAREGRADETALHE FR WHERE FR.NROCNPJCPF = X.NROCNPJCPF)     
THEN 'Diverg Não Identificada' ELSE 'CNPJ Não Cadastrado!' END
ELSE DIVERGENCIA||CASE WHEN LPAD(X.NROCNPJCPF,12,0)||LPAD(X.DIGCNPJCPF,2,0) IN
(SELECT LPAD(FR.NROCNPJCPF,12,0)||LPAD(FR.DIGCNPJCPF,2,0) FROM FI_DDAREGRADETALHE FR WHERE FR.NROCNPJCPF = X.NROCNPJCPF)
OR  LPAD(X.NROCNPJCPF, 12, 0) = (SELECT MAX(LPAD(D.NROCGCCPF, 12, 0)) FROM GE_PESSOA D WHERE D.NROCGCCPF = X.NROCNPJCPF AND D.STATUS = 'A')
THEN NULL ELSE ' - CNPJ Não Cadastrado!' END END DIVERGENCIA, 
DOCTO DOCTO_DDA, Emissao, Vencimento, Valor, DESCONTO1, DATADESCONTO1, DESCONTO2, DATADESCONTO2, VALORABATIMENTO, CODIGODEBARRAS, SEQ, CNPJSAC, EMP

FROM (

SELECT CASE WHEN LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) NOT IN (SELECT DISTINCT LPAD(GE.NROCGCCPF,12,0)||LPAD(GE.DIGCGCCPF,2,0) FROM GE_PESSOA GE WHERE GE.SEQPESSOA IN (GM.NROEMPRESA)) THEN (SELECT DISTINCT SEQPESSOA FROM GE_PESSOA GE WHERE LPAD(GE.NROCGCCPF,12,0)||LPAD(GE.DIGCGCCPF,2,0) = LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) AND SEQPESSOA < 1000) ELSE NULL END CNPJSAC,
GE.NOMERAZAO||' - '||GE.SEQPESSOA Fornecedor, DDA2.DESCFORNECEDOR, GE.SEQPESSOA SEQ, DDA2.NRODOCUMENTO DOCTO, F.NRODOCUMENTO DOC_C5, F.NROTITULO TIT_C5, F.CODESPECIE, DDA2.NRODOCUMENTO,
TO_CHAR(DDA2.DTAEMISSAO,'DD/MM/YYYY') EMISSAO, TO_CHAR(DDA2.DTAVENCIMENTO,'DD/MM/YYYY') VENCIMENTO, DDA2.VALORDOCUMENTO VALOR, DDA2.VALORDESCONTO1 DESCONTO1, TO_CHAR(DDA2.DTADESCONTO1,'DD/MM/YYYY') DATADESCONTO1, DDA2.VALORDESCONTO2 DESCONTO2, TO_CHAR(DDA2.DTADESCONTO2,'DD/MM/YYYY') DATADESCONTO2, DDA2.VALORABATIMENTO, DDA2.CODBARRAS CODIGODEBARRAS,

CASE WHEN (
SELECT SUM(F2.VLRORIGINAL) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.OBRIGDIREITO = 'O'
AND F2.ABERTOQUITADO = 'A' 
AND F2.SITUACAO != 'S'  
AND NVL(F2.SUSPLIB,'L') = 'L'
AND F2.SEQTITULO NOT IN (     
SELECT  SEQTITULO
FROM  FI_AUTPAGTO
WHERE   FI_AUTPAGTO.SEQTITULO = F2.SEQTITULO)
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) IN (
SELECT (VALORDOCUMENTO - A.VALORDESCONTO1 - A.VALORABATIMENTO) FROM FIV_DDATITULOSBUSCA A 
WHERE A.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(a.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA))))
THEN 'Títulos Agrupados - DOC DDA: '||DDA2.NRODOCUMENTO||' - Valor Total: '||DDA2.VALORCOMDESCONTO

WHEN (
SELECT SUM(F2.VLRNOMINAL) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.OBRIGDIREITO = 'O'
AND F2.ABERTOQUITADO = 'A' 
AND F2.SITUACAO != 'S'  
AND NVL(F2.SUSPLIB,'L') = 'L'
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) IN (
SELECT (VALORDOCUMENTO - A.VALORDESCONTO1 - A.VALORABATIMENTO) FROM FIV_DDATITULOSBUSCA A 
WHERE A.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(a.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA))))
THEN 'Títulos Agrupados - DOC DDA: '||DDA2.NRODOCUMENTO||' - Valor Total: '||DDA2.VALORCOMDESCONTO

WHEN (
SELECT SUM(F2.VLRORIGINAL) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.OBRIGDIREITO = 'O'
AND F2.ABERTOQUITADO    = 'A' 
AND F2.SITUACAO        != 'S'  
AND NVL(F2.SUSPLIB,'L') = 'L'
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) IN (
SELECT ((VALORDOCUMENTO - 0.01)- NVL(A.VALORDESCONTO1,0) - NVL(A.VALORABATIMENTO,0))  FROM FIV_DDATITULOSBUSCA A 
WHERE A.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(a.ACEITO,'N') = 'N' 
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
UNION ALL
SELECT ((VALORDOCUMENTO + 0.01)- NVL(A.VALORDESCONTO1,0) - NVL(A.VALORABATIMENTO,0))  FROM FIV_DDATITULOSBUSCA A 
WHERE A.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(a.ACEITO,'N') = 'N' 
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
UNION ALL
SELECT ((VALORDOCUMENTO + 0.02)- NVL(A.VALORDESCONTO1,0) - NVL(A.VALORABATIMENTO,0))  FROM FIV_DDATITULOSBUSCA A 
WHERE A.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(a.ACEITO,'N') = 'N' 
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
UNION ALL
SELECT ((VALORDOCUMENTO - 0.02)- NVL(A.VALORDESCONTO1,0) - NVL(A.VALORABATIMENTO,0))  FROM FIV_DDATITULOSBUSCA A 
WHERE A.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(a.ACEITO,'N') = 'N' 
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA))))
THEN 'Títulos Agrupados - Valor Sistema: '||TO_CHAR((
SELECT SUM(F2.VLRORIGINAL) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1),'FM999G999G999D90', 'nls_numeric_characters='',.''')||' - Valor DDA: '||
TO_CHAR(DDA2.VALORCOMDESCONTO,'FM999G999G999D90', 'nls_numeric_characters='',.''')||CASE WHEN F.DTAVENCIMENTO != DDA2.DTAVENCIMENTO
THEN ' - Data de Vencimento Sistema: '||TO_CHAR(F.DTAVENCIMENTO, 'DD/MM/YYYY')||' - DDA: '||TO_CHAR(DDA2.DTAVENCIMENTO, 'DD/MM/YYYY') ELSE NULL END

WHEN (F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)) != (DDA2.VALORDOCUMENTO - NVL((DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO),0))
THEN 'Valor Total Sistema: '||TO_CHAR((F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)),'FM999G999G999D90', 'nls_numeric_characters='',.''')||' - DDA: '||
TO_CHAR(DDA2.VALORCOMDESCONTO,'FM999G999G999D90', 'nls_numeric_characters='',.''')||' | Desconto Sistema: '||
TO_CHAR(NVL((FC.VLRDESCCONTRATO+FC.VLRDSCFINANC+F.VLRPAGO),0),'FM999G999G999D90', 'nls_numeric_characters='',.''')||' - DDA: '||
TO_CHAR((DDA2.VALORDESCONTO1 + DDA2.VALORDESCONTO2+DDA2.VALORDESCONTO3+DDA2.VALORABATIMENTO),'FM999G999G999D90', 'nls_numeric_characters='',.''')||CASE WHEN DDA2.DTAVENCIMENTO != F.DTAVENCIMENTO THEN CASE WHEN DDA2.DTAVENCIMENTO != F.DTAPROGRAMADA 
THEN ' | Data de Vencimento Sistema: '||TO_CHAR(F.DTAVENCIMENTO, 'DD/MM/YYYY')||' - DDA: '||TO_CHAR(DDA2.DTAVENCIMENTO, 'DD/MM/YYYY') ELSE NULL END ELSE NULL END
WHEN DDA2.DTAVENCIMENTO != F.DTAVENCIMENTO THEN CASE WHEN DDA2.DTAVENCIMENTO != F.DTAPROGRAMADA 
THEN 'Data de Vencimento Sistema: '||TO_CHAR(F.DTAVENCIMENTO, 'DD/MM/YYYY')||' - DDA: '||TO_CHAR(DDA2.DTAVENCIMENTO, 'DD/MM/YYYY') ELSE NULL END

ELSE NULL END Divergencia, DDA2.NROCNPJCPF, DDA2.DIGCNPJCPF, GM.NROEMPRESA EMP
FROM FI_TITULO F 

INNER JOIN FI_ESPECIE FI      ON F.CODESPECIE = FI.CODESPECIE AND F.NROEMPRESAMAE = FI.NROEMPRESAMAE
INNER JOIN GE_PESSOA  GE      ON F.SEQPESSOA  = GE.SEQPESSOA  
INNER JOIN FI_COMPLTITULO  FC ON F.SEQTITULO  = FC.SEQTITULO
INNER JOIN GE_EMPRESA GM      ON F.NROEMPRESA = GM.NROEMPRESA
LEFT JOIN FIV_DDATITULOSBUSCA DDA2 ON 
(LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND DDA2.DTAVENCIMENTO = F.DTAVENCIMENTO AND DDA2.NRODOCUMENTO LIKE ('%'||F.NROTITULO||'%') AND (LENGTH(DDA2.NRODOCUMENTO)) > 4 AND NVL(DDA2.ACEITO,'N') = 'N'
OR (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND DDA2.DTAVENCIMENTO = F.DTAPROGRAMADA AND DDA2.NRODOCUMENTO LIKE ('%'||F.NROTITULO||'%')AND (LENGTH(DDA2.NRODOCUMENTO)) > 4 AND NVL(DDA2.ACEITO,'N') = 'N'
OR (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND DDA2.DTAVENCIMENTO = F.DTAVENCIMENTO AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND (LENGTH(DDA2.NRODOCUMENTO)) > 4 AND NVL(DDA2.ACEITO,'N') = 'N' 
OR (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND DDA2.DTAVENCIMENTO = F.DTAPROGRAMADA AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%')AND (LENGTH(DDA2.NRODOCUMENTO)) > 4 AND NVL(DDA2.ACEITO,'N') = 'N' 
OR (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND DDA2.NRODOCUMENTO LIKE ('%'||F.NROTITULO||'%') AND ((F.VLRORIGINAL - (FC.VLRDESCCONTRATO + F.VLRPAGO)) = (DDA2.VALORDOCUMENTO - (DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO)))AND (LENGTH(DDA2.NRODOCUMENTO)) > 4 AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR DDA2.DTAVENCIMENTO = F.DTAVENCIMENTO AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%')AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA)))  AND NVL(DDA2.ACEITO,'N') = 'N' 
OR DDA2.DTAVENCIMENTO = F.DTAPROGRAMADA AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%')AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO,'N') = 'N' 
OR GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND DDA2.NRODOCUMENTO LIKE ('%'||F.NROTITULO||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND ((F.VLRORIGINAL - (FC.VLRDESCCONTRATO + F.VLRPAGO)) = (DDA2.VALORDOCUMENTO - (DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO)))   AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR GE.NOMERAZAO LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND ((F.VLRORIGINAL - (FC.VLRDESCCONTRATO + F.VLRPAGO)) = (DDA2.VALORDOCUMENTO - (DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO))) AND NVL(DDA2.ACEITO,'N') = 'N' AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA)))AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND (F.VLRORIGINAL) = (DDA2.VALORDOCUMENTO) AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10) AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND NVL(DDA2.ACEITO,'N') = 'N' 
OR (F.VLRORIGINAL) = (DDA2.VALORDOCUMENTO) AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10) AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO,'N') = 'N' 
OR ((F.VLRORIGINAL - (FC.VLRDESCCONTRATO + F.VLRPAGO)) = (DDA2.VALORDOCUMENTO - (DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO))) AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND (F.VLRORIGINAL) = (DDA2.VALORDOCUMENTO) AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10) AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND NVL(DDA2.ACEITO,'N') = 'N' 
OR GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND (F.DTAVENCIMENTO - DDA2.DTAVENCIMENTO) IN (1,2) AND NVL(DDA2.ACEITO,'N') = 'N' 
OR DDA2.DTAVENCIMENTO = F.DTAVENCIMENTO AND GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO, 'N') = 'N' AND REPLACE(DDA2.NRODOCUMENTO,'.','') LIKE ('%'||F.NRODOCUMENTO||'%') AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)',1,2)||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO, 'N') = 'N' AND (DDA2.VALORDOCUMENTO - DDA2.VALORDESCONTO1) = (F.VLRORIGINAL - FC.VLRDESCCONTRATO) AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND F.DTAVENCIMENTO = DDA2.DTAVENCIMENTO AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND ((F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)) - (DDA2.VALORDOCUMENTO - NVL((DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO),0))) 
IN (0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.010,-0.01,-0.02,-0.03,-0.04,-0.05,-0.06,-0.07,-0.08,-0.09,-0.010)AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10) AND NVL(DDA2.ACEITO,'N') = 'N' 
OR GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)')||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND ((F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)) - (DDA2.VALORDOCUMENTO - NVL((DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO),0))) 
IN (0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.010,-0.01,-0.02,-0.03,-0.04,-0.05,-0.06,-0.07,-0.08,-0.09,-0.010) AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 7) AND NVL(DDA2.ACEITO,'N') = 'N' 
OR DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND ((F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)) - (DDA2.VALORDOCUMENTO - NVL((DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO),0))) 
IN (0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.010,-0.01,-0.02,-0.03,-0.04,-0.05,-0.06,-0.07,-0.08,-0.09,-0.010) AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 7) AND NVL(DDA2.ACEITO,'N') = 'N' 
OR GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)',1,2)||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO, 'N') = 'N' AND DDA2.VALORDOCUMENTO = F.VLRORIGINAL AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10) AND NVL(DDA2.ACEITO,'N') = 'N' AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10)
OR DDA2.NRODOCUMENTO LIKE ('%'||F.NRODOCUMENTO||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 10) AND NVL(DDA2.ACEITO,'N') = 'N' AND  (DDA2.VALORDOCUMENTO - NVL((DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO),0)) < ((F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)) *2) AND (LENGTH(F.NRODOCUMENTO)) >= 4 
OR GE.NOMERAZAO LIKE ('%'||REGEXP_SUBSTR(DDA2.DESCFORNECEDOR, '(\S*)(\s)',1,2)||'%') AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND ((F.VLRORIGINAL - NVL((FC.VLRDESCCONTRATO + F.VLRPAGO),0)) - (DDA2.VALORDOCUMENTO - NVL((DDA2.VALORDESCONTO1 + DDA2.VALORABATIMENTO),0))) 
IN (0,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.010,-0.01,-0.02,-0.03,-0.04,-0.05,-0.06,-0.07,-0.08,-0.09,-0.010) AND DDA2.DTAVENCIMENTO = F.DTAVENCIMENTO AND NVL(DDA2.ACEITO,'N') = 'N' 
OR REPLACE(GE.NOMERAZAO, '.',' ') LIKE ('%'||DDA2.DESCFORNECEDOR||'%') AND F.VLRORIGINAL = DDA2.VALORDOCUMENTO AND DDA2.DTAVENCIMENTO BETWEEN (F.DTAVENCIMENTO - 7) AND (F.DTAVENCIMENTO + 7) AND (LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0)) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT  A.MATRIZ FROM  GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT A.NROEMPRESA FROM GE_EMPRESA A WHERE  A.NROEMPRESA IN(GM.NROEMPRESA))) AND NVL(DDA2.ACEITO,'N') = 'N'
OR
(SELECT SUM(F2.VLRORIGINAL) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.OBRIGDIREITO = 'O'
AND F2.ABERTOQUITADO    = 'A' 
AND F2.SITUACAO != 'S'  
AND NVL(F2.SUSPLIB,'L') = 'L'
AND F2.SEQTITULO NOT IN (     
SELECT  SEQTITULO  
FROM  FI_AUTPAGTO 
WHERE   FI_AUTPAGTO.SEQTITULO = F2.SEQTITULO)
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
AND FF3.CODBARRA IS NULL
HAVING COUNT (NRODOCUMENTO) > 1) 
= 
(DDA2.VALORDOCUMENTO - DDA2.VALORDESCONTO1 - DDA2.VALORABATIMENTO)
AND DDA2.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(DDA2.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
OR
(SELECT SUM(NVL(F2.VLRNOMINAL,0)) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.OBRIGDIREITO = 'O'
AND F2.ABERTOQUITADO    = 'A' 
AND F2.SITUACAO!= 'S'  
AND NVL(F2.SUSPLIB,'L') = 'L'
AND FF3.CODBARRA IS NULL
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1)= 
(DDA2.VALORDOCUMENTO - DDA2.VALORDESCONTO1 - DDA2.VALORABATIMENTO)
AND DDA2.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(DDA2.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
OR 
(SELECT SUM(NVL(F2.VLRORIGINAL,0)) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.ABERTOQUITADO = 'A' 
AND F2.SITUACAO != 'S'  
AND NVL(F2.SUSPLIB,'L') = 'L'
AND FF3.CODBARRA IS NULL
AND F2.OBRIGDIREITO = 'O'
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) =
((DDA2.VALORDOCUMENTO -0.01) - DDA2.VALORDESCONTO1 - DDA2.VALORABATIMENTO)
AND DDA2.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(DDA2.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
OR 
(SELECT SUM(NVL(F2.VLRORIGINAL,0)) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.ABERTOQUITADO    = 'A' 
AND F2.SITUACAO != 'S'
AND NVL(F2.SUSPLIB,'L') = 'L'
AND FF3.CODBARRA IS NULL
AND F2.OBRIGDIREITO = 'O'
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) =
((DDA2.VALORDOCUMENTO +0.01) - DDA2.VALORDESCONTO1 - DDA2.VALORABATIMENTO)
AND DDA2.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(DDA2.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
OR 
(SELECT SUM(NVL(F2.VLRORIGINAL,0)) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.ABERTOQUITADO    = 'A'
AND F2.SITUACAO != 'S'
AND NVL(F2.SUSPLIB,'L') = 'L'
AND FF3.CODBARRA IS NULL
AND F2.OBRIGDIREITO = 'O'
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) =
((DDA2.VALORDOCUMENTO +0.02) - DDA2.VALORDESCONTO1 - DDA2.VALORABATIMENTO)
AND DDA2.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(DDA2.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))
OR 
(SELECT SUM(NVL(F2.VLRORIGINAL,0)) - (SUM(NVL(FF3.VLRDESCCONTRATO,0)) + SUM(NVL(F2.VLRPAGO,0)))
AS VLRSOMADO
FROM FI_TITULO F2 INNER JOIN FI_COMPLTITULO FF3 ON F2.SEQTITULO = FF3.SEQTITULO
WHERE F2.SEQPESSOA = F.SEQPESSOA
AND F2.NROEMPRESA IN(GM.NROEMPRESA)
AND F2.ABERTOQUITADO = 'A'
AND F2.SITUACAO != 'S'
AND NVL(F2.SUSPLIB,'L') = 'L'
AND FF3.CODBARRA IS NULL
AND F2.OBRIGDIREITO = 'O'
AND F2.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
HAVING COUNT (NRODOCUMENTO) > 1) =
((DDA2.VALORDOCUMENTO -0.02) - DDA2.VALORDESCONTO1 - DDA2.VALORABATIMENTO)
AND DDA2.DTAVENCIMENTO BETWEEN (:DT1 - 10) AND (:DT2 + 10)
AND NVL(DDA2.ACEITO,'N') = 'N'
AND LPAD(DDA2.NROCNPJCPFSACADO,12,0)||LPAD(DDA2.DIGCNPJCPFSACADO,2,0) IN (SELECT LPAD(GEE.NROCGC,12,0)||LPAD(GEE.DIGCGC,2,0) 
FROM GE_EMPRESA GEE WHERE GEE.NROEMPRESA IN (SELECT A.MATRIZ FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA) UNION SELECT  A.NROEMPRESA FROM GE_EMPRESA A WHERE A.NROEMPRESA IN(GM.NROEMPRESA)))

WHERE F.OBRIGDIREITO = 'O'
AND F.ABERTOQUITADO = 'A'
AND FI.TIPOESPECIE = 'T'
AND F.SITUACAO != 'S'
AND NVL(F.SUSPLIB,'L') = 'L'
AND FC.CODBARRA IS NULL 
AND F.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
AND F.SEQPESSOA = :NR1
AND NVL(DDA2.ACEITO,'N') = 'N'

) X, GE_EMPRESA GE

WHERE GE.NROEMPRESA = X.EMP

ORDER BY 1,5,6) XX

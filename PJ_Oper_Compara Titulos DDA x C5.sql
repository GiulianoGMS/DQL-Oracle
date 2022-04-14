ALTER SESSION SET current_schema = CONSINCO;

SELECT * FROM (

SELECT D.DESCFORNECEDOR FORNECEDOR,
       LPAD(D.NROCNPJCPF,12,0)||LPAD(D.DIGCNPJCPF,2,0) CNPJ_DDA,
       CASE WHEN LPAD(D.NROCNPJCPF,12,0) = (SELECT MAX(LPAD(D.NROCGCCPF,12,0)) FROM CONSINCO.GE_PESSOA D 
            WHERE D.NROCGCCPF = D.NROCNPJCPF AND D.STATUS = 'A' ) THEN 'S' ELSE 'N' END CNPJ_CAD,
       (SELECT GE.FANTASIA FROM CONSINCO.GE_EMPRESA GE 
            WHERE LPAD(GE.NROCGC,12,0)||LPAD(GE.DIGCGC,2,0) = LPAD(D.NROCNPJCPFSACADO,12,0)||LPAD(D.DIGCNPJCPFSACADO,2,0)) EMPRESA,
       D.NRODOCUMENTO, 
       CASE -- WHEN TO_CHAR(D.NRODOCUMENTO)   != TO_CHAR(FI.NRODOCUMENTO||'-'||FI.SERIETITULO)       THEN 'Nro Documento Divergente'         
             --WHEN TO_CHAR(D.DTAEMISSAO,   'DD/MM/YYYY') != TO_CHAR(FI.DTAEMISSAO,   'DD/MM/YYYY')  THEN 'Data Emissão Divergente' 
        WHEN TO_CHAR(D.DTAVENCIMENTO,'DD/MM/YYYY') != TO_CHAR(FI.DTAVENCIMENTO,'DD/MM/YYYY')     
           THEN 'Data Vencimento : Sistema: '||TO_CHAR(FI.DTAVENCIMENTO,'DD/MM/YYYY') ||' DDA: '||TO_CHAR(D.DTAVENCIMENTO,'DD/MM/YYYY')
        WHEN D.VALORDOCUMENTO != FI.VLRORIGINAL                                                   
           THEN 'Valor Total : Sistema: '||TO_CHAR(FI.VLRORIGINAL,           'FM999G999G999D90', 'nls_numeric_characters='',.''')||
                                 ' DDA: '||TO_CHAR(D.VALORDOCUMENTO,         'FM999G999G999D90', 'nls_numeric_characters='',.''')||
        CASE WHEN D.VALORDESCONTO1 + D.VALORDESCONTO2 + D.VLRABATIMENTO != FC.VLRDESCCONTRATO  
           THEN '  |  Descontos : Sistema: '||FC.VLRDESCCONTRATO||' DDA: '||D.VALORDESCONTO1 ELSE NULL END
        WHEN D.VALORDESCONTO1 + D.VALORDESCONTO2 + D.VLRABATIMENTO != FC.VLRDESCCONTRATO                                           
           THEN 'Descontos : Sistema: '||TO_CHAR(FC.VLRDESCCONTRATO,         'FM999G999G999D90', 'nls_numeric_characters='',.''')|
                                      |' DDA: '||TO_CHAR(D.VALORDESCONTO1,   'FM999G999G999D90', 'nls_numeric_characters='',.''')
       ELSE 'OUTROS' END Motivo_Inconsistencia,
         
       D.DTAEMISSAO, D.DTAVENCIMENTO, D.VALORDOCUMENTO, D.VALORDESCONTO1 DESCONTO1,
       D.DTADESCONTO1 DATADESCONTO1,
       D.VALORDESCONTO2 DESCONTO2,
       TO_CHAR(D.DTADESCONTO2, 'DD/MM/YYYY') DATADESCONTO2,
       D.VLRABATIMENTO VALORABATIMENTO,
       D.CODBARRAS CODIGODEBARRA
       
FROM CONSINCO.FI_DDAARQUIVO DDA
                                      INNER JOIN FI_DDAARQTITULO         D ON (DDA.SEQIMPORTACAO = D.SEQIMPORTACAO)                           
                                      INNER JOIN CONSINCO.GE_BANCO       B ON (DDA.NROBANCO = B.NROBANCO)
                                      INNER JOIN CONSINCO.FI_CTACORRENTE C ON (DDA.SEQCTACORRENTE = C.SEQCTACORRENTE)
                                      LEFT  JOIN CONSINCO.FI_TITULO     FI ON (LPAD(D.NRODOCUMENTO,20,0) = LPAD(FI.NRODOCUMENTO,20,0))
                                      LEFT  JOIN FI_COMPLTITULO         FC ON (FI.SEQTITULO = FC.SEQTITULO) 
                                      LEFT  JOIN GE_PESSOA             GE1 ON (LPAD(NROCGCCPF,12,0)||LPAD(DIGCGCCPF,2,0) =
                                                                               LPAD(D.NROCNPJCPF,12,0)||LPAD(D.DIGCNPJCPF,2,0))                          
WHERE 1=1
     AND NVL(D.ACEITO,'N') = 'N'
     --AND FI.ABERTOQUITADO != 'Q'
     AND STATUS = 'A'
     AND FI.SEQPESSOA = GE1.SEQPESSOA
     AND D.DTAVENCIMENTO BETWEEN DATE '2022-05-01' AND DATE '2022-05-10'
     AND  (SELECT GE.NROEMPRESA FROM CONSINCO.GE_EMPRESA GE WHERE LPAD(GE.NROCGC,12,0)||LPAD(GE.DIGCGC,2,0) = 
          LPAD(D.NROCNPJCPFSACADO,12,0)||LPAD(D.DIGCNPJCPFSACADO,2,0)) IN (50)
     AND FI.NROEMPRESA IN (50)
     AND LPAD(D.NRODOCUMENTO, 20,0) IN ( -- TITULOS DENTRO DA APLICACAO - LANÇADOS C5
     
     SELECT DISTINCT LPAD(FI_TITULO.NROTITULO,20,0)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
     FROM FI_TITULO, FI_ESPECIE, GE_PESSOA, FI_COMPLTITULO, GE_EMPRESA  
 
WHERE FI_TITULO.SEQPESSOA = GE_PESSOA.SEQPESSOA 
  AND     FI_TITULO.NROEMPRESA = GE_EMPRESA.NROEMPRESA 
  AND     FI_TITULO.CODESPECIE = FI_ESPECIE.CODESPECIE 
  AND     FI_TITULO.NROEMPRESAMAE = FI_ESPECIE.NROEMPRESAMAE 
  AND     FI_TITULO.SEQTITULO = FI_COMPLTITULO.SEQTITULO 
  AND     FI_TITULO.OBRIGDIREITO = 'O' 
  AND     FI_TITULO.ABERTOQUITADO = 'A' 
  AND     GE_EMPRESA.STATUS = 'A' 
  AND     FI_ESPECIE.TIPOESPECIE = 'T' 
  AND     FI_TITULO.SITUACAO != 'S'  
  AND NVL(FI_TITULO.SUSPLIB,'L') = 'L'  AND FI_COMPLTITULO.CODBARRA IS NULL  --AND FI_TITULO.NROTITULO = 1731075                            
  AND FI_TITULO.DTAVENCIMENTO BETWEEN DATE '2022-05-01' AND DATE '2022-05-10'      AND FI_TITULO.NROEMPRESA IN (50)  
 /* AND FI_TITULO.CODESPECIE IN ('13SAL',  'ADIEMP', 'ADIPPG', 'ADIPRP', 'ADISAL', 'AGUA',   'ALPGCX', 'ALUGPG', 'ANTREC', 
   'ATIPCO', 'ATIVO',  'ATIVOC', 'ATVEFU', 'BEFUNC', 'BONIAC', 'BONIDV', 'CHQPG',  'COFINS', 'CONTDV', 'COSIND', 'COSNCX',
   'CSSLL',  'DEPJUD', 'DESP',   'DEVCOM', 'DEVPAG', 'DEVPCO', 'DUPCIM', 'DUPP',   'DUPPCX', 'DUPPIM', 'DUPPPD', 'DUPVIM', 'DVCPCO', 
   'DVESEC', 'DVIFOO', 'DVRBEC', 'DVVOEC', 'EMPAG',  'EMPAIM', 'ENCSOC', 'ENERGI', 'ESDUPR', 'FATICD', 'FATNAG', 'FERIAS', 'FGTS',
   'FGTSQT', 'FINAIM', 'FINANC', 'FRETE',  'GNRE',   'ICMS',   'IMPOPP', 'IMPOST', 'INSS',   'INSSNF', 'INTANG', 'IOFRET', 'IPI', 'IR', 
   'IRRFFP', 'IRRFNF', 'ISSQN',  'ISSQNP', 'ISSST',  'LEASIM', 'LEASIN', 'LEIROU', 'MKFUNC', 'MKPREM', 'ORDSAL', 'PAGEST', 'PCCNF', 
   'PENSAO', 'PGETRH', 'PIS',    'PIXREC', 'PROCIM', 'PROCIV', 'PROTIM', 'PROTRA', 'PROTRG', 'PRTPAG', 'QTPRP',  'RECARG', 'REEMB', 
   'REMBCT', 'REMBEC', 'RESCIS', 'RESODH', 'RETSOC', 'SEST',   'TEL',    'VLDESC' ))
 */

--ORDER BY  D.DTAVENCIMENTO, (SELECT GE.FANTASIA FROM CONSINCO.GE_EMPRESA GE WHERE LPAD(GE.NROCGC,12,0)||LPAD(GE.DIGCGC,2,0) = LPAD(D.NROCNPJCPFSACADO,12,0)||LPAD(D.DIGCNPJCPFSACADO,2,0)),
--          D.DESCFORNECEDOR, MOTIVO_INCONSISTENCIA
)

UNION ALL

------------------------- UNIR SEM CNPJ CADASTRADO

SELECT D.DESCFORNECEDOR FORNECEDOR,
       LPAD(D.NROCNPJCPF,12,0)||LPAD(D.DIGCNPJCPF,2,0) CNPJ,
       CASE WHEN LPAD(D.NROCNPJCPF,12,0) = (SELECT MAX(LPAD(D.NROCGCCPF,12,0)) FROM CONSINCO.GE_PESSOA D 
            WHERE D.NROCGCCPF = D.NROCNPJCPF AND D.STATUS = 'A' ) THEN 'S' ELSE 'N' END CNPJ_CADASTRADO,
       (SELECT GE.FANTASIA FROM CONSINCO.GE_EMPRESA GE 
            WHERE LPAD(GE.NROCGC,12,0)||LPAD(GE.DIGCGC,2,0) = LPAD(D.NROCNPJCPFSACADO,12,0)||LPAD(D.DIGCNPJCPFSACADO,2,0)) EMPRESA,
       D.NRODOCUMENTO, 
       'CNPJ incorreto ou não cadastrado - CNPJ Docto sistema: '||(SELECT LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) CNPJ 
       FROM GE_PESSOA D INNER JOIN MLF_NOTAFISCAL A ON D.SEQPESSOA = A.SEQPESSOA
       WHERE A.NUMERONF = FI.NRODOCUMENTO
       AND NROEMPRESA = 50),
         
       D.DTAEMISSAO, D.DTAVENCIMENTO, D.VALORDOCUMENTO, D.VALORDESCONTO1 DESC_CONTRATO,
       D.DTADESCONTO1 DATADESCONTO1,
       D.VALORDESCONTO2 DESCONTO2,
       TO_CHAR(D.DTADESCONTO2, 'DD/MM/YYYY') DATADESCONTO2,
       D.VLRABATIMENTO VALORABATIMENTO,
       D.CODBARRAS CODIGODEBARRA
       
FROM CONSINCO.FI_DDAARQUIVO DDA    
                                      INNER JOIN FI_DDAARQTITULO         D ON (DDA.SEQIMPORTACAO = D.SEQIMPORTACAO)                           
                                      INNER JOIN CONSINCO.GE_BANCO       B ON (DDA.NROBANCO = B.NROBANCO)
                                      INNER JOIN CONSINCO.FI_CTACORRENTE C ON (DDA.SEQCTACORRENTE = C.SEQCTACORRENTE)
                                      LEFT  JOIN CONSINCO.FI_TITULO     FI ON (LPAD(D.NRODOCUMENTO,20,0) = LPAD(FI.NRODOCUMENTO,20,0))
                                      LEFT  JOIN FI_COMPLTITULO         FC ON (FI.SEQTITULO = FC.SEQTITULO) 
                                      LEFT  JOIN GE_PESSOA             GE1 ON (LPAD(NROCGCCPF,12,0)||LPAD(DIGCGCCPF,2,0) =
                                                                               LPAD(D.NROCNPJCPF,12,0)||LPAD(D.DIGCNPJCPF,2,0))                          
WHERE 1=1
     AND NVL(D.ACEITO,'N') = 'N'
     --AND FI.ABERTOQUITADO != 'Q'
     AND (CASE WHEN LPAD(D.NROCNPJCPF,12,0) = (SELECT MAX(LPAD(D.NROCGCCPF,12,0)) FROM CONSINCO.GE_PESSOA D 
            WHERE D.NROCGCCPF = D.NROCNPJCPF AND D.STATUS = 'A' ) THEN 'S' ELSE 'N' END) = 'N'
     AND D.DTAVENCIMENTO BETWEEN DATE '2022-05-01' AND DATE '2022-05-10'
     AND  (SELECT GE.NROEMPRESA FROM CONSINCO.GE_EMPRESA GE WHERE LPAD(GE.NROCGC,12,0)||LPAD(GE.DIGCGC,2,0) = 
          LPAD(D.NROCNPJCPFSACADO,12,0)||LPAD(D.DIGCNPJCPFSACADO,2,0)) IN (50)
     AND FI.NROEMPRESA IN (50)
     AND LPAD(D.NRODOCUMENTO, 20,0) IN ( -- TITULOS DENTRO DA APLICACAO - LANÇADOS C5
     
     SELECT DISTINCT LPAD(FI_TITULO.NROTITULO,20,0)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
     FROM FI_TITULO, FI_ESPECIE, GE_PESSOA, FI_COMPLTITULO, GE_EMPRESA  
 
WHERE FI_TITULO.SEQPESSOA = GE_PESSOA.SEQPESSOA 
  AND     FI_TITULO.NROEMPRESA = GE_EMPRESA.NROEMPRESA 
  AND     FI_TITULO.CODESPECIE = FI_ESPECIE.CODESPECIE 
  AND     FI_TITULO.NROEMPRESAMAE = FI_ESPECIE.NROEMPRESAMAE 
  AND     FI_TITULO.SEQTITULO = FI_COMPLTITULO.SEQTITULO 
  AND     FI_TITULO.OBRIGDIREITO = 'O' 
  AND     FI_TITULO.ABERTOQUITADO = 'A' 
  AND     GE_EMPRESA.STATUS = 'A' 
  AND     FI_ESPECIE.TIPOESPECIE = 'T' 
  AND     FI_TITULO.SITUACAO != 'S'  
  AND NVL(FI_TITULO.SUSPLIB,'L') = 'L'  AND FI_COMPLTITULO.CODBARRA IS NULL  --AND FI_TITULO.NROTITULO = 1731075                            
  AND FI_TITULO.DTAVENCIMENTO BETWEEN DATE '2022-05-01' AND DATE '2022-05-10'      AND FI_TITULO.NROEMPRESA IN (50)  
 /* AND FI_TITULO.CODESPECIE IN ('13SAL',  'ADIEMP', 'ADIPPG', 'ADIPRP', 'ADISAL', 'AGUA', 'ALPGCX', 'ALUGPG', 'ANTREC', 
   'ATIPCO', 'ATIVO',  'ATIVOC', 'ATVEFU', 'BEFUNC', 'BONIAC', 'BONIDV', 'CHQPG', 'COFINS', 'CONTDV', 'COSIND', 'COSNCX',
   'CSSLL',  'DEPJUD', 'DESP',   'DEVCOM', 'DEVPAG', 'DEVPCO', 'DUPCIM', 'DUPP', 'DUPPCX', 'DUPPIM', 'DUPPPD', 'DUPVIM', 'DVCPCO', 
   'DVESEC', 'DVIFOO', 'DVRBEC', 'DVVOEC', 'EMPAG', 'EMPAIM', 'ENCSOC', 'ENERGI', 'ESDUPR', 'FATICD', 'FATNAG', 'FERIAS', 'FGTS',
   'FGTSQT', 'FINAIM', 'FINANC', 'FRETE',  'GNRE', 'ICMS', 'IMPOPP', 'IMPOST', 'INSS', 'INSSNF', 'INTANG', 'IOFRET', 'IPI', 'IR', 
   'IRRFFP', 'IRRFNF', 'ISSQN',  'ISSQNP', 'ISSST', 'LEASIM', 'LEASIN', 'LEIROU', 'MKFUNC', 'MKPREM', 'ORDSAL', 'PAGEST', 'PCCNF', 
   'PENSAO', 'PGETRH', 'PIS',    'PIXREC', 'PROCIM', 'PROCIV', 'PROTIM', 'PROTRA', 'PROTRG', 'PRTPAG', 'QTPRP', 'RECARG', 'REEMB', 
   'REMBCT', 'REMBEC', 'RESCIS', 'RESODH', 'RETSOC', 'SEST', 'TEL', 'VLDESC' ))
 */
) ) X

GROUP BY X.NRODOCUMENTO, X.MOTIVO_INCONSISTENCIA, X.FORNECEDOR, X.CNPJ_DDA, X.CNPJ_CAD, X.EMPRESA,
         X.DTAEMISSAO, X.DTAVENCIMENTO, X.VALORDOCUMENTO, X.DESCONTO1, X.DATADESCONTO1,
         X.DESCONTO2, X.DATADESCONTO2, X.VALORABATIMENTO, X.CODIGODEBARRA
       
ORDER BY  8,4,1

SELECT F.NROEMPRESA, F.NROTITULO, F.CODESPECIE ESPECIE, F.SEQPESSOA||' - '||G.NOMERAZAO FORNEC,
       TO_CHAR(F.DTAVENCIMENTO, 'DD/MM/YYYY') DTA_VENCIMENTO, 
       TO_CHAR(F.VLRORIGINAL, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VLR_ORIGINAL,
       TO_CHAR(NVL(C.VLRDESCCONTRATO,0), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VLR_DESC,
       TO_CHAR(F.VLRORIGINAL - VLRPAGO - NVL(C.VLRDESCCONTRATO,0)) VLR_LIQUIDO, F.OBSERVACAO
       

  FROM FI_TITULO F LEFT JOIN FI_COMPLTITULO C ON F.SEQTITULO = C.SEQTITULO
                   INNER JOIN GE_PESSOA G      ON G.SEQPESSOA = F.SEQPESSOA
                   INNER JOIN FI_FORNECEDOR  O ON O.SEQPESSOA = G.SEQPESSOA
                   
 WHERE F.ABERTOQUITADO = 'A'
   AND F.OBRIGDIREITO = 'O'
   AND F.SITUACAO != 'C'
   AND NOT EXISTS (SELECT 1 FROM FI_COMPLTITULO X WHERE X.SEQTITULO = F.SEQTITULO AND X.CODBARRA IS NOT NULL)
   AND F.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
   AND NOT EXISTS (SELECT 1 FROM FI_AUTPAGTO XX WHERE XX.SEQTITULO = F.SEQTITULO AND XX.DTAAUTORIZOU IS NOT NULL)
   AND F.CODESPECIE IN ('AGUA',
                        'ALUGPG',
                        'IPVAMU',
                        'ANTREC',
                        'ATIVO',
                        'ATIVOC',
                        'ATVEFU',
                        'BEFUNC',
                        'COFINS',
                        'COSIND',
                        'CSSLL',
                        'DESP',
                        'DIVSOC',
                        'DUPP',
                        'DVRBEC',
                        'ENERGI',
                        'ESPORT',
                        'FATDMC',
                        'FATCID',
                        'FGTS',
                        'FGTSQT',
                        'FRETE',
                        'GNRE',
                        'ICMS',
                        'IMPOST',
                        'INSS',
                        'INSSNF',
                        'IPI',
                        'IPTU',
                        'IR',
                        'IRRFFP',
                        'IRRNF',
                        'ISSQN',
                        'ISSQNP',
                        'ISST',
                        'LEBEMC',
                        'LEASIM',
                        'LEASIN',
                        'LEIROU',
                        'MKFUNC',
                        'MKPREM',
                        'PAGEST',
                        'PCCNF',
                        'PIS',
                        'PROCIM',
                        'PROCIV',
                        'PROTRG',
                        'RECARG',
                        'REEMB',
                        'RETSOC',
                        'SEGURO',
                        'SERVPJ',
                        'SEST',
                        'SUPERT',
                        'TEL',
                        'VLDESC')
                                    
  ORDER BY 3,1

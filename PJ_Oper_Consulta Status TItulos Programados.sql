ALTER SESSION SET current_schema = CONSINCO;

SELECT  A.SEQTITULO,A.NROEMPRESA EMPRESA, A.NROTITULO, A.SERIETITULO SERIE, A.NOMERAZAO,  A.NROBANCO||' - '|| A.NOMEAGENCIA BCOAGENCIA, A.CODESPECIE, 
        A.NROPARCELA, A.DTAEMISSAO, A.DTAPROGRAMADA, A.PRAZOEFETIVO, 
        --CASE WHEN B.SITUACAO = 'C' THEN 'Cancelado - Usuário: '||B.USUCANCELAMENTO ELSE DECODE(B.SITUACAO, 'C','Cancelado','N','Programada - Normal','P','Protestado', NULL, '??') END Situacao_TIT, 
        DECODE(A.SITJURIDICA, 'C','Cartório','N','Normal','P','Protestado') SITUACAO_JURI,
        DECODE(A.SITUACAO, 'H','Cheque Devolvido','B','Cobrança','J','Cobrança Jurídica','N','Não Programada','S','Suspenso')||CASE WHEN B.SITUACAO = 'C' THEN ' - Programação Cancelada - Usuário: '||B.USUCANCELAMENTO ELSE NULL END SITUACAO_TIT,
        DECODE(B.DOCTOEMITIDO, 'S','Sim','N','Não') DOCTOEMITIDO,
        A.SITCREDITO, A.SITJURIDICA, A.DIASATRASO, A.VLRMULTA, A.VLRJUROS, A.VLRORIGINAL, A.VLREMABERTO, 
        A.VLRDESCFIN, A.VLRDESCFINDISP, A.DTAVIAGEM, A.NROCARGA, A.CODBARRA, A.DTAMOVIMENTO, A.IMPLETRAA, A.IMPLETRAP, A.VLRTAXAS
  
FROM  CONSINCO.FIV_TITULOS_EM_ABERTO A LEFT JOIN CONSINCO.FI_PROGPAGAMENTO B ON A.SEQTITULO = B.SEQTITULO 

WHERE A.OBRIGDIREITO = 'O'                      
  AND A.DTAPROGRAMADA BETWEEN DATE '2022-06-06' AND DATE '2022-06-08'                         
  AND A.CODIGOFATOR IS NULL
  AND A.CODESPECIE IN ( '13SAL', 'ADIEMP', 'ADIPPG', 'ADIPRP', 'ADISAL', 'AGUA', 'ALPGCX', 'ALUGPG', 'ANTREC', 'ATIPCO', 'ATIVO', 'ATIVOC', 'ATVEFU', 'BEFUNC', 'BONIAC', 
                        'BONIDV', 'CHQPG', 'COFINS', 'CONTDV', 'COSIND', 'COSNCX', 'CSSLL', 'DEPJUD', 'DESP', 'DEVCOM', 'DEVPAG', 'DEVPCO', 'DUPCIM', 'DUPP', 'DUPPCO', 
                        'DUPPCX', 'DUPPIM', 'DUPPPD', 'DUPVIM', 'DVCPCO', 'DVESEC', 'DVIFOO', 'DVRBEC', 'DVVOEC', 'EMPAG', 'EMPAIM', 'ENCSOC', 'ENERGI', 'ESDUPR', 'FATICD', 
                        'FATNAG', 'FERIAS', 'FGTS', 'FGTSQT', 'FINAIM', 'FINANC', 'FRETE', 'GNRE', 'ICMS', 'IMPOPP', 'IMPOST', 'INSS', 'INSSNF', 'INTANG', 'IOFRET', 'IPI', 
                        'IR', 'IRRFFP', 'IRRFNF', 'ISSQN', 'ISSQNP', 'ISSST', 'LEASIM', 'LEASIN', 'LEIROU', 'MKFUNC', 'MKPREM', 'ORDSAL', 'PAGEST', 'PCCNF', 'PENSAO', 'PGETRH', 
                        'PIS', 'PIXREC', 'PROCIM', 'PROCIV', 'PROTIM', 'PROTRA', 'PROTRG', 'PRTPAG', 'QTPRP', 'RECARG', 'REEMB', 'REMBCT', 'REMBEC', 'RESCIS', 'RESODH', 'RETSOC', 
                        'SEST', 'TEL', 'VLDESC' )  
  AND A.NROEMPRESAMAE IN (  SELECT  DISTINCT A.NROEMPRESAMAE 
     FROM  FI_PARAMETRO A 
    WHERE   A.NROEMPRESA IN (1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 301, 500, 501, 502, 503, 506, 601, 603 )  )
  AND A.NROEMPRESA IN ( 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 301, 500, 501, 502, 503, 506, 601, 603 )  
  AND A.NROBANCO IN ( 237, 1, 900, 11, 341, 422, 33 )   
  AND EXISTS (    
      SELECT  1  
      FROM  FI_AUTPAGTO 
      WHERE   FI_AUTPAGTO.SEQTITULO = A.SEQTITULO)  
  AND NOT EXISTS   
      (  
      SELECT  1 
      FROM  FI_PROGPAGAMENTO 
      WHERE FI_PROGPAGAMENTO.SEQTITULO = A.SEQTITULO 
      AND NVL(FI_PROGPAGAMENTO.SITUACAO,'N') = 'N')  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  --AND NROEMPRESA = 12
  
ORDER BY A.DTAPROGRAMADA , A.SEQTITULO, A.NOMERAZAO

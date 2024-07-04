ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT NVL(A.SEQPESSOA, 0) || ' - ' || A.NOMERAZAO PESSOA,
       DESCDEPOSITARIO,
       A.NROEMPRESA EMP,
       A.NROBANCO BCO,
       A.CODESPECIE ESPECIE,
       NVL(A.NROTITULO, 0) || '-' || A.SERIETITULO || '/' || A.NROPARCELA TITULO,
       B.OBSERVACAO COMPL,
       TO_CHAR(A.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') DTAVENCIMENTO,
       TO_CHAR(A.DTAMOVIMENTO, 'DD/MM/YYYY') DTAMOVIMENTO,
       TO_CHAR(A.DTAQUITACAO, 'DD/MM/YYYY') DTAQUITACAO,
       A.SITJURIDICA SJ,
       A.DIASATRASO,
       A.DIASPRAZOPAGAMENTO DIAS_PZO_PGTO,
       A.VLRABATIMENTO,
       A.VLRCOMPENSACAO,
       A.VLRMULTA,
       A.VLRJUROS,
       A.VLRDESCFIN,
       A.VLRORIGINAL,
       A.VLRPAGO,
       A.VLRPAGO + A.VLRJUROS + A.VLRMULTA - A.VLRDESCFIN -
       A.VLRCOMPENSACAO VLRLIQUIDO

/*
       A.SEQTITULO,
       A.NROEMPRESA,
       A.NROBANCO,
       A.SEQAGENCIA,
       NVL(A.NROTITULO, 0) || '-' || A.SERIETITULO || '/' || A.NROPARCELA,
       A.SEQPESSOA,
       A.VLRORIGINAL,
       A.DIASATRASO,
       A.VLRJUROS,
       A.CODESPECIE,
       A.SITJURIDICA,
       NVL(A.SEQPESSOA, 0) || ' - ' || A.NOMERAZAO,
       A.NOMEAGENCIA,
       A.DTAPROGRAMADA,
       A.DTAEMISSAO,
       A.DTAVENCIMENTO,
       A.DTALIMDSCFINANC,
       A.VLRDSCFINANC,
       A.VLRPAGO,
       A.DTAQUITACAO,
       A.DESCDEPOSITARIO,
       A.VLRDESCFIN,
       A.VLRMULTA,
       A.NROAUTELETRONICA,
       A.DTAMOVIMENTO,
       A.OBSERVACAO,
       TRANSLATE(A.OBSERVACAO, CHR(13) || CHR(10), '  '),
       A.NROEMPRESAMAE,
       A.CODBARRA,
       A.DESCTIPODOCUMENTO,
       A.DESCTIPOPAGAMENTO,
       A.DESCFORMA,
       A.DESCTRIBUTO,
       A.DESCTIPOPAGAMENTO,
       A.DESCFORMA,
       A.BANCO,
       A.AGENCIA,
       A.DIGAGENCIA,
       A.NROCONTA,
       A.DIGCONTA,
       A.TIPOPAGAMENTO,
       A.PAGTOBOLETO,
       A.NOMEPROPTERCEIRO,
       A.SEQCONTA,
       A.TIPOTRIBUTO,
       A.VLRPAGO + A.VLRJUROS + A.VLRMULTA - A.VLRDESCFIN -
       A.VLRCOMPENSACAO,
       A.DIASPRAZOPAGAMENTO,
       CASE
         WHEN A.DIASPRAZOPAGAMENTO = 0 THEN
          1
         ELSE
          A.DIASPRAZOPAGAMENTO
       END * A.VLRPAGO,
       A.VLRABATIMENTO,
       A.VLRCOMPENSACAO,
       A.VLRTXADMINISTRATIVA,
       A.CHAVEPAGTO,
       A.FORMAPAGAMENTO,
       A.DESCCONTA
       */
  FROM FIV_TITULOS_QUITADOS A LEFT JOIN FI_TITOPERACAO B ON A.SEQTITULO = B.SEQTITULO
 WHERE A.OBRIGDIREITO = 'D'
   AND B.CODOPERACAO = 28
 
   AND A.SEQPESSOA IN (SELECT GE_REDEPESSOA.SEQPESSOA
                         FROM GE_REDEPESSOA
                        WHERE GE_REDEPESSOA.SEQREDE = (SELECT SEQREDE FROM GE_REDE WHERE DESCRICAO = :LS1)
                          AND GE_REDEPESSOA.STATUS = 'A') 
   AND A.DTAQUITACAO BETWEEN :DT1 AND :DT2
   AND A.CODIGOFATOR IS NULL
   AND A.CODESPECIE IN  ( 'ACORDO', 'ACORIM', 'ACRCOM', 'ACRCOM', 'ACRCON', 'ACRDIV', 'ACRDIV', 'ACRING', 'ACRING', 'ACRINT', 'ACRLOG', 'ACRMKT', 'ACRPRE', 'ACRTRO', 'ADIPRR', 'ADIPRR', 'ANTPAG', 'ATIRCO', 'BOLECD', 'CARDEB', 'CARTAO', 'CARTIM', 'CHEQUE', 'CHQPRE', 'COMRCP', 'CONDEQ', 'CONTCR', 'CONTDE', 'CONTEV', 'CONTNS', 'CONTRT', 'CONTRT', 'CONTVB', 'CONVEN', 'DESCAG', 'DEVDUV', 'DEVRCO', 'DEVREC', 'DEVRIM', 'DRCXIM', 'DUPCXA', 'DUPR', 'DUPRCO', 'DUPRCX', 'DUPRIM', 'DUPRPD', 'DURCIM', 'EMREC', 'JUROS', 'PRTREC', 'PRTREC', 'QPRHR', 'QTPRR', 'SACREC', 'TICKEL', 'TICKET', 'TKTCAR', 'TKTNR' )
      
   AND A.NROBANCO IN (1, 237, 11, 310, 341, 422, 33, 900)
   AND A.SEQTITULO IN (SELECT A.SEQTITULO
                         FROM FI_TITOPERACAO A, FI_OPERACAO B, FI_TITULO C
                        WHERE A.CODOPERACAO = B.CODOPERACAO
                          AND A.SEQTITULO = C.SEQTITULO
                          AND A.OPCANCELADA IS NULL
                          AND (B.COLOPERACAO1 = 'P' OR B.COLOPERACAO2 = 'P')
                             
                          AND (EXISTS (SELECT 1
                                         FROM GEX_DADOSTEMPORARIOS
                                        WHERE NUMBER1 = A.SEQCTACORRENTE
                                          AND IDENTIFUSUARIO = '9') OR
                               (A.SEQCTACORRENTE IS NULL))
                          AND A.CODOPERACAO IN (2,
                                                3,
                                                4,
                                                5,
                                                6,
                                                11,
                                                17,
                                                19,
                                                20,
                                                23,
                                                24,
                                                25,
                                                28,
                                                29,
                                                30,
                                                38,
                                                39,
                                                42,
                                                43,
                                                46,
                                                49,
                                                58,
                                                61,
                                                67,
                                                68,
                                                70,
                                                76,
                                                77,
                                                95,
                                                97,
                                                98,
                                                105,
                                                106,
                                                107,
                                                108,
                                                112,
                                                113,
                                                114,
                                                120,
                                                121,
                                                136,
                                                138,
                                                148,
                                                150,
                                                151,
                                                153,
                                                154,
                                                155,
                                                172,
                                                180,
                                                181,
                                                182,
                                                184,
                                                185,
                                                191,
                                                194,
                                                196,
                                                197,
                                                203,
                                                204,
                                                205,
                                                208,
                                                210,
                                                211,
                                                213,
                                                214,
                                                217,
                                                218,
                                                220,
                                                221,
                                                222,
                                                223,
                                                224,
                                                228,
                                                229,
                                                230,
                                                231,
                                                233,
                                                235,
                                                236,
                                                237,
                                                238,
                                                239,
                                                244,
                                                299,
                                                415,
                                                418,
                                                500,
                                                501,
                                                502,
                                                811,
                                                935))
 ORDER BY A.DTAQUITACAO, A.SEQTITULO


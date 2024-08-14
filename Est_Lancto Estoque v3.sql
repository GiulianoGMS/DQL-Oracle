SELECT TO_CHAR(A.DTAENTRADASAIDA, 'DD/MM/YYYY') DATA_LANCTO,
       A.NROEMPRESA,
       A.SEQPRODUTO PLU,
       B.DESCCOMPLETA DESCRICAO,
       (SELECT X.FANTASIA
          FROM GE_PESSOA X
         WHERE X.SEQPESSOA = (SELECT X.SEQFORNECEDOR
                                FROM MAP_FAMFORNEC X
                               WHERE X.SEQFAMILIA = B.SEQFAMILIA
                                     AND X.PRINCIPAL = 'S')) FORNEC,
       A.QTDLANCTO QTD,
       TRUNC(DECODE('S',
                    'S',
                    FMRL_CUSTOULTENTRADASP(A.SEQPRODUTO,
                                           A.NROEMPRESA,
                                           'B',
                                           NULL),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
             2) CUSTOBR_UNI,
       TRUNC(A.QTDLANCTO *
             DECODE('S',
                    'S',
                    FMRL_CUSTOULTENTRADASP(A.SEQPRODUTO,
                                           A.NROEMPRESA,
                                           'B',
                                           NULL),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
             2) CUSTOBR_TOTAL,
       F.LOCAL,
       A.CODGERALOPER CGO,
       A.HISTORICO AS JUSTIFICATIVA,
       REGEXP_SUBSTR(A.HISTORICO, '[0-9]+', 1, 1) NRO_JUSTIFICATIVA1,
       REGEXP_SUBSTR(A.HISTORICO, '[0-9]+', 1, 2) NRO_JUSTIFICATIVA2
       
  FROM MRL_LANCTOESTOQUE  A,
       MAP_PRODUTO        B,
       MAX_ATRIBUTOFIXO   C,
       MAX_CODGERALOPER   D,
       MRL_CUSTODIA       E,
       MRL_LOCAL          F,
       MRL_PRODUTOEMPRESA G
 WHERE A.SEQPRODUTO = B.SEQPRODUTO
       AND A.MOTIVOMOVTO = C.LISTA(+)
       AND D.CODGERALOPER = A.CODGERALOPER
       AND A.NROEMPRESA IN (#LS1)
       AND A.DTAENTRADASAIDA >= :DT1
       AND A.DTAENTRADASAIDA <= :DT2
       AND A.NROEMPRESA = E.NROEMPRESA
       AND A.DTAENTRADASAIDA = E.DTAENTRADASAIDA
       AND A.CODGERALOPER IN (#LS2)
       AND D.TIPUSO = 'I'
       AND D.GERALTERACAOESTQ = 'S'
       AND A.SEQPRODUTO = E.SEQPRODUTO
       AND F.NROEMPRESA = A.NROEMPRESA
       AND G.NROEMPRESA = A.NROEMPRESA
       AND G.SEQPRODUTO = B.SEQPRODUTO
       AND A.LOCAL = F.SEQLOCAL

UNION ALL

SELECT TO_CHAR(A.DTAENTRADASAIDA, 'DD/MM/YYYY') AS DTAENTSAIDA,
       A.NROEMPRESA,
       A.SEQPRODUTO,
       B.DESCCOMPLETA,
       (SELECT X.FANTASIA
          FROM GE_PESSOA X
         WHERE X.SEQPESSOA = (SELECT X.SEQFORNECEDOR
                                FROM MAP_FAMFORNEC X
                               WHERE X.SEQFAMILIA = B.SEQFAMILIA
                                     AND X.PRINCIPAL = 'S')) FORNECEDOR_PRINCIPAL,
       A.QTDLANCTO,
       TRUNC(DECODE('S',
                    'S',
                    FMRL_CUSTOULTENTRADASP(A.SEQPRODUTOBASE,
                                           A.NROEMPRESA,
                                           'B',
                                           NULL),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
             2) AS CUSTOBRT,
       TRUNC(A.QTDLANCTO *
             DECODE('S',
                    'S',
                    FMRL_CUSTOULTENTRADASP(A.SEQPRODUTOBASE,
                                           A.NROEMPRESA,
                                           'B',
                                           NULL),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
             2) AS CUSTOBRTOTAL,
       F.LOCAL,
       A.CODGERALOPER CODOPER,
       A.HISTORICO AS JUSTIFICATIVA,
       REGEXP_SUBSTR(A.HISTORICO, '[0-9]+', 1, 1) NRO_JUSTIFICATIVA,
       REGEXP_SUBSTR(A.HISTORICO, '[0-9]+', 1, 2) NRO_JUSTIFICATIVA2


  FROM MRL_LANCTOESTOQUE  A,
       MAP_PRODUTO        B,
       MAX_ATRIBUTOFIXO   C,
       MAX_CODGERALOPER   D,
       MRL_CUSTODIA       E,
       MRL_LOCAL          F,
       MRL_PRODUTOEMPRESA G
 WHERE A.SEQPRODUTO = B.SEQPRODUTO
       AND A.MOTIVOMOVTO = C.LISTA(+)
       AND D.CODGERALOPER = A.CODGERALOPER
       AND A.NROEMPRESA IN (#LS1)
       AND A.DTAENTRADASAIDA >= :DT1
       AND A.DTAENTRADASAIDA <= :DT2
       AND A.NROEMPRESA = E.NROEMPRESA
       AND A.DTAENTRADASAIDA = E.DTAENTRADASAIDA
       AND A.CODGERALOPER IN (#LS2)
       AND D.TIPUSO = 'I'
       AND D.GERALTERACAOESTQ = 'S'
       AND A.SEQPRODUTOBASE = E.SEQPRODUTO
       AND F.NROEMPRESA = A.NROEMPRESA
       AND G.NROEMPRESA = A.NROEMPRESA
       AND G.SEQPRODUTO = B.SEQPRODUTO
       AND A.LOCAL = F.SEQLOCAL

 ORDER BY 3, 2, 4

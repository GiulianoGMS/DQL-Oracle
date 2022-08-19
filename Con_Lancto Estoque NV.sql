ALTER SESSION SET current_schema = CONSINCO;

Select  to_char(A.DTAENTRADASAIDA, 'DD/MM/YYYY') as DTAENTSAIDA,
        A.NROEMPRESA,
       A.SEQPRODUTO,
       B.DESCCOMPLETA,
       (select x.fantasia from ge_pessoa x where x.seqpessoa = (select x.seqfornecedor from map_famfornec x where x.seqfamilia = b.seqfamilia and x.principal = 'S')) Fornecedor_Principal,
       A.QTDLANCTO,
       trunc(decode('S',
                    'S',
                    fmrl_custoultentradasp(a.seqprodutoBASE,
                                           a.nroempresa,
                                           'B',
                                           null),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
             2) AS CUSTOBRT,
       trunc(A.QTDLANCTO *
             decode('S',
                    'S',
                    fmrl_custoultentradasp(a.seqprodutobase,
                                           a.nroempresa,
                                           'B',
                                           null),
                    (E.CMDIAVLRNF + E.CMDIAIPI + E.CMDIAICMSST +
                    E.CMDIADESPNF + E.CMDIADESPFORANF - E.CMDIADCTOFORANF)),
             2) AS CUSTOBRTotal,
       F.LOCAL,
       DECODE(A.TIPLANCTO, 'S', 'SAIDA', 'ENTRADA') as LANCTO,
       DECODE(D.TIPUSO,
              'I',
              DECODE(NVL(D.TIPCLASSINTERNO, 'N'),
                     'C',
                     'CONSUMO PRÓPRIO',
                     'P',
                     'PERDA OU QUEBRA',
                     'R',
                     'FURTO OU ROUBO',
                     'A',
                     'AVARIA',
                     'NORMAL'),
              NULL) as Tipolanct, a.codgeraloper ||'-'|| d.descricao as CODOPER, a.historico as Justificativa,
       A.USULANCTO
  From MRL_LANCTOESTOQUE  A, 
       MAP_PRODUTO        B,
       MAX_ATRIBUTOFIXO   C,
       MAX_CODGERALOPER   D,
       MRL_CUSTODIA       E,
       MRL_LOCAL          F,
       MRL_PRODUTOEMPRESA G
 Where A.SEQPRODUTO = B.SEQPRODUTO
   AND A.MOTIVOMOVTO = C.LISTA(+)
   AND D.CODGERALOPER = A.CODGERALOPER
   AND A.NROEMPRESA in (31) 
   AND A.DTAENTRADASAIDA = DATE '2022-07-02'
   AND A.NROEMPRESA = E.NROEMPRESA
   AND A.DTAENTRADASAIDA = E.DTAENTRADASAIDA
   AND A.CODGERALOPER in (450)
   AND D.TIPUSO = 'I'
   AND D.GERALTERACAOESTQ = 'S'
   AND A.SEQPRODUTOBASE = E.SEQPRODUTO
   AND F.NROEMPRESA = A.NROEMPRESA
   AND G.NROEMPRESA = A.NROEMPRESA
   AND G.SEQPRODUTO = B.SEQPRODUTO
   AND A.LOCAL = F.SEQLOCAL
 ORDER BY A.DTAENTRADASAIDA, A.NROEMPRESA, B.DESCCOMPLETA;

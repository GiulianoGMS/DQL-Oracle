SELECT X.NROEMPRESA LOJA, X.NUMERONF, XI.SEQPRODUTO PLU, DESCCOMPLETA, SUM(XI.QUANTIDADE) QUANTIDADE, L.LOCAL , G.SEQPESSOA||' - '||NOMERAZAO FORNEC_DESTINO, X.CODGERALOPER CGO, TO_CHAR(DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO
  FROM MLF_NOTAFISCAL X INNER JOIN MLF_NFITEM XI ON XI.SEQNF = X.SEQNF
                        INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = XI.SEQPRODUTO
                        INNER JOIN MRL_LOCAL   L ON L.NROEMPRESA = X.NROEMPRESA
                                                AND L.SEQLOCAL = XI.LOCATUESTQ
                        INNER JOIN GE_PESSOA   G ON G.SEQPESSOA = X.SEQPESSOA
 WHERE X.CODGERALOPER IN
       (SELECT CODGERALOPER C FROM MAX_CODGERALOPER C WHERE C.TIPCGO = 'S')
   AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2
   AND X.NROEMPRESA IN (#LS1)
   AND X.STATUSNF != 'C'
   AND G.SEQPESSOA = :NR1
   
   GROUP BY X.NROEMPRESA, X.NUMERONF, XI.SEQPRODUTO, DESCCOMPLETA, LOCAL, G.SEQPESSOA||' - '||NOMERAZAO, X.CODGERALOPER, TO_CHAR(DTAEMISSAO, 'DD/MM/YYYY')

ORDER BY 1,2
SELECT A.SEQPESSOA EMP_DESTINO, CASE WHEN A.NUMERONF IN(SELECT Z.NRONOTA FROM CONSINCO.OR_NFDESPESA Z WHERE Z.NROEMPRESA = A.SEQPESSOA 
                                   AND Z.NRONOTA = A.NUMERONF AND Z.SEQPESSOA = A.NROEMPRESA)
         THEN 'NF Lançada no Orçamento' ELSE 'NF Não Importada' END STATUS, A.NROEMPRESA EMITENTE, A.NUMERONF, 
       TO_CHAR(A.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO, 
       CASE WHEN X.NUMERONF IS NULL THEN NULL ELSE X.NUMERONF||' - CGO: '||X.CODGERALOPER||' - Data Emissão: '
                                                             ||TO_CHAR(X.DTAEMISSAO, 'DD/MM/YYYY') END NF_MATOU_OP

  FROM MLF_NOTAFISCAL A LEFT JOIN MAX_CODGERALOPER C ON A.CODGERALOPER = C.CODGERALOPER
                        LEFT JOIN MLF_NOTAFISCAL X   ON A.NUMERONF     = SUBSTR(REGEXP_SUBSTR(X.OBSERVACAO, ':[^:](\S*)'),3,10)
                                                    AND X.CODGERALOPER IN (202,16,69,135,22,141,12,169,135,27,23,26)
                                                    AND X.SEQPESSOA    < 999
                                                    AND X.DTAEMISSAO   BETWEEN :DT1 AND :DT2
                                                    AND A.NROEMPRESA   = X.SEQPESSOA 
                                                    AND X.STATUSNF != 'C'
 WHERE A.TIPNOTAFISCAL = 'S' 
   AND A.DTAENTRADA IS NULL
   AND A.SEQPESSOA != A.NROEMPRESA
   AND A.STATUSNF  != 'C'
   AND A.SEQPESSOA IN (#LS1)
   AND A.DTAEMISSAO   BETWEEN :DT1 AND :DT2
   AND A.NUMERONF NOT IN (SELECT NUMERONF FROM MLF_NOTAFISCAL B WHERE B.TIPNOTAFISCAL = 'E' 
                         AND SEQPESSOA < 999 
                         AND DTAENTRADA IS NOT NULL 
                         AND B.SEQPESSOA = A.NROEMPRESA
                         AND STATUSNF != 'C')
                         
UNION ALL 

SELECT D.NROEMPRESA DESTINO,
       CASE WHEN D.NUMERONF IN (SELECT Z.NRONOTA FROM CONSINCO.OR_NFDESPESA Z WHERE Z.NROEMPRESA = D.NROEMPRESA AND Z.NRONOTA = D.NUMERONF AND Z.SEQPESSOA = D.SEQPESSOA)
         THEN 'NF Lançada no Orçamento' ELSE
       DECODE(D.INDPROCESSAMENTO, 'G', 'NF em Conferência', 'L', 'NF Liberada, Conferência Não Iniciada', 'NF Gerada, Processo Não Iniciado') END,
       D.SEQPESSOA EMITENTE, D.NUMERONF, TO_CHAR(D.DTAEMISSAO, 'DD/MM/YYYY'), 
       CASE WHEN X.NUMERONF IS NULL THEN NULL ELSE X.NUMERONF||' - CGO: '||X.CODGERALOPER||' - Data Emissão: '
                                                             ||TO_CHAR(X.DTAEMISSAO, 'DD/MM/YYYY') END NF_MATOU_OP
  FROM MLF_AUXNOTAFISCAL D LEFT JOIN MAX_CODGERALOPER C ON D.CODGERALOPER = C.CODGERALOPER
                           LEFT JOIN MLF_NOTAFISCAL X   ON D.NUMERONF     = SUBSTR(REGEXP_SUBSTR(X.OBSERVACAO, ':[^:](\S*)'),3,10)
                                                    AND X.CODGERALOPER IN (202,16,69,135,22,141,12,169,135,27,23,26)
                                                    AND X.SEQPESSOA    < 999
                                                    AND X.DTAEMISSAO   BETWEEN :DT1 AND :DT2
                                                    AND X.NROEMPRESA   = D.SEQPESSOA 
                                                    AND X.STATUSNF != 'C'
 WHERE D.SEQPESSOA < 999 
   AND D.NUMERONF != 0   
   AND D.DTAEMISSAO BETWEEN :DT1 AND :DT2
   AND D.NROEMPRESA IN (#LS1)
   AND D.STATUSNF != 'C'
   
 ORDER BY 1,2,5 DESC;

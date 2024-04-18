SELECT DISTINCT D.NROEMPRESA DESTINO,
       CASE WHEN D.NUMERONF IN (SELECT Z.NRONOTA FROM CONSINCO.OR_NFDESPESA Z WHERE Z.NROEMPRESA = D.NROEMPRESA AND Z.NRONOTA = D.NUMERONF AND Z.SEQPESSOA = D.SEQPESSOA)
         THEN 'NF Lançada no Orçamento' ELSE
       DECODE(D.INDPROCESSAMENTO, 'G', 'NF em Conferência', 'L', 'NF Liberada, Conferência Não Iniciada', 'NF Gerada, Processo Não Iniciado') END SITUACAO,
       D.SEQPESSOA||' - '||NOMERAZAO FORNEC, D.NUMERONF, TO_CHAR(D.DTAEMISSAO, 'DD/MM/YYYY') DTA_EMISSAO, 
       CASE WHEN X.NUMERONF IS NULL THEN NULL ELSE X.NUMERONF||' - CGO: '||X.CODGERALOPER||' - Data Emissão: '
                                                             ||TO_CHAR(X.DTAEMISSAO, 'DD/MM/YYYY') END NF_MATOU_OP, D.OBSERVACAO
  FROM MLF_AUXNOTAFISCAL D LEFT JOIN MAX_CODGERALOPER C ON D.CODGERALOPER = C.CODGERALOPER
                           LEFT JOIN MLF_NOTAFISCAL X   ON D.NUMERONF     = X.NFREFERENCIANRO
                                                    AND X.CODGERALOPER IN (202,16,69,135,22,141,12,169,135,27,23,26,953,923)
                                                    AND X.SEQPESSOA    < 999
                                                    AND X.DTAEMISSAO   >= :DT1 
                                                    AND X.NROEMPRESA   = D.SEQPESSOA 
                                                    AND X.STATUSNF != 'C'
                          INNER JOIN GE_PESSOA Z ON Z.SEQPESSOA = D.SEQPESSOA                          
 WHERE D.SEQPESSOA != 999 
   AND D.NUMERONF != 0   
   AND D.DTAEMISSAO  BETWEEN :DT1 AND :DT2
   AND D.SEQPESSOA != D.NROEMPRESA
   AND D.NROEMPRESA in (#LS1)
   AND D.STATUSNF != 'C'
   AND D.NUMERONF NOT IN (SELECT NUMERONF FROM MLF_NOTAFISCAL B WHERE B.TIPNOTAFISCAL = 'E' 
                         AND SEQPESSOA != 999 
                         AND DTAENTRADA IS NOT NULL 
                         AND B.NROEMPRESA = D.NROEMPRESA
                         AND STATUSNF != 'C')
 ORDER BY 1,2,5 DESC;

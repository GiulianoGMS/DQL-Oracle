-- Inserir em MLFV_AUXNOTAFISCALINCONS

UNION ALL -- Trava lançamentos com vencimento menor que a data do pedido - Giuliano - Solicitação Ronie

SELECT DISTINCT(X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                62  AS CODINCONSISTENC,
                'Prazo de Vencimento Informado MENOR que o Prazo do Pedido' /*- Pedido: '||MP.NROPEDIDOSUPRIM||
                ' - Prazo: '||MP.PZOPAGAMENTO||TO_CHAR((MP.DTAEMISSAO + MP.PZOPAGAMENTO), 'DD/MM/YYYY')*/
                AS MENSAGEM

  FROM MLF_AUXNOTAFISCAL X INNER JOIN MLF_AUXNFVENCIMENTO MA ON MA.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL
                           INNER JOIN MLF_AUXNFITEM XA       ON X.SEQAUXNOTAFISCAL  = XA.SEQAUXNOTAFISCAL AND XA.SITUACAONF != 'C'
                           INNER JOIN MSU_PEDIDOSUPRIM MP    ON XA.NROPEDIDOSUPRIM  = MP.NROPEDIDOSUPRIM  AND MP.SITUACAOPED != 'C'
                                                                                                          AND MP.CENTRALLOJA = XA.CENTRALLOJA
                                                                                                          AND X.NROEMPRESA = MP.NROEMPRESA
                           INNER JOIN MAF_FORNECDIVISAO MF   ON MF.SEQFORNECEDOR    = MP.SEQFORNECEDOR

 WHERE MA.DTAVENCIMENTO < DECODE(MF.INDPZOPAGAMENTO, 'F', -- Forma de pagamento Faturamento
                  DECODE(MF.TIPODTABASEVENCTO, 'E', X.DTAEMISSAO, 'R', X.DTARECEBIMENTO, 'S', X.DTASAIDA) +
                  CASE WHEN MP.PZOPAGAMENTO LIKE '%/%' THEN REGEXP_SUBSTR(REPLACE(MP.PZOPAGAMENTO, '/',' '), '(\S*)(\s)',1)
                       ELSE MP.PZOPAGAMENTO END,
                  -- Function para tratar outras formas de pagamento de acordo com o cadastro (Fora a Dezena, Quinzena, Semana ou Mês)
                  FMAD_CALCDTAVENCTO((DECODE(MF.TIPODTABASEVENCTO, 'E', X.DTAEMISSAO, 'R', X.DTARECEBIMENTO, 'S', X.DTASAIDA)), MF.INDPZOPAGAMENTO,
                  CASE WHEN MP.PZOPAGAMENTO LIKE '%/%' THEN REGEXP_SUBSTR(REPLACE(MP.PZOPAGAMENTO, '/',' '), '(\S*)(\s)',1)
                       ELSE MP.PZOPAGAMENTO END, NULL)) 
                       
                       -1 -- 1 Dia de Margem Aceitável

   AND MP.PZOPAGAMENTO IS NOT NULL
   AND X.NUMERONF != 0
   AND MP.TIPPEDIDOSUPRIM NOT IN ('X','T')

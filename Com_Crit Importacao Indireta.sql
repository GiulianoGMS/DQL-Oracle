-- Critica em criada em MACV_CONSISTELOTECOMPRA
-- Barrar emissao de transferencia para Importacoes Indiretas quando nao possuir os CGOs 95 ou 93 informados

  SELECT DISTINCT X.SEQGERCOMPRA,
                  102 AS CODIGOCONSIST,
                  'CGO 95 ou 93 não informado na capa do lote para transferência de Importação Indireta, verifique!',
                  NULL AS COMPLEMENTO,
                  'B' AS BLOQUEIOLIBERACAO
    FROM MAC_GERCOMPRA X INNER JOIN MAC_GERCOMPRAITEM Y          ON X.SEQGERCOMPRA = Y.SEQGERCOMPRA
                         INNER JOIN CONSINCO.MAC_GERCOMPRAFORN Z ON Z.SEQGERCOMPRA = X.SEQGERCOMPRA
                         INNER JOIN MAP_PRODUTO P                ON P.SEQPRODUTO = Y.SEQPRODUTO
   WHERE 1 = 1
         AND NVL(CODGERALOPER, 0) NOT IN (95, 93)
         AND Z.SEQFORNECEDOR IN (502, 503)
         AND
         (SELECT UF
            FROM GE_PESSOA G
           WHERE SEQPESSOA = (SELECT SEQPESSOA
                                FROM MLF_NOTAFISCAL N
                               WHERE N.SEQNF = (SELECT NVL(FMLF_SEQNFULTENTRADA(Z.SEQFORNECEDOR,
                                                                                Y.SEQPRODUTO,
                                                                                'C'),
                                                           FMLF_SEQNFULTENTRADA(503,
                                                                                Y.SEQPRODUTO,
                                                                                'C'))
                                                  FROM DUAL))) != 'EX'

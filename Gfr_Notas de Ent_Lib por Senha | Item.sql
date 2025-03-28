SELECT X.NUMERONF NF,
              X.SERIENF SERIE,
              X.NROEMPRESA LOJA,
              X.SEQPESSOA COD_FORNECEDOR,
              P.NOMERAZAO FORNECEDOR,
              X.CODGERALOPER CGO,
              TO_CHAR(X.DTARECEBIMENTO,'DD/MM/YYYY') DTA_RECEBIMENTO,
              TO_CHAR(X.DTAEMISSAO,'DD/MM/YYYY') DTA_EMISSAO,
              Z.CODINCONSIST COD_INCONSISTENCIA,
              Z.DESCRICAO INCOSISTENCIA,
              Z.USUAUTORIZOU AUTORIZADOR,
              U.NOME NOME_AUTORIZADOR,
              TO_CHAR(Z.DTAAUTORIZOU,'DD/MM/YYYY')  DTA_AUTORIZACAO,
              UPPER(X.JUSTIFACEITEPEDIDO) JUSTIFICATIVA,
              'NF' ORIGEM_INCONSISTENCIA, NULL PLU, NULL DESCRICAO, NULL PESAVEL
FROM MLF_NOTAFISCAL X INNER JOIN MLF_AUXNFINCONSISTENCIA Z ON (Z.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL )
                                               INNER JOIN GE_PESSOA P ON (P.SEQPESSOA = X.SEQPESSOA)
                                               INNER JOIN GE_USUARIO U ON (U.CODUSUARIO = Z.USUAUTORIZOU)
WHERE 1=1
AND Z.SEQAUXNFITEM = 0
AND X.DTARECEBIMENTO BETWEEN :DT1 AND :DT2
AND X.NROEMPRESA IN (#LS1)

UNION ALL

SELECT X.NUMERONF NF,
              X.SERIENF SERIE,
              X.NROEMPRESA LOJA,
              X.SEQPESSOA COD_FORNECEDOR,
              P.NOMERAZAO FORNECEDOR,
              X.CODGERALOPER CGO,
              TO_CHAR(X.DTARECEBIMENTO,'DD/MM/YYYY') DTA_RECEBIMENTO,
              TO_CHAR(X.DTAEMISSAO,'DD/MM/YYYY') DTA_EMISSAO,
              Z.CODINCONSIST COD_INCONSISTENCIA,
              Z.DESCRICAO INCOSISTENCIA,
              Z.USUAUTORIZOU AUTORIZADOR,
              U.NOME NOME_AUTORIZADOR,
              TO_CHAR(Z.DTAAUTORIZOU,'DD/MM/YYYY')  DTA_AUTORIZACAO,
              UPPER(X.JUSTIFACEITEPEDIDO) JUSTIFICATIVA,
              'ITEM' ORIGEM_INCONSISTENCIA,
              I.SEQPRODUTO, M.DESCCOMPLETA, DECODE(F.PESAVEL,'S','Sim','N','Não') PESAVEL
              
FROM MLF_NOTAFISCAL X INNER JOIN  MLF_NFITEM I ON (I.SEQNF = X.SEQNF)

                                               INNER JOIN MLF_AUXNFINCONSISTENCIA Z ON (X.SEQAUXNOTAFISCAL = Z.SEQAUXNOTAFISCAL AND Z.SEQAUXNFITEM = I.SEQITEMNF)                                              
                                               INNER JOIN GE_PESSOA P ON (P.SEQPESSOA = X.SEQPESSOA)
                                               INNER JOIN GE_USUARIO U ON (U.CODUSUARIO = Z.USUAUTORIZOU)
                                               INNER JOIN MAP_PRODUTO M ON M.SEQPRODUTO = I.SEQPRODUTO
                                               INNER JOIN MAP_FAMILIA F ON F.SEQFAMILIA = M.SEQFAMILIA
WHERE 1=1
  AND Z.SEQAUXNFITEM <> 0
  AND X.DTARECEBIMENTO BETWEEN :DT1 AND :DT2
  AND X.NROEMPRESA IN (#LS1)

ORDER BY 7,3,4

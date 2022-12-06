-- Insere Operação | Tarifa

INSERT INTO CONSINCO.FI_TITOPERACAO X ( X.SEQTITOPERACAO,
                     X.SEQLANCTO, X.CODOPERACAO, X.SEQTITULO, X.DTAOPERACAO,
                     X.DTACONTABILIZA, X.VLROPERACAO, X.COLOPERACAO1, X.NRODOCUMENTO,
                     X.OBSERVACAO, X.ANOTACAO, X.TIPOASSUMIDO, X.SEQCTACORRENTE,
                     X.NROPROCESSO, X.DTACONCILIACAO, X.USUCONCILIOU, X.SITUACAO,
                     X.DTAQUITACAOANT, X.OPCANCELADA, X.USUCANCELOU, X.DTACANCELOU,
                     X.JUSTCANCEL, X.CODESPECIEANT, X.DTAALTERACAO, X.USUALTERACAO,
                     X.NROEMPRCTAPARTIDA, X.DTAHORAALTERACAO, X.SEQTITDESCONTO, X.ORIGEM,
                     X.DTAHORACANCELOU, X.USUARIOSO, X.IP, X.MAQUINA,
                     X.MODULO, X.INDESOCIAL, X.SEQDEPOSITARIO, X.SEQEXPFLUXOCAIXA )

                       SELECT (SELECT MAX(Y.SEQTITOPERACAO) +1 FROM CONSINCO.FI_TITOPERACAO Y), -- Cipolla - S_FINANCEIRO.nextval
                              X.SEQLANCTO,
                              77,
                              X.SEQTITULO,
                              X.DTAOPERACAO,
                              X.DTACONTABILIZA,
                              (SELECT (F.VLRORIGINAL / 100) * 8 FROM CONSINCO.FI_TITULO F WHERE F.SEQTITULO = 784311793),
                              'P',
                              X.NRODOCUMENTO,
                              'Tarifa De Cobranca De CartaoOperação da Taxa Administrativa lançada via Integração dos Títulos',
                              X.ANOTACAO,
                              X.TIPOASSUMIDO,
                              X.SEQCTACORRENTE,
                              X.NROPROCESSO,
                              X.DTACONCILIACAO,
                              X.USUCONCILIOU,
                              X.SITUACAO,
                              X.DTAQUITACAOANT,
                              X.OPCANCELADA,
                              X.USUCANCELOU,
                              X.DTACANCELOU,
                              X.JUSTCANCEL,
                              X.CODESPECIEANT,
                              X.DTAALTERACAO,
                              X.USUALTERACAO,
                              NULL,
                              X.DTAHORAALTERACAO,
                              X.SEQTITDESCONTO,
                              'TIT',
                              X.DTAHORACANCELOU,
                              X.USUARIOSO,
                              X.IP,
                              X.MAQUINA,
                              X.MODULO,
                              X.INDESOCIAL,
                              X.SEQDEPOSITARIO,
                              X.SEQEXPFLUXOCAIXA FROM CONSINCO.FI_TITOPERACAO X WHERE X.SEQTITULO = 784311793 AND CODOPERACAO = 16;
                                                      
COMMIT;

-- Insere desconto e percentual de tax.admin no título (8%)
                            
UPDATE CONSINCO.FI_TITULO A SET VLRPAGO = (A.VLRORIGINAL / 100) * 8,
                       PERCADMINISTRACAO = 8,
                       VLRADMINISTRACAO = (A.VLRORIGINAL / 100) * 8
WHERE SEQTITULO = 781151060;

COMMIT;

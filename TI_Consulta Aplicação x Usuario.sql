ALTER SESSION SET current_schema = CONSINCO;

SELECT GE_APLICACAO.TIPOACESSO, GE_APLICACAO.SEQAPLICACAO, GE_APLICACAO.CODAPLICACAO, 
       GE_APLICACAO.DESCRICAO, GE_APLICACAO.ESPECIAL1, GE_APLICACAO.ESPECIAL2, GE_APLICACAO.ESPECIAL3, GE_APLICACAO.ESPECIAL4                                                                                                                                                                                                                                                                                                                                             
FROM GE_APLICACAO 

WHERE   ge_aplicacao.nomeaplicacaodotnet IS NULL
   AND (UPPER(descricao)  LIKE UPPER('%MAX00920%') 
   OR UPPER(codaplicacao) LIKE UPPER('%MAX00920%')) 
ORDER BY CODAPLICACAO;

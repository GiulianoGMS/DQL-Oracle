ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT DISTINCT TO_CHAR(A.DTAAUDITORIA,'DD/MM/YYYY') AS DTAAUDITORIA,
       B.SEQPRODUTO PLU, 
       B.DESCCOMPLETA DESCRICAO,
       C.SEQFORNECEDOR|| ' - ' ||D.NOMERAZAO FORNECEDOR, MD.SEQCONTRATO NRO_CONTRATO, 
       DECODE(MC.STATUS, 'A','ATIVO','I','INATIVO') STATUS_CONTRATO, MD.DESCRICAO,
       CASE WHEN MD.INDDESCGERAL = 'S' THEN 'Contrato Geral'
         WHEN MD.INDDESCGERAL = 'N' AND FD.STATUS IS NOT NULL AND CF.SEQIDENTIFICADOR IS NOT NULL THEN 'Por Categoria | Família' 
           WHEN MD.INDDESCGERAL = 'N' AND FD.STATUS IS NOT NULL AND CF.SEQIDENTIFICADOR IS NULL THEN 'Por Categoria' ELSE NULL END 
       TIPO_CONTRATO, MD.PERCDESCONTO PERC_DESC

FROM CONSINCO.MAP_AUDITORIA A INNER JOIN CONSINCO.MAP_PRODUTO B ON (A.SEQIDENTIFICA = B.SEQPRODUTO)
                              LEFT JOIN CONSINCO.MAP_FAMFORNEC C ON (B.SEQFAMILIA = C.SEQFAMILIA) AND SEQFORNECEDOR > 999--AND C.PRINCIPAL = 'S'
                              INNER JOIN CONSINCO.MAP_FAMDIVISAO E ON (B.SEQFAMILIA = E.SEQFAMILIA)
                              INNER JOIN CONSINCO.GE_PESSOA D ON (C.SEQFORNECEDOR = D.SEQPESSOA) AND D.STATUS = 'A'
                              INNER JOIN GE_REDEPESSOA R ON R.SEQPESSOA = C.SEQFORNECEDOR
                              LEFT JOIN MGC_CONTRATO MC ON MC.SEQREDE = R.SEQREDE
                              LEFT JOIN MGC_CONTRATODESCONTO MD ON MD.SEQCONTRATO = MC.SEQCONTRATO
                              LEFT JOIN MGC_CONTRATOCATEGORIA MCA ON MCA.SEQIDENTIFICADOR = MD.SEQCONTRATODESCONTO
                              LEFT JOIN MAP_FAMDIVCATEG FD ON FD.SEQCATEGORIA = MCA.SEQCATEGORIA
                              LEFT JOIN MGC_CONTRATOFAMILIA CF ON CF.SEQIDENTIFICADOR = MCA.SEQIDENTIFICADOR AND CF.SEQFAMILIA = B.SEQFAMILIA

WHERE A.CAMPO = 'STATUSCOMPRA'
AND A.VLRATUAL LIKE 'A%'
AND A.DTAAUDITORIA = DATE '2023-01-08'

ORDER BY 3,4,7;

--SELECT * FROM MGC_CONTRATODESCONTO X WHERE SEQCONTRATO = 522
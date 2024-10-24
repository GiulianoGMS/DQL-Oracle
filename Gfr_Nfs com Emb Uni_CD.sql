ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT X.NROEMPRESA EMPRESA, X.NUMERONF, X.SEQPESSOA||' - '||(SELECT NOMERAZAO FROM GE_PESSOA G WHERE G.SEQPESSOA = X.SEQPESSOA) FORNECEDOR,
       XI.SEQPRODUTO PLU, M.DESCCOMPLETA DESC_PROD, TO_NUMBER(XI.QTDEMBALAGEM) EMBALAGEM_NF, TO_NUMBER(XI.QUANTIDADE) QTD,
       TO_CHAR(DTAEMISSAO, 'DD/MM/YYYY') DTA_EMISSAO, (SELECT SUM(A.VLRTOTALITEM) FROM MLF_AUXNFITEM A WHERE A.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL) VLR_TOTAL,
       CASE WHEN PR.NROPEDIDOSUPRIM IS NULL THEN 'SEM PEDIDO' ELSE 'OK' END PEDIDO_VINCULADO
       
  FROM MLF_AUXNOTAFISCAL X INNER JOIN MLF_AUXNFITEM XI ON X.SEQAUXNOTAFISCAL = XI.SEQAUXNOTAFISCAL
                           INNER JOIN MAP_PRODUTO   M  ON M.SEQPRODUTO       = XI.SEQPRODUTO
                           INNER JOIN MAP_FAMILIA   F  ON F.SEQFAMILIA       = M.SEQFAMILIA
                           LEFT JOIN  MSU_PSITEMRECEBIDO PR ON PR.SEQAUXNFITEM = XI.SEQAUXNFITEM AND PR.SEQAUXNOTAFISCAL = XI.SEQAUXNOTAFISCAL

 WHERE X.NROEMPRESA IN (501,506)
   AND DTAEMISSAO > SYSDATE - 10-- BETWEEN :DT1 AND :DT2
   AND XI.QTDEMBALAGEM = 1
   AND F.PESAVEL != 'S'
   AND X.NUMERONF != 0
   AND CODGERALOPER = 1

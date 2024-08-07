ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Criando a Tabela com os produtos selecionados

CREATE TABLE CONSINCO.NAGT_PROD_QISAR (SEQPRODUTO NUMBER(10));

-- View GMD Lista Produtos Selecionados

SELECT A.SEQPRODUTO, C.DESCCOMPLETA FROM CONSINCO.NAGT_PROD_QISAR A INNER JOIN MAP_PRODUTO C ON C.SEQPRODUTO = A.SEQPRODUTO ORDER BY 2;
 
-- Select com PIVOT para trazer coluna por empresa

SELECT *
FROM (
    SELECT XI.NROEMPRESA, XI.SEQPRODUTO PLU, DESCCOMPLETA DESCRICAO, XI.EMBCOMPRA EMB, TO_NUMBER(XI.QTDEMBALAGEM) QTD_EMB, XI.QTDPEDIDA
      FROM CONSINCO.MAC_GERCOMPRA X INNER JOIN MAC_GERCOMPRAITEM XI ON XI.SEQGERCOMPRA = X.SEQGERCOMPRA
                                    INNER JOIN MAP_PRODUTO P        ON XI.SEQPRODUTO = P.SEQPRODUTO
     WHERE X.SEQGERCOMPRA = 295404
    -- AND NVL(XI.QTDPEDIDA,0) > 0 -- No PIVOT nao precisa > 0
       AND EXISTS (SELECT 1 FROM CONSINCO.NAGT_PROD_QISAR Q WHERE Q.SEQPRODUTO = XI.SEQPRODUTO)
     )
PIVOT (
    SUM(QTDPEDIDA)
    FOR NROEMPRESA IN (1,2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
                       37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,57,58,301,500,501,502,503,504,505,506)
    
)
;
-- Dados das Lojas do Grupo

SELECT E.NROEMPRESA, E.NOMEREDUZIDO, E.RAZAOSOCIAL, E.ENDERECO, EE.ENDERECONRO, E.BAIRRO,
       E.CEP, E.CIDADE, E.UF, LPAD(E.NROCGC,12,0)||LPAD(E.DIGCGC,2,0) CNPJ
  FROM MAX_EMPRESA E INNER JOIN GE_EMPRESA EE ON EE.NROEMPRESA = E.NROEMPRESA
  
 WHERE E.NROEMPRESA < 507
 
ORDER BY 1

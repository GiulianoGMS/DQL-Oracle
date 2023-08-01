-- Alteração na CONSINCO.MLFV_AUXNOTAFISCALINCONS

SELECT DISTINCT(X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF, 
                X.NROEMPRESA, 
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                67  AS CODINCONSISTENC,
                /*'Comprador não possúi limite disponível. Valor Itens sem Pedidos: R$ '||
                TO_CHAR(
                 SUM(Y.VLRITEM) --+ SUM(Y.VLRIPI) + SUM(Y.VLRICMS) + SUM(Y.VLRDESPTRIBUTITEM) + SUM(Y.VLRPIS) + SUM(Y.VLRCOFINS)
               - SUM(Y.VLRDESCITEM) - SUM(NVL(Y.VLRDESCFINANCEIRO,0)),
               'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''')||' Valor Disponível: R$ '||
                TO_CHAR(VLRDISPONIVEL,'FM999G999G999D90', 'NLS_NUMERIC_CHARACTERS='',.''')||' Entre em contato com o Departamento Comercial.' */
                'Não existe saldo disponível para o comprador para recebimento sem pedido. Entre em contato com o Departamento Comercial'
                AS MENSAGEM
                 
  FROM MLF_AUXNOTAFISCAL X INNER JOIN MLF_AUXNFITEM Y ON Y.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL
                           INNER JOIN MAP_PRODUTO   P ON P.SEQPRODUTO = Y.SEQPRODUTO
                           INNER JOIN MAP_FAMDIVISAO F ON F.SEQFAMILIA = P.SEQFAMILIA
                           INNER JOIN NAGV_LIMITECOMPRADOR NV ON NV.SEQCOMPRADOR = F.SEQCOMPRADOR
                           INNER JOIN MLF_AUXNFINCONSISTENCIA A ON A.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL AND A.SEQAUXNFITEM = Y.SEQAUXNFITEM
                           
 WHERE A.CODINCONSIST IN (7) 
   AND A.AUTORIZADA = 'N'         
   AND A.TIPOINCONSIST = 'P' 
   AND X.DTAENTRADA > SYSDATE - 100
 GROUP BY X.SEQAUXNOTAFISCAL, X.NUMERONF, X.NROEMPRESA, VLRDISPONIVEL

HAVING SUM(Y.VLRITEM) 
     - SUM(Y.VLRDESCITEM) > VLRDISPONIVEL

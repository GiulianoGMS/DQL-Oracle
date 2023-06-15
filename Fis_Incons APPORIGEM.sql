-- Adicionado na CONSINCO.MLFV_AUXNOTAFISCALINCONS

-- Ticket 244728 - Solic Rafael Recebimento | Adicionado por Giuliano em 15/06/2023
-- Trava geração de recebimento de notas que forem deletadas e importadas novamente (CD x Lojas | Lojas x CD)

SELECT DISTINCT(X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                66  AS CODINCONSISTENC,
                'NF não pode ser importada novamente. Entre em contato com Fiscal Apoio de sua região' AS MENSAGEM

  FROM MLF_AUXNOTAFISCAL X
 WHERE 1=1
   AND NVL(X.APPORIGEM,0) != 9 -- Ao excluír a nota da tela de recebimento, o 'APPORIGEM' é definido como NULO
   AND USULANCTO != 'CONSINCO'
   AND NUMERONF  != 0
   AND X.STATUSNF != 'C'
   AND (SEQPESSOA IN (501,506)
        OR NROEMPRESA IN (501,506) AND SEQPESSOA < 100)

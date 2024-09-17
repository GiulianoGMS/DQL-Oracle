-- Adicionar em MLFV_AUXNOTAFISCALINCONS
-- Ticket 432832 - Adicionado por Giuliano em 29/07/2024
-- Regra para EX - Valida se a saída do IPI está parametrizada

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                82  AS CODINCONSISTENC,
                '(EX) Produto com entrada de IPI sem saída parametrizada. Entrar em contato com Depto Cadastro Comercial'

  FROM MLF_AUXNOTAFISCAL X INNER JOIN MLF_AUXNFITEM XI ON X.SEQAUXNOTAFISCAL = XI.SEQAUXNOTAFISCAL
                           INNER JOIN MAP_PRODUTO MP ON MP.SEQPRODUTO = XI.SEQPRODUTO
                           INNER JOIN MAP_FAMILIA MF ON MF.SEQFAMILIA = MP.SEQFAMILIA
                           INNER JOIN MAP_FAMFORNEC FC ON FC.SEQFAMILIA = MF.SEQFAMILIA
                           INNER JOIN GE_PESSOA GE ON GE.SEQPESSOA = FC.SEQFORNECEDOR
  WHERE 1=1
    AND UF = 'EX'
    AND NVL(MF.ALIQUOTAIPI,0) > 0
    AND (MF.PERISENTOIPI IS NULL
     OR MF.PEROUTROIPI IS NULL
     OR MF.PERALIQUOTAIPI IS NULL
     OR NVL(MF.PERBASEIPI,0) = 0)
    AND X.NROEMPRESA IN (502,503)

-- Inserir em MLFV_AUXNOTAFISCALINCONS

/* Alteracao na logica das duas críticas abaixo em solicitação de Neides - 22/11/2023 - Alterado por Giuliano

----Critica : Para Fornecedores de SP a data de emiss¿o n¿o pode ser mais do que 15 dias da data do recebimento
SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'L' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                54 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Data de Recebimento Acima de 18 Dias da Emissão Para Fornecedores de SP Data Limite : '|| to_char(a.dtaemissao + 16, 'DD/MM/YY') AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a, ge_pessoa b , max_empresa c
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and   b.uf = 'SP'
and a.dtaemissao <= (a.dtarecebimento - 18)   --- alteração em 13/12/2022 neides - Ticket 153066
and A.DTAEMISSAO + 180 > A.DTARECEBIMENTO -- Inconsistencia será validada pela regra COD 63

union all

----Critica : Para Todos os Fornecedores exceto SP a data de emiss¿o n¿o pode ser mais do que 20 dias da data do recebimento
 SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'L' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                55 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Data de Recebimento Acima de 32 Dias da Emissão Data Limite : '|| to_char(a.dtaemissao + 30, 'DD/MM/YY') AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a, ge_pessoa b , max_empresa c
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and   b.uf != 'SP'
and a.dtaemissao <= (a.dtarecebimento - 32)  --- alteração em 13/12/2022 neides - Ticket 153066
and A.DTAEMISSAO + 180 > A.DTARECEBIMENTO -- Inconsistencia será validada pela regra COD 63
*/

-- Novas:

-- 18 Dias para Emissoes na mesma UF

 SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0 AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                54 AS CODINCONSISTENC,
                'Data de Recebimento Acima de 18 Dias da Emissão Data Limite : '|| TO_CHAR(A.DTAEMISSAO + 16, 'DD/MM/YY') AS MENSAGEM
FROM MLF_AUXNOTAFISCAL A, GE_PESSOA B , MAX_EMPRESA C
WHERE A.NROEMPRESA = C.NROEMPRESA
AND   A.SEQPESSOA = B.SEQPESSOA
AND   B.UF = C.UF
AND A.DTAEMISSAO <= (A.DTARECEBIMENTO - 18)
AND A.DTAEMISSAO + 180 > A.DTARECEBIMENTO

  UNION ALL
-- 32 Dias para Emissoes em UF diferentes

SELECT DISTINCT (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                A.NUMERONF,
                A.NROEMPRESA,
                0 AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                55 AS CODINCONSISTENC,
                'Data de Recebimento Acima de 32 Dias da Emissão Data Limite : '|| TO_CHAR(A.DTAEMISSAO + 30, 'DD/MM/YY') AS MENSAGEM
FROM MLF_AUXNOTAFISCAL A, GE_PESSOA B , MAX_EMPRESA C
WHERE A.NROEMPRESA = C.NROEMPRESA
AND   A.SEQPESSOA = B.SEQPESSOA
AND   B.UF != C.UF
AND A.DTAEMISSAO <= (A.DTARECEBIMENTO - 32)
AND A.DTAEMISSAO + 180 > A.DTARECEBIMENTO

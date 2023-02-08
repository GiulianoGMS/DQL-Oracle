UNION ALL -- TIcket 184335 - Solic Danielle - Adicionado por Giuliano - 08/02/2023

SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'B' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                63 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'NF excedeu o prazo de 180 dias e não pode ser recebida - Data Limite : '|| to_char(a.DTAEMISSAO + 180, 'DD/MM/YY') AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a, ge_pessoa b , max_empresa c
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and a.dtaemissao + 180 < a.dtarecebimento

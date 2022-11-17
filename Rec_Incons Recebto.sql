CREATE OR REPLACE VIEW CONSINCO.MLFV_AUXNOTAFISCALINCONS AS
SELECT distinct (PP.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                PP.NUMERONF,
                PP.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'L' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                51 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Nota com produtos que cobram ST por fora sem guia lançada ou valor divergente' AS MENSAGEM -- Mensagem da inconsist¿ncia
  FROM MLF_AUXNOTAFISCAL PP,
       MLF_GNRE Z,
       (SELECT X.SEQAUXNOTAFISCAL, SUM(X.VLRICMSST) VLRICMSST
          FROM MLF_AUXNFITEM X
         WHERE X.VLRICMSST > 0
           AND X.LANCAMENTOST IN ('O', 'I')
         GROUP BY X.SEQAUXNOTAFISCAL) GS
 WHERE PP.SEQAUXNOTAFISCAL = Z.SEQAUXNOTAFISCAL
   AND PP.SEQAUXNOTAFISCAL = GS.SEQAUXNOTAFISCAL
   AND ABS(GS.VLRICMSST - Z.VLRRECOLHIDO) > 1

   union all

----cr¿tica solicitada por Neides.
   SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'B' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                52 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Nota Fiscal com o CGO incorreto' AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a,ge_pessoa b, max_empresa c,
(select substr((lpad(a.nrocgccpf,13,0)),0,9)as raiz,b.seqpessoaemp,a.fantasia, b.nroempresa
from ge_pessoa a, max_empresa b
where a.seqpessoa = b.seqpessoaemp) d, max_codgeraloper e
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and   a.nroempresa = d.nroempresa
and   a.codgeraloper = e.codgeraloper
and substr((lpad(b.nrocgccpf,13,0)),0,9) != d.raiz
and e.cfopestado in (1209)

union all

   SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'B' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                53 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Nota Fiscal com o CGO incorreto' AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a,ge_pessoa b, max_empresa c,
(select substr((lpad(a.nrocgccpf,13,0)),0,9)as raiz,b.seqpessoaemp,a.fantasia, b.nroempresa
from ge_pessoa a, max_empresa b
where a.seqpessoa = b.seqpessoaemp) d, max_codgeraloper e
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and   a.nroempresa = d.nroempresa
and   a.codgeraloper = e.codgeraloper
and substr((lpad(b.nrocgccpf,13,0)),0,9) = d.raiz
and a.seqpessoa <> a.nroempresa --- Tratativa para quando empresa mata a operação para ela mesma 30/09/2022
and e.cfopestado in (1202)

union all

----Critica : Para Fornecedores de SP a data de emiss¿o n¿o pode ser mais do que 15 dias da data do recebimento
SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'L' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                54 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Data de Recebimento Acima de 15 Dias da Emissão Para Fornecedores de SP Data Limite : '|| to_char(a.dtarecebimento - 15, 'DD/MM/YY') AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a, ge_pessoa b , max_empresa c
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and   b.uf = 'SP'
and a.dtaemissao <= (a.dtarecebimento - 15)

union all

----Critica : Para Todos os Fornecedores exceto SP a data de emiss¿o n¿o pode ser mais do que 20 dias da data do recebimento
 SELECT distinct (a.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                a.NUMERONF,
                a.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'L' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                55 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Data de Recebimento Acima de 20 Dias da Emissão Data Limite : '|| to_char(a.dtarecebimento - 20, 'DD/MM/YY') AS MENSAGEM -- Mensagem da inconsist¿ncia
from MLF_AUXNOTAFISCAL a, ge_pessoa b , max_empresa c
where a.nroempresa = c.nroempresa
and   a.seqpessoa = b.seqpessoa
and   b.uf != 'SP'
and a.dtaemissao <= (a.dtarecebimento - 19)

union all

---CRITICA Nota com produtos que cobram ST por fora sem guia gnre lan¿ada Edvaldo
SELECT distinct (PP.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
PP.NUMERONF,
PP.NROEMPRESA,
0 AS SEQAUXNFITEM, -- Seq Item
'B' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
56 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
'Nota com produtos que cobram ST por fora sem guia lançada ou valor divergente (V2-COD 56)' AS MENSAGEM -- Mensagem da inconsist¿ncia
FROM CONSINCO.MLF_AUXNOTAFISCAL PP
WHERE PP.SEQAUXNOTAFISCAL IN
(SELECT C.SEQAUXNOTAFISCAL
FROM MLF_AUXNFITEM C
WHERE C.VLRICMSST > 0
AND C.LANCAMENTOST IN ('O', 'I'))
AND PP.SEQAUXNOTAFISCAL NOT IN
(SELECT Z.SEQAUXNOTAFISCAL FROM MLF_GNRE Z)

union all

-- Critica para bloquear recebimento de notas que não esteja vinculadas a notas de remessa. Ticket 11783532
   SELECT distinct (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                A.NUMERONF,
                A.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'B' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                57 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Nota Fiscal de remessa não está vinculada a essa NF' AS MENSAGEM -- Mensagem da inconsistência
  FROM consinco.MLF_AUXNOTAFISCAL A
 WHERE A.CODGERALOPER IN (121,116)
  --- Trecho abaixo adicionado devido a mudança de estrutura da nova versão 22.01 - Cipolla / Paloma 28/06/2022
   AND not EXISTS (select 1
  from CONSINCO.MLF_NFCOMPRAREMESSARELAC
 where (SEQIDENTIFICAORIGEM = a.seqauxnotafiscal OR SEQIDENTIFICARELACIONADO = a.seqauxnotafiscal)
   AND TIPORELACIONADO = 'M')


/*   union all -- Retirado critica pois foi alterado parametro dinamico, ticket 12339992

   -- Critica para bloquear notas do RJ onde o Vlr da Nota está diferente do Vlr XML com oirgem do CD
--- Ticket 11835472
SELECT distinct (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                A.NUMERONF,
                A.NROEMPRESA,
                0 AS SEQAUXNFITEM, -- Seq Item
                'B' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                58 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Valor Total da Nota Fiscal' || ' - R$ '||A.VLRTOTALNF|| ' está divergente do valor total do XML - R$ '||B.m000_vl_nf AS MENSAGEM -- Mensagem da inconsist¿ncia
  FROM consinco.MLF_AUXNOTAFISCAL A INNER JOIN consinco.tmp_m000_nf b ON (a.nfechaveacesso = b.m000_nr_chave_acesso )
 WHERE b.m000_vl_nf != a.vlrtotalnf ---- Onde valores sejam diferentes
 AND a.nroempresa = 36 --- Apenas loja do RJ
 and a.seqpessoa in (501,502,503,504,505,506) -- Origem apenas do CD*/

 union all


 -- Critica solicitada pelo Juan para não permitir entrada de produtos de uso e consumo que não sejam no CGO 02 08/09/2021 Cipolla
 --- Solicitação do Juan 06/09/2021
 SELECT distinct (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL, -- Seq da nota
                A.NUMERONF,
                A.NROEMPRESA,
                b.seqauxnfitem AS SEQAUXNFITEM, -- Seq Item
                'L' AS BLOQAUTOR, -- Indica se ¿ de bloqueio(B) ou permite Libera¿¿o (L)
                58 AS CODINCONSISTENC, -- C¿digo de inconsist¿ncia. Nro Sequencial iniciando em 50
                'Item ' || b.seqproduto || ' está cadastrado com a Finalidade "Material de Uso e Consumo", portanto, só poderá ser lançado no CGO 02, 22, 59 ou 61' as  MENSAGEM -- Mensagem da inconsist¿ncia
  FROM consinco.MLF_AUXNOTAFISCAL A INNER JOIN consinco.Mlf_Auxnfitem b ON (a.seqauxnotafiscal = b.seqauxnotafiscal )
                                                                           inner join consinco.map_produto c on (c.seqproduto = b.seqproduto)
                                                                           inner join consinco.map_famdivisao e on (e.seqfamilia = c.seqfamilia)
  where e.finalidadefamilia = 'U'                                                                               --- Incluido CGOS 69,135,202 em 19/01/2022 por Cipolla - Solicitação Juan
  and   a.codgeraloper not in (2,22,59,61,128,65,652,950,141,69,135,202,126,14,127) --- Solicitação Juan 128, 65 e 652 em 10/12/2021 - Alterado por Cipolla- Incluido CGO 950 em 14/12 solciitação Juan - Incuido CGO 141 Solicitação Juan em 05/01/2022
                                                                                                                                         ---- CGO 126,14 incluido em 15/09/2022 solicitação Neides cvia Teamns
                                                                                                                                         ---- CGO 127 - 16/11/2022 Giuliano - Ticket 138456
  and a.nroempresa < 500
--  and a.nroempresa = 14

union all

 --- Critica solicitada pela Daniele do Fiscal - Ticket 97671 - Criado por Cipolla em 14/11/2022
 SELECT  /*+optimizer_features_enable('11.2.0.4') */
                distinct (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                a.numeronf,
                A.NROEMPRESA,
                b.seqauxnfitem AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                59 AS CODINCONSISTENC,
                'O Item ' || b.seqproduto || ' está com PIS/COFINS divergente, entrar em contato com o departamento fiscal - Tipo de Fornecedor: '||decode(f.TIPO,'M','Simples Nacional','I','Industria','D','Distribuidor') as  MENSAGEM
  FROM consinco.MLF_AUXNOTAFISCAL A INNER JOIN consinco.Mlf_Auxnfitem b ON (a.seqauxnotafiscal = b.seqauxnotafiscal )
                                                                           inner join consinco.map_produto c on (c.seqproduto = b.seqproduto)
                                                                           inner join consinco.map_familia e on (e.seqfamilia = c.seqfamilia)
                                                                           inner join NAGV_FORNTIPO f on (f.seqfornecedor = a.seqpessoa) --- view tipo fornecedor
                                                                           inner join TMP_M000_NF k on (k.m000_nr_chave_acesso = a.nfechaveacesso)
                                                                           inner join TMP_M014_ITEM l on (l.m000_id_nf = k.m000_id_nf and l.m014_nr_item = b.seqauxnfitem  )
  where 1=1
  and  exists (select 1 from max_codgeraloper z where z.codgeraloper = a.codgeraloper and z.tipuso = 'R') --- Apenas CGo de Recebimento
  and not exists (select 1 from ge_empresa ge where ge.seqpessoa = a.seqpessoa) --- Retirar empresas do Grupo Nagumo
  and exists (select 1 From NAGT_ENTRADAPISCOFINS r where l.m014_dm_st_trib_cf = r.cst_saidafornecedor and r.cst_entranagumo !=  e.situacaonfpis and f.TIPO = r.fornecedor) --- De x Para tipo fornecedor com CST Saída x Entrada
;

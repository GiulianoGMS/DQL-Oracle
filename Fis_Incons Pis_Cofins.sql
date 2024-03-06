-- Alterar MLFV_AUXNOTAFISCALINCONS

         --- Critica solicitada pela Daniele do Fiscal - Ticket 97671 - Criado por Cipolla em 14/11/2022
	 --- Essa view vai tratar apenas as consistencias de Pis e Cofins quando CGO for de entrada comum, bonificações estão sendo tratadas na view abaixo..
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
                                                                           inner join TMP_M014_ITEM l on (l.m000_id_nf = k.m000_id_nf and l.m014_nr_item = b.seqitemnfxml  )
  where 1=1
  and  exists (select 1 from max_codgeraloper z where z.codgeraloper = a.codgeraloper and z.tipuso = 'R') --- Apenas CGo de Recebimento
  and not exists (select 1 from ge_empresa ge where ge.seqpessoa = a.seqpessoa) --- Retirar empresas do Grupo Nagumo
  and a.codgeraloper not  in (126,816,101,128,208,239,117,14,127,65, 116, 139, 652, 143,900,107,206,939,279) --- Dani solicitou que Bonificalções tem tratamento diferente, será acrescido na critica abaixo. Retirado CGO 279 DANI em 28/02/2024
  -- COFINS
  and (not exists (select 1 From NAGT_ENTRADAPISCOFINS r where (l.m014_dm_st_trib_cf = r.cst_saidafornecedor OR l.M014_Dm_St_Trib_Pis = r.cst_saidafornecedor )
  and r.cst_entranagumo =  e.situacaonfpis and f.TIPO = r.fornecedor and r.tipo = 'N' --- De x Para tipo fornecedor com CST Saída x Entrada
                                                         -- Adicionado por Giuliano em 04/01/2024 - Solic Danielle - Ticket 339477
                                                         -- Começa a tratar permissao por UF - UF_PERM adicionada na tabela de/para NAGT_ENTRADAPISCOFINS
                                                          AND (UF_PERM IS NULL OR
                                                               UF_PERM LIKE '%'||(SELECT UF FROM GE_PESSOA GEP WHERE GEP.SEQPESSOA = A.SEQPESSOA)||'%'))
  -- PIS 
    OR not exists (select 1 From NAGT_ENTRADAPISCOFINS r where l.M014_Dm_St_Trib_Pis = r.cst_saidafornecedor and r.cst_entranagumo =  e.situacaonfpis and r.fornecedor = F.TIPO and r.tipo = 'N' --- De x Para tipo fornecedor com CST Saída x Entrada
                                                          AND (UF_PERM IS NULL OR
                                                               UF_PERM LIKE '%'||(SELECT UF FROM GE_PESSOA GEP WHERE GEP.SEQPESSOA = A.SEQPESSOA)||'%')))
  -- Alterado por Giuliano em 06/10/2023 - Solic Danielle/Neides - Ticket 300200
  -- Retirado fornecedores Micro Empresa e Pis/Cofins 49 no Cadastro do Fornecedor
  AND NOT EXISTS (
  SELECT 1
    FROM CONSINCO.MAF_FORNECDIVISAO FD INNER JOIN MAF_FORNECEDOR FF ON FF.SEQFORNECEDOR = FD.SEQFORNECEDOR
   WHERE FD.PERPISDIF    = 49
     AND FD.PERCOFINSDIF = 49
     AND FF.MICROEMPRESA != 'S'
     AND FD.SEQFORNECEDOR = A.SEQPESSOA)

	union all

		--- Critica solicitada pela Daniele do Fiscal - Ticket 97671 - Criado por Cipolla em 14/11/2022
	 --- Essa view vai tratar apenas as consistencias de Pis e Cofins quando CGO for de bonificação.
 SELECT  /*+optimizer_features_enable('11.2.0.4') */
                distinct (A.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                a.numeronf,
                A.NROEMPRESA,
                b.seqauxnfitem AS SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                60 AS CODINCONSISTENC,
                'O Item ' || b.seqproduto || ' está com PIS/COFINS divergente, entrar em contato com o departamento fiscal - Tipo de Fornecedor: '||decode(f.TIPO,'M','Simples Nacional','I','Industria','D','Distribuidor') as  MENSAGEM
  FROM consinco.MLF_AUXNOTAFISCAL A INNER JOIN consinco.Mlf_Auxnfitem b ON (a.seqauxnotafiscal = b.seqauxnotafiscal )
                                                                           inner join consinco.map_produto c on (c.seqproduto = b.seqproduto)
                                                                           inner join consinco.map_familia e on (e.seqfamilia = c.seqfamilia)
                                                                           inner join NAGV_FORNTIPO f on (f.seqfornecedor = a.seqpessoa) --- view tipo fornecedor
                                                                           inner join TMP_M000_NF k on (k.m000_nr_chave_acesso = a.nfechaveacesso)
                                                                           inner join TMP_M014_ITEM l on (l.m000_id_nf = k.m000_id_nf and l.m014_nr_item = b.seqitemnfxml  )  --- alteração Cipolla de seqauxnfitem Para seqitemnfxml
  where 1=1
  and not exists (select 1 from ge_empresa ge where ge.seqpessoa = a.seqpessoa) --- Retirar empresas do Grupo Nagumo
  and a.codgeraloper in (126,816,101,128,208,239,117,14,127,65, 116, 139, 652, 143,900,107) --- Bonificações Ticket 194151 Dani em 02/03/2023 Cipolla CGO 900
   -- COFINS
  and (not exists (select 1 From NAGT_ENTRADAPISCOFINS r where (l.m014_dm_st_trib_cf = r.cst_saidafornecedor OR l.M014_Dm_St_Trib_Pis = r.cst_saidafornecedor )
  and r.cst_entranagumo =  e.situacaonfpis and r.fornecedor = F.GERAL and r.tipo = 'B' --- De x Para tipo fornecedor com CST Saída x Entrada
                                                         -- Adicionado por Giuliano em 04/01/2024 - Solic Danielle - Ticket 339477
                                                         -- Começa a tratar permissao por UF - UF_PERM adicionada na tabela de/para NAGT_ENTRADAPISCOFINS
                                                          AND (UF_PERM IS NULL OR
                                                               UF_PERM LIKE '%'||(SELECT UF FROM GE_PESSOA GEP WHERE GEP.SEQPESSOA = A.SEQPESSOA)||'%'))
  -- PIS 
    OR not exists (select 1 From NAGT_ENTRADAPISCOFINS r where l.M014_Dm_St_Trib_Pis = r.cst_saidafornecedor and r.cst_entranagumo =  e.situacaonfpis and r.fornecedor = F.GERAL and r.tipo = 'B' --- De x Para tipo fornecedor com CST Saída x Entrada
                                                          AND (UF_PERM IS NULL OR
                                                               UF_PERM LIKE '%'||(SELECT UF FROM GE_PESSOA GEP WHERE GEP.SEQPESSOA = A.SEQPESSOA)||'%')))
  -- Alterado por Giuliano em 06/10/2023 - Solic Danielle/Neides - Ticket 300200
  -- Retirado fornecedores Micro Empresa e Pis/Cofins 49 no Cadastro do Fornecedor
  AND NOT EXISTS (
  SELECT 1
    FROM CONSINCO.MAF_FORNECDIVISAO FD INNER JOIN MAF_FORNECEDOR FF ON FF.SEQFORNECEDOR = FD.SEQFORNECEDOR
   WHERE FD.PERPISDIF    = 49
     AND FD.PERCOFINSDIF = 49
     AND FF.MICROEMPRESA != 'S'
     AND FD.SEQFORNECEDOR = A.SEQPESSOA)

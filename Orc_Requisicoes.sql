ALTER SESSION SET current_schema = CONSINCO;

select a.nrorequisicao Requisicao,
       d.nroparcela PARCELA,
       a.nroempresa Empresa,
       a.seqpessoa Codigo,
       c.nomerazao Razao,
       lpad(c.nrocgccpf, 11, 0) || lpad(c.digcgccpf, 2, 0) CNPJ,
       a.usuautorizacao AUTORIZACAO,
       to_char(a.dtaautorizacao,'DD-MM-YYYY') DTA_AUTORIZACAO,
       decode(a.status,'L','LIBERADO','A','AGUARDANDO AUTORIZAÇÃO','F','FINALIZADA') STATUS,
       a.usufinalizou USUARIO_FINALIZOU,
       D.DTAPROGRAMADA VENCIMENTO, --to_char(d.dtaprogramada,'DD-MM-YYYY') VENCIMENTO,        
 to_char( (nvl(d.vlrtotal,0) - nvl(d.vlrdesconto, 0)), '999G999G990D99') ValorLiquido,
       a.observacao OBS
  from or_requisicao a  inner join ge_pessoa c on (a.seqpessoa = c.seqpessoa)
                        left join OR_REQUISICAOVENCTO d  on (a.seqrequisicao = d.seqrequisicao) 
  WHERE d.DTAVENCIMENTO BETWEEN :DT1 AND :DT2
  and a.codhistorico not in (571, 4947,4967,4968,4969,4970,4971,4972,4973,4974, 884,904,1247,1248,1367,1386,905,906,907,1192,1193,1249,1186,1706, 1080, 361,1078,395,389)
  AND a.seqpessoa = :NR1
  
  ORDER BY 3,5

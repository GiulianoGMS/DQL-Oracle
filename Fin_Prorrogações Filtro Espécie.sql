ALTER SESSION SET current_schema = CONSINCO;

SELECT a.nroempresa empresa,
       b.seqpessoa,
       c.nomerazao RAZAO,
       b.nrodocumento DOCUMENTO,
       b.nroparcela PARCELA,
       a.codespecie ESPECIE,
       (SELECT fi.descricao FROM fi_especie fi WHERE fi.codespecie = a.codespecie AND a.nroempresamae = fi.nroempresamae) ESPECIE_DESC,
       to_char(b.dtaemissao, 'DD-MM-YYYY')EMISSAO,
       to_char(b.dtaentrada, 'DD-MM-YYYY')ENTRADA,
       b.dtaentrada - b.dtaemissao DIAS,
       to_char(a.dtaprogramada,'DD-MM-YYYY') VENCIMENTO,
CASE WHEN FC5F_DATAUTIL(b.dtavencimento,NULL,NULL,0,'P',NULL) = a.dtaprogramada THE NULL ELSE to_char(b.dtavencimento,'DD-MM-YYYY') 
  END VENCIMENTO_ORIGINAL,
       b.vlroriginal VALOR
FROM fi_titulo a LEFT JOIN mrl_titulofin b ON (a.seqtitulo = b.seqintegracao AND a.nroempresa = b.nroempresa)
                 INNER JOIN ge_pessoa c ON (a.seqpessoa = c.seqpessoa)
WHERE a.obrigdireito = 'O'
AND a.codespecie IN (#LS@)   -- Alteração Chamado 33726 - Andressa
AND  a.situacao != 'C'
AND a.abertoquitado = 'A'
AND a.codespecie not in ('DUPPIM','BONIAC')
AND NVL(a.SUSPLIB, 'L') != 'S'
AND a.dtaemissao between :DT1 and :DT2
AND (b.dtaentrada - b.dtaemissao) >= 4
AND NVL(A.SEQMOTIVOSUSPLIB,0) not in ('43','42','1')
AND NOT EXISTS (select * from fi_movocor o where o.seqidentifica = a.seqtitulo and o.codocorrencia in (67))
AND a.nroempresa in (#LS1)
AND NOT EXISTS (select * from fi_autpagto g where g.seqtitulo = a.seqtitulo)
AND NOT EXISTS (select * from ge_empresa d where d.seqpessoa = a.seqpessoa)
AND NOT EXISTS (select * from fi_progpagamento g where g.seqtitulo = a.seqtitulo)



union all

select null,
       null,
     ' TOTAL DE TITULOS',
       count(a.nrotitulo),
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       'VALOR_TOTAL',
       sum(b.vlroriginal) VALOR
from fi_titulo a left join mrl_titulofin b on (a.seqtitulo = b.seqintegracao and a.nroempresa = b.nroempresa)
                 inner join ge_pessoa c on (a.seqpessoa = c.seqpessoa)
where a.obrigdireito = 'O'
AND a.codespecie IN (#LS@)   -- Alteração Chamado 33726 - Andressa
and  a.situacao != 'C'
and a.abertoquitado = 'A'
and a.codespecie not in ('DUPPIM','BONIAC')
and NVL(a.SUSPLIB, 'L') != 'S'
and (b.dtaentrada - b.dtaemissao) >= 4
and a.dtaemissao between :DT1 AND :DT2
and not exists (select * from fi_movocor o where o.seqidentifica = a.seqtitulo and o.codocorrencia in (67))
and a.nroempresa in (#LS1)
AND NVL(A.SEQMOTIVOSUSPLIB,0) not in ('43','42','1')
and not exists (select * from fi_autpagto g where g.seqtitulo = a.seqtitulo)
and not exists (select * from ge_empresa d where d.seqpessoa = a.seqpessoa)
and not exists (select * from fi_progpagamento g where g.seqtitulo = a.seqtitulo)
ORDER BY 3,2,11;

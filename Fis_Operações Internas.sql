ALTER SESSION SET current_schema = CONSINCO;

select x.nroempresa LOJA , TO_CHAR(:DT3,'DD/MM/YYYY') DATA_INICIO, TO_CHAR(:DT4,'DD/MM/YYYY') DATA_FIM, x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806,807)
and x.dtaoperacao between  :DT3 and :DT4
and x.nroempresa IN (#LS1)
group by  x.nroempresa, x.codgeraloper, y.descricao

union all

select x.nroempresa LOJA , TO_CHAR(:DT1,'DD/MM/YYYY') DATA_INICIO, TO_CHAR(:DT2,'DD/MM/YYYY') DATA_FIM, x.codgeraloper CGO , y.descricao,   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.dtaoperacao   between  :DT1 and :DT2
and x.nroempresa IN (#LS1)
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
group by x.nroempresa  , x.codgeraloper  , y.descricao

union all

select null , null , null,  NULL, NULL,null  from dual 
union all

select null , null , null,  null, NULL,NULL  from dual 
union all

select null , null , NULL,NULL,'Notas Emitidas',  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806,807)
and x.dtaoperacao between  :DT3 and :DT4
and x.nroempresa IN (#LS1)

union all

select null , null , NULL,NULL,'Operações Internas',   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.dtaoperacao   between  :DT1 and :DT2
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
and x.nroempresa IN (#LS1)

order by 1,4

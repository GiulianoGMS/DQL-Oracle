SELECT LOJA, TO_CHAR(DATA_INICIO 'DD-MM-YYYY') DATA_INICIO, TO_CHAR(DATA_FIM, 'DD-MM-YYYY') DATA_FIM,
       CGO, DESCRICAO, TO_CHAR(VALOR,'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR FROM(

Select x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806,807)
AND TO_CHAR(X.DTAOPERACAO, 'YYYY') = #LS3
and TO_CHAR(x.dtaoperacao,'MM') = REGEXP_SUBSTR(#LS2, '(\S*)(\S)') +1
and x.nroempresa IN (10)
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')

union all

select x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO,LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where 
    TO_CHAR(X.DTAOPERACAO, 'YYYY') = #LS3
and TO_CHAR(x.dtaoperacao,'MM') = REGEXP_SUBSTR(#LS2, '(\S*)(\S)')
and x.nroempresa IN (10) 
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
group by x.nroempresa  , x.codgeraloper  , y.descricao, TRUNC(X.DTAOPERACAO,'MM')

union all

select null , null , null,null,  NULL,null  from dual
union all

select null , null , null, null,   NULL,NULL  from dual
union all

select null , null ,null, NULL,'Notas Emitidas',  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806,807)
AND TO_CHAR(X.DTAOPERACAO, 'YYYY') = #LS3
and TO_CHAR(x.dtaoperacao,'MM') = REGEXP_SUBSTR(#LS2, '(\S*)(\S)') +1
and x.nroempresa IN (10)

union all

select null , null , null, NULL,'Operações Internas',   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where 
    TO_CHAR(X.DTAOPERACAO, 'YYYY') = #LS3
and TO_CHAR(x.dtaoperacao,'MM') = REGEXP_SUBSTR(#LS2, '(\S*)(\S)')
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
and x.nroempresa IN (10)

UNION ALL

SELECT NULL, NULL, null, NULL, 'Diferença', ((select round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806,807)
AND TO_CHAR(X.DTAOPERACAO, 'YYYY') = #LS3
and TO_CHAR(x.dtaoperacao,'MM') = REGEXP_SUBSTR(#LS2, '(\S*)(\S)')+1
and x.nroempresa IN (10)) -

(select round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where 
    TO_CHAR(X.DTAOPERACAO, 'YYYY') = #LS3
and TO_CHAR(x.dtaoperacao,'MM') = REGEXP_SUBSTR(#LS2, '(\S*)(\S)')
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
and x.nroempresa IN (10))) VALOR FROM DUAL
)
order by 1,3;

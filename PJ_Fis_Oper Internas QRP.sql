ALTER SESSION SET current_schema = CONSINCO;

SELECT LOJA, CASE WHEN LOJA IS NULL THEN NULL ELSE TO_CHAR(DATA_INICIO, 'DD/MM/YY')||' até '||TO_CHAR(DATA_FIM, 'DD/MM/YY') END Período,
       CGO, DESCRICAO, TO_CHAR(VALOR,'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR,
      (Select round(sum (x.vlroperacao),2) VALOR
        from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.codgeraloper in (806)
        and x.nroempresa IN (10)
        AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
        group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')) CONSUMO_SP,
      (Select round(sum (x.vlroperacao),2) VALOR
        from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.codgeraloper in (807)
        and x.nroempresa IN (10)
        AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
        group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')) PERDA_DET_SP,
      (select round(sum (x.vlroperacao),2) VALOR
        from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.codgeraloper in (806,807)
        and x.nroempresa IN (10)
        AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30') NOTAS_EMITIDAS,
      (select round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
        from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.nroempresa IN (10)
        AND TO_CHAR(X.DTAOPERACAO, 'YYYY') = 2022
        AND DTAOPERACAO BETWEEN DATE '2022-06-01' AND DATE '2022-06-30') OPERACOES_INTERNAS,
      (SELECT ((select round(sum (x.vlroperacao),2) VALOR
        from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.codgeraloper in (806,807)
        and x.nroempresa IN (10)
        AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
        ) -
        (select round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
        from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.nroempresa IN (10)
        AND DTAOPERACAO BETWEEN DATE '2022-06-01' AND DATE '2022-06-30'
        AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
        )) VALOR FROM DUAL) DIFERENÇA, O1, O2
       
FROM(

select '-' O1, '-' O2, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO,LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where X.nroempresa IN (10) 
AND DTAOPERACAO BETWEEN DATE '2022-06-01' AND DATE '2022-06-30'
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
group by x.nroempresa  , x.codgeraloper  , y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

SELECT NULL, '1' O2, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

UNION ALL

SELECT NULL, '3' O2, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

union all

Select NULL, '2' O2, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806)
and x.nroempresa IN (10)
AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

Select NULL, '4' O2, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (807)
and x.nroempresa IN (10)
AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')
)

order by 11,12;


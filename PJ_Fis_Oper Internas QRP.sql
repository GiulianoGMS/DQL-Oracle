ALTER SESSION SET current_schema = CONSINCO;

CREATE OR REPLACE VIEW NAGV_OPERACOESINTERNASQRP AS

SELECT CASE WHEN LOJA IS NULL THEN 'LOJA' ELSE TO_CHAR(LOJA) END LOJA, 
       CASE WHEN DATA_INICIO IS NULL AND LOJA IS NULL THEN 'PERIODO' ELSE
         CASE WHEN DATA_INICIO IS NOT NULL THEN TO_CHAR(DATA_INICIO, 'DD/MM/YY')||' até '||TO_CHAR(DATA_FIM, 'DD/MM/YY') 
            WHEN DATA_INICIO IS NULL AND LOJA IS NOT NULL THEN 'Emissão: '||TO_CHAR(DATA_FIM, 'DD/MM/YYYY') ELSE NULL END END Periodo,
       CASE WHEN CGO IS NULL THEN 'CGO' ELSE TO_CHAR(CGO) END CGO, 
       CASE WHEN DESCRICAO IS NULL THEN 'DESCRICAO' ELSE DESCRICAO END DESCRICAO, 
       CASE WHEN VALOR IS NULL THEN 'VALOR' ELSE TO_CHAR(VALOR,'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') END VALOR,
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
        )) VALOR FROM DUAL) DIFERENCA, O1, O2, O3, O4
       
FROM(

select X.CODGERALOPER O1, '-' O2, '1' O3, NULL O4, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO,LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where X.nroempresa IN (10) 
AND DTAOPERACAO BETWEEN DATE '2022-06-01' AND DATE '2022-06-30'
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
group by x.nroempresa  , x.codgeraloper  , y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

Select NULL, 'B' O2, '2' O3, NULL O4, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806)
and x.nroempresa IN (10)
AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

Select NULL, 'D' O2,'4' O3, NULL O4, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (807)
and x.nroempresa IN (10)
AND DTAOPERACAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

SELECT DISTINCT NULL, 'B'||F.NUMERODF O2,'3' O3, NULL O4, F.NROEMPRESA, NULL, F.DTAEMISSAO, F.CODGERALOPER, 'NRO NF: '||F.numerodf, F.vlrcontabil
FROM MFLV_BASENF F WHERE F.NROEMPRESA = 10 AND F.CODGERALOPER = 806
AND DTAEMISSAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30'

UNION ALL

SELECT DISTINCT NULL, 'D'||F.NUMERODF O2, '5' O3, NULL O4, F.NROEMPRESA, NULL, F.DTAEMISSAO, F.CODGERALOPER, 'NRO NF: '||F.numerodf, F.vlrcontabil 
FROM MFLV_BASENF F WHERE F.NROEMPRESA = 10 AND F.CODGERALOPER = 807
AND DTAEMISSAO BETWEEN DATE '2022-07-01' AND DATE '2022-07-30' 


UNION ALL

SELECT NULL, 'A' O2, NULL, '1' O4, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

UNION ALL

SELECT NULL, 'C' O2, NULL, '2' O4, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

)

order by 11,12;

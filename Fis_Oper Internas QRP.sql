SELECT LOJA, PERIODO, CGO, DESCRICAO, VALOR, O4, CASE WHEN O4 IS NOT NULL THEN NULL ELSE ROWNUM END O5, 
       TO_CHAR(NOTAS_EMITIDAS, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') NOTAS_EMITIDAS, 
       TO_CHAR(OPERACOES_INTERNAS, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') OP_INT, 
       TO_CHAR(OPERACOES_INTERNAS - NOTAS_EMITIDAS, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') DIFERENCA, DT1

FROM (

SELECT CASE WHEN LOJA IS NULL THEN 'LOJA' ELSE TO_CHAR(LOJA) END LOJA, 
       CASE WHEN DATA_INICIO IS NULL AND LOJA IS NULL THEN 'PERIODO' ELSE
         CASE WHEN DATA_INICIO IS NOT NULL THEN TO_CHAR(DATA_INICIO, 'DD/MM/YY')||' até '||TO_CHAR(DATA_FIM, 'DD/MM/YY') 
            WHEN DATA_INICIO IS NULL AND LOJA IS NOT NULL THEN 'Emissão: '||TO_CHAR(DATA_FIM, 'DD/MM/YYYY') ELSE NULL END END Periodo,
       CASE WHEN CGO IS NULL THEN 'CGO' ELSE TO_CHAR(CGO) END CGO, 
       CASE WHEN DESCRICAO IS NULL THEN 'DESCRICAO' ELSE DESCRICAO END DESCRICAO, 
       CASE WHEN VALOR IS NULL THEN 'VALOR' ELSE TO_CHAR(VALOR,'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') END VALOR,
       CASE WHEN DATA_INICIO IS NOT NULL AND CGO < 800 THEN TO_CHAR(DATA_INICIO, 'DD/MM/YY')||' até '||TO_CHAR(DATA_FIM, 'DD/MM/YY') END DT1, NULL,
        (select round(sum (x.vlroperacao),2) VALOR
        from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.codgeraloper in (806,807)
        and x.nroempresa IN (#LS1)
        AND EXTRACT (MONTH FROM DTAOPERACAO) = :NR1 +1 
        AND EXTRACT (YEAR FROM DTAOPERACAO) = :NR2) NOTAS_EMITIDAS,
      (select round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
        from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
        where x.nroempresa IN (#LS1)
        AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
        AND EXTRACT (MONTH FROM DTAOPERACAO) = :NR1
        AND EXTRACT (YEAR FROM DTAOPERACAO) = :NR2) OPERACOES_INTERNAS,
        NULL, O1, O2, O3, O4
       
FROM(

select X.CODGERALOPER O1, '-' O2, '1' O3, NULL O4, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO,LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,   round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where X.nroempresa IN (#LS1) 
AND EXTRACT (MONTH FROM DTAOPERACAO) = :NR1 
        AND EXTRACT (YEAR FROM DTAOPERACAO) = :NR2
AND Y.CODGERALOPER NOT IN (49,269,270,271,272,273,274)
group by x.nroempresa  , x.codgeraloper  , y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

Select NULL, 'B' O2, '2' O3, NULL O4, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (806)
and x.nroempresa IN (#LS1)
AND EXTRACT (MONTH FROM DTAOPERACAO) = :NR1 +1 
AND EXTRACT (YEAR FROM DTAOPERACAO) = :NR2
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

Select NULL, 'D' O2,'4' O3, NULL O4, x.nroempresa LOJA , TRUNC(X.DTAOPERACAO,'MM') DATA_INICIO, LAST_DAY(TRUNC(X.DTAOPERACAO,'MM')) DATA_FIM,
x.codgeraloper CGO , y.descricao,  round(sum (x.vlroperacao),2) VALOR
from fatog_vendadia x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
where x.codgeraloper in (807)
and x.nroempresa IN (#LS1)
AND EXTRACT (MONTH FROM DTAOPERACAO) = :NR1 +1 
AND EXTRACT (YEAR FROM DTAOPERACAO) = :NR2
group by  x.nroempresa, x.codgeraloper, y.descricao, TRUNC(X.DTAOPERACAO,'MM')

UNION ALL

SELECT DISTINCT NULL, 'B'||F.NUMERODF O2,'3' O3, NULL O4, F.NROEMPRESA, NULL, F.DTAEMISSAO, F.CODGERALOPER, 'NRO NF: '||F.numerodf, F.vlrcontabil
FROM MFLV_BASENF F WHERE F.NROEMPRESA IN (#LS1) AND F.CODGERALOPER = 806 AND F.STATUSDF != 'C'
AND EXTRACT (MONTH FROM DTAEMISSAO) = :NR1 +1 
AND EXTRACT (YEAR FROM DTAEMISSAO) = :NR2

UNION ALL

SELECT DISTINCT NULL, 'D'||F.NUMERODF O2, '5' O3, NULL O4, F.NROEMPRESA, NULL, F.DTAEMISSAO, F.CODGERALOPER, 'NRO NF: '||F.numerodf, F.vlrcontabil 
FROM MFLV_BASENF F WHERE F.NROEMPRESA IN (#LS1) AND F.CODGERALOPER = 807 AND F.STATUSDF != 'C'
AND EXTRACT (MONTH FROM DTAEMISSAO) = :NR1 +1 
AND EXTRACT (YEAR FROM DTAEMISSAO) = :NR2


UNION ALL

SELECT NULL, 'A' O2, NULL, '1' O4, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

UNION ALL

SELECT NULL, 'C' O2, NULL, '2' O4, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL

)

order by 11,12);

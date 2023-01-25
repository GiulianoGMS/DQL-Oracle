
SELECT EMPRESA, PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO,
       TO_CHAR(SUM(TOTAL_BRUTO_VENDAS), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')        TOTAL_BRUTO_VENDAS,
       TO_CHAR(SUM(TOTAL_PRESTACOES_SERVICOS), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') TOTAL_PRESTACOES_SERVICOS,
       TO_CHAR(:DT1, 'DD/MM/YYYY') Data_Inicial, TO_CHAR(:DT2, 'DD/MM/YYYY') Data_Final,
       SUBTOTAL_VENDAS,
       SUBTOTAL_SERVICOS, TOTAL
  FROM (
SELECT EMPRESA, CASE WHEN PARTICIPANTE IN (SELECT LPAD(NROCGCCPF,12,0)||LPAD(DIGCGCCPF,2,0) FROM GE_PESSOA WHERE SEQPESSOA < 999) THEN '60746948150270' ELSE PARTICIPANTE END PARTICIPANTE, 
       CASE WHEN PARTICIPANTE IN (SELECT LPAD(NROCGCCPF,12,0)||LPAD(DIGCGCCPF,2,0) FROM GE_PESSOA WHERE SEQPESSOA < 999) THEN 'BRADESCO S.A' ELSE NOME_PART_PAGTO END NOME_PART_PAGTO, 
       PARTICIP_TRANS, NOME_PART_TRANSACAO,
       TOTAL_BRUTO_VENDAS, 
       TOTAL_PRESTACOES_SERVICOS, 
       
      (SELECT TO_CHAR(SUM(TOTAL_BRUTO_VENDAS), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')
             FROM (
             
        SELECT CASE WHEN A.NROEMPRESA >= 500 THEN 0 ELSE SUM(A.VLRORIGINAL) END TOTAL_BRUTO_VENDAS,
               CASE WHEN A.CODESPECIE IN ('SERVRC') THEN SUM(NVL(A.VLRORIGINAL,0)) ELSE 0 END TOTAL_PREST_SERV

        FROM CONSINCO.FI_TITULO A
        INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
        INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
        LEFT  JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
             CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
                  WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
                  ELSE NULL END)
        WHERE a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC')
          and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1458426)
          and a.dtaemissao BETWEEN :DT1 AND :DT2
          AND A.NROEMPRESA = :NR1 
          GROUP BY A.NROEMPRESA, CODESPECIE
          
 UNION ALL 
    
        SELECT sum(x.vlroriginal), NULL

        from fi_titulo x inner join fi_especie k on (k.codespecie = x.codespecie and x.nroempresamae = k.nroempresamae )
                         inner join ge_empresa c on (c.nroempresa = x.nroempresa)
                         inner join ge_pessoa b on (x.seqpessoa = b.seqpessoa)
        where x.obrigdireito = 'D'
        and exists (select 1 from fi_compltitulo y where x.seqtitulo = y.seqtitulo and  y.codbarra is not null)
        and x.seqpessoa <> c.seqpessoa
        and x.codespecie not in ('SERVRC') 
        and x.apporigem = 'F' 
        and nvl(k.espdevolucao,'N') = 'N' 
        AND X.NROEMPRESA = :NR1
        AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2

 UNION ALL

        SELECT sum(t.vlrlancamento), NULL
               
        from FI_CTACORLANCA t inner join fi_ctacorrente x on (t.seqctacorrente = x.seqctacorrente)
                              inner join ge_empresa z on (z.nroempresa = t.nroempresa)
                              LEFT JOIN GE_PESSOA C ON x.Seqpessoanota = C.SEQPESSOA
        where 1=1
        and x.tipoconta = 'B' 
        and t.codoperacao in (452, 948) 
        and t.origemdoc = 'TSN' 
        and t.opcancelada is null
        AND T.NROEMPRESA = :NR1
        AND T.DTALANCTO BETWEEN :DT1 AND :DT2)) SUBTOTAL_VENDAS,
        
       (SELECT TO_CHAR(SUM(TOTAL_PREST_SERV),   'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') FROM (

        SELECT CASE WHEN A.CODESPECIE IN ('SERVRC') THEN SUM(NVL(A.VLRORIGINAL,0)) ELSE 0 END TOTAL_PREST_SERV

        FROM CONSINCO.FI_TITULO A
        INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
        INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
        LEFT  JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
             CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
                  WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
                  ELSE NULL END)
        where a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC')
          and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1458426)
          and a.dtaemissao BETWEEN :DT1 AND :DT2
          AND A.NROEMPRESA = :NR1 
          GROUP BY  CODESPECIE
 )) SUBTOTAL_SERVICOS,
    (SELECT TO_CHAR(SUM(TOTAL), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') TOTAL

FROM (

        SELECT CASE WHEN A.NROEMPRESA >= 500 THEN 0 ELSE SUM(A.VLRORIGINAL) END + CASE WHEN A.CODESPECIE IN ('SERVRC') THEN SUM(NVL(A.VLRORIGINAL,0)) ELSE 0 END TOTAL

        FROM CONSINCO.FI_TITULO A
          INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
          INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
          LEFT  JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
               CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
                    WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
                    ELSE NULL END)
          where a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC')
            and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1458426)
            and a.dtaemissao BETWEEN :DT1 AND :DT2
            AND A.NROEMPRESA = :NR1 GROUP BY A.NROEMPRESA, A.CODESPECIE
    
 UNION ALL
    
          SELECT sum(x.vlroriginal)

          from fi_titulo x inner join fi_especie k on (k.codespecie = x.codespecie and x.nroempresamae = k.nroempresamae )
                                      inner join ge_empresa c on (c.nroempresa = x.nroempresa)
                                      inner join ge_pessoa b on (x.seqpessoa = b.seqpessoa)
          where x.obrigdireito = 'D'
          and exists (select 1 from fi_compltitulo y where x.seqtitulo = y.seqtitulo and  y.codbarra is not null)
          and x.seqpessoa <> c.seqpessoa
          and x.codespecie not in ('SERVRC') 
          and x.apporigem = 'F' 
          and nvl(k.espdevolucao,'N') = 'N' 
          AND X.NROEMPRESA = :NR1
          AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2

 UNION ALL 

          SELECT sum(t.vlrlancamento)
                 
          from FI_CTACORLANCA t inner join fi_ctacorrente x on (t.seqctacorrente = x.seqctacorrente)
                                                      inner join ge_empresa z on (z.nroempresa = t.nroempresa)
                                                      LEFT JOIN GE_PESSOA C ON x.Seqpessoanota = C.SEQPESSOA
          where 1=1
          and x.tipoconta = 'B' 
          and t.codoperacao in (452, 948) 
          and t.origemdoc = 'TSN' 
          and t.opcancelada is null
          AND T.NROEMPRESA = :NR1
          AND T.DTALANCTO BETWEEN :DT1 AND :DT2)) TOTAL
FROM (
SELECT Y.* FROM (
SELECT * FROM (

SELECT NROEMPRESA EMPRESA , PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO, 
       SUM(TOTAL_BRUTO_VENDAS) TOTAL_BRUTO_VENDAS, 
       SUM(TOTAL_PRESTACOES_SERVICOS) TOTAL_PRESTACOES_SERVICOS 
       
       FROM ( 

SELECT A.NROEMPRESA, LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) PARTICIPANTE,
       SUBSTR(B.NOMERAZAO,1,32) NOME_PART_PAGTO,
       CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
              ELSE NULL END PARTICIP_TRANS,
       SUBSTR(D.NOMERAZAO,1,32) NOME_PART_TRANSACAO,
       CASE WHEN A.NROEMPRESA >= 500 THEN 0 ELSE SUM(A.VLRORIGINAL) END TOTAL_BRUTO_VENDAS,
       CASE WHEN A.CODESPECIE IN ('SERVRC') THEN SUM(NVL(A.VLRORIGINAL,0)) ELSE 0 END TOTAL_PRESTACOES_SERVICOS

  FROM CONSINCO.FI_TITULO A
  INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
  INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
  LEFT  JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
       CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
            ELSE NULL END)

  where a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC')
    and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1458426)
    and a.dtaemissao BETWEEN :DT1 AND :DT2
    and A.NROEMPRESA = :NR1
    GROUP BY LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0), B.NOMERAZAO, A.CODESPECIE, D.NOMERAZAO, A.NROEMPRESA
)
GROUP BY NROEMPRESA, PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO

) ORDER BY 2) Y

UNION ALL

select X.NROEMPRESA, 
       lpad(b.nrocgccpf,12,0)||lpad(b.digcgccpf,2,0), 
       SUBSTR(B.NOMERAZAO,1,32),
       NULL, NULL,
       sum(x.vlroriginal) TOT_VS,
       0   TOT_ISS

from fi_titulo x inner join fi_especie k on (k.codespecie = x.codespecie and x.nroempresamae = k.nroempresamae )
                            inner join ge_empresa c on (c.nroempresa = x.nroempresa)
                            inner join ge_pessoa b on (x.seqpessoa = b.seqpessoa)
where x.obrigdireito = 'D'
and exists (select 1 from fi_compltitulo y where x.seqtitulo = y.seqtitulo and  y.codbarra is not null)
and x.seqpessoa <> c.seqpessoa
and x.codespecie not in ('SERVRC') 
and x.apporigem = 'F' 
and nvl(k.espdevolucao,'N') = 'N' 
AND X.NROEMPRESA = :NR1
AND X.DTAEMISSAO BETWEEN :DT1 AND :DT2
  group by  NOMERAZAO,lpad(c.nrocgc,12,0)||lpad(c.digcgc,2,0) ,  to_char(x.dtaemissao, 'YYYY'), to_char(x.dtaemissao, 'MM'), lpad(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0), x.codespecie,x.NROEMPRESA,to_char(x.dtaemissao, 'MM-YYYY')

UNION ALL
SELECT T.NROEMPRESA, lpad(z.nrocgc,12,0)||lpad(z.digcgc,2,0), 
       SUBSTR(C.NOMERAZAO,1,32), NULL, NULL,
       sum(t.vlrlancamento),
       0 

from FI_CTACORLANCA t inner join fi_ctacorrente x on (t.seqctacorrente = x.seqctacorrente)
                                            inner join ge_empresa z on (z.nroempresa = t.nroempresa)
                                            LEFT JOIN GE_PESSOA C ON T.NROEMPRESA = C.SEQPESSOA
where 1=1
and x.tipoconta = 'B' 
and t.codoperacao in (452, 948) 
and t.origemdoc = 'TSN' 
and t.opcancelada is null
AND T.NROEMPRESA = :NR1
AND T.DTALANCTO BETWEEN :DT1 AND :DT2
  group by NOMERAZAO,lpad(z.nrocgc,12,0)||lpad(z.digcgc,2,0) ,  
  to_char(t.dtalancto, 'YYYY'), to_char(t.dtalancto, 'MM'),  t.NROEMPRESA,to_char(t.dtalancto, 'MM-YYYY') 

) X ) ZZ

GROUP BY EMPRESA, PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO,
       SUBTOTAL_VENDAS,
       SUBTOTAL_SERVICOS, TOTAL
       
       ORDER BY 3 ASC

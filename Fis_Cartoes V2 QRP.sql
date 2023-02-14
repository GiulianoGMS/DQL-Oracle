SELECT EMPRESA, PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO,
       TO_CHAR(SUM(TOTAL_BRUTO_VENDAS), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''')        TOTAL_BRUTO_VENDAS,
       TO_CHAR(SUM(TOTAL_PRESTACOES_SERVICOS), 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') TOTAL_PRESTACOES_SERVICOS,
       TO_CHAR(:DT1, 'DD/MM/YYYY') Data_Inicial, TO_CHAR(:DT2, 'DD/MM/YYYY') Data_Final,
       TO_CHAR(SUBTOTAL_VENDAS, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') SUBTOTAL_VENDAS,
       TO_CHAR(SUBTOTAL_SERVICOS, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') SUBTOTAL_SERVICOS, 
       TO_CHAR(SUBTOTAL_VENDAS + SUBTOTAL_SERVICOS, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') TOTAL
  FROM (
SELECT EMPRESA, CASE WHEN PARTICIPANTE IN (SELECT LPAD(NROCGCCPF,12,0)||LPAD(DIGCGCCPF,2,0) FROM GE_PESSOA WHERE SEQPESSOA < 999) THEN '60746948150270' ELSE PARTICIPANTE END PARTICIPANTE, 
       CASE WHEN PARTICIPANTE IN (SELECT LPAD(NROCGCCPF,12,0)||LPAD(DIGCGCCPF,2,0) FROM GE_PESSOA WHERE SEQPESSOA < 999) THEN 'BRADESCO S.A' ELSE NOME_PART_PAGTO END NOME_PART_PAGTO, 
       PARTICIP_TRANS, NOME_PART_TRANSACAO,
       TOTAL_BRUTO_VENDAS, 
       TOTAL_PRESTACOES_SERVICOS, 
       
      (SELECT SUM(TOTAL_BRUTO_VENDAS)
             FROM ( 
             
        SELECT CASE WHEN A.NROEMPRESA >= 500 THEN 0 ELSE SUM(A.VLRORIGINAL) END TOTAL_BRUTO_VENDAS,
               NULL
          FROM CONSINCO.FI_TITULO A
  INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
  INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
  LEFT JOIN CONSINCO.NAGV_PARTICIPANTEPAGTO NP ON NP.SEQTITULO = A.SEQTITULO
  LEFT JOIN CONSINCO.GE_PESSOA GP ON GP.SEQPESSOA = NP.SEQPESSOA
  LEFT JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
       CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
            ELSE NULL END)

  where a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC','AMERIC')
    and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1457426)
    and a.dtaemissao bETWEEN :DT1 AND :DT2
    and A.NROEMPRESA = :NR1
    and a.seqpessoa not in (942508)
GROUP BY CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN LPAD(GP.NROCGCCPF,12,0)||LPAD(GP.DIGCGCCPF,2,0) ELSE LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) END,
         CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN GP.NOMERAZAO ELSE B.NOMERAZAO END,
         CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
              ELSE NULL END,   
                A.CODESPECIE, D.NOMERAZAO, A.NROEMPRESA
          
 UNION ALL 
    
        SELECT sum(x.vlroriginal), NULL

        from fi_titulo x inner join fi_especie k on (k.codespecie = x.codespecie and x.nroempresamae = k.nroempresamae )
                         inner join ge_empresa c on (c.nroempresa = x.nroempresa)
                         inner join ge_pessoa b on (x.seqpessoa = b.seqpessoa)
        where x.obrigdireito = 'D'
        and exists (select 1 from fi_compltitulo y where x.seqtitulo = y.seqtitulo and  y.codbarra is not null)
        and x.seqpessoa <> c.seqpessoa AND X.SEQPESSOA NOT IN (942508)
        and x.codespecie not in ('SERVRC') 
        and x.apporigem = 'F' 
        AND X.SITUACAO != 'C'
        and nvl(k.espdevolucao,'N') = 'N' 
        AND X.NROEMPRESA = :NR1
        AND X.DTAEMISSAO bETWEEN :DT1 AND :DT2

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
        AND T.DTALANCTO bETWEEN :DT1 AND :DT2)) SUBTOTAL_VENDAS,
        
       (SELECT SUM(TOTAL_PREST_SERV) FROM (

        SELECT CASE WHEN A.CODESPECIE IN ('SERVRC') THEN SUM(NVL(A.VLRORIGINAL,0)) ELSE 0 END TOTAL_PREST_SERV,
       CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN LPAD(GP.NROCGCCPF,12,0)||LPAD(GP.DIGCGCCPF,2,0) ELSE LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) END PARTICIPANTE

        FROM CONSINCO.FI_TITULO A
  INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
  INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
  LEFT JOIN CONSINCO.NAGV_PARTICIPANTEPAGTO NP ON NP.SEQTITULO = A.SEQTITULO
  LEFT JOIN CONSINCO.GE_PESSOA GP ON GP.SEQPESSOA = NP.SEQPESSOA
  LEFT JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
       CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
            ELSE NULL END)

  where a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC','AMERIC')
    and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1457426)
    and a.dtaemissao bETWEEN :DT1 AND :DT2
    and A.NROEMPRESA = :NR1
    and a.seqpessoa not in (942508)
GROUP BY CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN LPAD(GP.NROCGCCPF,12,0)||LPAD(GP.DIGCGCCPF,2,0) ELSE LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) END,
         CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN GP.NOMERAZAO ELSE B.NOMERAZAO END,
         CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
              ELSE NULL END,   
                A.CODESPECIE,        
         CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN LPAD(GP.NROCGCCPF,12,0)||LPAD(GP.DIGCGCCPF,2,0) ELSE LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) END

                
          UNION ALL
          select sum(nvl(a.vlroriginal,0)) TOT_ISS, '0' X
      from consinco.fi_titulo a inner join consinco.ge_pessoa b on (a.seqpessoa = b.seqpessoa)
                                                 inner join consinco.ge_empresa c on (a.nroempresa = c.nroempresa)

   where 1=1
   and a.situacao != 'C'
   AND A.NROEMPRESA = :NR1
   AND A.DTAEMISSAO bETWEEN :DT1 AND :DT2
   AND A.SEQTITULO IN (
 SELECT K.SEQTITULO FROM CONSINCO.FI_TITOPERACAO K where K.CODOPERACAO IN (18) AND K.NROPROCESSO IN ( SELECT X.NROPROCESSO
FROM CONSINCO.FI_TITOPERACAO X WHERE X.CODESPECIEANT = 'SERVRC' AND X.OPCANCELADA IS NULL AND X.CODOPERACAO = 20 AND X.NROEMPRCTAPARTIDA NOT IN (501)))

 ) WHERE PARTICIPANTE IS NOT NULL) SUBTOTAL_SERVICOS
    
FROM (
SELECT Y.* FROM (
SELECT * FROM (

SELECT NROEMPRESA EMPRESA , PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO, 
       SUM(TOTAL_BRUTO_VENDAS) TOTAL_BRUTO_VENDAS, 
       SUM(TOTAL_PRESTACOES_SERVICOS) TOTAL_PRESTACOES_SERVICOS 
       
       FROM (

SELECT A.NROEMPRESA, 
       CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN LPAD(GP.NROCGCCPF,12,0)||LPAD(GP.DIGCGCCPF,2,0) ELSE LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) END PARTICIPANTE,
       SUBSTR((CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN GP.NOMERAZAO ELSE B.NOMERAZAO END),1,32) NOME_PART_PAGTO,
       CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
              ELSE NULL END PARTICIP_TRANS,
       SUBSTR(D.NOMERAZAO,1,32) NOME_PART_TRANSACAO,
       CASE WHEN A.NROEMPRESA >= 500 THEN 0 ELSE SUM(A.VLRORIGINAL) END TOTAL_BRUTO_VENDAS,
       CASE WHEN A.CODESPECIE IN ('SERVRC') THEN SUM(NVL(A.VLRORIGINAL,0)) ELSE 0 END 
       TOTAL_PRESTACOES_SERVICOS

  FROM CONSINCO.FI_TITULO A
  INNER JOIN consinco.ge_pessoa b  on (a.seqpessoa = b.seqpessoa)
  INNER JOIN consinco.ge_empresa c on (a.nroempresa = c.nroempresa)
  LEFT JOIN CONSINCO.NAGV_PARTICIPANTEPAGTO NP ON NP.SEQTITULO = A.SEQTITULO
  LEFT JOIN CONSINCO.GE_PESSOA GP ON GP.SEQPESSOA = NP.SEQPESSOA
  LEFT JOIN CONSINCO.GE_PESSOA D ON LPAD(D.NROCGCCPF,12,0)||LPAD(D.DIGCGCCPF,2,0) = (
       CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
            ELSE NULL END)

  where a.codespecie in ('CARDEB', 'CARTAO', 'TICKET', 'CCECOM', 'CDECOM', 'TKECOM','IFOOD','IFOPDV','SERVRC','AMERIC')
    and a.situacao != 'C'     and B.SEQPESSOA NOT IN (1457426)
    and a.dtaemissao bETWEEN :DT1 AND :DT2
    and A.NROEMPRESA = :NR1
    and a.seqpessoa not in (942508)
GROUP BY CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN LPAD(GP.NROCGCCPF,12,0)||LPAD(GP.DIGCGCCPF,2,0) ELSE LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) END,
         CASE WHEN A.CODESPECIE = 'SERVRC' AND A.NROEMPRESA >= 500 THEN GP.NOMERAZAO ELSE B.NOMERAZAO END,
         CASE WHEN A.CODESPECIE IN ('IFOOD','IFOPDV') THEN LPAD(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0)
            WHEN A.CODESPECIE IN ('CCECOM','CDECOM','TKECOM') THEN '14071169000147'
              ELSE NULL END,   
                A.CODESPECIE, D.NOMERAZAO, A.NROEMPRESA
   UNION ALL
   select A.NROEMPRESA,

         lpad(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0) Cod_PART_IP,
          B.NOMERAZAO, NULL, NULL,
          0 ,
          sum(nvl(a.vlroriginal,0)) TOT_ISS

      from consinco.fi_titulo a inner join consinco.ge_pessoa b on (a.seqpessoa = b.seqpessoa)
                                                 inner join consinco.ge_empresa c on (a.nroempresa = c.nroempresa)

   where 1=1
   and a.situacao != 'C'
   AND A.DTAEMISSAO bETWEEN :DT1 AND :DT2
   AND A.NROEMPRESA = :NR1
   AND A.SEQTITULO IN (
 SELECT K.SEQTITULO FROM CONSINCO.FI_TITOPERACAO K where K.CODOPERACAO IN (18) AND K.NROPROCESSO IN ( SELECT X.NROPROCESSO
FROM CONSINCO.FI_TITOPERACAO X WHERE X.CODESPECIEANT = 'SERVRC' AND X.OPCANCELADA IS NULL AND X.CODOPERACAO = 20 AND X.NROEMPRCTAPARTIDA NOT IN (501)))
   group by  lpad(c.nrocgc,12,0)||lpad(c.digcgc,2,0) ,  to_char(a.dtaemissao, 'YYYY'), to_char(a.dtaemissao, 'MM'), lpad(B.NROCGCCPF,12,0)||lpad(B.DIGCGCCPF,2,0), B.NOMERAZAO, a.codespecie,A.NROEMPRESA,to_char(a.dtaemissao, 'MM-YYYY')
) WHERE PARTICIPANTE IS NOT NULL
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
                            inner join ge_pessoa b on (x.NROEMPRESA = b.seqpessoa)
where x.obrigdireito = 'D'
and exists (select 1 from fi_compltitulo y where x.seqtitulo = y.seqtitulo and  y.codbarra is not null)
and x.seqpessoa <> c.seqpessoa
and x.codespecie not in ('SERVRC') 
and x.apporigem = 'F' 
and nvl(k.espdevolucao,'N') = 'N' 
AND X.NROEMPRESA = :NR1
AND X.SITUACAO != 'C'
AND X.DTAEMISSAO bETWEEN :DT1 AND :DT2
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
AND T.DTALANCTO bETWEEN :DT1 AND :DT2
  group by NOMERAZAO,lpad(z.nrocgc,12,0)||lpad(z.digcgc,2,0) ,  
  to_char(t.dtalancto, 'YYYY'), to_char(t.dtalancto, 'MM'),  t.NROEMPRESA,to_char(t.dtalancto, 'MM-YYYY') 

) X ) ZZ

GROUP BY EMPRESA, PARTICIPANTE, NOME_PART_PAGTO, PARTICIP_TRANS, NOME_PART_TRANSACAO,
       SUBTOTAL_VENDAS,
       SUBTOTAL_SERVICOS

ORDER BY 3 ASC

SELECT *
  FROM (
        
        SELECT A.NROEMPRESA,
                A.USUAGENDA,
                TO_CHAR(A.DTAHORAGENDA, 'DD/MM/YYYY HH24:MI') DTAHORAGENDA,
                A.NROBOX,
                A.CODTIPCARGA,
                TO_CHAR(A.DTAAGENDA, 'DD/MM/YYYY') DTAAGENDA,
                A.HORARIO,
                A.HORCHEGADA,
                A.HORENTRADA,
                A.HORSAIDA,
                A.NROCARGA,
                A.TRANSPORTADORA,
                A.SENHAREGISTRO,
                A.STATUSAGENDA,
                A.SEQPORTARIA
          FROM MLO_BOXHORAGENDA A, GE_EMPRESA E
         WHERE A.NROEMPRESA = E.NROEMPRESA
               AND TRUNC(A.DTAAGENDA) = :DT1
               AND E.NROEMPRESA || ' - ' || E.FANTASIA IN (:LS1)
         ORDER BY A.DTAHORAGENDA, A.NROBOX, A.NROCARGA ASC
        
        )

UNION ALL
SELECT NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL
  FROM DUAL
UNION ALL

SELECT NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       'Total de Agendas:',
       COUNT(A.SENHAREGISTRO),
       NULL,
       NULL
  FROM MLO_BOXHORAGENDA A, GE_EMPRESA E
 WHERE A.NROEMPRESA = E.NROEMPRESA
       AND TRUNC(A.DTAAGENDA) = :DT1
       AND E.NROEMPRESA || ' - ' || E.FANTASIA IN (:LS1)

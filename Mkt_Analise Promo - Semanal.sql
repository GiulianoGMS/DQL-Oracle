SELECT NROEMPRESA, 'Mes: '||:NR1||' - Ano: 2024' Periodo,

                   NAGF_BUSCAQTDITENSPROMOC_SM(:NR1,2024,EMP.NROEMPRESA,1) PRIM_SEMANA,
                   NAGF_BUSCAQTDITENSPROMOC_SM(:NR1,2024,EMP.NROEMPRESA,2) SEG_SEMANA,
                   NAGF_BUSCAQTDITENSPROMOC_SM(:NR1,2024,EMP.NROEMPRESA,3) TER_SEMANA,
                   NAGF_BUSCAQTDITENSPROMOC_SM(:NR1,2024,EMP.NROEMPRESA,4) QUAR_SEMANA
                   
  FROM MAX_EMPRESA EMP
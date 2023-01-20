SELECT A.NROEMPRESA EMPRESA, A.NRONOTA, 
       SUBSTR(B.NOMERAZAO, 0,35) NOMERAZAO, 
       LPAD(B.NROCGCCPF,12,0)||LPAD(B.DIGCGCCPF,2,0) CNPJ,
       TO_CHAR(A.DTAEMISSAO,'DD/MM/YYYY') EMISSAO, 
       TO_CHAR(A.DTAENTRADA,'DD/MM/YYYY') ENTRADA,  
       TO_CHAR(C.DTAVENCTO, 'DD/MM/YYYY') VENCIMENTO, 
       TO_CHAR(C.VALOR, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') VALOR

FROM CONSINCO.OR_NFDESPESA A INNER JOIN CONSINCO.GE_PESSOA       B ON A.SEQPESSOA = B.SEQPESSOA
                             INNER JOIN CONSINCO.OR_NFVENCIMENTO C ON A.SEQNOTA = C.SEQNOTA
                             
WHERE A.DTAENTRADA BETWEEN SYSDATE - 100 AND SYSDATE
  AND A.CODHISTORICO = 746
  AND A.NROEMPRESA   IN (1,2,3,4,6,7,8,9,10)

/*
union all

select null, null, null, null,
 null, null,  
         null, sum(c.valor),
          null, null ,null ,null ,null,null, null ,null ,null ,null,null, null ,null ,null ,null,null, null ,null ,null ,null,
          null,null, null ,null ,null ,null,null, null ,null ,null ,null,null, null ,null ,null ,null,
          null,
          null,
          null,
          null,
          null,
         null,
          null,
         null
from consinco.or_nfdespesa a inner join consinco.ge_pessoa b on (a.seqpessoa = b.seqpessoa)
                    inner join consinco.or_nfvencimento c on (a.seqnota = c.seqnota)
where a.dtaentrada between :DT1 and :DT2
and a.codhistorico = :NR1
and a.nroempresa in (#LS1)
order by 5, 2,1*/

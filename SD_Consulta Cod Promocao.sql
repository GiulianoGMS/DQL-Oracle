SELECT DISTINCT SEQPROMOCAO, /* DECODE(NROSEGMENTO, '2','Nagumo SP', '5', 'Ecommerce', '8', 'Ecomm-Mixter') SEGMENTO,*/ PROMOCAO,
       TO_CHAR(DTAINICIO, 'DD/MM/YYYY') DTAINICIO,
       TO_CHAR(DTAFIM,    'DD/MM/YYYY') DTAFIM
       
  FROM CONSINCO.MRL_PROMOCAO X
  
 WHERE 1=1
  AND PROMOCAO LIKE '%'||UPPER(:LT1)||'%'
  AND DTAINICIO = :DT1 
  AND DTAFIM = :DT2

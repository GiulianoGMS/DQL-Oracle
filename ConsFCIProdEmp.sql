ALTER SESSION SET current_schema = CONSINCO;

SELECT * FROM MAP_FAMDIVCATEG WHERE SEQFAMILIA = 90407

SELECT * FROM MRL_PRODUTOEMPRESA
WHERE SEQPRODUTO = 90407

select a.seqproduto , a.nroempresa , a.nrofci
from consinco.mrl_produtoempresa a 
where A.SEQPRODUTO = 90407 

--and a.vlrparcfci is not null

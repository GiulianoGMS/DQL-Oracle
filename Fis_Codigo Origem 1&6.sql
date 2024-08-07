
SELECT  A.SEQFAMILIA FAMILIA, MA.FAMILIA DESCRICAO, A.CODORIGEMTRIB
FROM CONSINCO.MAP_FAMDIVISAO A LEFT JOIN CONSINCO.MAP_TRIBUTACAO B ON A.NROTRIBUTACAO = B.NROTRIBUTACAO
                               LEFT JOIN CONSINCO.MAP_FAMILIA MA ON A.SEQFAMILIA = MA.SEQFAMILIA

WHERE  CODORIGEMTRIB IN (6)

UNION ALL

SELECT  A.SEQFAMILIA FAMILIA, MA.FAMILIA DESCRICAO, A.CODORIGEMTRIB
FROM CONSINCO.MAP_FAMDIVISAO A LEFT JOIN CONSINCO.MAP_TRIBUTACAO B ON A.NROTRIBUTACAO = B.NROTRIBUTACAO
                               LEFT JOIN CONSINCO.MAP_FAMILIA MA ON A.SEQFAMILIA = MA.SEQFAMILIA

WHERE  CODORIGEMTRIB IN (1)

ORDER BY 3 DESC, 1

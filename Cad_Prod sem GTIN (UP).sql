
UPDATE CONSINCO.MAP_PRODCODIGO X SET INDEANTRIBNFE = 'S' WHERE CODACESSO IN (SELECT CODACESSO FROM (

SELECT DISTINCT MP.SEQPRODUTO, DESCCOMPLETA, CODACESSO, MP.QTDEMBALAGEM, COUNT(CODACESSO), ROW_NUMBER() OVER(PARTITION BY MP.SEQPRODUTO ORDER BY MP.SEQPRODUTO) ODR
  FROM CONSINCO.MAP_PRODCODIGO MP INNER JOIN CONSINCO.MAP_PRODUTO MA ON MA.SEQPRODUTO = MP.SEQPRODUTO
 
 WHERE MP.TIPCODIGO = 'E' AND NVL(MP.INDEANTRIBNFE,'N') = 'N'
   AND MA.DESCCOMPLETA NOT LIKE '%MP%'
   AND MA.DESCCOMPLETA NOT LIKE '%INS%'
   AND MA.DESCCOMPLETA NOT LIKE '%USO%'
   AND MP.QTDEMBALAGEM = 1
   AND NOT EXISTS (SELECT 1 FROM CONSINCO.MAP_PRODCODIGO XX WHERE XX.SEQPRODUTO = MP.SEQPRODUTO AND TIPCODIGO = 'E' AND INDEANTRIBNFE = 'S')
   
   GROUP BY  MP.SEQPRODUTO, DESCCOMPLETA, CODACESSO, MP.QTDEMBALAGEM
   ORDER BY 2 ) 
   
   WHERE ODR = 1);
   
   COMMIT;

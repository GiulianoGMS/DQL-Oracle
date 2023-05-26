SELECT * 
  FROM CONSINCO.MAP_PRODCODIGO X 
 WHERE X.TIPCODIGO = 'F' -- Cod tipo Fornecedor
   AND X.CODACESSO IN ('257200','20776','4046777306538') -- Códigos de referencia do fornecedor
   AND X.CGCFORNEC = 09109081 -- 6 primeiros dígitos do fornecedor que está recebendo

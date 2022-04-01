ALTER SESSION SET current_schema = CONSINCO;

SELECT owner, table_name, column_name 
FROM all_tab_columns 
WHERE column_name LIKE '%NROEMPRESA%' -- EXEMPLO NRO DA EMPRESA
AND OWNER IN ('CONSINCO')
ORDER BY 2;

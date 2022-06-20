SELECT * 
    FROM all_cons_columns 
    WHERE constraint_name = ( 
        SELECT constraint_name FROM all_constraints  
            WHERE UPPER(table_name) = UPPER('MAP_FAMDIVCATEG') 
        AND CONSTRAINT_TYPE = 'P');

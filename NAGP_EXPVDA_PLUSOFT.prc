CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_EXPVDA_PLUSOFT  IS

    v_file UTL_FILE.file_type;
    v_line VARCHAR2(32767);
    v_Targetcharset varchar2(40 BYTE);
    v_Dbcharset varchar2(40 BYTE);
    v_Cabecalho VARCHAR2(4000);
    v_Periodo VARCHAR2(10);
    
BEGIN
       
    FOR t IN (SELECT X.ANOMESDESCRICAO,
                   MIN(TO_DATE(LAST_DAY(ADD_MONTHS(X.DTA, -1)) + 1, 'DD/MM/RRRR')) DTA_INICIAL,
                   MAX(TO_DATE(LAST_DAY(X.DTA), 'DD/MM/RRRR')) DTA_FINAL
              FROM DIM_TEMPO@CONSINCODW X
             WHERE X.DTA BETWEEN '01-JUL-2022' AND '31-AUG-2024'
             GROUP BY X.ANOMESDESCRICAO
             ORDER BY 2)
      
    LOOP
      
    V_Periodo := REPLACE(t.ANOMESDESCRICAO, '/','_');
    
    -- Abre o arquivo para escrita
    v_file := UTL_FILE.fopen('/u02/app_acfs/arquivos/plusoft', 'Ext_Vda_'||v_Periodo||'.csv', 'w', 32767);
    
    -- Pega o nome das colunas para inserir no cabecalho pq tenho preguica
    SELECT LISTAGG(COLUMN_NAME,';') WITHIN GROUP (ORDER BY COLUMN_ID)
      INTO v_Cabecalho
      FROM ALL_TAB_COLUMNS@CONSINCODW A
     WHERE A.table_name = 'NAGV_PLUSOFT_VENDAS'
       AND COLUMN_NAME != 'DATA';
    
    -- Escreve o cabeçalho do CSV
    UTL_FILE.put_line(v_file, v_Cabecalho);

    -- Executa a query e escreve os resultados
        
      FOR vda IN (SELECT * FROM NAGV_PLUSOFT_VENDAS@CONSINCODW VD WHERE VD.DATA BETWEEN t.DTA_INICIAL AND t.DTA_FINAL)
        
      LOOP
      
        v_line := vda.IDPESSOA||';'||vda.IDFILIAL||';'||vda.IDCUPOM||';'||vda.IDPRODUTO||';'||vda.DATVENDA||';'||vda.NUMQTDVENDIDA||';'||
                  vda.VLRPRECOVENDAUNITARIO||';'||vda.VLRPRECOPDVUNITARIO||';'||vda.VLRDESCONTOUNITARIO||';'||vda.VLRMARGEMPDV||';'||
                  vda.TXTCANALVENDAS||';'||vda.TXTTIPOVENDA||';'||vda.IDFORMAPAGTO||';'||vda.TXTFORMAPAGTO;
                
        UTL_FILE.put_line(v_file, v_line);
        
       COMMIT;
    END LOOP;

    -- Fecha o arquivo
    UTL_FILE.fclose(v_file);
    
    END LOOP;
    
EXCEPTION
  
    WHEN OTHERS THEN
        IF UTL_FILE.is_open(v_file) THEN
            UTL_FILE.fclose(v_file);
        END IF;
        RAISE;
        
    COMMIT;
END;

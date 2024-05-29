BEGIN
  CONSINCO.NAGP_EXPORTA_SPACEMAN(8);
  END;
  

-- Chamada em Loop _ Emp

BEGIN
  
  FOR emp IN (SELECT NROEMPRESA FROM CONSINCO.MAX_EMPRESA WHERE NROEMPRESA < 100)
    
  LOOP
  
  CONSINCO.NAGP_EXPORTA_SPACEMAN(emp.NROEMPRESA);
  
  COMMIT;
  
  END LOOP;
  
END;
  

-- Pegando os nomes das colunas pq tenho preguica

SELECT LISTAGG(COLUMN_NAME,';') WITHIN GROUP (ORDER BY COLUMN_ID)
  FROM ALL_TAB_COLUMNS A
WHERE A.table_name = 'NAGV_SPACEMAN_DATA';

-- View

SELECT * FROM consinco.NAGV_SPACEMAN_DATA;

CREATE OR REPLACE VIEW CONSINCO.NAGV_SPACEMAN_DATA AS 

SELECT A.SEQPRODUTO PRODUCT_ID,
       B.CODACESSO UPC,
       A.DESCCOMPLETA NAME,
       TO_CHAR(H.PESOLIQUIDO, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') SIZE_VAL,
       NULL UOM,
       G.NOMERAZAO MANUFACTURER,
       D.MARCA BRAND,
       NULL CATEGORY,
       NULL SUBCATEGORY,
       NULL SUBSEGMENT,
       NULL DESC_A,
       NULL DESC_B,
       NULL DESC_C,
       NULL DESC_D,
       NULL DESC_E,
       ROUND(SYSDATE - NVL(I.DTAULTVENDA,SYSDATE - 999)) DESC_F,
       ROUND(CASE WHEN I.ESTQLOJA <= 0 THEN SYSDATE - NVL(I.DTAULTVENDA, SYSDATE - 999) ELSE 0 END) DESC_G,
       TO_CHAR(A.DTAHORINCLUSAO, 'DD/MM/YYYY') DESC_H,
       DECODE(I.STATUSCOMPRA, 'A','ATIVO','I','INATIVO','S','SUSPENSO') DESC_I,
       DECODE(J.STATUSVENDA,  'A','ATIVO','I','INATIVO') DESC_J,
       NULL DESC_K,
       NULL DESC_L,
       TO_CHAR(H.ALTURA, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') HEIGHT,
       TO_CHAR(H.LARGURA, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') WIDTH,
       TO_CHAR(H.PROFUNDIDADE, 'FM999G999G990D90', 'NLS_NUMERIC_CHARACTERS='',.''') DEPTHVALUE,
       NVL(J.PRECOVALIDNORMAL, J.PRECOGERNORMAL) PRICE,
       ROUND(I.CMULTVLRNF,2) COST, 
      (SELECT SUM(QTDOPERACAO) 
         FROM FATOG_VENDADIA@CONSINCODW X
        WHERE X.SEQPRODUTO = A.SEQPRODUTO  
          AND CODGERALOPER IN (37,48,123,610,615,613,810,916,910,911) 
          AND X.NROEMPRESA = I.NROEMPRESA 
          AND X.DTAOPERACAO > SYSDATE - 100) REG_MOVEMENT, --
       NULL CASE_HEIGHT,
       NULL CASE_WIDTH,
       NULL CASE_DEPTH,
       NULL UNITS_CASE,
       NULL FILL_COLOR,
       NULL FILL_PATTERN,
       NULL PACKAGE_TYPE,
       NULL SHAPE_ID,
       NULL TRAY_HEIGHT,
       NULL TRAY_WIDTH,
       NULL TRAY_DEPTH,
       NULL UNITS_CASE_HIGH,
       NULL UNITS_CASE_WIDE,
       NULL UNITS_CASE_DEEP,
       NULL UNITS_TRAY,
       NULL UNITS_TRAY_HIGH,
       NULL UNITS_TRAY_WIDE,
       NULL UNITS_TRAY_DEEP,
       NULL PEG_RIGHT,
       NULL PEG_DOWN,
       NULL PEG_1_RIGHT,
       NULL PEG_1_DOWN,
       NULL PEG_1_DEPTH,
       NULL PEG_2_RIGHT,
       NULL PEG_2_DOWN,
       NULL PEG_3_RIGHT,
       NULL PEG_3_DOWN,
       NULL PEG_NEST,
       NULL VERT_NEST,
       NULL HORIZ_NEST,
       NULL DEPTH_NEST,
       NULL STD_ORIENT,
       NULL BASKET_FACTOR,
       NULL HANG,
       NULL MERCH_STYLE,
       NULL CAP_STYLE,
       NULL DEPTH_FILL,
       NULL STD_PEG,
       NULL STD_PEG_HOLE,
       NULL FIT_TYPE,
       NULL FULL_FACINGS,
       NULL PREFERRED_FIXEL,
       NULL RANK,
       NULL FRONT_0,
       NULL FRONT_90,
       NULL FRONT_180,
       NULL FRONT_270,
       NULL BACK_0,
       NULL BACK_90,
       NULL BACK_180,
       NULL BACK_270,
       NULL LEFT_0,
       NULL LEFT_90,
       NULL LEFT_180,
       NULL LEFT_270,
       NULL RIGHT_0,
       NULL RIGHT_90,
       NULL RIGHT_180,
       NULL RIGHT_270,
       NULL TOP_0,
       NULL TOP_90,
       NULL TOP_180,
       NULL TOP_270,
       NULL BOTTOM_0,
       NULL BOTTOM_90,
       NULL BOTTOM_180,
       NULL BOTTOM_270,
       NULL OVERHANG,
       NULL MAX_VERT_CRUSH,
       NULL MAX_HORIZ_CRUSH,
       NULL MAX_DEPTH_CRUSH,
       NULL DISPLAY_HEIGHT,
       NULL DISPLAY_WIDTH,
       NULL DISPLAY_DEPTH,
       NULL COLOUR,
       NULL COLOURISCLEAR,
       NULL CONTAINHEIGHT,
       NULL CONTAINWIDTH,
       NULL CONTAINDEPTH,
       NULL PEGSPERFACING,
       NULL GTIN,
       NULL USEIMAGEOVERRIDE,
       NULL USEUNITIMAGEFORTRAYSANDCASES,
       NULL IMAGEOVERRIDE,
       NULL MODEL_SCHED,
       NULL MIN_FACINGS,
       NULL MAX_FACINGS,
       NULL TAX_PER,
       NULL TAX_CODE, I.NROEMPRESA PN, CATEGORIAN3 PC

  FROM MAP_PRODUTO A LEFT  JOIN MAP_PRODCODIGO   B ON A.SEQPRODUTO = B.SEQPRODUTO   AND B.TIPCODIGO = 'E'
                     INNER JOIN MAP_FAMILIA      C ON C.SEQFAMILIA = A.SEQFAMILIA
                     LEFT  JOIN MAP_MARCA        D ON D.SEQMARCA   = C.SEQMARCA
                     LEFT  JOIN MAP_FAMFORNEC    E ON E.SEQFAMILIA = A.SEQFAMILIA   AND E.PRINCIPAL = 'S'
                     INNER JOIN GE_PESSOA        G ON G.SEQPESSOA  = E.SEQFORNECEDOR
                     INNER JOIN MAP_FAMEMBALAGEM H ON H.SEQFAMILIA = A.SEQFAMILIA   AND H.QTDEMBALAGEM = B.QTDEMBALAGEM
                     INNER JOIN MRL_PRODUTOEMPRESA I ON I.SEQPRODUTO = A.SEQPRODUTO --AND I.NROEMPRESA = 8 
                                                                                    AND I.DTAULTVENDA > SYSDATE - 180
                                                                                    AND I.ESTQLOJA > 0
                     INNER JOIN MRL_PRODEMPSEG   J ON J.SEQPRODUTO = A.SEQPRODUTO   AND J.NROEMPRESA = I.NROEMPRESA
                                                                                    AND J.QTDEMBALAGEM = B.QTDEMBALAGEM
                                                                                    AND J.STATUSVENDA  = 'A'
                                                                                     
                     INNER JOIN DIM_CATEGORIA@CONSINCODW DC ON DC.SEQFAMILIA = C.SEQFAMILIA
                     
  WHERE B.QTDEMBALAGEM = 1 
  AND J.NROSEGMENTO  = 2
  /*AND I.NROEMPRESA   = 8*/;
  
-- Proc

CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_EXPORTA_SPACEMAN (v_Emp NUMBER) IS

    v_file UTL_FILE.file_type;
    v_line VARCHAR2(32767);
    v_Cabecalho VARCHAR2(4000);
    v_LpadLoja  VARCHAR2(3);
    v_Categoria VARCHAR2(200);
    
BEGIN
    
    v_LpadLoja := LPAD(v_Emp,3,0);
    
    FOR t IN (SELECT DISTINCT CATEGORIAN3 FROM DIM_CATEGORIA@CONSINCODW WHERE CATEGORIAN3 IS NOT NULL)
      
    LOOP
    
    v_Categoria := t.Categorian3;
    
    -- Abre o arquivo para escrita
    v_file := UTL_FILE.fopen('/u02/app_acfs/arquivos/Spaceman', v_LpadLoja||'_'||v_Categoria||'_Products'||'.csv', 'w', 32767);
    
    -- Pega o nome das colunas para inserir no cabecalho
    SELECT LISTAGG(COLUMN_NAME,';') WITHIN GROUP (ORDER BY COLUMN_ID)
     INTO v_Cabecalho
     FROM ALL_TAB_COLUMNS A 
    WHERE A.table_name = 'NAGV_SPACEMAN_DATA';
    
    -- Escreve o cabeçalho do CSV
    UTL_FILE.put_line(v_file, v_Cabecalho);

    -- Executa a query e escreve os resultados
    FOR rec IN (SELECT x.PRODUCT_ID,x.UPC,x.NAME,x.SIZE_VAL,x.UOM,x.MANUFACTURER,x.BRAND,x.CATEGORY,x.SUBCATEGORY,
                       x.SUBSEGMENT,x.DESC_A,x.DESC_B,x.DESC_C,x.DESC_D,x.DESC_E,x.DESC_F,x.DESC_G,x.DESC_H,x.DESC_I,
                       x.DESC_J,x.DESC_K,x.DESC_L,x.HEIGHT,x.WIDTH,x.DEPTHVALUE,x.PRICE,x.COST,x.REG_MOVEMENT,x.CASE_HEIGHT,
                       x.CASE_WIDTH,x.CASE_DEPTH,x.UNITS_CASE,x.FILL_COLOR,x.FILL_PATTERN,x.PACKAGE_TYPE,x.SHAPE_ID,x.TRAY_HEIGHT,
                       x.TRAY_WIDTH,x.TRAY_DEPTH,x.UNITS_CASE_HIGH,x.UNITS_CASE_WIDE,x.UNITS_CASE_DEEP,x.UNITS_TRAY,x.UNITS_TRAY_HIGH,
                       x.UNITS_TRAY_WIDE,x.UNITS_TRAY_DEEP,x.PEG_RIGHT,x.PEG_DOWN,x.PEG_1_RIGHT,x.PEG_1_DOWN,x.PEG_1_DEPTH,x.PEG_2_RIGHT,
                       x.PEG_2_DOWN,x.PEG_3_RIGHT,x.PEG_3_DOWN,x.PEG_NEST,x.VERT_NEST,x.HORIZ_NEST,x.DEPTH_NEST,x.STD_ORIENT,
                       x.BASKET_FACTOR,x.HANG,x.MERCH_STYLE,x.CAP_STYLE,x.DEPTH_FILL,x.STD_PEG,x.STD_PEG_HOLE,x.FIT_TYPE,x.FULL_FACINGS,
                       x.PREFERRED_FIXEL,x.RANK,x.FRONT_0,x.FRONT_90,x.FRONT_180,x.FRONT_270,x.BACK_0,x.BACK_90,x.BACK_180,x.BACK_270,
                       x.LEFT_0,x.LEFT_90,x.LEFT_180,x.LEFT_270,x.RIGHT_0,x.RIGHT_90,x.RIGHT_180,x.RIGHT_270,x.TOP_0,x.TOP_90,
                       x.TOP_180,x.TOP_270,x.BOTTOM_0,x.BOTTOM_90,x.BOTTOM_180,x.BOTTOM_270,x.OVERHANG,x.MAX_VERT_CRUSH,x.MAX_HORIZ_CRUSH,
                       x.MAX_DEPTH_CRUSH,x.DISPLAY_HEIGHT,x.DISPLAY_WIDTH,x.DISPLAY_DEPTH,x.COLOUR,x.COLOURISCLEAR,x.CONTAINHEIGHT,
                       x.CONTAINWIDTH,x.CONTAINDEPTH,x.PEGSPERFACING,x.GTIN,x.USEIMAGEOVERRIDE,x.USEUNITIMAGEFORTRAYSANDCASES,x.IMAGEOVERRIDE,
                       x.MODEL_SCHED,x.MIN_FACINGS,x.MAX_FACINGS,x.TAX_PER,x.TAX_CODE
                       
                  FROM CONSINCO.NAGV_SPACEMAN_DATA X
                 WHERE X.PN = v_Emp
                   AND X.PC = t.Categorian3) 
      
      LOOP
      
        v_line := rec.PRODUCT_ID||';'||rec.UPC||';'||rec.NAME||';'||rec.SIZE_VAL||';'||rec.UOM||';'||rec.MANUFACTURER||';'||rec.BRAND||';'||rec.CATEGORY||';'||rec.SUBCATEGORY||';'
                ||rec.SUBSEGMENT||';'||rec.DESC_A||';'||rec.DESC_B||';'||rec.DESC_C||';'||rec.DESC_D||';'||rec.DESC_E||';'||rec.DESC_F||';'||rec.DESC_G||';'||rec.DESC_H||';'||rec.DESC_I||';'
                ||rec.DESC_J||';'||rec.DESC_K||';'||rec.DESC_L||';'||rec.HEIGHT||';'||rec.WIDTH||';'||rec.DEPTHVALUE||';'||rec.PRICE||';'||rec.COST||';'||rec.REG_MOVEMENT||';'||rec.CASE_HEIGHT||';'
                ||rec.CASE_WIDTH||';'||rec.CASE_DEPTH||';'||rec.UNITS_CASE||';'||rec.FILL_COLOR||';'||rec.FILL_PATTERN||';'||rec.PACKAGE_TYPE||';'||rec.SHAPE_ID||';'||rec.TRAY_HEIGHT||';'
                ||rec.TRAY_WIDTH||';'||rec.TRAY_DEPTH||';'||rec.UNITS_CASE_HIGH||';'||rec.UNITS_CASE_WIDE||';'||rec.UNITS_CASE_DEEP||';'||rec.UNITS_TRAY||';'||rec.UNITS_TRAY_HIGH||';'
                ||rec.UNITS_TRAY_WIDE||';'||rec.UNITS_TRAY_DEEP||';'||rec.PEG_RIGHT||';'||rec.PEG_DOWN||';'||rec.PEG_1_RIGHT||';'||rec.PEG_1_DOWN||';'||rec.PEG_1_DEPTH||';'||rec.PEG_2_RIGHT||';'
                ||rec.PEG_2_DOWN||';'||rec.PEG_3_RIGHT||';'||rec.PEG_3_DOWN||';'||rec.PEG_NEST||';'||rec.VERT_NEST||';'||rec.HORIZ_NEST||';'||rec.DEPTH_NEST||';'||rec.STD_ORIENT||';'
                ||rec.BASKET_FACTOR||';'||rec.HANG||';'||rec.MERCH_STYLE||';'||rec.CAP_STYLE||';'||rec.DEPTH_FILL||';'||rec.STD_PEG||';'||rec.STD_PEG_HOLE||';'||rec.FIT_TYPE||';'||rec.FULL_FACINGS||';'
                ||rec.PREFERRED_FIXEL||';'||rec.RANK||';'||rec.FRONT_0||';'||rec.FRONT_90||';'||rec.FRONT_180||';'||rec.FRONT_270||';'||rec.BACK_0||';'||rec.BACK_90||';'||rec.BACK_180||';'||rec.BACK_270||';'
                ||rec.LEFT_0||';'||rec.LEFT_90||';'||rec.LEFT_180||';'||rec.LEFT_270||';'||rec.RIGHT_0||';'||rec.RIGHT_90||';'||rec.RIGHT_180||';'||rec.RIGHT_270||';'||rec.TOP_0||';'||rec.TOP_90||';'
                ||rec.TOP_180||';'||rec.TOP_270||';'||rec.BOTTOM_0||';'||rec.BOTTOM_90||';'||rec.BOTTOM_180||';'||rec.BOTTOM_270||';'||rec.OVERHANG||';'||rec.MAX_VERT_CRUSH||';'||rec.MAX_HORIZ_CRUSH||';'
                ||rec.MAX_DEPTH_CRUSH||';'||rec.DISPLAY_HEIGHT||';'||rec.DISPLAY_WIDTH||';'||rec.DISPLAY_DEPTH||';'||rec.COLOUR||';'||rec.COLOURISCLEAR||';'||rec.CONTAINHEIGHT||';'
                ||rec.CONTAINWIDTH||';'||rec.CONTAINDEPTH||';'||rec.PEGSPERFACING||';'||rec.GTIN||';'||rec.USEIMAGEOVERRIDE||';'||rec.USEUNITIMAGEFORTRAYSANDCASES||';'||rec.IMAGEOVERRIDE||';'
                ||rec.MODEL_SCHED||';'||rec.MIN_FACINGS||';'||rec.MAX_FACINGS||';'||rec.TAX_PER||';'||rec.TAX_CODE;
                
        UTL_FILE.put_line(v_file, v_line);
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
        
        
END;

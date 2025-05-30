-- Spaceman

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT A.SEQPRODUTO PRODUCT_ID,
       B.CODACESSO UPC,
       A.DESCCOMPLETA NAME,
       H.PESOLIQUIDO SIZE_VAL,
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
       A.DTAHORINCLUSAO DESC_H,
       DECODE(I.STATUSCOMPRA, 'A','ATIVO','I','INATIVO','S','SUSPENSO') DESC_I,
       DECODE(J.STATUSVENDA,  'A','ATIVO','I','INATIVO') DESC_J,
       NULL DESC_K,
       NULL DESC_L,
       H.ALTURA HEIGHT,
       H.LARGURA WIDTH,
       H.PROFUNDIDADE DEPTHVALUE,
       NVL(J.PRECOVALIDNORMAL, J.PRECOGERNORMAL) PRICE,
       I.CMULTVLRNF COST, 
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
       NULL TAX_CODE

  FROM MAP_PRODUTO A LEFT  JOIN MAP_PRODCODIGO   B ON A.SEQPRODUTO = B.SEQPRODUTO   AND B.TIPCODIGO = 'E'
                     INNER JOIN MAP_FAMILIA      C ON C.SEQFAMILIA = A.SEQFAMILIA
                     LEFT  JOIN MAP_MARCA        D ON D.SEQMARCA   = C.SEQMARCA
                     LEFT  JOIN MAP_FAMFORNEC    E ON E.SEQFAMILIA = A.SEQFAMILIA   AND E.PRINCIPAL = 'S'
                     INNER JOIN GE_PESSOA        G ON G.SEQPESSOA  = E.SEQFORNECEDOR
                     INNER JOIN MAP_FAMEMBALAGEM H ON H.SEQFAMILIA = A.SEQFAMILIA   AND H.QTDEMBALAGEM = B.QTDEMBALAGEM
                     INNER JOIN MRL_PRODUTOEMPRESA I ON I.SEQPRODUTO = A.SEQPRODUTO AND I.NROEMPRESA = 8 
                                                                                    AND I.DTAULTVENDA > SYSDATE - 180
                                                                                    AND I.ESTQLOJA > 0
                     INNER JOIN MRL_PRODEMPSEG   J ON J.SEQPRODUTO = A.SEQPRODUTO   AND J.NROEMPRESA = I.NROEMPRESA
                                                                                    AND J.QTDEMBALAGEM = B.QTDEMBALAGEM
                                                                                    AND J.STATUSVENDA  = 'A'
                                                                                     
                     INNER JOIN DIM_CATEGORIA@CONSINCODW DC ON DC.SEQFAMILIA = C.SEQFAMILIA
                     
  WHERE B.QTDEMBALAGEM = 1 
    --AND A.SEQPRODUTO   = 237203
    AND J.NROSEGMENTO  = 2
    AND DC.CATEGORIAN3 = 'CATCHUP'
    --AND ROWNUM <= 500rapazz
    --AND A.DESCCOMPLETA NOT LIKE '%ZZ%'
    
   -- SELECT DISTINCT CATEGORIAN3 FROM DIM_CATEGORIA@CONSINCODW

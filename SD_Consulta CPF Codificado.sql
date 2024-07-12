SELECT REPLACE(RAWTOHEX(DBMS_OBFUSCATION_TOOLKIT.md5(input => UTL_RAW.cast_to_raw(nvl(:NR1,
                                                                                      0)))),
               'CFCD208495D565EF66E7DFF9F98764DA',
               '') CPF_CODIFICADO
  FROM DUAL

CREATE OR REPLACE FUNCTION CONSINCO.NAGF_BUSCAULTDTAPEDIDO (p_SeqLoteModelo NUMBER) RETURN DATE IS
                                                                           v_proxped DATE;
                                                                           v_diasconfig NUMBER;
                                                                           v_diasemana VARCHAR2(10);
                                                                           v_dia VARCHAR(10);
                                                                           v_dta DATE;
 BEGIN
  -- Valida Parametrizacoes na NAGT_ABASTECIMENTOCONFIG
  SELECT DIASCONFIG, DECODE(UPPER(DIASEMANA),  'SEGUNDA' , 'MONDAY',
                                               'TERCA'   , 'TUESDAY',
                                               'QUARTA'  , 'WEDNESDAY',
                                               'QUINTA'  , 'THURSDAY',
                                               'SEXTA'   , 'FRIDAY',
                                               'SABADO ' , 'SATURDAY',
                                               'DOMINGO' , 'SUNDAY')
    INTO v_diasconfig, v_diasemana
    FROM CONSINCO.NAGT_CONTROLELOTECOMPRA X
   WHERE X.SEQLOTEMODELO = p_SeqLoteModelo;
   
  SELECT TRIM(TO_CHAR(MAX(TRUNC(DTAHORINCLUSAO)) + v_diasconfig,'DAY')), MAX(TRUNC(DTAHORINCLUSAO))
    INTO v_dia, v_dta
    FROM CONSINCO.MAC_GERCOMPRA A
   WHERE 1=1
     AND A.SEQGERMODELOCOMPRA = p_SeqLoteModelo 
     OR A.SEQGERCOMPRA = p_SeqLoteModelo AND TIPOLOTE = 'M';
  --
  -- Se o dia da semana for igual hoje, retorna hoje
   IF v_diasemana = v_dia 
  AND v_dta = TRUNC(SYSDATE)

   THEN
     SELECT TRUNC(SYSDATE)
       INTO v_proxped
       FROM DUAL;

   DBMS_OUTPUT.PUT_LINE(v_dia||'-'||v_diasemana); -- Teste
  -- Caso contrário, próximo dia da semana que está parametrizado
   ELSE

  SELECT NEXT_DAY((SELECT MAX(TRUNC(DTAHORINCLUSAO))
    FROM CONSINCO.MAC_GERCOMPRA A 
   WHERE 1=1
     AND A.SEQGERMODELOCOMPRA = p_SeqLoteModelo 
      OR A.SEQGERCOMPRA = p_SeqLoteModelo AND TIPOLOTE = 'M')
   + v_diasconfig, v_diasemana)
   INTO v_proxped
   FROM DUAL;

    END IF;

 RETURN v_proxped;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RETURN TRUNC(SYSDATE) -1;
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(p_SeqLoteModelo);
END;

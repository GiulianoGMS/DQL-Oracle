CREATE OR REPLACE FUNCTION NAGF_BUSCAULTDTAPEDIDO (p_SeqLoteModelo NUMBER) RETURN DATE IS
                                                                           v_proxped DATE;
                                                                           v_diasconfig NUMBER;
                                                                           v_diasemana VARCHAR2(10);
                                                                           v_diahoje VARCHAR(10);
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
    FROM NAGT_ABASTECIMENTOCONFIG X
   WHERE X.SEQLOTEMODELO = p_SeqLoteModelo;

  SELECT TRIM(TO_CHAR(MAX(DTAHORINCLUSAO) + v_diasconfig,'DAY'))
    INTO v_diahoje
    FROM CONSINCO.MAC_GERCOMPRA A 
   WHERE 1=1
     AND A.SEQGERMODELOCOMPRA = p_SeqLoteModelo;
  --
  -- Se o dia da semana for igual hoje, retorna hoje
   IF v_diasemana = v_diahoje

   THEN
     SELECT TRUNC(SYSDATE)
       INTO v_proxped
       FROM DUAL;
       
   DBMS_OUTPUT.PUT_LINE(v_diahoje||'-'||v_diasemana); -- Teste
  -- Caso contrário, próximo dia da semana que está parametrizado
   ELSE

  SELECT NEXT_DAY((SELECT MAX(DTAHORINCLUSAO)
    FROM CONSINCO.MAC_GERCOMPRA A 
   WHERE 1=1
     AND A.SEQGERMODELOCOMPRA = p_SeqLoteModelo)
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

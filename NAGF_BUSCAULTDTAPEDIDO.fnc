CREATE OR REPLACE FUNCTION NAGF_BUSCAULTDTAPEDIDO (p_SeqLoteModelo NUMBER) RETURN DATE IS
  /* Criado por Giuliano | 07/07/2023 */                                   v_proxped    DATE;
                                                                           v_diasconfig NUMBER;
                                                                           v_diasemana  VARCHAR2(10);
                                                                           v_dia        VARCHAR2(10);
                                                                           v_dta        DATE;
                                                                           v_datainicio DATE;
                                                                           v_diafixo    NUMBER(3);
                                                                           v_diahoje    NUMBER(3);
 BEGIN
  -- Valida Parametrizacoes na NAGT_CONTROLELOTECOMPRA
  -- Tradur o dia configurado pra utilizar no Next_Day
  
  SELECT DIASCONFIG, DECODE(UPPER(DIASEMANA),  'SEGUNDA' , 'MONDAY',
                                               'TERCA'   , 'TUESDAY',
                                               'QUARTA'  , 'WEDNESDAY',
                                               'QUINTA'  , 'THURSDAY',
                                               'SEXTA'   , 'FRIDAY',
                                               'SABADO'  , 'SATURDAY',
                                               'DOMINGO' , 'SUNDAY'), DATAINICIO, DIA_FIXO
  --
    INTO v_diasconfig, v_diasemana, v_datainicio, v_diafixo
    FROM CONSINCO.NAGT_CONTROLELOTECOMPRA X
   WHERE X.SEQLOTEMODELO = p_SeqLoteModelo;
   
  SELECT TO_CHAR(SYSDATE, 'DD') 
    INTO v_diahoje
    FROM DUAL;
  --
  -- Primeiro resultado para validar se o dia semana é igual ao dia atual
  -- GREATEST pega a maior data entre Inclusão ou Fechamento
  SELECT TRIM(TO_CHAR(TRUNC(GREATEST(MAX(DTAHORINCLUSAO), NVL(MAX(DTAHORFECHAMENTO),MAX(DTAHORINCLUSAO))) + v_diasconfig),'DAY')), 
  --
  -- Segundo resultado para validar se o dia inteiro é igual ao dia atual
         TRUNC(GREATEST(MAX(DTAHORINCLUSAO), NVL(MAX(DTAHORFECHAMENTO),MAX(DTAHORINCLUSAO))) + v_diasconfig)
  --
    INTO v_dia, v_dta
    FROM CONSINCO.MAC_GERCOMPRA A
   WHERE 1=1
     AND (A.SEQGERMODELOCOMPRA = p_SeqLoteModelo
      OR A.SEQGERCOMPRA = p_SeqLoteModelo AND TIPOLOTE = 'M')
     AND A.SITUACAOLOTE != 'C';
  --
  -- Valida se a data de inicio é igual ou maior que o dia atual e retorna na variavel
       IF 
             TRUNC(v_datainicio) >= TRUNC(SYSDATE) 
        THEN v_proxped := v_datainicio;
  --
  -- Caso contrário, valida se o prazo no calculo é igual ao dia atual
       ELSIF v_diasemana = v_dia 
         AND v_dta = TRUNC(SYSDATE)
         AND v_datainicio < SYSDATE 
          
        THEN
      SELECT TRUNC(SYSDATE)
        INTO v_proxped
        FROM DUAL;
  --
  -- Se não for, retorna róximo dia da semana conforme calculo
        ELSE
          -- Sem Dia Fixo
          IF v_diafixo IS NULL THEN

      SELECT NEXT_DAY((SELECT GREATEST(MAX(DTAHORINCLUSAO), NVL(MAX(DTAHORFECHAMENTO),MAX(DTAHORINCLUSAO))) -1
        FROM CONSINCO.MAC_GERCOMPRA A 
       WHERE 1=1
         AND A.SEQGERMODELOCOMPRA = p_SeqLoteModelo
         AND A.SITUACAOLOTE != 'C'
          OR A.SEQGERCOMPRA = p_SeqLoteModelo AND TIPOLOTE = 'M')
           + v_diasconfig, v_diasemana)
        INTO v_proxped
        FROM DUAL;
        
         -- Se tiver dia fixo
       ELSIF v_diafixo IS NOT NULL
         AND v_diafixo = v_diahoje
        THEN v_proxped := TRUNC(SYSDATE);
        
      END IF;
  
   END IF;

 RETURN v_proxped;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RETURN TRUNC(SYSDATE) + 100;
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(p_SeqLoteModelo);
END;

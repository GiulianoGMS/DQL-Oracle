CREATE OR REPLACE FUNCTION NAGF_BUSCAULTDTAPEDIDO (p_Seqfornecedor NUMBER) RETURN DATE IS
                                                                           v_ultpedido DATE;
                                                                           v_diasconfig NUMBER;
                                                                           v_diasemana VARCHAR2(20);
 BEGIN
  SELECT DIASCONFIG, DECODE(UPPER(DIASEMANA),  'SEGUNDA' , 'MONDAY',
                                              'TER_A'   , 'TUESDAY',
                                              'QUARTA'  , 'WEDNESDAY',
                                              'QUINTA'  , 'THURSDAY',
                                              'SEXTA'   , 'FRIDAY',
                                              'SABADO ' , 'SATURDAY',
                                              'DOMINGO' , 'SUNDAY')
    INTO v_diasconfig, v_diasemana
    FROM NAGT_ABASTECIMENTOCONFIG X
   WHERE X.SEQFORNECEDOR = p_Seqfornecedor;

  SELECT NEXT_DAY((SELECT MAX(DTAGERPEDIDO)
    FROM CONSINCO.MAC_GERCOMPRA A INNER JOIN CONSINCO.MAC_GERCOMPRAFORN C ON A.SEQGERCOMPRA = C.SEQGERCOMPRA
   WHERE 1=1
     AND C.SEQFORNECEDOR = p_Seqfornecedor
     AND A.SITUACAOLOTE = 'F')
   + v_diasconfig, v_diasemana)
   INTO v_ultpedido
   FROM DUAL;

 RETURN v_ultpedido;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RETURN TRUNC(SYSDATE) -1;
END;

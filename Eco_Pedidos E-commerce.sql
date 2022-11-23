SELECT A.*,
       /*Colunas com os totais*/
       
      (SELECT /*'     ',NULL,NULL,'PEDIDO CONFERIDO AGUARDANDO CLIENTE','TOTAL CONFERIDO',*/
      TO_CHAR(sum(case when pag.nroformapagto = 65 or pag.nroformapagto = 81 then pag.valor
             when PED.STATUSPEDIDO = 'N' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'L' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'U' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'T' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'C' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             else sd.vlrlancamento  end),'FM999G999G999D90','nls_numeric_characters='',.''') AS VALOR_COMPRA

      FROM CONSINCO.ECOMM_PDV_VENDA PED
      INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)                  
      LEFT JOIN (select d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, sum(p.vlrlancamento) as vlrlancamento, d.dtamovimento
              from consinco.pdv_docto d
              inner join consinco.pdv_doctopagto p on d.seqdocto = p.seqdocto
              where d.nrosegmento = (DECODE(:LS1,'Mixter','8','Nagumo SP','5'))
              and p.nroformapagto not in (65, 81) 
              and p.vlrlancamento != 0.01
              group by d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, d.dtamovimento) SD ON PED.NROPEDVENDA = SD.NUMERODF 
                    
      AND PED.NROREPRESENTANTE = SD.NROCHECKOUT AND SD.NROEMPRESA = :NR1
      WHERE TRUNC(PED.DTAINCLUSAO) BETWEEN :DT1 AND :DT2
      AND PED.NROEMPRESA = :NR1
      AND PED.STATUSPEDIDO = 'C' ) TOTAL_CONFERIDO,
      
      (SELECT /* '       ',NULL,NULL,'PEDIDO LIVRE','TOTAL LIVRE',*/
      TO_CHAR(sum(case when pag.nroformapagto = 65 or pag.nroformapagto = 81 then pag.valor
             when PED.STATUSPEDIDO = 'N' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'L' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'U' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'T' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'C' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             else sd.vlrlancamento  end),'FM999G999G999D90','nls_numeric_characters='',.''') AS VALOR_COMPRA
                                           
      FROM CONSINCO.ECOMM_PDV_VENDA PED
      INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)                  
      LEFT JOIN (select d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, sum(p.vlrlancamento) as vlrlancamento, d.dtamovimento
              from consinco.pdv_docto d
              inner join consinco.pdv_doctopagto p on d.seqdocto = p.seqdocto
              where d.nrosegmento = (DECODE(:LS1,'Mixter','8','Nagumo SP','5'))
              and p.nroformapagto not in (65, 81) and p.vlrlancamento != 0.01
              group by d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, d.dtamovimento) SD ON PED.NROPEDVENDA = SD.NUMERODF 
                              
      AND PED.NROREPRESENTANTE = SD.NROCHECKOUT AND SD.NROEMPRESA = :NR1
      WHERE TRUNC(PED.DTAINCLUSAO) BETWEEN :DT1 AND :DT2
      AND PED.NROEMPRESA = :NR1
      AND PED.STATUSPEDIDO = 'L') TOTAL_LIVRE,
      
      (SELECT  /*'         ',NULL,NULL,'TOTAL GERAL: SEM PEDIDO CONFERIDO E PEDIDO LIVRE','TOTAL GERAL',*/
      TO_CHAR(sum(case when pag.nroformapagto = 65 or pag.nroformapagto = 81 then pag.valor
             when PED.STATUSPEDIDO = 'N' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'L' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'U' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'T' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'C' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             else sd.vlrlancamento  end),'FM999G999G999D90','nls_numeric_characters='',.''') AS VALOR_COMPRA

      FROM CONSINCO.ECOMM_PDV_VENDA PED
      INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)                  
      LEFT JOIN (select d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, sum(p.vlrlancamento) as vlrlancamento, d.dtamovimento
              from consinco.pdv_docto d
              inner join consinco.pdv_doctopagto p on d.seqdocto = p.seqdocto
              where d.nrosegmento = (DECODE(:LS1,'Mixter','8','Nagumo SP','5'))
              and p.nroformapagto not in (65, 81) 
              and p.vlrlancamento != 0.01
              group by d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, d.dtamovimento) SD ON PED.NROPEDVENDA = SD.NUMERODF 
                    
      AND PED.NROREPRESENTANTE = SD.NROCHECKOUT AND SD.NROEMPRESA = :NR1
      WHERE TRUNC(PED.DTAINCLUSAO) BETWEEN :DT1 AND :DT2
      AND PED.NROEMPRESA = :NR1

      AND PED.STATUSPEDIDO != 'L'
      AND PED.STATUSPEDIDO != 'C' ) TOTAL_GERAL
      
FROM (

SELECT
' ', NVL(B.NRODOCUMENTO,SD.NUMERODF) AS NUMERO_NF_CUPOM, PED.NROREPRESENTANTE AS PDV,

CASE
  WHEN PED.STATUSPEDIDO = 'U' THEN 'EM USO'
  WHEN PED.STATUSPEDIDO = 'F' THEN 'FINALIZADO'
  WHEN PED.STATUSPEDIDO = 'N' THEN 'NOTA FISCAL'
  WHEN PED.STATUSPEDIDO = 'X' THEN 'CANCELADO'
  WHEN PED.STATUSPEDIDO = 'C' THEN 'CONFERIDO AGUARDANDO CLIENTE'
  WHEN PED.STATUSPEDIDO = 'T' THEN 'TRANSITANDO'
  ELSE 'PEDIDO LIVRE' END AS STATUS_PEDIDO,
    
PED.NROPEDCLIENTE AS PEDIDO_ECOMMERCE,

TO_CHAR(case when pag.nroformapagto = 65 or pag.nroformapagto = 81 then pag.valor
             when PED.STATUSPEDIDO = 'N' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'L' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'U' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'T' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'C' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             else sd.vlrlancamento  end,'FM999G999G999D90','nls_numeric_characters='',.''')AS VALOR_COMPRA,
               
CASE WHEN PAG.NROFORMAPAGTO = 65 OR PAG.NROFORMAPAGTO = 81 THEN 'PGTO DESCONTO'  
   ELSE 'PGTO CLIENTE' END AS DESCRICAO_PAGAMENTO,
CASE WHEN PAG.NROFORMAPAGTO = 77 THEN 'PAGAMENTO EM LOJA'
  WHEN PAG.NROFORMAPAGTO = 79 THEN 'ELO DEBITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 7 THEN 'VALE ALIMENTACAO'
  WHEN PAG.NROFORMAPAGTO = 51 THEN 'MASTERCARD CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 50 THEN 'VISA CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 53 THEN 'AMERICAN EXPRESS CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 6 THEN 'AURA CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 52 THEN 'DINNERS CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 56 THEN 'ELO CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 55 THEN 'HIPERCARD CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 78 THEN 'MASTERCARD DEBITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 58 THEN 'VISA DEBITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 77 THEN 'PAGAMENTO EM LOJA'
  WHEN PAG.NROFORMAPAGTO = 57 THEN 'INFOCARDS'
  WHEN PAG.NROFORMAPAGTO = 35 THEN 'PIX ONLINE'
  WHEN PAG.NROFORMAPAGTO = 524 THEN 'PAGAMENTO IFOOD RETIRA ONLINE'
  WHEN PAG.NROFORMAPAGTO = 523 THEN 'PAGAMENTO IFOOD ENTREGA ONLINE'
  WHEN PAG.NROFORMAPAGTO = 81 THEN 'VOUCHER MARKETING NAGUMO'
  WHEN PAG.NROFORMAPAGTO = 65 THEN 'VOUCHER SITE MERCADO'
  ELSE 'VERIFICAR PAGAMENTO' END AS FORMA_PAGAMENTO,
    
TO_CHAR(SD.DTAMOVIMENTO, 'DD/MM/YYYY') AS DATA_FATURAMENTO_CUPOM_PDV,

TO_CHAR(PED.DTAINCLUSAO, 'DD/MM/YYYY HH24:MI:SS') AS DATA_EXPORTACAO_COLETOR,

CASE WHEN INSTR(UPPER(ped.OBSPEDIDO), 'ID PEDIDO IFOOD:') > 0 THEN TRIM(SUBSTR(UPPER(ped.OBSPEDIDO),
     INSTR(UPPER(ped.OBSPEDIDO), 'ID PEDIDO IFOOD:') + LENGTH('ID PEDIDO IFOOD:'), INSTR(LTRIM(SUBSTR(UPPER(ped.OBSPEDIDO),
     INSTR(UPPER(ped.OBSPEDIDO), 'ID PEDIDO IFOOD:') + LENGTH('ID PEDIDO IFOOD:'), LENGTH(UPPER(ped.OBSPEDIDO)))), ' '))) 
     ELSE NULL END AS ID_PEDIDO_IFOOD, #NR1 LOJA
       
FROM CONSINCO.ECOMM_PDV_VENDA PED
  INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG ON (PAG.SEQEDIPEDVENDA = PED.SEQEDIPEDVENDA)
  LEFT JOIN CONSINCO.MAD_PEDVENDA A ON (PED.NROPEDCLIENTE = A.IDTRANSACAOECOMMERCE)
  LEFT JOIN CONSINCO.FI_TITULO B ON (A.NROCARGA = B.NROCARGA)                    
  LEFT JOIN (select d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, sum(p.vlrlancamento) as vlrlancamento, d.dtamovimento
              from consinco.pdv_docto d
              inner join consinco.pdv_doctopagto p on d.seqdocto = p.seqdocto
              where d.nrosegmento = (DECODE(:LS1,'Mixter','8','Nagumo SP','5'))
              and p.nroformapagto not in (65, 81) 
              and p.vlrlancamento != 0.01
              group by d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, d.dtamovimento) SD ON PED.NROPEDVENDA = SD.NUMERODF 
              
AND PED.NROREPRESENTANTE = SD.NROCHECKOUT AND SD.NROEMPRESA = :NR1
WHERE TRUNC(PED.DTAINCLUSAO) BETWEEN :DT1 AND :DT2
AND PED.NROEMPRESA = :NR1

GROUP BY B.NRODOCUMENTO, SD.NUMERODF, PED.NROREPRESENTANTE, PED.STATUSPEDIDO, PED.NROPEDCLIENTE,ped.OBSPEDIDO,
PAG.NROFORMAPAGTO, sd.vlrlancamento, PAG.NROFORMAPAGTO, SD.DTAMOVIMENTO, PED.DTAINCLUSAO, A.OBSPEDIDO, PAG.VALOR, SD.NROEMPRESA

UNION ALL

SELECT '   ',NULL,NULL,NULL,'SUBTOTAL',

TO_CHAR(sum(case when pag.nroformapagto = 65 or pag.nroformapagto = 81 then pag.valor
             when PED.STATUSPEDIDO = 'N' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'L' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'U' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'T' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             when ped.statuspedido = 'C' and pag.nroformapagto != 65 and pag.nroformapagto != 81 then pag.valor
             else sd.vlrlancamento  end),'FM999G999G999D90','nls_numeric_characters='',.''') AS VALOR_COMPRA,
NULL,
      
CASE
  WHEN PAG.NROFORMAPAGTO = 77 THEN 'PAGAMENTO EM LOJA'
  WHEN PAG.NROFORMAPAGTO = 79 THEN 'ELO DEBITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 7 THEN 'VALE ALIMENTACAO'
  WHEN PAG.NROFORMAPAGTO = 51 THEN 'MASTERCARD CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 50 THEN 'VISA CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 53 THEN 'AMERICAN EXPRESS CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 6 THEN 'AURA CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 52 THEN 'DINNERS CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 56 THEN 'ELO CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 55 THEN 'HIPERCARD CREDITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 78 THEN 'MASTERCARD DEBITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 58 THEN 'VISA DEBITO ONLINE'
  WHEN PAG.NROFORMAPAGTO = 77 THEN 'PAGAMENTO EM LOJA'
  WHEN PAG.NROFORMAPAGTO = 57 THEN 'INFOCARDS'
  WHEN PAG.NROFORMAPAGTO = 35 THEN 'PIX ONLINE'
  WHEN PAG.NROFORMAPAGTO = 524 THEN 'PAGAMENTO IFOOD RETIRA ONLINE'
  WHEN PAG.NROFORMAPAGTO = 523 THEN 'PAGAMENTO IFOOD ENTREGA ONLINE'
  WHEN PAG.NROFORMAPAGTO = 81 THEN 'VOUCHER MARKETING NAGUMO'
  WHEN PAG.NROFORMAPAGTO = 65 THEN 'VOUCHER SITE MERCADO'
  ELSE 'VERIFICAR PAGAMENTO'
  END AS FORMA_PAGAMENTO,
  
NULL,NULL,NULL, #NR1 LOJA

FROM CONSINCO.ECOMM_PDV_VENDA PED
  INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)
  LEFT JOIN (select d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, sum(p.vlrlancamento) as vlrlancamento, d.dtamovimento
              from consinco.pdv_docto d
              inner join consinco.pdv_doctopagto p on d.seqdocto = p.seqdocto
              where d.nrosegmento = (DECODE(:LS1,'Mixter','8','Nagumo SP','5'))
              and p.nroformapagto not in (65, 81) 
              and p.vlrlancamento != 0.01
              group by d.nroempresa, d.nrosegmento, d.nrocheckout, d.numerodf, d.dtamovimento) SD ON PED.NROPEDVENDA = SD.NUMERODF 
              
AND PED.NROREPRESENTANTE = SD.NROCHECKOUT AND SD.NROEMPRESA = :NR1
WHERE TRUNC(PED.DTAINCLUSAO) BETWEEN :DT1 AND :DT2
AND PED.NROEMPRESA = :NR1

GROUP BY 
PAG.NROFORMAPAGTO 

ORDER BY 8, 10 ) A;


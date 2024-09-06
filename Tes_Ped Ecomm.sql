-- Para eventuais backups

SELECT /*+OPTIMIZER_FEATURES_ENABLE('19.1.0')*/
 A.*,
 
 (SELECT /*'     ',NULL,NULL,'PEDIDO CONFERIDO AGUARDANDO CLIENTE','TOTAL CONFERIDO',*/
  
   TO_CHAR(SUM(CASE
                 WHEN (PAG.NROFORMAPAGTO = 65 OR PAG.NROFORMAPAGTO = 81 OR
                      PAG.NROFORMAPAGTO = 84 OR PAG.NROFORMAPAGTO = 31 OR
                      PAG.NROFORMAPAGTO = 9)
                      AND PED.STATUSPEDIDO != 'X' THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'N'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  B.VLRORIGINAL
                 WHEN PED.STATUSPEDIDO = 'L'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'U'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'T'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'C'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 ELSE
                  SD.VLRLANCAMENTO
               END),
           'FM999G999G999D90',
           'nls_numeric_characters='',.''') AS VALOR_COMPRA
  
    FROM CONSINCO.ECOMM_PDV_VENDA PED
  
   INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG
      ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)
    LEFT JOIN CONSINCO.MAD_PEDVENDA A
      ON (PED.NROPEDCLIENTE = A.IDTRANSACAOECOMMERCE)
    LEFT JOIN CONSINCO.FI_TITULO B
      ON (A.NROCARGA = B.NROCARGA AND A.SEQPESSOA = B.SEQPESSOANOTA AND
         B.CODESPECIE NOT IN ('VOUCEC'))
    LEFT JOIN (SELECT D.NROEMPRESA,
                     D.NROSEGMENTO,
                     D.NROCHECKOUT,
                     D.NUMERODF,
                     SUM(P.VLRLANCAMENTO) AS VLRLANCAMENTO,
                     D.DTAMOVIMENTO
              
                FROM CONSINCO.PDV_DOCTO D
              
               INNER JOIN CONSINCO.PDV_DOCTOPAGTO P
                  ON D.SEQDOCTO = P.SEQDOCTO
              
               WHERE D.NROSEGMENTO =
                     (DECODE(:LS1, 'Mixter', '8', 'Nagumo SP', '5'))
                    
                     AND P.NROFORMAPAGTO NOT IN (65, 81, 84, 31, 9)
                    
                     AND P.VLRLANCAMENTO != 0.01
                     AND D.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
              
               GROUP BY D.NROEMPRESA,
                        D.NROSEGMENTO,
                        D.NROCHECKOUT,
                        D.NUMERODF,
                        D.DTAMOVIMENTO) SD
      ON PED.NROPEDVENDA = SD.NUMERODF
        
         AND PED.NROREPRESENTANTE = SD.NROCHECKOUT
         AND SD.NROEMPRESA = :NR1
  
   WHERE NVL(TRUNC(SD.DTAMOVIMENTO),
             NVL(TRUNC(B.DTAEMISSAO), TRUNC(PED.DTAINCLUSAO))) BETWEEN :DT1 AND :DT2
        
         AND PED.NROEMPRESA = :NR1
        
         AND PED.STATUSPEDIDO = 'C') TOTAL_CONFERIDO,
 
 (SELECT /* '       ',NULL,NULL,'PEDIDO LIVRE','TOTAL LIVRE',*/
  
   TO_CHAR(SUM(CASE
                 WHEN (PAG.NROFORMAPAGTO = 65 OR PAG.NROFORMAPAGTO = 81 OR
                      PAG.NROFORMAPAGTO = 84 OR PAG.NROFORMAPAGTO = 31 OR
                      PAG.NROFORMAPAGTO = 9)
                      AND PED.STATUSPEDIDO != 'X' THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'N'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  B.VLRORIGINAL
                 WHEN PED.STATUSPEDIDO = 'L'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'U'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'T'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'C'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 ELSE
                  SD.VLRLANCAMENTO
               END),
           'FM999G999G999D90',
           'nls_numeric_characters='',.''') AS VALOR_COMPRA
  
    FROM CONSINCO.ECOMM_PDV_VENDA PED
  
   INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG
      ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)
    LEFT JOIN CONSINCO.MAD_PEDVENDA A
      ON (PED.NROPEDCLIENTE = A.IDTRANSACAOECOMMERCE)
    LEFT JOIN CONSINCO.FI_TITULO B
      ON (A.NROCARGA = B.NROCARGA AND A.SEQPESSOA = B.SEQPESSOANOTA AND
         B.CODESPECIE NOT IN ('VOUCEC'))
    LEFT JOIN (SELECT D.NROEMPRESA,
                     D.NROSEGMENTO,
                     D.NROCHECKOUT,
                     D.NUMERODF,
                     SUM(P.VLRLANCAMENTO) AS VLRLANCAMENTO,
                     D.DTAMOVIMENTO
              
                FROM CONSINCO.PDV_DOCTO D
              
               INNER JOIN CONSINCO.PDV_DOCTOPAGTO P
                  ON D.SEQDOCTO = P.SEQDOCTO
              
               WHERE D.NROSEGMENTO =
                     (DECODE(:LS1, 'Mixter', '8', 'Nagumo SP', '5'))
                    
                     AND P.NROFORMAPAGTO NOT IN (65, 81, 84, 31, 9)
                     AND P.VLRLANCAMENTO != 0.01
                     AND D.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
              
               GROUP BY D.NROEMPRESA,
                        D.NROSEGMENTO,
                        D.NROCHECKOUT,
                        D.NUMERODF,
                        D.DTAMOVIMENTO) SD
      ON PED.NROPEDVENDA = SD.NUMERODF
        
         AND PED.NROREPRESENTANTE = SD.NROCHECKOUT
         AND SD.NROEMPRESA = :NR1
  
   WHERE NVL(TRUNC(SD.DTAMOVIMENTO),
             NVL(TRUNC(B.DTAEMISSAO), TRUNC(PED.DTAINCLUSAO))) BETWEEN :DT1 AND :DT2
        
         AND PED.NROEMPRESA = :NR1
        
         AND PED.STATUSPEDIDO = 'L') TOTAL_LIVRE,
 
 (SELECT /*'         ',NULL,NULL,'TOTAL GERAL: SEM PEDIDO CONFERIDO E PEDIDO LIVRE','TOTAL GERAL',*/
  
   TO_CHAR(SUM(CASE
                 WHEN (PAG.NROFORMAPAGTO = 65 OR PAG.NROFORMAPAGTO = 81 OR
                      PAG.NROFORMAPAGTO = 84 OR PAG.NROFORMAPAGTO = 31 OR
                      PAG.NROFORMAPAGTO = 9)
                      AND PED.STATUSPEDIDO != 'X' THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'N'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  B.VLRORIGINAL
                 WHEN PED.STATUSPEDIDO = 'L'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'U'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'T'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 WHEN PED.STATUSPEDIDO = 'C'
                      AND PAG.NROFORMAPAGTO != 65
                      AND PAG.NROFORMAPAGTO != 81
                      AND PAG.NROFORMAPAGTO != 84 THEN
                  PAG.VALOR
                 ELSE
                  SD.VLRLANCAMENTO
               END),
           'FM999G999G999D90',
           'nls_numeric_characters='',.''') AS VALOR_COMPRA
  
    FROM CONSINCO.ECOMM_PDV_VENDA PED
  
   INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG
      ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)
    LEFT JOIN CONSINCO.MAD_PEDVENDA A
      ON (PED.NROPEDCLIENTE = A.IDTRANSACAOECOMMERCE)
    LEFT JOIN CONSINCO.FI_TITULO B
      ON (A.NROCARGA = B.NROCARGA AND A.SEQPESSOA = B.SEQPESSOANOTA AND
         B.CODESPECIE NOT IN ('VOUCEC'))
    LEFT JOIN (SELECT D.NROEMPRESA,
                     D.NROSEGMENTO,
                     D.NROCHECKOUT,
                     D.NUMERODF,
                     SUM(P.VLRLANCAMENTO) AS VLRLANCAMENTO,
                     D.DTAMOVIMENTO
              
                FROM CONSINCO.PDV_DOCTO D
              
               INNER JOIN CONSINCO.PDV_DOCTOPAGTO P
                  ON D.SEQDOCTO = P.SEQDOCTO
              
               WHERE D.NROSEGMENTO =
                     (DECODE(:LS1, 'Mixter', '8', 'Nagumo SP', '5'))
                    
                     AND P.NROFORMAPAGTO NOT IN (65, 81, 84, 31, 9)
                    
                     AND P.VLRLANCAMENTO != 0.01
                     AND D.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
              
               GROUP BY D.NROEMPRESA,
                        D.NROSEGMENTO,
                        D.NROCHECKOUT,
                        D.NUMERODF,
                        D.DTAMOVIMENTO) SD
      ON PED.NROPEDVENDA = SD.NUMERODF
        
         AND PED.NROREPRESENTANTE = SD.NROCHECKOUT
         AND SD.NROEMPRESA = :NR1
  
   WHERE NVL(TRUNC(SD.DTAMOVIMENTO),
             NVL(TRUNC(B.DTAEMISSAO), TRUNC(PED.DTAINCLUSAO))) BETWEEN :DT1 AND :DT2
        
         AND PED.NROEMPRESA = :NR1
        
         AND PED.STATUSPEDIDO != 'L'
        
         AND PED.STATUSPEDIDO != 'C') TOTAL_GERAL

  FROM (
        
        SELECT
        
         ' ',
          NVL(B.NRODOCUMENTO, SD.NUMERODF) AS NUMERO_NF_CUPOM,
          PED.NROREPRESENTANTE AS PDV,
          
          CASE
          
            WHEN PED.STATUSPEDIDO = 'U' THEN
             'EM USO'
          
            WHEN PED.STATUSPEDIDO = 'F' THEN
             'FINALIZADO'
          
            WHEN PED.STATUSPEDIDO = 'N' THEN
             'NOTA FISCAL'
          
            WHEN PED.STATUSPEDIDO = 'X' THEN
             'CANCELADO'
          
            WHEN PED.STATUSPEDIDO = 'C' THEN
             'CONFERIDO AGUARDANDO CLIENTE'
          
            WHEN PED.STATUSPEDIDO = 'T' THEN
             'TRANSITANDO'
          
            ELSE
             'PEDIDO LIVRE'
          END AS STATUS_PEDIDO,
          
          PED.NROPEDCLIENTE AS PEDIDO_ECOMMERCE,
          
          TO_CHAR(CASE
                    WHEN (PAG.NROFORMAPAGTO = 65 OR PAG.NROFORMAPAGTO = 81 OR
                         PAG.NROFORMAPAGTO = 84 OR PAG.NROFORMAPAGTO = 31 OR
                         PAG.NROFORMAPAGTO = 9)
                         AND PED.STATUSPEDIDO != 'X' THEN
                     PAG.VALOR
                    WHEN PED.STATUSPEDIDO = 'N'
                         AND PAG.NROFORMAPAGTO != 65
                         AND PAG.NROFORMAPAGTO != 81
                         AND PAG.NROFORMAPAGTO != 84 THEN
                     B.VLRORIGINAL
                    WHEN PED.STATUSPEDIDO = 'L'
                         AND PAG.NROFORMAPAGTO != 65
                         AND PAG.NROFORMAPAGTO != 81
                         AND PAG.NROFORMAPAGTO != 84 THEN
                     PAG.VALOR
                    WHEN PED.STATUSPEDIDO = 'U'
                         AND PAG.NROFORMAPAGTO != 65
                         AND PAG.NROFORMAPAGTO != 81
                         AND PAG.NROFORMAPAGTO != 84 THEN
                     PAG.VALOR
                    WHEN PED.STATUSPEDIDO = 'T'
                         AND PAG.NROFORMAPAGTO != 65
                         AND PAG.NROFORMAPAGTO != 81
                         AND PAG.NROFORMAPAGTO != 84 THEN
                     PAG.VALOR
                    WHEN PED.STATUSPEDIDO = 'C'
                         AND PAG.NROFORMAPAGTO != 65
                         AND PAG.NROFORMAPAGTO != 81
                         AND PAG.NROFORMAPAGTO != 84 THEN
                     PAG.VALOR
                    ELSE
                     SD.VLRLANCAMENTO
                  END,
                  'FM999G999G999D90',
                  'nls_numeric_characters='',.''') AS VALOR_COMPRA,
          
          CASE
            WHEN PAG.NROFORMAPAGTO = 65
                 OR PAG.NROFORMAPAGTO = 81 THEN
             'PGTO DESCONTO'
          
            ELSE
             'PGTO CLIENTE'
          END AS DESCRICAO_PAGAMENTO,
          
          CASE
            WHEN PAG.NROFORMAPAGTO = 77 THEN
             'PAGAMENTO EM LOJA'
          
            WHEN PAG.NROFORMAPAGTO = 79 THEN
             'ELO DEBITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 7 THEN
             'VALE ALIMENTACAO'
          
            WHEN PAG.NROFORMAPAGTO = 51 THEN
             'MASTERCARD CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 50 THEN
             'VISA CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 53 THEN
             'AMERICAN EXPRESS CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 6 THEN
             'AURA CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 52 THEN
             'DINNERS CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 56 THEN
             'ELO CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 55 THEN
             'HIPERCARD CREDITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 78 THEN
             'MASTERCARD DEBITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 58 THEN
             'VISA DEBITO ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 77 THEN
             'PAGAMENTO EM LOJA'
          
            WHEN PAG.NROFORMAPAGTO = 57 THEN
             'INFOCARDS'
          
            WHEN PAG.NROFORMAPAGTO = 35 THEN
             'PIX ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 524 THEN
             'PAGAMENTO IFOOD RETIRA ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 523 THEN
             'PAGAMENTO IFOOD ENTREGA ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 81 THEN
             'VOUCHER MARKETING NAGUMO'
          
            WHEN PAG.NROFORMAPAGTO = 65 THEN
             'VOUCHER SITE MERCADO'
          
            WHEN PAG.NROFORMAPAGTO = 525 THEN
             'PAGAMENTO AMERICANAS ENTREGA ONLINE'
          
            WHEN PAG.NROFORMAPAGTO = 526 THEN
             'PAGAMENTO AMERICANAS RETIRA ONLINE'
            WHEN PAG.NROFORMAPAGTO = 527 THEN
             'PAGAMENTO IFOOD B2B'
            WHEN PAG.NROFORMAPAGTO = 84 THEN
             'VOUCHER IFOOD'
          
            ELSE
             'VERIFICAR PAGAMENTO'
          END AS FORMA_PAGAMENTO,
          
          TO_CHAR(NVL(SD.DTAMOVIMENTO, B.DTAEMISSAO), 'DD/MM/YYYY') AS DATA_FATURAMENTO_CUPOM_PDV,
          
          TO_CHAR(PED.DTAINCLUSAO, 'DD/MM/YYYY HH24:MI:SS') AS DATA_EXPORTACAO_COLETOR,
          
          /*CASE
            WHEN INSTR(UPPER(ped.OBSPEDIDO), 'ID PEDIDO IFOOD:') > 0 THEN
             TRIM(SUBSTR(UPPER(ped.OBSPEDIDO),
                         
                         INSTR(UPPER(ped.OBSPEDIDO), 'ID PEDIDO IFOOD:') +
                         LENGTH('ID PEDIDO IFOOD:'),
                         INSTR(LTRIM(SUBSTR(UPPER(ped.OBSPEDIDO),
                                            
                                            INSTR(UPPER(ped.OBSPEDIDO),
                                                  'ID PEDIDO IFOOD:') +
                                            LENGTH('ID PEDIDO IFOOD:'),
                                            LENGTH(UPPER(ped.OBSPEDIDO)))),
                               ' ')))
          
            ELSE
            
            
             NULL
          END AS ID_PEDIDO_IFOOD*/
          CASE
            WHEN LENGTH(SUBSTR(UPPER(PED.OBSPEDIDO),
                               INSTR(UPPER(PED.OBSPEDIDO), 'PEDIDO ID IFOOD:') +
                               LENGTH('PEDIDO ID IFOOD:'))) > 4 THEN
             '0'
            WHEN SUBSTR(UPPER(PED.OBSPEDIDO),
                        INSTR(UPPER(PED.OBSPEDIDO), 'PEDIDO ID IFOOD:') +
                        LENGTH('PEDIDO ID IFOOD:')) = 'NONE' THEN
             '0'
            ELSE
             SUBSTR(UPPER(PED.OBSPEDIDO),
                    INSTR(UPPER(PED.OBSPEDIDO), 'PEDIDO ID IFOOD:') +
                    LENGTH('PEDIDO ID IFOOD:'))
          END ID_PEDIDO_IFOOD,
          
          #NR1 LOJA
        
          FROM CONSINCO.ECOMM_PDV_VENDA PED
        
         INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG
            ON (PAG.SEQEDIPEDVENDA = PED.SEQEDIPEDVENDA)
        
          LEFT JOIN CONSINCO.MAD_PEDVENDA A
            ON (PED.NROPEDCLIENTE = A.IDTRANSACAOECOMMERCE AND
               A.SITUACAOPED != 'C')
        
          LEFT JOIN CONSINCO.FI_TITULO B
            ON (A.NROCARGA = B.NROCARGA AND A.SEQPESSOA = B.SEQPESSOANOTA AND
               B.CODESPECIE NOT IN ('VOUCEC'))
        
          LEFT JOIN (SELECT D.NROEMPRESA,
                            D.NROSEGMENTO,
                            D.NROCHECKOUT,
                            D.NUMERODF,
                            SUM(P.VLRLANCAMENTO) AS VLRLANCAMENTO,
                            D.DTAMOVIMENTO
                     
                       FROM CONSINCO.PDV_DOCTO D
                     
                      INNER JOIN CONSINCO.PDV_DOCTOPAGTO P
                         ON D.SEQDOCTO = P.SEQDOCTO
                     
                      WHERE D.NROSEGMENTO =
                            (DECODE(:LS1, 'Mixter', '8', 'Nagumo SP', '5'))
                           
                            AND P.NROFORMAPAGTO NOT IN (65, 81, 84, 31, 9)
                           
                            AND P.VLRLANCAMENTO != 0.01
                            AND D.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
                     
                      GROUP BY D.NROEMPRESA,
                               D.NROSEGMENTO,
                               D.NROCHECKOUT,
                               D.NUMERODF,
                               D.DTAMOVIMENTO) SD
            ON PED.NROPEDVENDA = SD.NUMERODF
              
               AND PED.NROREPRESENTANTE = SD.NROCHECKOUT
               AND SD.NROEMPRESA = :NR1
        
         WHERE NVL(TRUNC(SD.DTAMOVIMENTO),
                   NVL(TRUNC(B.DTAEMISSAO), TRUNC(PED.DTAINCLUSAO))) BETWEEN :DT1 AND :DT2
              
               AND PED.NROEMPRESA = :NR1
        
         GROUP BY B.NRODOCUMENTO,
                   SD.NUMERODF,
                   PED.NROREPRESENTANTE,
                   PED.STATUSPEDIDO,
                   PED.NROPEDCLIENTE,
                   PED.OBSPEDIDO,
                   B.DTAEMISSAO,
                   PAG.NROFORMAPAGTO,
                   SD.VLRLANCAMENTO,
                   PAG.NROFORMAPAGTO,
                   SD.DTAMOVIMENTO,
                   PED.DTAINCLUSAO,
                   A.OBSPEDIDO,
                   PAG.VALOR,
                   B.VLRORIGINAL,
                   SD.NROEMPRESA
        
        UNION ALL
        
        SELECT '   ',
                NULL,
                NULL,
                NULL,
                'SUBTOTAL',
                
                TO_CHAR(SUM(CASE
                              WHEN (PAG.NROFORMAPAGTO = 65 OR PAG.NROFORMAPAGTO = 81 OR
                                   PAG.NROFORMAPAGTO = 84 OR PAG.NROFORMAPAGTO = 31 OR
                                   PAG.NROFORMAPAGTO = 9)
                                   AND PED.STATUSPEDIDO != 'X' THEN
                               PAG.VALOR
                              WHEN PED.STATUSPEDIDO = 'N'
                                   AND PAG.NROFORMAPAGTO != 65
                                   AND PAG.NROFORMAPAGTO != 81
                                   AND PAG.NROFORMAPAGTO != 84 THEN
                               B.VLRORIGINAL
                              WHEN PED.STATUSPEDIDO = 'L'
                                   AND PAG.NROFORMAPAGTO != 65
                                   AND PAG.NROFORMAPAGTO != 81
                                   AND PAG.NROFORMAPAGTO != 84 THEN
                               PAG.VALOR
                              WHEN PED.STATUSPEDIDO = 'U'
                                   AND PAG.NROFORMAPAGTO != 65
                                   AND PAG.NROFORMAPAGTO != 81
                                   AND PAG.NROFORMAPAGTO != 84 THEN
                               PAG.VALOR
                              WHEN PED.STATUSPEDIDO = 'T'
                                   AND PAG.NROFORMAPAGTO != 65
                                   AND PAG.NROFORMAPAGTO != 81
                                   AND PAG.NROFORMAPAGTO != 84 THEN
                               PAG.VALOR
                              WHEN PED.STATUSPEDIDO = 'C'
                                   AND PAG.NROFORMAPAGTO != 65
                                   AND PAG.NROFORMAPAGTO != 81
                                   AND PAG.NROFORMAPAGTO != 84 THEN
                               PAG.VALOR
                              ELSE
                               SD.VLRLANCAMENTO
                            END),
                        'FM999G999G999D90',
                        'nls_numeric_characters='',.''') AS VALOR_COMPRA,
                
                NULL,
                
                CASE
                
                  WHEN PAG.NROFORMAPAGTO = 77 THEN
                   'PAGAMENTO EM LOJA'
                
                  WHEN PAG.NROFORMAPAGTO = 79 THEN
                   'ELO DEBITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 7 THEN
                   'VALE ALIMENTACAO'
                
                  WHEN PAG.NROFORMAPAGTO = 51 THEN
                   'MASTERCARD CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 50 THEN
                   'VISA CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 53 THEN
                   'AMERICAN EXPRESS CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 6 THEN
                   'AURA CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 52 THEN
                   'DINNERS CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 56 THEN
                   'ELO CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 55 THEN
                   'HIPERCARD CREDITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 78 THEN
                   'MASTERCARD DEBITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 58 THEN
                   'VISA DEBITO ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 77 THEN
                   'PAGAMENTO EM LOJA'
                
                  WHEN PAG.NROFORMAPAGTO = 57 THEN
                   'INFOCARDS'
                
                  WHEN PAG.NROFORMAPAGTO = 35 THEN
                   'PIX ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 524 THEN
                   'PAGAMENTO IFOOD RETIRA ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 523 THEN
                   'PAGAMENTO IFOOD ENTREGA ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 81 THEN
                   'VOUCHER MARKETING NAGUMO'
                
                  WHEN PAG.NROFORMAPAGTO = 65 THEN
                   'VOUCHER SITE MERCADO'
                
                  WHEN PAG.NROFORMAPAGTO = 525 THEN
                   'PAGAMENTO AMERICANAS ENTREGA ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 526 THEN
                   'PAGAMENTO AMERICANAS RETIRA ONLINE'
                
                  WHEN PAG.NROFORMAPAGTO = 527 THEN
                   'PAGAMENTO IFOOD B2B'
                
                  WHEN PAG.NROFORMAPAGTO = 84 THEN
                   'VOUCHER IFOOD'
                
                  ELSE
                   'VERIFICAR PAGAMENTO'
                
                END AS FORMA_PAGAMENTO,
                
                NULL,
                NULL,
                NULL,
                #NR1 LOJA
        
          FROM CONSINCO.ECOMM_PDV_VENDA PED
        
         INNER JOIN CONSINCO.ECOMM_PDV_PAGTO PAG
            ON (PED.SEQEDIPEDVENDA = PAG.SEQEDIPEDVENDA)
          LEFT JOIN CONSINCO.MAD_PEDVENDA A
            ON (PED.NROPEDCLIENTE = A.IDTRANSACAOECOMMERCE)
          LEFT JOIN CONSINCO.FI_TITULO B
            ON (A.NROCARGA = B.NROCARGA AND A.SEQPESSOA = B.SEQPESSOANOTA AND
               B.CODESPECIE NOT IN ('VOUCEC'))
          LEFT JOIN (SELECT D.NROEMPRESA,
                            D.NROSEGMENTO,
                            D.NROCHECKOUT,
                            D.NUMERODF,
                            SUM(P.VLRLANCAMENTO) AS VLRLANCAMENTO,
                            D.DTAMOVIMENTO
                     
                       FROM CONSINCO.PDV_DOCTO D
                     
                      INNER JOIN CONSINCO.PDV_DOCTOPAGTO P
                         ON D.SEQDOCTO = P.SEQDOCTO
                     
                      WHERE D.NROSEGMENTO =
                            (DECODE(:LS1, 'Mixter', '8', 'Nagumo SP', '5'))
                           
                            AND P.NROFORMAPAGTO NOT IN (65, 81, 84, 31, 9)
                            AND P.VLRLANCAMENTO != 0.01
                            AND D.DTAMOVIMENTO BETWEEN :DT1 AND :DT2
                     
                      GROUP BY D.NROEMPRESA,
                               D.NROSEGMENTO,
                               D.NROCHECKOUT,
                               D.NUMERODF,
                               D.DTAMOVIMENTO) SD
            ON PED.NROPEDVENDA = SD.NUMERODF
              
               AND PED.NROREPRESENTANTE = SD.NROCHECKOUT
               AND SD.NROEMPRESA = :NR1
        
         WHERE NVL(TRUNC(SD.DTAMOVIMENTO),
                   NVL(TRUNC(B.DTAEMISSAO), TRUNC(PED.DTAINCLUSAO))) BETWEEN :DT1 AND :DT2
              
               AND PED.NROEMPRESA = :NR1
        
         GROUP BY PAG.NROFORMAPAGTO
        
         ORDER BY 8, 10) A;

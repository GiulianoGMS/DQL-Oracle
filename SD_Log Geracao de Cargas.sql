-- Bruna Macedo | Log Carga PDV | Tkt 423552

-- Tabela

CREATE TABLE CONSINCO.NAGT_LOG_CARGAPDV (NROEMPRESA NUMBER(3),
                                         DTALOG     DATE,
                                         USUARIOEXE VARCHAR2(50),
                                         INDGERAPDV VARCHAR2(1),
                                         INDGERABALANCA VARCHAR2(1),
                                         TIPOCARGA VARCHAR2(1));
                                         
SELECT * FROM CONSINCO.NAGT_LOG_CARGAPDV

         -- Gravando Log - Solic Bruna Macedo - Tkt 423552 - Giuliano 08/07/2024
         
         INSERT INTO NAGT_LOG_CARGAPDV L VALUES (EMP.NROEMPRESA, SYSDATE, (SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
                                                 DECODE(psTIPOLOG, 'Não Gera', 'N', 'Parcial', 'P', 'Total', 'T'),
                                                 DECODE(psBALANCA, 'Não', 'N',      'Parcial', 'P', 'Total', 'T'),
                                                 NULL);
         COMMIT;

          -- Gravando Log - Solic Bruna Macedo - Tkt 423552 - Giuliano 08/07/2024 no JOB
         
         INSERT INTO NAGT_LOG_CARGAPDV L VALUES (i.NROEMPRESA, SYSDATE, 'JOB_CARGAPDV',
                                                 DECODE(vsTipoCarga, 'Não Gera', 'N', 'Parcial', 'P', 'Total', 'T'),
                                                 DECODE(vsTipoCarga, 'Não', 'N',      'Parcial', 'P', 'Total', 'T'),
                                                 NULL);
         COMMIT;

--========================== Consulta/View C5

SELECT * FROM (

SELECT M.NROEMPRESA, A.SEQPRODUTO PLU, DESCCOMPLETA,
       TO_CHAR(GREATEST(MAX(B.DTAALTERACAO), MAX(B.DTAGERACAOPRECO), MAX(PL.DTAHORALTERACAO)), 'DD/MM/YYYY HH24:MI:SS') DTA_ULTIMA_ALT,
       TO_CHAR(L.DTALOG, 'DD/MM/YYYY HH24:MI:SS') DTA_CARGA, L.USUARIOEXE USUARIO_GEROU, 
       DECODE(NVL(L.INDGERAPDV, 'N'),     'N',' Não', 'P', 'Parcial', 'T', 'Total') IND_GEROU_PDV,
       DECODE(NVL(L.INDGERABALANCA, 'N'), 'N',' Não', 'P', 'Parcial', 'T', 'Total') IND_GEROU_BAL
       
  FROM CONSINCO.MAP_PRODUTO A INNER JOIN CONSINCO.MRL_PRODEMPSEG B    ON A.SEQPRODUTO = B.SEQPRODUTO
                              INNER JOIN CONSINCO.MAX_EMPRESA M       ON M.NROEMPRESA = B.NROEMPRESA AND M.NROSEGMENTOPRINC = B.NROSEGMENTO
                               LEFT JOIN CONSINCO.NAGT_LOG_CARGAPDV L ON L.NROEMPRESA = B.NROEMPRESA 
                               LEFT JOIN CONSINCO.MAP_PRODCODIGO  E   ON E.SEQPRODUTO = A.SEQPRODUTO AND E.QTDEMBALAGEM = B.QTDEMBALAGEM AND E.TIPCODIGO = 'E'
                               LEFT JOIN CONSINCO.MAD_PRODLOGPRECO PL ON PL.SEQPRODUTO  = A.SEQPRODUTO
                                                                     AND PL.NROEMPRESA  = B.NROEMPRESA
                                                                     AND PL.NROSEGMENTO = B.NROSEGMENTO
                                                                     AND PL.QTDEMBALAGEM = B.QTDEMBALAGEM
                              
                              
 WHERE (A.SEQPRODUTO = :NR1 OR E.CODACESSO = :NR2)
   AND B.QTDEMBALAGEM = 1
   AND B.NROEMPRESA = :LS1
   
 GROUP BY M.NROEMPRESA, A.SEQPRODUTO, DESCCOMPLETA, TO_CHAR(L.DTALOG, 'DD/MM/YYYY HH24:MI:SS'), L.USUARIOEXE, L.INDGERAPDV, L.INDGERABALANCA)
 
 WHERE DTA_CARGA >= DTA_ULTIMA_ALT 
   
 ORDER BY 1
 
--======
 
SELECT * FROM CONSINCO.NAGT_LOG_CARGAPDV XX

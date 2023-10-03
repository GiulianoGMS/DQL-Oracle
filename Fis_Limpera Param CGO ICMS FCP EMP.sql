/* Limpeza de parametrizações dentro dos CGOs.
   Parâmetro Subtrair ICMS/FCP base pis/cofins - Por Empresa*/

-- Backup

CREATE TABLE CONSINCO.NAGT_MAX_CGOEMPRESA_BKP AS
SELECT * FROM CONSINCO.MAX_CGOEMPRESA;

-- Apagando

DELETE FROM CONSINCO.MAX_CGOEMPRESA X WHERE 1=1;
COMMIT;

-- Conferindo

SELECT * FROM CONSINCO.MAX_CGOEMPRESA 

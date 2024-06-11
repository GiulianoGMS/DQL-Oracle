-- Incluir em MLFV_AUXNOTAFISCALINCONS
-- Ticket 408539 | Adicionado por Giuliano em 11/06/24
-- Solic Silene Fiscal - Barrar data de entrada divergente nas notas de remessa amarradas

SELECT DISTINCT (X.SEQAUXNOTAFISCAL) AS SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                0   AS SEQAUXNFITEM,
                'B' AS BLOQAUTOR,
                79  AS CODINCONSISTENC,
                'A data de entrada da NF está divergente da data de remessa amarrada! Data NF CGO '||X.CODGERALOPER||': '||TO_CHAR(X.DTAENTRADA, 'DD/MM/YYYY')||
                ' - CGO '||X2.CODGERALOPER||': '||TO_CHAR(X2.DTAENTRADA, 'DD/MM/YYYY')
                
  FROM MLF_AUXNOTAFISCAL X INNER JOIN CONSINCO.NAGV_NF_RELAC_REMESSA R ON X.SEQAUXNOTAFISCAL  = R.SEQAUX_O
                           INNER JOIN CONSINCO.MLF_AUXNOTAFISCAL X2    ON X2.SEQAUXNOTAFISCAL = R.SEQAUX_R
 WHERE 1=1
   AND X.DTAENTRADA != X2.DTAENTRADA
   AND X.CODGERALOPER IN (116,121)


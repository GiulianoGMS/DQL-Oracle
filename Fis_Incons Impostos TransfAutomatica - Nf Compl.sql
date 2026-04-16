-- Adicionar em MLFV_AUXNOTAFISCALINCONS

-- Ticket 711231
-- Giuliano/Julio 16/04/26
-- Barrar Imp Emissao x Imp Calculado Transf Automatica

SELECT DISTINCT X.SEQAUXNOTAFISCAL,
                X.NUMERONF,
                X.NROEMPRESA,
                Y.SEQAUXNFITEM,
                'L' AS BLOQAUTOR,
                108 AS CODINCONSISTENC,
                'Impostos de Entrada Divergentes da Emissão. Informe a NF Complementar na Justificativa do Aceite e assine para dar sequência.'

  FROM consinco.MLF_AUXNOTAFISCAL X INNER JOIN consinco.MLF_AUXNFITEM Y ON X.SEQAUXNOTAFISCAL = Y.SEQAUXNOTAFISCAL
                                 INNER JOIN TMP_M000_NF Z ON Z.M000_NR_CHAVE_ACESSO = X.NFECHAVEACESSO
                                 INNER JOIN TMP_M014_ITEM A ON A.M000_ID_NF = Z.M000_ID_NF AND A.M014_NR_ITEM = Y.SEQITEMNFXML
                                 INNER JOIN MAX_CODGERALOPER B ON B.CODGERALOPER = X.CODGERALOPER

 WHERE B.TIPDOCFISCAL = 'T'
   AND B.TIPCGO = 'E'
   AND X.APPORIGEM = 9
   AND X.NUMERONF != 645036
   AND TO_CHAR(X.DTAEMISSAO, 'MM') != TO_CHAR(NVL(X.DTAENTRADA,X.DTAEMISSAO), 'MM') -- Apenas o que for emitido em mes diferente
   AND A.M014_VL_ICMS IS NULL AND Y.VLRICMS > 0                                     -- Nao tem ICMS no XML mas tem no calculado do ERP

UPDATE MAP_TRIBUTACAOUF A SET INDAPROPRIAST  = 'O', 
                              SITUACAONFDEV  = '000'
WHERE UFEMPRESA = 'SP' AND UFCLIENTEFORNEC = 'RS' AND TIPTRIBUTACAO IN ('EI', 'ED') AND NROREGTRIBUTACAO IN (0,2); 
COMMIT;

UPDATE MAP_TRIBUTACAOUF A SET INDAPROPRIAST  = 'O'
WHERE UFEMPRESA = 'SP' AND UFCLIENTEFORNEC = 'RS' AND TIPTRIBUTACAO IN ('EM') AND NROREGTRIBUTACAO IN (0,2); 
COMMIT;

UPDATE MAP_TRIBUTACAOUF A SET INDAPROPRIAST  = 'O', 
                              SITUACAONFDEV  = '000',
                              PERALIQUOTAST  = 20,
                              A.PERALIQFCPST = NULL,
                              A.BASEFCPST    = NULL
WHERE UFEMPRESA = 'RJ' AND UFCLIENTEFORNEC = 'RS' AND TIPTRIBUTACAO IN ('EI', 'ED') AND NROREGTRIBUTACAO IN (0,2); 
COMMIT;

UPDATE MAP_TRIBUTACAOUF A SET INDAPROPRIAST  = 'O',
                              PERALIQUOTAST  = 20,
                              A.PERALIQFCPST = NULL,
                              A.BASEFCPST    = NULL
WHERE UFEMPRESA = 'RJ' AND UFCLIENTEFORNEC = 'RS' AND TIPTRIBUTACAO IN ('EM') AND NROREGTRIBUTACAO IN (0,2); 
COMMIT;

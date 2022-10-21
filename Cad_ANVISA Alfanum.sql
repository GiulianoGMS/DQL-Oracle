-- Correção de informações no campo MOTIVOISENCAOMINSAUDE que estiverem com o símbolo º (Simbolo gera erro na integração)

UPDATE CONSINCO.MAP_PRODUTO A SET A.MOTIVOISENCAOMINSAUDE = 'Produtos da linha Pet.Base legal ART.86 LEI N 6360-73'
WHERE A.MOTIVOISENCAOMINSAUDE LIKE '%Produtos da linha Pet.Base legal ART.86 LEI Nº 6360-73%'

SELECT * FROM CONSINCO.MAP_PRODUTO A WHERE A.MOTIVOISENCAOMINSAUDE LIKE '%º%'

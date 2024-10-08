ALTER SESSION SET current_schema = CONSINCO;

SELECT  A.NROTITULO || '-' || A.SERIETITULO || '/' || A.NROPARCELA TITULO, A.NRODOCUMENTO, A.ORIGEM,  
    A.USUALTERACAO, A.NROEMPRESA,  
    A.CODESPECIE, A.DTAMOVIMENTO, 
    A.TIPOREGISTRO, A.VLRORIGINAL, 
    A.DTAVENCIMENTO, GE_PESSOA.SEQPESSOA ||'-'|| GE_PESSOA.NOMERAZAO 
  FROM  FI_INTTITULO A, GE_PESSOA 
  WHERE   A.SEQINTTITULO IN(
SELECT DISTINCT AA.CODLINK                                                                                                             
FROM FI_REJEITADO  AA 
 
WHERE AA.TABELA IN ( 'TIT' , 'CC' , 'CON'  ) 
AND EXISTS(SELECT 1 FROM FI_INTTITULO A WHERE A.SEQINTTITULO = AA.CODLINK)  

 )
 AND  
    GE_PESSOA.SEQPESSOA(+) = A.CODPESSOA
    -- PDs
AND VLRORIGINAL = 828.67

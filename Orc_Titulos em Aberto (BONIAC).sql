ALTER SESSION SET current_schema = CONSINCO;

-- Select Por REDE

SELECT to_number(SUBSTR(:LS1, INSTR(:LS1, ' - ')+3, LENGTH(:LS1) - INSTR(:LS1, ' - ')))
INTO  :NRA
FROM  DUAL;

SELECT f.nomereduzido AS LOJA,
       LPAD(SUBSTR(f.nrocgc, 0, LENGTH(f.nrocgc)-4), 8, 0) || '/' || 
       SUBSTR(f.nrocgc, -4) ||  '-' || LPAD(f.digcgc, 2, 0) AS cnpjloja,
       d.descricao || ' - ' || d.seqrede as rede,
       b.seqpessoa AS SeqFornec,
       b.nomerazao AS RazaoSocial,
       a.nrodocumento AS NroDocto,
       a.codespecie   As Especie,
       a.observacao   AS OBS,
       (a.vlroriginal - a.vlrpago) AS VlrAberto,
       LPAD(a.nroparcela, 3,0)   AS Parcela,
       TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') AS DtaVenc,
       NVL(a.dtaprogramada, a.dtavencimento) - TRUNC(SYSDATE) DiasAtraso
       
FROM   FI_TITULO A, GE_PESSOA B, GE_REDEPESSOA C, GE_REDE D, MAX_EMPRESA F
WHERE  A.ABERTOQUITADO = 'A'
AND C.SEQPESSOA = B.SEQPESSOA
AND A.SEQPESSOA = B.SEQPESSOA
AND D.SEQREDE   = C.SEQREDE
AND A.CODESPECIE IN ('BONIAC')
AND F.NROEMPRESA = A.NROEMPRESA   
AND A.DTAVENCIMENTO <= :DT1
AND D.SEQREDE = NRA

ORDER BY   F.NROEMPRESA, A.SEQPESSOA, A.DTAVENCIMENTO;

--Select Por Nome Fornecedor

SELECT f.nomereduzido AS LOJA,
       LPAD(SUBSTR(f.nrocgc, 0, LENGTH(f.nrocgc)-4), 8, 0) || '/' || 
       SUBSTR(f.nrocgc, -4) ||  '-' || LPAD(f.digcgc, 2, 0) AS cnpjloja,
       d.descricao || ' - ' || d.seqrede as rede,
       b.seqpessoa AS SeqFornec,
       b.nomerazao AS RazaoSocial,
       a.nrodocumento AS NroDocto,
       a.codespecie   As Especie,
       a.observacao   AS OBS,
       (a.vlroriginal - a.vlrpago) AS VlrAberto,
       LPAD(a.nroparcela, 3,0)   AS Parcela,
       TO_CHAR(A.DTAVENCIMENTO, 'DD/MM/YYYY') AS DtaVenc,
       NVL(a.dtaprogramada, a.dtavencimento) - TRUNC(SYSDATE) DiasAtraso
       
FROM   FI_TITULO A, GE_PESSOA B, GE_REDEPESSOA C, GE_REDE D, MAX_EMPRESA F
WHERE  A.ABERTOQUITADO = 'A'
AND C.SEQPESSOA = B.SEQPESSOA
AND A.SEQPESSOA = B.SEQPESSOA
AND D.SEQREDE   = C.SEQREDE
AND A.CODESPECIE IN ('BONIAC')
AND F.NROEMPRESA = A.NROEMPRESA   
AND A.DTAVENCIMENTO <= DATE '2022-05-02' --:DT1
AND B.NOMERAZAO LIKE ('%BRF%')

ORDER BY   F.NROEMPRESA, A.SEQPESSOA, A.DTAVENCIMENTO;

SELECT X.NROEMPRESA LOJA, NRONOTA, X.CODHISTORICO COD_NATUREZA,
       X.SEQPESSOA||' - '||G.NOMERAZAO FORNECEDOR,
       TO_CHAR(X.DTAEMISSAO, 'DD/MM/YYYY') DTAEMISSAO,
       TO_CHAR(X.DTAENTRADA, 'DD/MM/YYYY') DTAENTRADA,
       TO_CHAR(X.DTAINCLUSAO, 'DD/MM/YYYY') DTAINCLUSAO,
       X.VALOR,
       X.USUINCLUSAO, USUAUTORIZACAO
       
  FROM OR_NFDESPESA X INNER JOIN GE_PESSOA G ON G.SEQPESSOA = X.SEQPESSOA
                      INNER JOIN OR_REQUISICAO R ON X.REQUISICOES = R.SEQREQUISICAO
  
 WHERE X.SITUACAO = 'I'
   AND NROEMPRESA = #LS1
   AND DTAEMISSAO BETWEEN :DT1 AND :DT2
   AND R.USUAUTORIZACAO IN ('TCHAN',
                            'THIAGO',
                            'ACGUIMARAES', 
                            'ONAKAMURA',   
                            'JTERADA',     
                            'SHIDEUSABE',  
                            'LMANFE',      
                            'MSATORU',     
                            'OHRIECHEL',   
                            'MPONTES',     
                            'TAMURA',
                            'WISANTOS',    
                            'AUTREQ')

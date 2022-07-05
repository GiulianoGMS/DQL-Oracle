ALTER SESSION SET current_schema = CONSINCO;

SELECT DISTINCT A.NROEMPRESA EMPRESA, A.NRONOTA, A.DTAEMISSAO DATA_EMISSAO, A.DTAENTRADA DATA_LANCTO,
       A.SEQPESSOA||' - '||C.NOMERAZAO FORNECEDOR, A.CODHISTORICO NATUREZA_DESP, F.DESCRICAO DESC_NATUREZA,
       X.CODPRODUTO PLU, Y.DESCRICAO DESC_PRODUTO, A.VALOR

FROM consinco.or_nfdespesa a left join consinco.or_nfitensdespesa b on (a.seqnota=b.seqnota)
                             left join consinco.ge_pessoa c on (a.seqpessoa=c.seqpessoa)
                             left join consinco.aba_historico f on (f.seqhistorico=a.codhistorico)    
                             LEFT JOIN CONSINCO.RF_PARAMNATNFDESP X ON X.CODHISTORICO = A.CODHISTORICO
                             LEFT JOIN CONSINCO.ORV_PRODUTO Y       ON X.CODPRODUTO   = Y.CODPRODUTO 
                             
WHERE A.CODMODELO = '99'

AND A.DTAENTRADA BETWEEN '01-JULY-2022' AND '04-JULY-2022'
AND A.NROEMPRESA IN (1)

ORDER BY 1,4,5

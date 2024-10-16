-- Criar crítica em MAD_CRITICAPEDCONFIG 
-- Inserir select em MADV_CRITICAPEDVENDA

-- Giuliano em 16/10/2024 - Ticket 464094
-- Barra Prod sem tipo Industria na Familia quando o fornec é EX e emissora é CD Importador 502/503

SELECT DISTINCT A.NROPEDVENDA, A.NROEMPRESA, 'G:Tipo Fornec Incorreto - Fam' CODCRITICA

   FROM MAD_PEDVENDA A INNER JOIN MAD_PEDVENDAITEM B ON A.NROPEDVENDA = B.NROPEDVENDA
                       INNER JOIN MAP_PRODUTO P ON P.SEQPRODUTO = B.SEQPRODUTO
   
   WHERE 1=1
     AND EXISTS (SELECT 1 FROM MAP_FAMFORNEC FC INNER JOIN MAP_FAMILIA F ON F.SEQFAMILIA = FC.SEQFAMILIA
                                                INNER JOIN MAP_FAMDIVISAO FD ON FD.SEQFAMILIA = F.SEQFAMILIA
                  WHERE FC.SEQFORNECEDOR IN (502,503) 
                    AND NVL(FC.TIPFORNECEDORFAM, 'X') != 'I'
                    AND EXISTS (SELECT 1 FROM MAP_FAMFORNEC EX INNER JOIN GE_PESSOA G ON G.SEQPESSOA = EX.SEQFORNECEDOR
                                 WHERE EX.SEQFAMILIA = FC.SEQFAMILIA
                                   AND UF = 'EX') 
                                   AND NVL(FD.FINALIDADEFAMILIA,'X') != 'U'
                                   AND F.SEQFAMILIA = P.SEQFAMILIA)
                                   
   AND A.NROEMPRESA IN (502,503)

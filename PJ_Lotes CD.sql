ALTER SESSION SET current_schema = CONSINCO;

SELECT MLO_ENDERECOMOVTO.CODDEPOSITANTE,
 MLO_ENDERECOMOVTO.SEQENDERECOMOVTO, MLO_ENDERECOMOVTO.SEQENDERECOMOVTODEP, MLO_ENDERECOMOVTO.SEQENDERECOMOVTOESTQ,
  MLO_ENDERECOMOVTO.SEQENDERECO, MLO_ENDERECOMOVTO.SEQENDERECOORIDEST, MLO_ENDERECOMOVTO.NROCARGA, MLO_ENDERECOMOVTO.SEQLOTE,
   MLO_ENDERECOMOVTO.NROQUEBRA,  
NVL(( 
SELECT  XXX.SEQPALETERFAGRUP 
FROM  MLO_PALETE XXX 
Where  XXX.SEQPALETERF = MLO_ENDERECOMOVTO.SEQPALETERF), MLO_ENDERECOMOVTO.SEQPALETERF) 
, MLO_ENDERECOMOVTO.USUMOVTO, MLO_ENDERECOMOVTO.ETIQUETASELINVAUTO, MLO_ENDERECOMOVTO.DTAHORMOVTO, 
DECODE(MLO_ENDERECOMOVTO.INDENTRADASAIDA,'E','Entrada','S','Saida') ENTRADASAIDA, MLO_PRODUTO.SEQPRODUTO, MLO_PRODUTO.DESCCOMPLETA, MLO_ENDERECOMOVTO.TIPMOVTO,
   NVL(MLO_ENDERECOMOVTO.INDREPSEPPALINTEIRO,'N'), MLO_ENDERECOMOVTO.STATUSMOVTO, MLO_ENDERECOMOVTO.QTDMOVTO, 
   Nvl(MLO_ENDERECOMOVTO.QTDEMBALAGEM,0), MLO_ENDERECOMOVTO.SALDOENDERECO                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
FROM MLO_ENDERECOMOVTO, MLO_PRODUTO  
 
WHERE MLO_ENDERECOMOVTO.SEQPRODUTO = MLO_PRODUTO.SEQPRODUTO 
And MLO_ENDERECOMOVTO.CODDEPOSITANTE = MLO_PRODUTO.NROEMPRESA 
And MLO_PRODUTO.NROEMPRESA     = 501                            
And MLO_ENDERECOMOVTO.NROEMPRESA   = 501             
AND SEQLOTe = 1691
order by  MLO_ENDERECOMOVTO.DTAHORMOVTO DESC

SELECT * FROM MLO_LOTEINVFISICO A WHERE NROEMPRESA = 501 AND DTAHORGERACAO > DATE '2022-06-01'

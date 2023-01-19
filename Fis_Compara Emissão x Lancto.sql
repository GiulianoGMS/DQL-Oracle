ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Conpara lançamentos X emissão

SELECT Z.*, SUM(QTDLANCTO) - NVL(QTD_EMISSAO,0) DIFERENCA_QTD FROM (
select X.SEQPRODUTO, SUM(X.QTDLANCTO) QTDLANCTO, A.QUANTIDADE QTD_EMISSAO, round(sum(x.valorlanctobrt *x.qtdlancto),2) VALOR, A VLR_EMISSAO
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
                  LEFT JOIN ( -- NF Emitida
                  
select A.seqproduto, SUM(A.quantidade) QUANTIDADE, SUM(VLRPRODBRUTO + NVL(VLRACRESCIMO, 0) - NVL(VLRDESCONTO, 0) - decode(TIPOTABELA,'N',0,nvl( VLRDESCINCOND, 0 ))) A from MFLV_BASEDFITEM A
where  A.NUMERODF IN ('35497'  ,'35535')                       
      AND A.SERIEDF = '1'                       
      AND A.NROSERIEECF = 'NF'                           
      AND A.NROEMPRESA = '14'                       
      AND A.TIPOTABELA = 'D'                          
      AND A.TIPNOTAFISCAL = 'S'                             
      AND A.SEQPESSOA = '14'                          
      AND NVL(A.SEQNF,0) IN('231979336','232206510')

 GROUP BY SEQPRODUTO
order by A.SEQITEMDF ) A ON A.seqproduto = X.SEQPRODUTO
where X.nroempresa IN (14) 
AND X.DTAOPERACAO BETWEEN DATE '2022-12-01' AND DATE '2022-12-31'
AND Y.CODGERALOPER NOT IN (20,30,35,46,47,62,63,263,34,49,269,270,271,272,273,274)
 
group by X.SEQPRODUTO, QUANTIDADE, A


) Z
WHERE VALOR != NVL(VLR_EMISSAO, 0)


GROUP BY SEQPRODUTO, QTD_EMISSAO, QTDLANCTO, VLR_EMISSAO, VALOR;

-------

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;
select SEQPRODUTO, SUM(QUANTIDADE), SUM (VLRPRODBRUTO + NVL(VLRACRESCIMO, 0) - NVL(VLRDESCONTO, 0) - decode(TIPOTABELA,'N',0,nvl( VLRDESCINCOND, 0 ))) VLR 

from MFLV_BASEDFITEM A
where  A.NUMERODF IN ('35497'  ,'35535')                       
      AND A.SERIEDF = '1'                       
      AND A.NROSERIEECF = 'NF'                           
      AND A.NROEMPRESA = '14'                       
      AND A.TIPOTABELA = 'D'                          
      AND A.TIPNOTAFISCAL = 'S'                             
      AND A.SEQPESSOA = '14'                          
      AND NVL(A.SEQNF,0) IN('231979336','232206510')
      AND SEQPRODUTO NOT IN (

select X.SEQPRODUTO
from fato_perda x INNER join dim_codgeraloper y on (x.codgeraloper = y.codgeraloper)
                  LEFT JOIN (select A.seqproduto, SUM(A.quantidade) QUANTIDADE, SUM(VLRPRODBRUTO + NVL(VLRACRESCIMO, 0) - NVL(VLRDESCONTO, 0) - decode(TIPOTABELA,'N',0,nvl( VLRDESCINCOND, 0 ))) A from MFLV_BASEDFITEM A
where  A.NUMERODF IN ('35497'  ,'35535')                       
      AND A.SERIEDF = '1'                       
      AND A.NROSERIEECF = 'NF'                           
      AND A.NROEMPRESA = '14'                       
      AND A.TIPOTABELA = 'D'                          
      AND A.TIPNOTAFISCAL = 'S'                             
      AND A.SEQPESSOA = '14'                          
      AND NVL(A.SEQNF,0) IN('231979336','232206510') GROUP BY SEQPRODUTO
order by A.SEQITEMDF ) A ON A.seqproduto = X.SEQPRODUTO
where X.nroempresa IN (54) 
AND X.DTAOPERACAO BETWEEN DATE '2022-12-01' AND DATE '2022-12-31'
AND Y.CODGERALOPER NOT IN (34,49,269,270,271,272,273,274)
 )
GROUP BY SEQPRODUTO

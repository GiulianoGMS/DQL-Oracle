SELECT ANO, MES, EMPRESA, G.SEQPRODUTO, G.PRODUTO DESCRICAO, 
       P.MARCA, Q.CATEGORIA_NIVEL_1, Q.CATEGORIA_NIVEL_2, Q.CATEGORIA_NIVEL_3,
       Q.CATEGORIA_NIVEL_4, Q.CATEGORIA_NIVEL_5, VLR_VENDA, QTD_VENDA, CUSTO_BRUTO, VLR_PROMOCAO 
FROM (
SELECT     ANO, MES, LOJA EMPRESA,  SEQPRODUTO, PRODUTO, 
           NVL(SUM(VLR_VENDA),0)    VLR_VENDA, 
           NVL(SUM(QTD_VENDA),0)    QTD_VENDA, 
           NVL(SUM(CUSTO_BRUTO),0)  CUSTO_BRUTO,
           NVL(SUM(VLR_PROMOCAO),0) VLR_PROMOCAO
FROM(
SELECT     to_char(x.dtaoperacao,'YYYY') ANO,
           to_char(x.dtaoperacao,'MM') MES,
           x.dtaoperacao DATA,
           X.NROEMPRESA LOJA,
           X.SEQPRODUTO SEQPRODUTO,
           y.produto PRODUTO,
           sum(x.vlroperacao) VLR_VENDA,
           sum(x.qtdoperacao) QTD_VENDA,
           null QTD_COMPRA,
           SUM(X.vvlrctobruto) CUSTO_BRUTO,
           SUM(x.vlrpromoc) vlr_promocao
from fatog_vendadia x inner join dim_produto y on (x.seqproduto = y.seqproduto)
where x.codgeraloper in (37,48,123,610,615,613,810,916,910,911)
AND X.DTAOPERACAO  >= '01-JAN-2021'
GROUP BY to_char(x.dtaoperacao,'MM') ,
           to_char(x.dtaoperacao,'YYYY'),
           X.NROEMPRESA , X.SEQPRODUTO ,
           y.produto,
           x.dtaoperacao ) 
  
GROUP BY MES, ANO, LOJA, SEQPRODUTO, PRODUTO ) G

LEFT JOIN QLV_PRODUTO P ON G.SEQPRODUTO = P.SEQPRODUTO
LEFT JOIN QLV_CATEGORIA Q ON P.SEQFAMILIA = Q.SEQFAMILIA

ORDER BY 1 DESC, 2 DESC, 3


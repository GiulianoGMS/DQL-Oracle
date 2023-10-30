ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT  MAX(E.SEQENCARTE) NROENCARTE,
  MAX(E.DESCRICAO) DESC_ENCARTE,
  MAX(E.DTAINICIO) DTAINICIO,
  MAX(E.DTAFIM) DTAFIM,
  MAX(E.SEQPRODUTO) PLU,
  MAX(E.DESCRICAOPRODUTO) DESC_PROD,
  MAX(SUBSTR(E.EAN, 1, 200)) as EAN,
  MAX(E.PRECOATUAL) PRECO_ATUAL,
  MAX(E.PRECOPROMOCIONAL) PRECO_PROMO,
  MAX(E.DESCONTO) DESCONTO,
  MAX(E.COMPRADOR) COMPRADOR,
  MAX(E.PAGINA) NROPAGINA,
  MAX(E.NOMEPAGINA) NOMEPAGINA,
  MAX(E.DTAVIGENCIAINI) AS DTAVIGENCIAINI,
  max(E.DTAVIGENCIAFIM) AS DTAVIGENCIAFIM                                                                                                                                                                                                                                                                                                                                                                                             
FROM    MRLV_ENCARTE E
WHERE E.SEQENCARTE ='22178'            
 and exists ( select 1
                        from   mrl_encarteproduto a
                        where a.seqencarte = e.seqencarte
                        and     a.seqproduto = e.seqproduto
            and   a.nropagina  = e.pagina 
and a.seqordem = e.seqordem) 
GROUP BY E.SEQFAMILIA, E.SEQPRODUTO
ORDER BY MAX(E.PAGINA), 
    MAX(E.SEQORDEM)  

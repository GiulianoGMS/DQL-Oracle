ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

SELECT A.SEQPRODUTO, DESCCOMPLETA, CODACESSO,
      -- Formação Cod de Etiquetas
      '^XA
      ^PRA^FS
      ^LH00,00^FS
      ^BY2^FS
      ^PQ 1^FS

      ^FO100,115^GB150,4,4^FS -- RISCO

      ^FO050,170^BY2.4^BEN,25,Y,N^FD'||CODACESSO||'^FS
      ^FO50,20^A0N,40,40^FD'||DESCCOMPLETA||'^FS

      ^FO50,251^A0N,20,20^FD09/01/24 10:05 - Prod: 123456 - Val. Prom.: 09/01/24 a 10/01/24 - Loja: MATRIZ 601^FS

      ^FO275,120^A0N,80,60^FDOFERTA^FS
      ^FO490,100^A0N,30,30^FD  R$  ^FS
      ^FO495,76^A0N,20,20^FD  POR  ^FS
      ^FO540,80^A0N,150,110^FD10,49 ^FS
      ^FO590,215^A0N,15,15^FDNesta Embalagem KG R$ XX,XX^FS
      ^FO690,85^A0N,090,40^FD  ^FS

      ^FO50,95^A0N,25,25^FDR$^FS
      ^FO51,125^A0N,20,20^FDDE^FS
      ^FO100,92^A0N,60,60^FD11,98^FS

      ^FO260,60^GB230,180,1^FS

      ^FO490,60^GB300,180,100^FR^FS 

      ^XZ' COD_ETQ
  FROM MAP_PRODUTO A INNER JOIN MAP_PRODCODIGO B
    ON A.SEQPRODUTO = B.SEQPRODUTO
   --AND B.TIPCODIGO = 'E'
   AND A.SEQPRODUTO IN (262659,262661,262681,262677,262678)

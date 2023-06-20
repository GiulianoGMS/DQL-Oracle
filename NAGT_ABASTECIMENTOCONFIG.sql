-- Tabela de Configuração | Abastecimento Automatico
-- Aplicação não vincula Fornecedor ao lote, logo precisa estar configurado nesta tabela
-- e os produtos devem respeitar o fornecedor

CREATE TABLE CONSINCO.NAGT_ABASTECIMENTOCONFIG (
                  SEQFORNECEDOR NUMBER(20),
                  SEQLOTEMODELO NUMBER(20),
                  DIASEMANA     VARCHAR2(10),
                  DIASCONFIG    NUMBER(3))

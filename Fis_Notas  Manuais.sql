select a.nroempresa EMPRESA,
       a.nronota NOTA,
       a.serie SERIE,
       (select g.descricao  from CONSINCO.aba_historico g where g.seqhistorico = a.codhistorico) Historico,
       to_char(a.dtaemissao,'DD/MM/YYYY') EMISSAO,
        to_char(a.dtaentrada,'DD/MM/YYYY') ENTRADA,
        a.cgo CGO,
        a.cfop,
        (select y.nomerazao from CONSINCO.ge_pessoa y where y.seqpessoa = a.seqpessoa) RAZAO,
         to_char(a.valor,'FM999G999G999D90', 'nls_numeric_characters='',.''') VALOR,
         (SELECT COUNT(DISTINCT(A.SEQNOTA))
          from CONSINCO.or_nfdespesa a
          where a.codmodelo in (01,06,21,22,28,29)
          and a.dtaentrada = DATE '2023-02-02'
          and a.nroempresa in (02)) QTD_TOTAL,
         (SELECT to_char(sum(a.valor),'FM999G999G999D90', 'nls_numeric_characters='',.''')
          from CONSINCO.or_nfdespesa a
          where a.codmodelo in (01,06,21,22,28,29)
          and a.dtaentrada = DATE '2023-02-02'
          and a.nroempresa in (02)) VALOR_TOTAL,
          TO_CHAR(:DT1, 'DD/MM/YYYY') Data_Inicial, TO_CHAR(:DT2, 'DD/MM/YYYY') Data_Final
          
from CONSINCO.or_nfdespesa a
where a.codmodelo in (01,06,21,22,28,29)
and a.dtaentrada BETWEEN :DT1 AND :DT2
and a.nroempresa in (#LS1)




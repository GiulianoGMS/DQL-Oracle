CREATE OR REPLACE VIEW consinco.nagv_pessoaitworks AS (

select   /*LPAD(ge.nrocgccpf,12,0)||LPAD(GE.DIGCGCCPF,2,0) CNPJCPF,*/ -- -Ticket 17469 Solicitação Sirlene
           ge.nrocgccpf,12,0)||LPAD(GE.DIGCGCCPF,2,0) END CNPJCPF, 
           GE.NOMERAZAO RAZAO_SOCIAL,
           GE.LOGRADOURO ENDERECO,
           GE.NROLOGRADOURO NUMERO,
           GE.BAIRRO BAIRRO,
           case when ge.fisicajuridica = 'F' then null else GE.INSCRICAORG end IE_RG, --- Ticket 26437 Alteração 15/03/2022 Cipolla
           GE.CMPLTOLOGRADOURO COMPLEMENTO,
           GE.FONEDDD1|| GE.FONENRO1 DDD_FONE,
           GE.CIDADE CIDADE,
             (select F.CODIBGE from CONSINCO.GE_CIDADE F WHERE F.SEQCIDADE = GE.SEQCIDADE) CODIGO_CIDADE,
           GE.PAIS PAIS,
               (select F.CODPAIS from CONSINCO.GE_CIDADE F WHERE F.SEQCIDADE = GE.SEQCIDADE) CODIGO_PAIS,
           GE.CEP CEP,
           GE.UF UF,
           LPAD(ge.Nrocpfprodutor,9,0)||LPAD(GE.DIGCPFPRODUTOR,2,0) CPFProdutorRural,
           NULL Ativ39ICMS,
           NULL OptanteSimplesNacionalUltrapassaLimite,
           NULL OptanteSimplesNacionalAliquotaAtual,
           GE.DTAINCLUSAO DTA_INCLUSAO,
           NVL(GE.DTAALTERACAO,GE.DTAINCLUSAO ) DTA_ALTERACAO,

 --- Adicionado as horas abaixo para tratar no robo da Itworks, para sincronizar tem que ter hora,
/*        case when TO_CHAR(GE.DTAINCLUSAO,'hh24:mi:ss') = '00:00:00' then
                            TO_DATE(GE.DTAINCLUSAO,'DD/MM/RRRR') +  7/24  else
                            GE.DTAINCLUSAO end DTA_INCLUSAO,

          case when  TO_CHAR(NVL(GE.DTAALTERACAO,GE.DTAINCLUSAO ),'hh24:mi:ss') = '00:00:00' then
                                 TO_DATE(nvl(GE.DTAALTERACAO,GE.DTAINCLUSAO),'DD/MM/RRRR') +  7/24  else
                             NVL(GE.DTAALTERACAO,GE.DTAINCLUSAO ) end DTA_ALTERACAO,*/

           'View Nagumo' ORIGEM
from consinco.ge_pessoa ge
where ge.nrocgccpf is not null)
;

create or replace procedure consinco.spMrl_AlterComprador(pnNroFornec        in MAP_FAMFORNEC.Seqfornecedor%type,
                                                 pdDescSegmento     in maf_segtofornec.descricao%type,
                                                 psApComprador      in max_comprador.apelido%type,
                                                 pnNroNovoComprador in max_comprador.seqcomprador%type)

 is

BEGIN
  FOR T IN (SELECT A.SEQFAMILIA, B.SEQCOMPRADOR
              FROM MAP_FAMDIVISAO A, MAX_COMPRADOR B, MAP_FAMFORNEC C
             WHERE A.SEQCOMPRADOR = B.SEQCOMPRADOR
               AND A.SEQFAMILIA = C.SEQFAMILIA
               AND C.SEQFORNECEDOR = pnNroFornec
               AND C.NROSEGFORNEC in
                   (select w.nrosegfornec
                      from maf_segtofornec w
                     where w.descricao in (pdDescSegmento))
               --AND C.PRINCIPAL = 'S' Ticket 101773 - 05/09/2022 - Solicitação Paloma
               AND A.SEQCOMPRADOR IN
                   (select D.seqcomprador
                      from max_comprador D
                     where D.Apelido in (psApComprador)))

   loop

    update map_famdivisao u
       set u.seqcomprador = pnNroNovoComprador
     where u.seqcomprador = t.seqcomprador
       and u.seqfamilia = t.seqfamilia;

  end loop;
  commit;
end spMrl_AlterComprador;

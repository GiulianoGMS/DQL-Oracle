-- Adicionar em ORP_INSCONSISTENCIACUST

-- Ticket 522853 | Adicionado por Giuliano em 24/01/2025
-- Valida CFOP de acordo com a UF Loja x Fornec

    FOR h IN (SELECT I.CODPRODUTO FROM OR_NFDESPESA X INNER JOIN GE_PESSOA FORNEC    ON FORNEC.SEQPESSOA = X.SEQPESSOA
                               INNER JOIN GE_PESSOA LJ        ON LJ.SEQPESSOA     = X.NROEMPRESA
                               INNER JOIN OR_NFITENSDESPESA I ON I.SEQNOTA        = X.SEQNOTA
                             
               WHERE 1=1
                 AND (FORNEC.UF != LJ.UF AND SUBSTR(I.CFOP,0,1) = 1
                  OR  FORNEC.UF  = LJ.UF AND SUBSTR(I.CFOP,0,1) = 2)
                  
                 AND X.NROEMPRESA = vnEmpresa
                 AND X.SEQNOTA    = pnSeqnota)
                 
    LOOP
      vsCodProduto := h.CODPRODUTO;

      INSERT INTO ORX_NFDESPESAINCOSISTCUST(SEQINCONSIST, MOTIVO, SITUACAO)
          VALUES (803,'CFOP incorreto na operação com este fornecedor! Item: '||vsCodProduto||' - Dúvidas: Depto Fiscal.', 'P');
          pnOk := 1;

    END LOOP;

-- Adicionar na Procedure ORP_INSCONSISTENCIACUST

-- Consiste Serie Nula
    -- Solicitacao via Teams 17/03/2025 - Giuliano
    FOR i IN (SELECT *
                FROM OR_NFDESPESA N
               WHERE 1 = 1
                 AND N.SERIE IS NULL
                 AND N.NROEMPRESA = vnEmpresa
                 AND N.SEQNOTA    = pnSeqnota)

    LOOP

      INSERT INTO ORX_NFDESPESAINCOSISTCUST(SEQINCONSIST, MOTIVO, SITUACAO)
          VALUES (804,'Não é permitido lançamento de NF sem série informada, Verifique!', 'P');
          pnOk := 1;

    END LOOP;

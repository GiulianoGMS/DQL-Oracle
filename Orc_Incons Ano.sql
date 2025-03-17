-- Adicionar em ORP_INSCONSISTENCIACUST

-- Consiste Ano de Emissao - Nao permite lancto com emissao (ano) menor que o ano atual -1
    -- Solicitacao via Teams 17/03/2025 - Giuliano
    FOR a IN (SELECT *
                FROM OR_NFDESPESA N
               WHERE 1 = 1
                 AND EXTRACT(YEAR FROM DTAEMISSAO) < EXTRACT(YEAR FROM SYSDATE)  - 1
                 AND N.NROEMPRESA = vnEmpresa
                 AND N.SEQNOTA    = pnSeqnota)

    LOOP

      INSERT INTO ORX_NFDESPESAINCOSISTCUST(SEQINCONSIST, MOTIVO, SITUACAO)
          VALUES (805,'Data de emissão incorreta, Verifique!', 'P');
          pnOk := 1;

    END LOOP;

-- Insere permissão ao grupo X para todas as contas transitórias e empresas

INSERT INTO CONSINCO.GE_USUARIOPERM X (X.CODAPLICACAO,
                                       X.CHAVEAPLICACAO,
                                       X.SEQUSUARIO,
                                       X.NROEMPRESA,
                                       X.PERMISSAO,
                                       X.TIPOEMPRESA,
                                       X.EMPRESA) 
                                       
      SELECT 'FISEGCTACOR' CODAPLICACAO, Z.SEQCTACORRENTE, (SELECT SEQUSUARIO FROM GE_USUARIO 
                                                             WHERE UPPER(CODUSUARIO) = UPPER(:LS1)) SEQUSUARIO, NULL NROEMPRESA, 6, 'G' TIPOEMPRESA, 1 EMPRESA FROM FI_CTACORRENTE Z
                                                             WHERE Z.SEQCTACORRENTE NOT IN (SELECT Y.CHAVEAPLICACAO FROM CONSINCO.GE_USUARIOPERM Y 
                                                                                             WHERE Y.CODAPLICACAO = 'FISEGCTACOR'
                                                                                               AND CHAVEAPLICACAO = Z.SEQCTACORRENTE 
                                                                                               AND Y.SEQUSUARIO = (SELECT SEQUSUARIO FROM GE_USUARIO WHERE UPPER(CODUSUARIO) = UPPER(:LS1)) 
                                                                                               AND Y.EMPRESA = 1) AND Z.TIPOCONTA = 'T';
COMMIT;

SELECT 'Alterações realizadas com sucesso!' STATUS FROM DUAL;

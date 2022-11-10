CREATE OR REPLACE VIEW CONSINCO.NAGV_OBSEMERGENCIAL_PDV AS

SELECT DISTINCT CODACESSO
  FROM CONSINCO.MAP_PRODCODIGO A 
 WHERE A.SEQFAMILIA IN (SELECT DISTINCT SEQFAMILIA FROM CONSINCO.MAP_FAMILIA F WHERE F.OBSEMERGENCIAL LIKE '%Mercadoria enquadrada%')
   AND TIPCODIGO = 'E'
   
;
------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_OBSEMERGENCIAL_PDV as
    saida UTL_File.File_Type;
    V_RAW1 raw(20000);
    v_Targetcharset varchar2(40 BYTE);
    v_Dbcharset varchar2(40 BYTE);

     ----- Select na view para buscar as informações de Pessoas
    Cursor Cur_Linha is (

       --- Detalhes
    SELECT X.CODACESSO AS linha
           FROM CONSINCO.NAGV_OBSEMERGENCIAL_PDV X );

BEGIN
    ------ Caminho para geração do arquivo e nome do arquivo
    saida := UTL_File.Fopen('/u02/dados/Obs_Emergencial', 'obsemergencial.TXT', 'w');

    --For Reg_Linha in Cur_linha  Loop  UTL_File.Put_Line(saida,Reg_linha.linha );   End Loop;
    v_Dbcharset := 'AMERICAN_AMERICA.AL32UTF8';
    v_Targetcharset := 'AMERICAN_AMERICA.WE8MSWIN1252';
    For Reg_Linha in Cur_linha  Loop
      v_Raw1 := UTL_RAW.CAST_TO_RAW (Reg_linha.linha);
      v_Raw1 := UTL_RAW.CONVERT(v_Raw1, v_Dbcharset, v_Targetcharset);

      UTL_File.PUT_LINE(saida, utl_raw.cast_to_varchar2(v_Raw1));
    End Loop;

    UTL_File.Fclose(saida);

    Dbms_Output.Put_Line('Arquivo gerado com sucesso!');

 ----- Tratamentos dos Erros
   EXCEPTION
      WHEN UTL_FILE.INVALID_OPERATION THEN Dbms_Output.Put_Line('Operação inválida no arquivo!');     UTL_File.Fclose(saida);
      WHEN UTL_FILE.WRITE_ERROR       THEN Dbms_Output.Put_Line('Erro de gravação no arquivo!');      UTL_File.Fclose(saida);
      WHEN UTL_FILE.INVALID_PATH      THEN Dbms_Output.Put_Line('Diretório inválido!');               UTL_File.Fclose(saida);
      WHEN UTL_FILE.INVALID_MODE      THEN Dbms_Output.Put_Line('Modo de acesso inválido!');          UTL_File.Fclose(saida);
      WHEN Others                     THEN Dbms_Output.Put_Line('Problemas na geração do arquivo!');  UTL_File.Fclose(saida);

END;

-----------------------

begin
  NAGP_OBSEMERGENCIAL_PDV;
end; 

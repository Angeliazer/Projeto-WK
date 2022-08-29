unit uAcharDadosGeraisPedido;
interface

   uses uDadosgeraispedidos, uConexao;

   type

   TAchaDadosGerais = class(TDadosGeraisPedidos)

   private

   public

   function FindDadosGerais(numPed:integer):boolean;

   end;


implementation

function TAchaDadosGerais.FindDadosGerais(numPed:integer):boolean;
begin
  with DMCon.FDQDadosGeraisPedido do
    begin
      Close;
      SQL.clear;
      SQL.Add('Select * from dadosgeraispedido where numeropedido = :numped');
      params[0].AsInteger:=numPed;
      Open;
      if RecordCount<>0 then
        begin
          numeropedido :=FieldByName('numeropedido').AsInteger;
          dataemissao  :=FieldByName('dataemissao').AsString;
          codigocliente:=FieldByName('codigocliente').AsInteger;
          valortotal   :=FieldByName('valortotal').AsFloat;
          result:=true;
        end
      else
        result:=false;
    end;
end;

end.


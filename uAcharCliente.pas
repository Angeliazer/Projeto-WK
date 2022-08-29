unit uAcharCliente;

interface

   uses uClientes, uConexao;

   type

   TAchaCliente = class(TClientes)

   private

   public

   function FindCliente(codCli:integer):boolean;

   end;


implementation

function TAchaCliente.FindCliente(codCli: Integer):boolean;
begin
  with DMCon.FDQClientes do
    begin
      Close;
      SQL.clear;
      SQL.Add('Select * from clientes where codigo = :codCliente');
      params[0].AsInteger:=codCli;
      Open;
      if RecordCount<>0 then
        begin
          CodigoCliente:=FieldByName('codigo').AsInteger;
          NomeCliente  :=FieldByName('nome').AsString;
          CidadeCliente:=FieldByName('cidade').AsString;
          UfCliente    :=FieldByName('uf').AsString;
          result:=true;
        end
      else
        result:=false;
      end;
end;

end.

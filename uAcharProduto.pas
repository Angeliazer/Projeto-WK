unit uAcharProduto;
interface

   uses uProdutos, uConexao;

   type

   TAchaProduto = class(TProdutos)

   private

   public

   function FindProduto(codPro:integer):boolean;

   end;


implementation

function TAchaProduto.FindProduto(codPro:integer):boolean;
begin
  with DMCon.FDQProdutos do
    begin
      Close;
      SQL.clear;
      SQL.Add('Select * from produtos where codigo = :codPro');
      params[0].AsInteger:=codPro;
      Open;
      if RecordCount<>0 then
        begin
          codigoproduto:=FieldByName('codigo').AsInteger;
          descricaoproduto  :=FieldByName('descricao').AsString;
          precovenda:=FieldByName('precovenda').AsFloat;
          result:=true;
        end
      else
        result:=false;
    end;
end;

end.


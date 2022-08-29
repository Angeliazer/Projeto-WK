unit uProdutos;

interface

type

   TProdutos = class

   private
    FCodigoProduto   :integer;
    FDescricaoProduto:string;
    FPrecoVendaProduto      :Double;

    procedure setCodigoProduto     (const Value: integer);
    procedure setDescricaoProduto  (const Value: string);
    procedure setPrecoVendaproduto (const Value: Double);

   public

     property CodigoProduto:integer   read FCodigoProduto     write setCodigoProduto;
     property DescricaoProduto:string read FDescricaoProduto  write setDescricaoProduto;
     property PrecoVenda:Double       read FPrecoVendaproduto write setPrecoVendaProduto;

   end;

implementation


procedure TProdutos.setCodigoProduto(const Value: integer);
begin
  FCodigoProduto:=Value;
end;

procedure TProdutos.setDescricaoProduto(const Value: string);
begin
  FDescricaoProduto:=Value;
end;

procedure TProdutos.setPrecoVendaProduto(const Value: Double);
begin
  FPrecoVendaProduto:=Value;
end;



end.

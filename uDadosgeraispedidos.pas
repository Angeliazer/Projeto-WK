unit uDadosgeraispedidos;

interface

type

   TDadosGeraisPedidos = class

   private
    FNumeroPedido      : integer;
    FDataEmissaoPedido : string;
    FCodigoCliente     : integer;
    FValorTotal        : Double;
    procedure setNumeroPedido     (const Value: integer);
    procedure setDataEmissao      (const Value: string);
    procedure setCodigoCliente    (const Value: integer);
    procedure setValorTotal       (const Value: Double);

   public
     property NumeroPedido  : integer read FNumeroPedido      write setNumeroPedido;
     property DataEmissao   : string  read FDataEmissaoPedido write setDataEmissao;
     property CodigoCliente : integer read FCodigoCliente     write setCodigoCliente;
     property ValorTotal    : Double  read FValorTotal        write setValorTotal;
   end;

implementation

procedure TDadosGeraisPedidos.setNumeroPedido(const Value: integer);
begin
  FNumeroPedido:=Value;
end;

procedure TDadosGeraisPedidos.setDataEmissao(const Value: string);
begin
  FDataEmissaoPedido:=Value;
end;

procedure TDadosGeraisPedidos.setCodigoCliente(const Value: integer);
begin
  FCodigoCliente:=Value;
end;

procedure TDadosGeraisPedidos.setValorTotal(const Value: double);
begin
  FValorTotal:=Value;
end;


end.

unit uClientes;

interface
   type

     TClientes= class

       FCodigoCliente : integer;
       FNomeCliente   : string;
       FCidadeCliente : string;
       FUFCliente     : string;

       procedure setCodigoCliente(const Value: integer);
       procedure setNomeCliente  (const Value: string);
       procedure setCidadeCliente(const Value: string);
       procedure setUFCliente    (const Value: string);

     public

       property CodigoCliente:integer read FCodigoCliente write setCodigoCliente;
       property NomeCliente  :string  read FNomeCliente   write setNomeCliente;
       property CidadeCliente:string  read FCidadeCliente write setCidadeCliente;
       property UFCliente    :string  read FUFcliente     write setUFCliente;
   end;

implementation


procedure TClientes.setCodigoCliente(const Value: integer);
begin
  FCodigoCliente:=Value;
end;

procedure TClientes.setNomeCliente(const Value: string);
begin
  FNomeCliente:=Value;
end;

procedure TClientes.setCidadeCliente(const Value: string);
begin
  FCidadeCliente:=Value;
end;

procedure TClientes.setUFCliente(const Value: string);
begin
  FUFCliente:=Value;
end;

end.

program ProjWk;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uClientes in 'uClientes.pas',
  uProdutos in 'uProdutos.pas',
  uConexao in 'uConexao.pas' {DMCon: TDataModule},
  uDadosgeraispedidos in 'uDadosgeraispedidos.pas',
  uAcharCliente in 'uAcharCliente.pas',
  uAcharProduto in 'uAcharProduto.pas',
  uAcharDadosGeraisPedido in 'uAcharDadosGeraisPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMCon, DMCon);
  Application.Run;
end.

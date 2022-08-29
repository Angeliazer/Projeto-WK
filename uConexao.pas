unit uConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Datasnap.DBClient, vcl.Dialogs, vcl.ExtCtrls, System.UITypes, vcl.Forms,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI;

type
  TDMCon = class(TDataModule)
    FDCon: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDQDadosGeraisPedido: TFDQuery;
    FDQClientes: TFDQuery;
    FDQProdutos: TFDQuery;
    FDQPedidosProdutos: TFDQuery;
    dsItensPedidos: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    cdsitenspedidos: TClientDataSet;
    cdsitenspedidoscodProd: TIntegerField;
    cdsitenspedidosdescProd: TStringField;
    cdsitenspedidosquant: TIntegerField;
    cdsitenspedidosvalorunitario: TFloatField;
    cdsitenspedidosvalortotal: TFloatField;
    cdsitenspedidosvlrunit: TStringField;
    cdsitenspedidosvlrtot: TStringField;
    cdsitenspedidosid: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure dsItensPedidosDataChange(Sender: TObject; Field: TField);
    procedure cdsItensPedidosCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMCon: TDMCon;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uMain;

{$R *.dfm}

procedure TDMCon.cdsItensPedidosCalcFields(DataSet: TDataSet);
begin
  cdsItensPedidosvlrunit.AsString:=FormatFloat('##,###,##0.#0', cdsItensPedidosvalorunitario.AsFloat);
  cdsItensPedidosvlrtot.AsString:=FormatFloat('##,###,##0.#0', cdsItensPedidosvalorTotal.AsFloat);
end;

procedure TDMCon.DataModuleCreate(Sender: TObject);
begin
    begin
      try
        FDCon.Params.Values['Database'] :='wk';
        FDCon.Params.Values['Password'] :='010101';
        FDCon.Params.Values['Server']   :='localhost';
        FDCon.Params.Values['user_name']:='root';
        FDCon.Connected:=True;
      except
          begin
            MessageDlg('Erro na Abertura do Banco de Dados MySQL', mtError, [mbOK],0);
            Application.Terminate;
          end;
      end;
    end;

end;

procedure TDMCon.dsItensPedidosDataChange(Sender: TObject; Field: TField);
begin
  frmMain.btnGravarPedido.Enabled:=cdsItensPedidos.recordCount<>0;
end;

end.

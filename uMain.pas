unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uClientes, uProdutos, Vcl.StdCtrls,
  Vcl.ExtCtrls, uConexao, FireDAC.Stan.Param, System.UITypes, Data.DB, Vcl.Grids,
  Vcl.DBGrids, DateUtils, uAcharCliente, uAcharProduto, uDadosGeraisPedidos, uAcharDadosGeraisPedido;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    btnExit: TButton;
    gbDadosCliente: TGroupBox;
    edtCidade: TEdit;
    Label1: TLabel;
    edtUf: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtNome: TEdit;
    edtCodigoCliente: TEdit;
    Label4: TLabel;
    gbDadosProduto: TGroupBox;
    edtCodigoProduto: TEdit;
    edtDescricaoProduto: TEdit;
    edtPrecoVenda: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnInserirGrid: TButton;
    gbItensPedido: TGroupBox;
    Panel2: TPanel;
    edtQuantidade: TEdit;
    Label8: TLabel;
    dbgItensPedidoVenda: TDBGrid;
    btnGravarPedido: TButton;
    btnCarregarPedidos: TButton;
    Label9: TLabel;
    edtNumeroPedido: TEdit;
    btnCancelarPedidos: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnExitClick(Sender: TObject);
    procedure edtCodigoClienteEnter(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoProdutoEnter(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure btnInserirGridClick(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure dbgItensPedidoVendaEnter(Sender: TObject);
    procedure LimpaCampos;
    procedure MostraTotal(vlrTot:double);
    procedure dbgItensPedidoVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtQuantidadeEnter(Sender: TObject);
    procedure dbgItensPedidoVendaKeyPress(Sender: TObject; var Key: Char);
    procedure dbgItensPedidoVendaExit(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure edtPrecoVendaKeyPress(Sender: TObject; var Key: Char);
    procedure edtPrecoVendaExit(Sender: TObject);
    function formataMoeda(vlr:string):string;
    procedure btnCarregarPedidosClick(Sender: TObject);
    procedure edtNumeroPedidoExit(Sender: TObject);
    procedure btnCancelarPedidosClick(Sender: TObject);
var
  private
    { Private declarations }
  public
    { Public declarations }
    oCliente        : TAchaCliente;
    oProduto        : TAchaProduto;
    oAchaDadosGerais: TAchaDadosGerais;
    valorTotal      : double;
    posGrid         : integer;
    vlrAux          : double;
    flagRegGravado  : boolean;
    oDadosGerais    : TDadosGeraisPedidos;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function TfrmMain.formataMoeda(vlr:string):string;
begin
  vlr:=FormatFloat('##,###,##0.#0', strToFloat(vlr));
  vlr:=Trim(StringReplace(vlr, '.', '', [rfReplaceAll, rfIgnoreCase]));
  vlr:=Trim(StringReplace(vlr, ',', '', [rfReplaceAll, rfIgnoreCase]));
  vlr:=FormatFloat('##,###,##0.#0', strToInt(vlr)/100);
  result := vlr;
end;


procedure TfrmMain.btnCancelarPedidosClick(Sender: TObject);
var
  flag:integer;
begin
  if (edtNumeroPedido.Text<>'') and (edtNumeroPedido.Text<>'0') then
    begin
      flag:=0;
      //Mostra os dados do Pedido Gravado...
      oAchaDadosGerais:=TAchaDadosGerais.Create;
      if not oAchaDadosGerais.FindDadosGerais(strtoint(edtNumeroPedido.Text)) then
        begin
          MessageDlg('Pedido não existe!', mtError, [mbOK], 0);
          OAchaDadosGerais.Free;
          edtNumeroPedido.SetFocus;
          exit;
        end;
      if MessageDlg('Confirmar Exclusão do Pedido?', mtError, [mbYes, mbNo], 0) = mrYes then
        begin
          // Apaga os dados das duas tabelas * dadosgeraispedido e pedidosprodutos
          if not DMCon.FDCon.InTransaction then
            begin
              try
                DMCon.FDCon.StartTransaction;

                with DMCon.FDQPedidosProdutos do
                  begin
                    Close;
                    SQL.Clear;
                    SQL.Add('Delete from pedidosprodutos where numeropedido = :nurped');
                    params[0].AsInteger:=StrToInt(edtNumeroPedido.Text);
                    ExecSql;
                  end;

                with DMCon.FDQDadosGeraisPedido do
                  begin
                    Close;
                    SQL.Clear;
                    SQL.Add('Delete from dadosgeraispedido where numeropedido = :nurped');
                    params[0].AsInteger:=StrToInt(edtNumeroPedido.Text);
                    ExecSql;
                  end;

                DMCon.FDCon.Commit;
              except
                on E: Exception do
                  begin
                    MessageDlg(E.Message, mtError, [mbOk], 0);
                    DMCon.FDCon.Rollback;
                  end;
              end;
            end;
          if flag=0 then
            begin
              Application.MessageBox('Pedido Excluído com sucesso!', 'Aviso', MB_OK);
              edtCodigoCliente.SetFocus;
            end;
        end;
    end;

end;

procedure TfrmMain.btnCarregarPedidosClick(Sender: TObject);
begin
  //Mostra os dados do Pedido Gravado...
  if (edtNumeroPedido.Text<>'') and (edtNumeroPedido.Text<>'0') then
    begin
      //Mostra os dados do Pedido Gravado...
      oAchaDadosGerais:=TAchaDadosGerais.Create;
      if not oAchaDadosGerais.FindDadosGerais(strtoint(edtNumeroPedido.Text)) then
        begin
          MessageDlg('Pedido não existe!', mtError, [mbOK], 0);
          OAchaDadosGerais.Free;
          edtNumeroPedido.SetFocus;
          exit;
        end
      else
        begin
          edtCodigoCliente.Text  :=intToStr(oAchaDadosGerais.CodigoCliente);
          oCliente:=TAchaCliente.Create;
          if not oCliente.FindCliente(oAchaDadosGerais.CodigoCliente) then
            begin
              oAchaDadosGerais.Free;
              oCliente.Free;
              MessageDlg('Cliente não Cadastrado!', mtError, [mbOk], 0);
              edtNumeroPedido.SetFocus;
            end
          else
            begin
              edtNome.Text:=oCliente.NomeCliente;
              edtCidade.Text:=oCliente.CidadeCliente;
              edtUf.Text:=oCliente.UFCliente;
            end;
        end;
    end
  else
    begin
      edtNumeroPedido.SetFocus;
      exit;
    end;
  flagRegGravado:=true;
  valorTotal:=oAchaDadosGerais.ValorTotal;
  with DMCon.FDQPedidosProdutos do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from pedidosprodutos where numeropedido = :nurPed');
      params[0].AsInteger:=oAchaDadosGerais.NumeroPedido;
      Open;
      if RecordCount=0 then
        begin
          MessageDlg('Pedido não possui Itens', mtError, [mbOk], 0);
          edtCodigoCliente.SetFocus;
        end;

      while not eof do
        begin
          oProduto:=TAchaProduto.create;
          oProduto.FindProduto(DMCon.FDQPedidosProdutos.FieldByName('codigoproduto').AsInteger);
          DMCon.cdsitenspedidos.Append;
          DMCon.cdsitenspedidoscodProd.AsInteger:=oProduto.CodigoProduto;
          DMCon.cdsitenspedidosdescProd.AsString:=oProduto.DescricaoProduto;
          DMCon.cdsitenspedidosquant.AsInteger:=DMCon.FDQPedidosProdutos.FieldByName('quantidade').AsInteger;
          DMCon.cdsitenspedidosvalorunitario.AsFloat:=DMCon.FDQPedidosprodutos.FieldByName('valorunitario').AsFloat;
          DMCon.cdsitenspedidosvalortotal.AsFloat:=DMCon.FDQPedidosProdutos.FieldByName('valortotal').AsFloat;
          DMCon.cdsitenspedidosid.AsInteger:=DMCon.FDQPedidosprodutos.FieldByName('idpedidosprodutos').AsInteger;
          DMCon.cdsitenspedidos.Post;
          Next;
        end;
        DMCon.cdsitenspedidos.First;
      MostraTotal(oAchaDadosGerais.ValorTotal);
      dbgItensPedidoVenda.SetFocus;
    end;
end;


procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  if MessageDlg('Confirma Encerramento do Programa?', mtInformation, mbYesNo,0) = mrYes then
    begin
      DMCon.FDCon.Connected:=False;
      Application.Terminate;
    end;
end;

procedure TfrmMain.btnGravarPedidoClick(Sender: TObject);
var
  nrpedido:integer;
begin
if (edtNumeroPedido.Text='0') or (edtNumeroPedido.Text='') then
  begin
    if not DMCon.FDCon.InTransaction then
      try
        DMCon.FDCon.StartTransaction;
        //Grava Dados Gerais dos Pedidos no Banco de Dados...
        with DMCon.FDQDadosGeraisPedido do
          begin
            Close;
            SQL.Clear;
            sql.Add('Insert Into dadosgeraispedido (dataemissao, codigocliente, valortotal) values (:dtemissao, :codcliente, :vlrtotal)');
            params[0].AsString  :=DateToStr(Now());
            params[1].AsInteger :=oCliente.CodigoCliente;
            params[2].AsCurrency:=valorTotal;
            ExecSQL;
            SQL.Clear;
            SQL.Add('SELECT Max(numeropedido) as numeropedido from dadosgeraispedido');
            Open;
            nrpedido:=FieldByName('numeropedido').AsInteger;
          end;
        //Grava Itens dos Produtos dos Pedidos de Venda...
        DMCon.cdsItensPedidos.First;
        with DMCon.FDQPedidosProdutos do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Insert Into pedidosprodutos (numeropedido, codigoproduto, quantidade, valorunitario, valortotal) values (:nurpedido, :codproduto, :quant, :vlrunt, :vlrtotl)');
            while not DMCon.cdsItensPedidos.eof do
              begin
                params[0].AsInteger  := nrpedido;
                params[1].AsInteger  := DMCon.cdsItensPedidoscodProd.AsInteger;
                params[2].AsInteger  := DMCon.cdsItensPedidosquant.AsInteger;
                params[3].AsCurrency := StrToFloat(DMCon.cdsItensPedidosvalorUnitario.AsString);
                params[4].AsCurrency := StrToFloat(DMCon.cdsItensPedidosvalorTotal.AsString);
                ExecSQL;
                DMCon.cdsItensPedidos.Next;
              end;
          end;
        DMCon.FDCon.Commit;
      except
        on E: Exception do
          begin
            MessageDlg(E.Message, mtError, [mbOk], 0);
            DMCon.FDCon.Rollback;
          end;
      end;
    edtCodigoCliente.SetFocus;
   end
  else
    begin
      MessageDlg('O Pedido já foi Alterado', mtError, [mbOk], 0);
    end;
end;

procedure TfrmMain.btnInserirGridClick(Sender: TObject);
var
  flag:integer;
  str_sql:string;
begin
  flag:=0;
  if btnInserirGrid.Tag=0 then
     begin
      //Inclui do Item de Pedido no ClientDataSet
      if not DMCon.FDCon.InTransaction then
        begin
          try
            DMCon.FDCon.StartTransaction;

            //Altera Registro da Tabela dadosGeraispedido
            if flagRegGravado=true then
              begin
                // Altera registro na tabela dadosgeraispedido
                with DMCon.FDQDadosGeraisPedido do
                  begin
                    Close;
                    SQL.Clear;
                    SQL.Add('Update dadosgeraispedido set valortotal = :vltot where numeropedido = :nurped');
                    params[0].AsCurrency :=valorTotal + (strToInt(edtQuantidade.Text) * StrToFloat(edtPrecoVenda.Text));
                    params[1].AsInteger  :=StrToInt(edtNumeroPedido.Text);
                    ExecSQL;
                  end;


                // Inclui registro na tabela pedidosprodutos
                with DMCon.FDQPedidosProdutos do
                  begin
                    Close;
                    SQL.Clear;
                    str_sql:='Insert into pedidosprodutos (numeropedido, codigoproduto, quantidade, ';
                    str_sql:=str_sql+'valorunitario, valortotal) values (:nurped, :codpro, :quan, :vlrunt, :vlrtot)';
                    SQL.Add(str_sql);
                    params[0].AsInteger :=StrToInt(edtNumeroPedido.Text);
                    params[1].AsString  :=edtCodigoProduto.Text;
                    params[2].AsInteger :=StrToInt(edtQuantidade.Text);
                    params[3].AsCurrency:=strToFloat(edtPrecoVenda.Text);
                    params[4].AsCurrency:=strToInt(edtQuantidade.Text) * StrToFloat(edtPrecoVenda.Text);
                    ExecSQL;

                    SQL.Clear;
                    SQL.Add('SELECT Max(idpedidosprodutos) as idpedidosprodutos from pedidosprodutos');
                    Open;
                  end;
              end;

            //Atualiza ClienteDataSet
            DMCon.cdsItensPedidos.Append;
            DMCon.cdsItensPedidoscodProd.AsInteger:=StrToInt(edtCodigoProduto.Text);
            DMCon.cdsItensPedidosdescProd.AsString:=edtDescricaoProduto.Text;
            DMCon.cdsItensPedidosquant.AsInteger:=strToInt(edtQuantidade.Text);
            DMCon.cdsItensPedidosvalorUnitario.AsFloat:= StrToFloat(edtPrecoVenda.Text);
            DMCon.cdsItensPedidosvalorTotal.AsFloat:= strToInt(edtQuantidade.Text) * StrToFloat(edtPrecoVenda.Text);
            if flagRegGravado=true then
              DMCon.cdsitenspedidosid.AsInteger:=DMCon.FDQPedidosProdutos.FieldByName('idpedidosprodutos').AsInteger;
            DMCon.cdsItensPedidos.Post;

            DMCon.FDCon.Commit;
          except
            on E: Exception do
              begin
                DMCon.FDCon.Rollback;
                flag:=1;
                MessageDlg(E.Message, mtError, [mbOk], 0);
              end;
          end;
        end;
        if flag=0 then
          begin
            valorTotal := valorTotal + DMCon.cdsItensPedidosvalorTotal.AsFloat;
            MostraTotal(valorTotal);
          end;
      edtCodigoProduto.SetFocus;
     end
  else
  if btnInserirGrid.Tag=1 then
    begin
      flag:=0;
      if not DMCon.FDCon.InTransaction then
        begin
          try
            DMCon.FDCon.StartTransaction;
            // Altera Item de Pedido no ClientDataSet
            vlrAux:=DMCon.cdsitenspedidosvalortotal.AsFloat;

            DMCon.cdsItensPedidos.Edit;
            DMCon.cdsItensPedidosquant.AsInteger:=strToInt(edtQuantidade.Text);
            DMCon.cdsItensPedidosvalorUnitario.AsFloat:= strToFloat(edtPrecoVenda.Text);
            DMCon.cdsItensPedidosvalorTotal.AsFloat:= strToInt(edtQuantidade.Text) * StrToFloat(edtPrecoVenda.Text);
            DMCon.cdsItensPedidos.Post;

            //Altera Registro da Tabela dadosGeraispedido  / pedidosprodutos
            if flagRegGravado=true then
              begin
                with DMCon.FDQDadosGeraisPedido do
                  begin
                    Close;
                    SQL.Clear;
                    str_sql:='Update dadosgeraispedido dg inner join pedidosprodutos pd on ';
                    str_sql:=str_sql + 'pd.numeropedido = dg.numeropedido set dg.valortotal = :vlt, pd.valorunitario = :vlrunt, pd.valortotal = :vlrtot, pd.quantidade = :quant where pd.numeropedido = :nurped and pd.idpedidosprodutos = :id';
                    SQL.Add(str_sql);
                    params[0].AsCurrency :=ValorTotal - vlrAux + (strToInt(edtQuantidade.Text) * StrToFloat(edtPrecoVenda.Text));
                    params[1].AsCurrency :=DMCon.cdsitenspedidosvalorunitario.AsCurrency;
                    params[2].AsCurrency :=DMCon.cdsitenspedidosvalortotal.AsCurrency;
                    params[3].AsInteger  :=DMCon.cdsitenspedidosquant.AsInteger;
                    params[4].AsInteger  :=StrToInt(edtNumeroPedido.Text);
                    params[5].AsInteger  :=DMCon.cdsitenspedidosid.AsInteger;
                    ExecSQL;
                  end;

              end;
            DMCon.FDCon.Commit;
          except
            on E: Exception do
              begin
                DMCon.FDCon.Rollback;
                flag:=1;
                MessageDlg(E.Message, mtError, [mbOk], 0);
              end;
          end;
        if flag=0 then
          begin
            valorTotal :=ValorTotal - vlrAux + (strToInt(edtQuantidade.Text) * StrToFloat(edtPrecoVenda.Text));
            dbgItensPedidoVenda.Tag:=0;
            MostraTotal(valorTotal);
            edtCodigoProduto.ReadOnly:=false;
            dbgItensPedidoVenda.SetFocus;
          end;
      end;
    end;
end;

procedure TfrmMain.MostraTotal(vlrTot:double);
begin
  panel2.Caption:=' Total do Pedido: '+FormatFloat('###,###,##0.#0', vlrTot);
end;

procedure TfrmMain.dbgItensPedidoVendaEnter(Sender: TObject);
begin
  LimpaCampos;
  KeyPreview:=false;
  btnInserirGrid.Tag:=0;
  btnInserirGrid.Caption:='Incluir Produto';
end;

procedure TfrmMain.dbgItensPedidoVendaExit(Sender: TObject);
begin
  KeyPreview:=true;
end;

procedure TfrmMain.dbgItensPedidoVendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  flag, idpedido :Integer;
begin
  if key=46 then
    begin
      // Deleta o Item de Pedido do ClientDataSet;
      if MessageDlg('Confirma Exclusão do Item de Pedido Venda?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        begin
          flag:=0;
          if not DMCon.FDCon.InTransaction then
            begin
              try
                DMCon.FDCon.StartTransaction;

                //Delete registro do clienteDataSet
                vlrAux:=DMCon.cdsitenspedidosvalortotal.AsCurrency;
                idpedido:=DMCon.cdsitenspedidosid.AsInteger;
                DMCon.cdsItensPedidos.Delete;

                if flagRegGravado=true then
                  begin
                    //Deleta registro na tabela PedidosProdutos...
                    with DMCon.FDQPedidosProdutos do
                      begin
                        Close;
                        SQL.Clear;
                        SQL.Add('Delete from pedidosprodutos where numeropedido = :nurped and idpedidosprodutos = :id');
                        params[0].AsInteger:=oAchaDadosGerais.NumeroPedido;
                        params[1].AsInteger:=idpedido;
                        ExecSQL;
                      end;

                    //Atualiza tabela DadosGeraisPedido...
                    with DMCon.FDQDadosGeraisPedido do
                      begin
                        Close;
                        SQL.Clear;
                        SQL.Add('Update dadosgeraispedido set valortotal = :vlrtot where numeropedido = :nurped');
                        params[0].AsCurrency:=valorTotal - vlrAux;
                        params[1].AsInteger :=oAchaDadosGerais.NumeroPedido;
                        ExecSQL;
                      end;
                  end;
                  DMCon.FDCon.Commit;
                except
                on E: Exception do
                  begin
                    flag:=1;
                    DMCon.FDCon.Rollback;
                    MessageDlg(E.Message, mtError, [mbOk], 0);
                  end;
              end;
              if flag=0 then
                begin
                  valorTotal:=valorTotal - vlrAux;
                  MostraTotal(ValorTotal);
                end;
              if DMCon.cdsItensPedidos.RecordCount=0 then
                edtCodigoProduto.SetFocus;
          end;
      end;
    end;
end;

procedure TfrmMain.dbgItensPedidoVendaKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    begin
      btnInserirGrid.Tag:=1;
      edtCodigoProduto.ReadOnly:=true;
      btnInserirGrid.Caption:='Alterar Pedido';
      edtCodigoProduto.Text:=DMCon.cdsItensPedidoscodProd.AsString;
      edtDescricaoProduto.Text:=DMCon.cdsItensPedidosdescProd.AsString;
      edtQuantidade.Text:=IntToStr(DMCon.cdsItensPedidosquant.AsInteger);
      edtPrecoVenda.Text:=DMCon.cdsitenspedidosvlrunit.AsString;
      vlrAux:=valorTotal - StrToFloat(DMCon.cdsItensPedidosvalorTotal.AsString);
      edtQuantidade.SetFocus;
    end;

end;

procedure TfrmMain.edtCodigoClienteChange(Sender: TObject);
begin
 edtNumeroPedido.Enabled:=edtCodigoCliente.Text='';
 Label9.Enabled:=edtCodigoCliente.Text='';
 btnCarregarPedidos.Enabled:=edtCodigoCliente.Text='';
 btnCancelarPedidos.Enabled:=edtCodigoCliente.Text='';
 gbDadosProduto.Enabled:=edtCodigoCliente.Text<>'';
end;

procedure TfrmMain.edtCodigoClienteEnter(Sender: TObject);
begin
  edtCodigoCliente.Text:='';
  edtNome.Text:='';
  edtCidade.Text:='';
  edtUf.Text:='';
  LimpaCampos;
  valorTotal:=0;
  btnCarregarPedidos.Enabled:=true;
  btnCancelarPedidos.Enabled:=true;
  panel2.Caption:='';
  label9.Visible:=true;
  edtNumeroPedido.Text:='';
  edtNumeroPedido.Visible:=true;
  if DMCon.cdsItensPedidos.RecordCount<>0 then
    DMCon.cdsItensPedidos.EmptyDataSet;
end;

procedure TfrmMain.edtCodigoClienteExit(Sender: TObject);
Begin
  if edtCodigoCliente.Text<>'' then
    begin
      oCliente:=TAchaCliente.create;
      if not oCliente.FindCliente(strtoint(edtCodigoCliente.Text)) then
        begin
          MessageDlg('Cliente não Cadastrado!', mtError, [mbOK], 0);
          oCliente.Free;
          edtCodigoCliente.SetFocus;
        end
      else
        begin
          edtNome.Text  :=oCliente.NomeCliente;
          edtCidade.Text:=oCliente.CidadeCliente;
          edtUf.Text    :=oCliente.UFCliente;
          flagRegGravado:=false;
          exit;
        end;
    end
  else
    edtNumeroPedido.SetFocus;
end;


procedure TfrmMain.LimpaCampos;
begin
  edtCodigoProduto.Text:='';
  edtDescricaoProduto.Text:='';
  edtPrecoVenda.Text:='';
  edtQuantidade.Text:=''
end;

procedure TfrmMain.edtCodigoProdutoEnter(Sender: TObject);
begin
  LimpaCampos;
  btnInserirGrid.Tag:=0;
  btnInserirGrid.Caption:='Incluir Produto';
  dbgItensPedidoVenda.Enabled:=DMCon.cdsItensPedidos.RecordCount<>0;
end;

procedure TfrmMain.edtCodigoProdutoExit(Sender: TObject);
begin
  if (edtCodigoProduto.Text<>'') and (edtCodigoProduto.Text<>'0') then
    begin
      oProduto:=TAchaProduto.create;
      if not oProduto.FindProduto(strtoint(edtCodigoProduto.Text)) then
        begin
          oProduto.Free;
          MessageDlg('Produto não Cadastrado!', mtError, [mbOK], 0);
          edtCodigoProduto.SetFocus;
          exit;
        end
      else
        begin
          edtDescricaoProduto.Text:=oProduto.DescricaoProduto;
          edtPrecoVenda.Text:=FormatFloat('##,###,##0.#0', oProduto.PrecoVenda);
        end;
    end
  else
    begin
      if DMCon.cdsItensPedidos.RecordCount<>0 then
        begin
          dbgItensPedidoVenda.SetFocus;
          DMCon.cdsItensPedidos.First;
        end
      else
        btnExit.SetFocus;
    end;
end;

procedure TfrmMain.edtNumeroPedidoExit(Sender: TObject);
begin
  btnCarregarPedidos.SetFocus;
end;

procedure TfrmMain.edtPrecoVendaExit(Sender: TObject);
begin
  if edtPrecoVenda.Text<>'0'  then
    edtPrecoVenda.Text:=formataMoeda(edtPrecoVenda.Text)
  else
    begin
      edtPrecoVenda.Text:=FloatToStr(oProduto.PrecoVenda);
      edtPrecoVenda.SetFocus;
    end;

end;

procedure TfrmMain.edtPrecoVendaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9','.',',']) then
    begin
     edtPrecoVenda.SetFocus;
    end;
end;

procedure TfrmMain.edtQuantidadeEnter(Sender: TObject);
begin
  KeyPreview:=true;
end;

procedure TfrmMain.edtQuantidadeExit(Sender: TObject);
begin
  if (edtQuantidade.Text='') or (edtQuantidade.Text='0') then
    begin
      MessageDlg('Quantidade de Venda não pode ser Nula!', mtError, [mbOK], 0);
      edtQuantidade.SetFocus;
      exit;
    end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
    begin
      SelectNext(ActiveControl, true, true);
      key:=#0;
    end;
end;

end.


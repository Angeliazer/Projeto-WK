object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Pedidos de Venda'
  ClientHeight = 449
  ClientWidth = 735
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 735
    Height = 449
    Align = alClient
    TabOrder = 0
    object btnGravarPedido: TButton
      Left = 6
      Top = 388
      Width = 100
      Height = 25
      Caption = 'Gravar Pedido'
      Enabled = False
      TabOrder = 5
      OnClick = btnGravarPedidoClick
    end
    object btnExit: TButton
      Left = 112
      Top = 388
      Width = 100
      Height = 25
      Caption = '&Exit'
      TabOrder = 3
      OnClick = btnExitClick
    end
    object gbDadosCliente: TGroupBox
      Left = 2
      Top = 3
      Width = 729
      Height = 110
      Caption = ' Dados do Cliente '
      TabOrder = 0
      object Label1: TLabel
        Left = 631
        Top = 64
        Width = 16
        Height = 13
        Caption = 'UF '
      end
      object Label2: TLabel
        Left = 372
        Top = 64
        Width = 33
        Height = 13
        Caption = 'Cidade'
      end
      object Label3: TLabel
        Left = 17
        Top = 64
        Width = 81
        Height = 13
        Caption = 'Nome do Cliente '
      end
      object Label4: TLabel
        Left = 17
        Top = 20
        Width = 69
        Height = 13
        Caption = 'C'#243'digo Cliente'
      end
      object Label9: TLabel
        Left = 119
        Top = 20
        Width = 55
        Height = 13
        Caption = 'Nro Pedido '
        Visible = False
      end
      object edtCidade: TEdit
        Left = 372
        Top = 83
        Width = 238
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object edtUf: TEdit
        Left = 631
        Top = 83
        Width = 34
        Height = 21
        Enabled = False
        TabOrder = 5
      end
      object edtNome: TEdit
        Left = 17
        Top = 83
        Width = 336
        Height = 21
        Enabled = False
        TabOrder = 3
      end
      object edtCodigoCliente: TEdit
        Left = 17
        Top = 37
        Width = 69
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 0
        OnChange = edtCodigoClienteChange
        OnEnter = edtCodigoClienteEnter
        OnExit = edtCodigoClienteExit
      end
      object btnCarregarPedidos: TButton
        Left = 193
        Top = 35
        Width = 100
        Height = 25
        Caption = 'Carregar Pedidos'
        Enabled = False
        TabOrder = 2
        OnClick = btnCarregarPedidosClick
      end
      object edtNumeroPedido: TEdit
        Left = 104
        Top = 37
        Width = 69
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 1
        Visible = False
        OnExit = edtNumeroPedidoExit
      end
      object btnCancelarPedidos: TButton
        Left = 314
        Top = 35
        Width = 91
        Height = 25
        Caption = 'Cancelar Pedido'
        TabOrder = 6
        OnClick = btnCancelarPedidosClick
      end
    end
    object gbDadosProduto: TGroupBox
      Left = 0
      Top = 113
      Width = 731
      Height = 76
      Caption = ' Dados do Produto '
      TabOrder = 1
      object Label5: TLabel
        Left = 14
        Top = 29
        Width = 74
        Height = 13
        Caption = 'C'#243'digo Produto'
      end
      object Label6: TLabel
        Left = 106
        Top = 29
        Width = 102
        Height = 13
        Caption = 'Descri'#231#227'o do Produto'
      end
      object Label7: TLabel
        Left = 537
        Top = 29
        Width = 75
        Height = 13
        Caption = 'Pre'#231'o de Venda'
      end
      object Label8: TLabel
        Left = 478
        Top = 29
        Width = 30
        Height = 13
        Caption = 'Quant'
      end
      object edtCodigoProduto: TEdit
        Left = 19
        Top = 46
        Width = 69
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 0
        OnEnter = edtCodigoProdutoEnter
        OnExit = edtCodigoProdutoExit
      end
      object edtDescricaoProduto: TEdit
        Left = 106
        Top = 46
        Width = 319
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object edtPrecoVenda: TEdit
        Left = 537
        Top = 46
        Width = 75
        Height = 21
        Alignment = taRightJustify
        TabOrder = 3
        OnExit = edtPrecoVendaExit
        OnKeyPress = edtPrecoVendaKeyPress
      end
      object btnInserirGrid: TButton
        Left = 633
        Top = 42
        Width = 92
        Height = 25
        Caption = '&Incluir Produto'
        TabOrder = 4
        OnClick = btnInserirGridClick
      end
      object edtQuantidade: TEdit
        Left = 446
        Top = 46
        Width = 62
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 2
        OnEnter = edtQuantidadeEnter
        OnExit = edtQuantidadeExit
      end
    end
    object gbItensPedido: TGroupBox
      Left = 2
      Top = 184
      Width = 729
      Height = 201
      Caption = 'Dados dos Itens do Pedido '
      TabOrder = 2
      object dbgItensPedidoVenda: TDBGrid
        Left = 3
        Top = 14
        Width = 720
        Height = 184
        DataSource = DMCon.dsItensPedidos
        Options = [dgTitles, dgIndicator, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnEnter = dbgItensPedidoVendaEnter
        OnExit = dbgItensPedidoVendaExit
        OnKeyDown = dbgItensPedidoVendaKeyDown
        OnKeyPress = dbgItensPedidoVendaKeyPress
        Columns = <
          item
            Expanded = False
            FieldName = 'codProd'
            Title.Alignment = taRightJustify
            Title.Caption = 'C'#243'd Produto'
            Width = 77
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'descProd'
            Title.Caption = 'Descri'#231#227'o do Produto'
            Width = 297
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'quant'
            Title.Alignment = taRightJustify
            Title.Caption = 'Quant'
            Width = 67
            Visible = True
          end
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'vlrunit'
            Title.Alignment = taRightJustify
            Title.Caption = 'Valor Unitario'
            Width = 121
            Visible = True
          end
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'vlrtot'
            Title.Alignment = taRightJustify
            Title.Caption = 'Valor Total'
            Width = 120
            Visible = True
          end>
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 422
      Width = 733
      Height = 26
      Align = alBottom
      Alignment = taLeftJustify
      TabOrder = 4
    end
  end
end

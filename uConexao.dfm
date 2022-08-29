object DMCon: TDMCon
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 223
  Width = 792
  object FDCon: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'User_Name=root')
    Left = 32
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\WK Technology\libmysql.dll'
    Left = 128
    Top = 16
  end
  object FDQDadosGeraisPedido: TFDQuery
    Connection = FDCon
    Left = 240
    Top = 80
  end
  object FDQClientes: TFDQuery
    Connection = FDCon
    Left = 32
    Top = 80
  end
  object FDQProdutos: TFDQuery
    Connection = FDCon
    Left = 128
    Top = 80
  end
  object FDQPedidosProdutos: TFDQuery
    Connection = FDCon
    Left = 368
    Top = 80
  end
  object dsItensPedidos: TDataSource
    DataSet = cdsitenspedidos
    OnDataChange = dsItensPedidosDataChange
    Left = 128
    Top = 144
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 256
    Top = 16
  end
  object cdsitenspedidos: TClientDataSet
    PersistDataPacket.Data = {
      890000009619E0BD010000001800000006000000000003000000890007636F64
      50726F640400010000000000086465736350726F640100490000000100055749
      445448020002002D00057175616E7404000100000000000D76616C6F72756E69
      746172696F08000400000000000A76616C6F72746F74616C0800040000000000
      02696404000100000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'codProd'
        DataType = ftInteger
      end
      item
        Name = 'descProd'
        DataType = ftString
        Size = 45
      end
      item
        Name = 'quant'
        DataType = ftInteger
      end
      item
        Name = 'valorunitario'
        DataType = ftFloat
      end
      item
        Name = 'valortotal'
        DataType = ftFloat
      end
      item
        Name = 'id'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    OnCalcFields = cdsItensPedidosCalcFields
    Left = 32
    Top = 144
    object cdsitenspedidoscodProd: TIntegerField
      FieldName = 'codProd'
    end
    object cdsitenspedidosdescProd: TStringField
      FieldName = 'descProd'
      Size = 45
    end
    object cdsitenspedidosquant: TIntegerField
      FieldName = 'quant'
    end
    object cdsitenspedidosvalorunitario: TFloatField
      FieldName = 'valorunitario'
    end
    object cdsitenspedidosvalortotal: TFloatField
      FieldName = 'valortotal'
    end
    object cdsitenspedidosvlrunit: TStringField
      FieldKind = fkCalculated
      FieldName = 'vlrunit'
      Size = 15
      Calculated = True
    end
    object cdsitenspedidosvlrtot: TStringField
      FieldKind = fkCalculated
      FieldName = 'vlrtot'
      Size = 15
      Calculated = True
    end
    object cdsitenspedidosid: TIntegerField
      FieldName = 'id'
    end
  end
end

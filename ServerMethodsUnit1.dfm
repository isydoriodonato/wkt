object ServerMethods1: TServerMethods1
  Height = 1080
  Width = 1440
  PixelsPerInch = 144
  object FDQpessoa: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT * From pessoa where dsdocumento = :DSDOC')
    Left = 256
    Top = 56
    ParamData = <
      item
        Name = 'DSDOC'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object FDQpessoaidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object FDQpessoaflnatureza: TSmallintField
      FieldName = 'flnatureza'
      Origin = 'flnatureza'
    end
    object FDQpessoadsdocumento: TWideStringField
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
    end
    object FDQpessoanmprimeiro: TWideStringField
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      Size = 100
    end
    object FDQpessoanmsegundo: TWideStringField
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      Size = 100
    end
    object FDQpessoadtregistro: TDateField
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorHome = 'D:\wkteste\Win32\Release'
    Left = 88
    Top = 160
  end
  object FDQendereco: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT * From endereco')
    Left = 376
    Top = 56
    object FDQenderecoidendereco: TLargeintField
      FieldName = 'idendereco'
      Origin = 'idendereco'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object FDQenderecoidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
    end
    object FDQenderecodscep: TWideStringField
      FieldName = 'dscep'
      Origin = 'dscep'
      Size = 15
    end
  end
  object FDQenderecoIntegracao: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT * From endereco_integracao')
    Left = 544
    Top = 56
    object FDQenderecoIntegracaoidendereco: TLargeintField
      FieldName = 'idendereco'
      Origin = 'idendereco'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object FDQenderecoIntegracaodsuf: TWideStringField
      FieldName = 'dsuf'
      Origin = 'dsuf'
      Size = 50
    end
    object FDQenderecoIntegracaonmcidade: TWideStringField
      FieldName = 'nmcidade'
      Origin = 'nmcidade'
      Size = 100
    end
    object FDQenderecoIntegracaonmbairro: TWideStringField
      FieldName = 'nmbairro'
      Origin = 'nmbairro'
      Size = 50
    end
    object FDQenderecoIntegracaonmlogradouro: TWideStringField
      FieldName = 'nmlogradouro'
      Origin = 'nmlogradouro'
      Size = 100
    end
    object FDQenderecoIntegracaodscomplemento: TWideStringField
      FieldName = 'dscomplemento'
      Origin = 'dscomplemento'
      Size = 100
    end
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=wk'
      'User_Name=postgres'
      'Password=dbtest123!@#'
      'Server=localhost'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 88
    Top = 48
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 88
    Top = 272
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 88
    Top = 376
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 88
    Top = 480
  end
  object FDQCadPessoa: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      
        'SELECT p.*, e.dscep, ei.*  From pessoa as p, endereco as e, ende' +
        'reco_integracao as ei'
      
        'Where p.idpessoa = e.idpessoa and e.idendereco = ei.idendereco a' +
        'nd p.dsdocumento = :DSDOC ')
    Left = 256
    Top = 160
    ParamData = <
      item
        Name = 'DSDOC'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object FDQCadPessoaidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object FDQCadPessoaflnatureza: TSmallintField
      FieldName = 'flnatureza'
      Origin = 'flnatureza'
    end
    object FDQCadPessoadsdocumento: TWideStringField
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
    end
    object FDQCadPessoanmprimeiro: TWideStringField
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      Size = 100
    end
    object FDQCadPessoanmsegundo: TWideStringField
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      Size = 100
    end
    object FDQCadPessoadtregistro: TDateField
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
    object FDQCadPessoadscep: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'dscep'
      Origin = 'dscep'
      Size = 15
    end
    object FDQCadPessoaidendereco: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'idendereco'
      Origin = 'idendereco'
    end
    object FDQCadPessoadsuf: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'dsuf'
      Origin = 'dsuf'
      Size = 50
    end
    object FDQCadPessoanmcidade: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nmcidade'
      Origin = 'nmcidade'
      Size = 100
    end
    object FDQCadPessoanmbairro: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nmbairro'
      Origin = 'nmbairro'
      Size = 50
    end
    object FDQCadPessoanmlogradouro: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nmlogradouro'
      Origin = 'nmlogradouro'
      Size = 100
    end
    object FDQCadPessoadscomplemento: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'dscomplemento'
      Origin = 'dscomplemento'
      Size = 100
    end
  end
  object RESTResponseCEP: TRESTResponse
    Left = 504
    Top = 232
  end
  object RESTClientCEP: TRESTClient
    BaseURL = 'http://viacep.com.br/ws/cep/json'
    Params = <>
    SynchronizedEvents = False
    Left = 424
    Top = 336
  end
  object RESTRequestCEP: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClientCEP
    Params = <>
    Response = RESTResponseCEP
    SynchronizedEvents = False
    Left = 584
    Top = 344
  end
end

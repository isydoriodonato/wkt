//
// Created by the DataSnap proxy generator.
// 28/09/2022 21:03:51
//

unit ClientClassesUnit1;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.FireDACJSONReflect, Data.DBXJSONReflect;

type

  IDSRestCachedTFDJSONDataSets = interface;

  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FGetPessoasCommand: TDSRestCommand;
    FGetPessoasCommand_Cache: TDSRestCommand;
    FPutPessoasCommand: TDSRestCommand;
    FPutsPessoasCommand: TDSRestCommand;
    FDelPessoaCommand: TDSRestCommand;
    FAtualizaPessoaCommand: TDSRestCommand;
    FIntegraCepCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function GetPessoas(dsdoc: string; const ARequestFilter: string = ''): TFDJSONDataSets;
    function GetPessoas_Cache(dsdoc: string; const ARequestFilter: string = ''): IDSRestCachedTFDJSONDataSets;
    function PutPessoas(dadosPessoas: TJSONArray; const ARequestFilter: string = ''): string;
    function PutsPessoas(dadosPessoas: TJSONArray; const ARequestFilter: string = ''): string;
    function DelPessoa(dsdoc: string; const ARequestFilter: string = ''): string;
    function AtualizaPessoa(novosDados: TJSONObject; const ARequestFilter: string = ''): string;
    function IntegraCep(idpessoa: string; dscep: string; const ARequestFilter: string = ''): Boolean;
  end;

  IDSRestCachedTFDJSONDataSets = interface(IDSRestCachedObject<TFDJSONDataSets>)
  end;

  TDSRestCachedTFDJSONDataSets = class(TDSRestCachedObject<TFDJSONDataSets>, IDSRestCachedTFDJSONDataSets, IDSRestCachedCommand)
  end;

const
  TServerMethods1_GetPessoas: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'dsdoc'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TFDJSONDataSets')
  );

  TServerMethods1_GetPessoas_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'dsdoc'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_PutPessoas: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'dadosPessoas'; Direction: 1; DBXType: 37; TypeName: 'TJSONArray'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_PutsPessoas: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'dadosPessoas'; Direction: 1; DBXType: 37; TypeName: 'TJSONArray'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_DelPessoa: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'dsdoc'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_AtualizaPessoa: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'novosDados'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_IntegraCep: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'idpessoa'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'dscep'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

implementation

function TServerMethods1Client.GetPessoas(dsdoc: string; const ARequestFilter: string): TFDJSONDataSets;
begin
  if FGetPessoasCommand = nil then
  begin
    FGetPessoasCommand := FConnection.CreateCommand;
    FGetPessoasCommand.RequestType := 'GET';
    FGetPessoasCommand.Text := 'TServerMethods1.GetPessoas';
    FGetPessoasCommand.Prepare(TServerMethods1_GetPessoas);
  end;
  FGetPessoasCommand.Parameters[0].Value.SetWideString(dsdoc);
  FGetPessoasCommand.Execute(ARequestFilter);
  if not FGetPessoasCommand.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetPessoasCommand.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FGetPessoasCommand.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetPessoasCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetPessoas_Cache(dsdoc: string; const ARequestFilter: string): IDSRestCachedTFDJSONDataSets;
begin
  if FGetPessoasCommand_Cache = nil then
  begin
    FGetPessoasCommand_Cache := FConnection.CreateCommand;
    FGetPessoasCommand_Cache.RequestType := 'GET';
    FGetPessoasCommand_Cache.Text := 'TServerMethods1.GetPessoas';
    FGetPessoasCommand_Cache.Prepare(TServerMethods1_GetPessoas_Cache);
  end;
  FGetPessoasCommand_Cache.Parameters[0].Value.SetWideString(dsdoc);
  FGetPessoasCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTFDJSONDataSets.Create(FGetPessoasCommand_Cache.Parameters[1].Value.GetString);
end;

function TServerMethods1Client.PutPessoas(dadosPessoas: TJSONArray; const ARequestFilter: string): string;
begin
  if FPutPessoasCommand = nil then
  begin
    FPutPessoasCommand := FConnection.CreateCommand;
    FPutPessoasCommand.RequestType := 'POST';
    FPutPessoasCommand.Text := 'TServerMethods1."PutPessoas"';
    FPutPessoasCommand.Prepare(TServerMethods1_PutPessoas);
  end;
  FPutPessoasCommand.Parameters[0].Value.SetJSONValue(dadosPessoas, FInstanceOwner);
  FPutPessoasCommand.Execute(ARequestFilter);
  Result := FPutPessoasCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.PutsPessoas(dadosPessoas: TJSONArray; const ARequestFilter: string): string;
begin
  if FPutsPessoasCommand = nil then
  begin
    FPutsPessoasCommand := FConnection.CreateCommand;
    FPutsPessoasCommand.RequestType := 'POST';
    FPutsPessoasCommand.Text := 'TServerMethods1."PutsPessoas"';
    FPutsPessoasCommand.Prepare(TServerMethods1_PutsPessoas);
  end;
  FPutsPessoasCommand.Parameters[0].Value.SetJSONValue(dadosPessoas, FInstanceOwner);
  FPutsPessoasCommand.Execute(ARequestFilter);
  Result := FPutsPessoasCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.DelPessoa(dsdoc: string; const ARequestFilter: string): string;
begin
  if FDelPessoaCommand = nil then
  begin
    FDelPessoaCommand := FConnection.CreateCommand;
    FDelPessoaCommand.RequestType := 'GET';
    FDelPessoaCommand.Text := 'TServerMethods1.DelPessoa';
    FDelPessoaCommand.Prepare(TServerMethods1_DelPessoa);
  end;
  FDelPessoaCommand.Parameters[0].Value.SetWideString(dsdoc);
  FDelPessoaCommand.Execute(ARequestFilter);
  Result := FDelPessoaCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.AtualizaPessoa(novosDados: TJSONObject; const ARequestFilter: string): string;
begin
  if FAtualizaPessoaCommand = nil then
  begin
    FAtualizaPessoaCommand := FConnection.CreateCommand;
    FAtualizaPessoaCommand.RequestType := 'POST';
    FAtualizaPessoaCommand.Text := 'TServerMethods1."AtualizaPessoa"';
    FAtualizaPessoaCommand.Prepare(TServerMethods1_AtualizaPessoa);
  end;
  FAtualizaPessoaCommand.Parameters[0].Value.SetJSONValue(novosDados, FInstanceOwner);
  FAtualizaPessoaCommand.Execute(ARequestFilter);
  Result := FAtualizaPessoaCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.IntegraCep(idpessoa: string; dscep: string; const ARequestFilter: string): Boolean;
begin
  if FIntegraCepCommand = nil then
  begin
    FIntegraCepCommand := FConnection.CreateCommand;
    FIntegraCepCommand.RequestType := 'GET';
    FIntegraCepCommand.Text := 'TServerMethods1.IntegraCep';
    FIntegraCepCommand.Prepare(TServerMethods1_IntegraCep);
  end;
  FIntegraCepCommand.Parameters[0].Value.SetWideString(idpessoa);
  FIntegraCepCommand.Parameters[1].Value.SetWideString(dscep);
  FIntegraCepCommand.Execute(ARequestFilter);
  Result := FIntegraCepCommand.Parameters[2].Value.GetBoolean;
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FGetPessoasCommand.DisposeOf;
  FGetPessoasCommand_Cache.DisposeOf;
  FPutPessoasCommand.DisposeOf;
  FPutsPessoasCommand.DisposeOf;
  FDelPessoaCommand.DisposeOf;
  FAtualizaPessoaCommand.DisposeOf;
  FIntegraCepCommand.DisposeOf;
  inherited;
end;

end.


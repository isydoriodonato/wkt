unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.PGDef,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.FMXUI.Wait, FireDAC.Stan.StorageBin,
  FireDAC.Stan.StorageJSON, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, Data.FireDACJSONReflect, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    FDQpessoa: TFDQuery;
    FDQpessoaidpessoa: TLargeintField;
    FDQpessoaflnatureza: TSmallintField;
    FDQpessoadsdocumento: TWideStringField;
    FDQpessoanmprimeiro: TWideStringField;
    FDQpessoanmsegundo: TWideStringField;
    FDQpessoadtregistro: TDateField;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDQendereco: TFDQuery;
    FDQenderecoidendereco: TLargeintField;
    FDQenderecoidpessoa: TLargeintField;
    FDQenderecodscep: TWideStringField;
    FDQenderecoIntegracao: TFDQuery;
    FDQenderecoIntegracaoidendereco: TLargeintField;
    FDQenderecoIntegracaodsuf: TWideStringField;
    FDQenderecoIntegracaonmcidade: TWideStringField;
    FDQenderecoIntegracaonmbairro: TWideStringField;
    FDQenderecoIntegracaonmlogradouro: TWideStringField;
    FDQenderecoIntegracaodscomplemento: TWideStringField;
    FDConnection: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDQCadPessoa: TFDQuery;
    FDQCadPessoaidpessoa: TLargeintField;
    FDQCadPessoaflnatureza: TSmallintField;
    FDQCadPessoadsdocumento: TWideStringField;
    FDQCadPessoanmprimeiro: TWideStringField;
    FDQCadPessoanmsegundo: TWideStringField;
    FDQCadPessoadtregistro: TDateField;
    FDQCadPessoadscep: TWideStringField;
    FDQCadPessoaidendereco: TLargeintField;
    FDQCadPessoadsuf: TWideStringField;
    FDQCadPessoanmcidade: TWideStringField;
    FDQCadPessoanmbairro: TWideStringField;
    FDQCadPessoanmlogradouro: TWideStringField;
    FDQCadPessoadscomplemento: TWideStringField;
    RESTResponseCEP: TRESTResponse;
    RESTClientCEP: TRESTClient;
    RESTRequestCEP: TRESTRequest;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetPessoas (const dsdoc: string) : TFDJSONDataSets;
    function PutPessoas (const dadosPessoas: TJSONArray) : String;
    function PutsPessoas (const dadosPessoas: TJSONArray) : String;
    function DelPessoa (const dsdoc: String) : String;
    function AtualizaPessoa ( const  novosDados :  TJSONObject ) : String ;

  end;
{$METHODINFO OFF}

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


uses System.StrUtils, ServerUnit, WebModuleUnit1;

var
  nPuts, nOld: Integer;
  strRetorno, msgCep: String;
  retCEPJSON: TJSONObject;



{ TServerMethods1 }

function TServerMethods1.AtualizaPessoa(const novosDados: TJSONObject): String;
begin
  FDConnection.StartTransaction;
  Try
    //Recuperando cadasto da pessoa
    FDQCadPessoa.Close;
    FDQCadPessoa.SQL.Clear;
    FDQCadPessoa.SQL.Add('SELECT p.*, e.dscep, ei.*  From pessoa as p, endereco as e, endereco_integracao as ei');
    FDQCadPessoa.SQL.Add('Where p.idpessoa = e.idpessoa and e.idendereco = ei.idendereco and dsdocumento = :DSDOC');
    FDQCadPessoa.ParamByName('DSDOC').Value:=novosDados.GetValue<String>('dsdocumento');
    FDQCadPessoa.Open;
    //Atualizando tabela pessoa
    FDConnection.ExecSQL('UPDATE pessoa	SET flnatureza='+novosDados.GetValue<String>('flnatureza')+', dsdocumento='+QuotedStr(novosDados.GetValue<String>('dsdocumento'))
    +', nmprimeiro='+QuotedStr(novosDados.GetValue<String>('nmprimeiro'))+', nmsegundo='+QuotedStr(novosDados.GetValue<String>('nmsegundo'))+' Where idpessoa = '+QuotedStr(FDQCadPessoaidpessoa.AsString));
    //Atualizando a tabela endereço
    FDConnection.ExecSQL('UPDATE endereco	SET dscep='+QuotedStr(novosDados.GetValue<String>('dscep'))+' Where idpessoa = '+QuotedStr(FDQCadPessoaidpessoa.AsString));
    Result:='Registros atualizados com sucesso!';
    //Atualizar tabela integração
    //Recuperando a chava primária do endereço
    FDQendereco.Close;
    FDQendereco.SQL.Clear;
    FDQendereco.SQL.Add('SELECT * From endereco where idpessoa = '+QuotedStr(FDQCadPessoaidpessoa.AsString)+' and dscep = '+QuotedStr(novosDados.GetValue<String>('dscep')));
    FDQendereco.Open;
    //Integração do CEP
    RESTClientCEP.BaseURL:='http://viacep.com.br/ws/'+FDQenderecodscep.AsString+'/json';
    Try
      RESTRequestCEP.Execute;
      strRetorno:=RESTResponseCEP.JSONText;
      retCEPJSON := TJSONObject.Create;
      retCEPJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(strRetorno),0) As TJSONObject;
      //Inserindo na tabela de integração
      FDConnection.ExecSQL('UPDATE endereco_integracao SET idendereco='+QuotedStr(FDQenderecoidendereco.AsString)+', dsuf='+QuotedStr(retCEPJSON.GetValue<String>('uf', ''))+', nmcidade='+QuotedStr(retCEPJSON.GetValue<String>('localidade', ''))
      +', nmbairro='+QuotedStr(retCEPJSON.GetValue<String>('bairro', ''))+', nmlogradouro='+QuotedStr(retCEPJSON.GetValue<String>('logradouro', ''))+', dscomplemento='+QuotedStr(retCEPJSON.GetValue<String>('complemento', ''))+' Where idendereco = '+QuotedStr(FDQenderecoidendereco.AsString));
      Inc(nPuts);
    except on e: Exception do
      FormServer.Memo1.Lines.Add(e.Message);
    End;
    FDConnection.Commit;
  except on e:Exception do
  begin
    FormServer.Memo1.Lines.Add(e.Message);
    FDConnection.Rollback;
  end;
  End;
end;

function TServerMethods1.DelPessoa(const dsdoc: String): String;
begin
  Try
    FDQCadPessoa.Close;
    FDQCadPessoa.SQL.Clear;
    FDQCadPessoa.SQL.Add('SELECT p.*, e.dscep, ei.*  From pessoa as p, endereco as e, endereco_integracao as ei');
    FDQCadPessoa.SQL.Add('Where p.idpessoa = e.idpessoa and e.idendereco = ei.idendereco and dsdocumento = :DSDOC');
    FDQCadPessoa.ParamByName('DSDOC').Value:=dsdoc;
    FDQCadPessoa.Open;
    if (FDQCadPessoa.RecordCount=1) then
    begin
      FDConnection.StartTransaction;
      Try
        FDConnection.ExecSQL('DELETE From endereco_integracao Where idendereco = '+QuotedStr(FDQCadPessoaidendereco.AsString));
        FDConnection.ExecSQL('DELETE From endereco Where idendereco = '+QuotedStr(FDQCadPessoaidendereco.AsString));
        FDConnection.ExecSQL('DELETE From pessoa Where idpessoa = '+QuotedStr(FDQCadPessoaidpessoa.AsString));
        FDConnection.Commit;
        Result:= 'Registro removido com sucesso!';
      except
        FDConnection.Rollback;
      End;
    end
    else
      Result:= 'Registro não encontrado!';

  except on e:Exception do
    FormServer.Memo1.Lines.Add(e.Message);
  End;
end;

function TServerMethods1.GetPessoas(const dsdoc: string): TFDJSONDataSets;
begin
  Try
    FDQCadPessoa.Active := False;
    FDQCadPessoa.SQL.Clear;
    FDQCadPessoa.SQL.Add('SELECT p.*, e.dscep, ei.*  From pessoa as p, endereco as e, endereco_integracao as ei');
    FDQCadPessoa.SQL.Add('Where p.idpessoa = e.idpessoa and e.idendereco = ei.idendereco and dsdocumento = :DSDOC');
    FDQCadPessoa.ParamByName('DSDOC').Value:=dsdoc;
    Result := TFDJSONDataSets.Create;
    TFDJSONDataSetsWriter.ListAdd(result, FDQCadPessoa);
  except on e:Exception do
    FormServer.Memo1.Lines.Add(e.Message);
  End;
end;



function TServerMethods1.PutPessoas(
  const dadosPessoas: TJSONArray): String;
begin
  FDConnection.StartTransaction;
  nPuts:=0;
  nOld:=0;
  TThread.Synchronize(nil,
  procedure
  begin
  try
      msgCep:='';
      FDQpessoa.Close;
      FDQpessoa.SQL.Clear;
      FDQpessoa.SQL.Add('SELECT * From pessoa where dsdocumento = :DSDOC');
      FDQpessoa.ParamByName('DSDOC').Value:=dadosPessoas.Get(0).GetValue<string>('dsdocumento', '');
      FDQpessoa.Open;
      if FDQpessoa.IsEmpty then
      begin
         //Inserindo o registro no banco
         FDConnection.ExecSQL('INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) VALUES ('
         +dadosPessoas.Get(0).GetValue<String>('flnatureza')+','+QuotedStr(dadosPessoas.Get(0).GetValue<String>('dsdocumento'))+','+QuotedStr(dadosPessoas.Get(0).GetValue<String>('nmprimeiro'))
         +','+QuotedStR(dadosPessoas.Get(0).GetValue<String>('nmsegundo'))+',Now())');
         //Recuperando a chava primária da pessoa
         FDQpessoa.Close;
         FDQpessoa.Open;
         //Inserindo endereço
         FDConnection.ExecSQL('INSERT INTO endereco (idpessoa, dscep) VALUES ('+QuotedStr(FDQpessoaidpessoa.AsString)+','+QuotedStr(dadosPessoas.Get(0).GetValue<String>('dscep'))+')');
         //IntegraCEP
         //Recuperando a chava primária do endereço
        FDQendereco.Close;
        FDQendereco.SQL.Clear;
        FDQendereco.SQL.Add('SELECT * From endereco where idpessoa = '+QuotedStr(FDQpessoaidpessoa.AsString)+' and dscep = '+QuotedStr(dadosPessoas.Get(0).GetValue<String>('dscep')));
        FDQendereco.Open;
        //Integração do CEP
        RESTClientCEP.BaseURL:='http://viacep.com.br/ws/'+FDQenderecodscep.AsString+'/json';
        Try
          RESTRequestCEP.Execute;
          strRetorno:=RESTResponseCEP.JSONText;
          retCEPJSON := TJSONObject.Create;
          retCEPJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(strRetorno),0) As TJSONObject;
          //Inserindo na tabela de integração
          FDConnection.ExecSQL('INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) VALUES ('
                                  +QuotedStr(FDQenderecoidendereco.AsString)+','+QuotedStr(retCEPJSON.GetValue<String>('uf', ''))+','+QuotedStr(retCEPJSON.GetValue<String>('localidade', ''))
                                  +','+QuotedStr(retCEPJSON.GetValue<String>('bairro', ''))+','+QuotedStr(retCEPJSON.GetValue<String>('logradouro', ''))+','+QuotedStr(retCEPJSON.GetValue<String>('complemento', ''))+')');
          Inc(nPuts);
        except on e: Exception do
          FormServer.Memo1.Lines.Add(e.Message);
        End;
      end
      else
        Inc(nOld);
    FDConnection.Commit;
  except on e:Exception do
    begin
      FormServer.Memo1.Lines.Add(e.Message);
      nPuts:=0;
      FDConnection.Rollback;
    end;
  end;
  strRetorno:=msgCep+IntToStr(nPuts)+' registro(s) adicionado(s)';
  If nOld>0 Then
    strRetorno:=strRetorno+' e '+IntToStr(nOld)+' registro(s) já estavam cadastrado(s) no banco de dados';
  end);
  Result:=strRetorno;
end;

function TServerMethods1.PutsPessoas(
  const dadosPessoas: TJSONArray): String;
begin
  FDConnection.StartTransaction;
  nPuts:=0;
  nOld:=0;
  TThread.Synchronize(nil,
  procedure
  var
    i: Integer;
  begin
  try
    for i := 0 to Pred(dadosPessoas.Size) do
    begin
      FDQpessoa.Close;
      FDQpessoa.SQL.Clear;
      FDQpessoa.SQL.Add('SELECT * From pessoa where dsdocumento = :DSDOC');
      FDQpessoa.ParamByName('DSDOC').Value:=dadosPessoas.Get(i).GetValue<string>('dsdocumento', '');
      FDQpessoa.Open;
      if FDQpessoa.IsEmpty then
      begin
         //Inserindo o registro no banco
         FDConnection.ExecSQL('INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) VALUES ('
         +dadosPessoas.Get(i).GetValue<String>('flnatureza')+','+QuotedStr(dadosPessoas.Get(i).GetValue<String>('dsdocumento'))+','+QuotedStr(dadosPessoas.Get(i).GetValue<String>('nmprimeiro'))
         +','+QuotedStR(dadosPessoas.Get(i).GetValue<String>('nmsegundo'))+',Now())');
         //Recuperando a chava primária da pessoa
         FDQpessoa.Close;
         FDQpessoa.Open;
         //Inserindo endereço
         FDConnection.ExecSQL('INSERT INTO endereco (idpessoa, dscep) VALUES ('+QuotedStr(FDQpessoaidpessoa.AsString)+','+QuotedStr(dadosPessoas.Get(i).GetValue<String>('dscep'))+')');
         //IntegraCEP
         FDQendereco.Close;
         FDQendereco.SQL.Clear;
         FDQendereco.SQL.Add('SELECT * From endereco where idpessoa = '+QuotedStr(FDQpessoaidpessoa.AsString)+' and dscep = '+QuotedStr(dadosPessoas.Get(i).GetValue<String>('dscep')));
         FDQendereco.Open;
         //Integração do CEP
         RESTClientCEP.BaseURL:='http://viacep.com.br/ws/'+FDQenderecodscep.AsString+'/json';
         Try
           RESTRequestCEP.Execute;
           strRetorno:=RESTResponseCEP.JSONText;
           retCEPJSON := TJSONObject.Create;
           retCEPJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(strRetorno),0) As TJSONObject;
           //Inserindo na tabela de integração
           FDConnection.ExecSQL('INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) VALUES ('
                                   +QuotedStr(FDQenderecoidendereco.AsString)+','+QuotedStr(retCEPJSON.GetValue<String>('uf', ''))+','+QuotedStr(retCEPJSON.GetValue<String>('localidade', ''))
                                   +','+QuotedStr(retCEPJSON.GetValue<String>('bairro', ''))+','+QuotedStr(retCEPJSON.GetValue<String>('logradouro', ''))+','+QuotedStr(retCEPJSON.GetValue<String>('complemento', ''))+')');
           Inc(nPuts);
         except on e: Exception do
           FormServer.Memo1.Lines.Add(e.Message);
         End;
      end
      else
        Inc(nOld);
    end;
    FDConnection.Commit;
  except on e:Exception do
    begin
      FormServer.Memo1.Lines.Add(e.Message);
      nPuts:=0;
      FDConnection.Rollback;
    end;
  end;
  strRetorno:=msgCEp+IntToStr(nPuts)+' registro(s) adicionado(s)';
  If nOld>0 Then
    strRetorno:=strRetorno+' e '+IntToStr(nOld)+' registro(s) já estavam cadastrado(s) no banco de dados';
  end);
  Result:=strRetorno;
end;

end.


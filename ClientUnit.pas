unit ClientUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.ListBox, FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  FireDAC.Stan.StorageBin, Data.FireDACJSONReflect,
  FireDAC.Stan.StorageJSON, System.JSON, REST.Types, REST.Client,
  Data.Bind.ObjectScope, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox;

type
  TFormCliente = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbNatureza: TComboBox;
    edtDocumento: TEdit;
    edtPrimeiro: TEdit;
    edtSegundo: TEdit;
    Label5: TLabel;
    edtCep: TEdit;
    ToolBar1: TToolBar;
    btnGet: TButton;
    FDMemTablePessoa: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldItemIndex: TLinkPropertyToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    btnPut: TButton;
    FDMemTableLote: TFDMemTable;
    btnLote: TButton;
    OpenDialog1: TOpenDialog;
    btnUpdate: TButton;
    btnDelete: TButton;
    sbNotify: TStatusBar;
    lbNotify: TLabel;
    procedure btnGetClick(Sender: TObject);
    procedure btnPutClick(Sender: TObject);
    procedure btnLoteClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetPessoas (const DSDOC: String);
    procedure PutPessoas (const dadosPessoa: TJSONArray);
    procedure PutsPessoas (const dadosPessoa: TJSONArray);
    procedure DelPessoa (const DSDOC: String);
    procedure UpPessoa (const novosDados: TJSONObject);
  public
    { Public declarations }
  end;

var
  FormCliente: TFormCliente;

implementation

{$R *.fmx}

uses ClientModuleUnit1;

{ TForm2 }

Var
jo, jor: TJSONObject;
ja: TJSONArray;

procedure TFormCliente.btnDeleteClick(Sender: TObject);
Var
i: Integer;
begin
DelPessoa(edtDocumento.Text);
for i := 0 to Pred(ComponentCount) do
if Components[i] is TEdit then
  TEdit(Components[i]).Text:='';
cbNatureza.SetFocus;
end;

procedure TFormCliente.btnGetClick(Sender: TObject);
var
dsdocumento: String;
begin
  dsdocumento :=InputBox('Cliente - Wk Teste técnico','Nº Documento','');
  GetPessoas(dsdocumento);
  if FDMemTablePessoa.IsEmpty then
    ShowMessage('Registos não encontrados para documento nº '+dsdocumento);
end;



procedure TFormCliente.btnLoteClick(Sender: TObject);
Var
read, write: TStringlist;
i, j: Integer;

begin
read := TStringList.Create;
write := TStringList.Create;
FDMemTableLote.Open;
if OpenDialog1.Execute then
begin
Try
  Try
    read.LoadFromFile(OpenDialog1.FileName);
    write.Delimiter:=';';
    write.StrictDelimiter := True;
    for i := 0 to Pred(read.Count) do
    begin
      write.DelimitedText := read.Strings[i];
      FDMemTableLote.Append;
      for j := 0 to Pred(FDMemTableLote.FieldDefs.Count) do
        FDMemTableLote.Fields[j].Value := write.Strings[j];
      FDMemTableLote.post;
    end;

  except on e:Exception do
    ShowMessage(e.Message);
  End;
Finally
  //Enviar para o servidor
  ja := TJSONArray.Create;
  FDMemTableLote.First;
  while NOT FDMemTableLote.Eof do
  begin
    jo := TJSONObject.Create;
    jo.AddPair('flnatureza', FDMemTableLote.FieldByName('flnatureza').AsString);
    jo.AddPair('dsdocumento', FDMemTableLote.FieldByName('dsdocumento').AsString);
    jo.AddPair('nmprimeiro', FDMemTableLote.FieldByName('nmprimeiro').AsString);
    jo.AddPair('nmsegundo', FDMemTableLote.FieldByName('nmsegundo').AsString);
    jo.AddPair('dscep', FDMemTableLote.FieldByName('dscep').AsString);
    ja.AddElement(jo);
    FDMemTableLote.Next;
  end;
  TThread.CreateAnonymousThread(
  procedure
  begin
    PutsPessoas(ja);
  end).Start;

End;

end;

end;

procedure TFormCliente.btnPutClick(Sender: TObject);
var
i: Integer;
begin
for i := 0 to Pred(ComponentCount) do
if Components[i] is TEdit then
  If (TEdit(Components[i]).Text='') Then
  begin
    lbNotify.Text:='É necessário preencher todos os campos!';
    exit;
  end;
ja := TJSONArray.Create;
jo := TJSONObject.Create;
jo.AddPair('flnatureza', cbNatureza.ItemIndex);
jo.AddPair('dsdocumento', edtDocumento.Text);
jo.AddPair('nmprimeiro', edtPrimeiro.Text);
jo.AddPair('nmsegundo', edtSegundo.Text);
jo.AddPair('dscep',edtCep.Text);
ja.AddElement(jo);
PutPessoas(ja);
for i := 0 to Pred(ComponentCount) do
if Components[i] is TEdit then
  TEdit(Components[i]).Text:='';
cbNatureza.SetFocus;
end;

procedure TFormCliente.btnUpdateClick(Sender: TObject);
Var
i: Integer;
begin
jo := TJSONObject.Create;
jo.AddPair('flnatureza', cbNatureza.ItemIndex);
jo.AddPair('dsdocumento', edtDocumento.Text);
jo.AddPair('nmprimeiro', edtPrimeiro.Text);
jo.AddPair('nmsegundo', edtSegundo.Text);
jo.AddPair('dscep',edtCep.Text);
UpPessoa(jo);
for i := 0 to Pred(ComponentCount) do
if Components[i] is TEdit then
  TEdit(Components[i]).Text:='';
cbNatureza.SetFocus;
end;

procedure TFormCliente.DelPessoa(const DSDOC: String);
var
  retorno: string;
begin
  FDMemTablePessoa.Close;
  lbNotify.Text:='Processo em andamento...';
  retorno := ClientModule1.ServerMethods1Client.DelPessoa(DSDOC);
  lbNotify.Text:=retorno+'!';
end;

procedure TFormCliente.GetPessoas(const DSDOC: String);
var
  LDataSetList: TFDJSONDataSets;
begin
  FDMemTablePessoa.Close;
  LDataSetList := ClientModule1.ServerMethods1Client.GetPessoas(DSDOC);
  FDMemTablePessoa.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));
  FDMemTablePessoa.Open;
end;

procedure TFormCliente.PutPessoas(const dadosPessoa: TJSONArray);
Var
  retorno: String;
begin
  lbNotify.Text:='Processo em andamento...';
  retorno := ClientModule1.ServerMethods1Client.PutPessoas(dadosPessoa);
  lbNotify.Text:=retorno+'!';
end;

procedure TFormCliente.PutsPessoas(const dadosPessoa: TJSONArray);
Var
  retorno: String;
begin
  lbNotify.Text:='Processo em andamento...';
  retorno := ClientModule1.ServerMethods1Client.PutsPessoas(dadosPessoa);
  lbNotify.Text:=retorno+'!';
end;

procedure TFormCliente.UpPessoa(const novosDados: TJSONObject);
Var
  retorno: String;
begin
  lbNotify.Text:='Processo em andamento...';
  retorno := ClientModule1.ServerMethods1Client.AtualizaPessoa(novosDados);
  lbNotify.Text:=retorno+'!';

end;

end.

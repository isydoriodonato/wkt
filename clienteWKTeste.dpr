program clienteWKTeste;

uses
  System.StartUpCopy,
  FMX.Forms,
  ClientUnit in 'ClientUnit.pas' {FormCliente},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormCliente, FormCliente);
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.Run;
end.

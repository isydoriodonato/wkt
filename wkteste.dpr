program wkteste;
{$APPTYPE GUI}

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ServerUnit in 'ServerUnit.pas' {FormServer},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas' {ServerMethods1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TFormServer, FormServer);
  Application.Run;
end.

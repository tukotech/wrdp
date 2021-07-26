program wrdp;

uses
  Vcl.Forms,
  main in 'main.pas' {FormMain},
  MSTSCLib_TLB in 'components\RdpControl\MSTSCLib_TLB.pas',
  ConnInfo in 'ConnInfo.pas' {FormConnInfo},
  About in 'About.pas' {FormAbout},
  Detached in 'Detached.pas' {FormDetached},
  Shared in 'Shared.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormConnInfo, FormConnInfo);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormDetached, FormDetached);
  Application.Run;
end.

program wrdp;

uses
  Vcl.Forms,
  main in 'main.pas' {FormMain},
  MSTSCLib_TLB in 'components\RdpControl\MSTSCLib_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

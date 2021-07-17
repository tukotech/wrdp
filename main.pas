unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.OleCtrls, MSTSCLib_TLB,
  Vcl.StdCtrls;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheet1: TTabSheet;
    MsRdpClient91: TMsRdpClient9;
    Button1: TButton;
    TabSheet2: TTabSheet;
    MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
begin
  MsRdpClient91.Server := '192.168.2.21';
  MsRdpClient91.Domain := '.';
  MsRdpClient91.UserName := 'z';
  MsRdpClient91.AdvancedSettings9.ClearTextPassword := 'P@$$w0rd';
  MsRdpClient91.Connect;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  MsRdpClient9NotSafeForScripting1.Server := '192.168.2.21';
  MsRdpClient9NotSafeForScripting1.Domain := '.';
  MsRdpClient9NotSafeForScripting1.UserName := 'z';
  MsRdpClient9NotSafeForScripting1.AdvancedSettings9.ClearTextPassword := 'P@$$w0rd';
  MsRdpClient9NotSafeForScripting1.Connect;
end;

end.

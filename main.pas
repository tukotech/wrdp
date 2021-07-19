unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.OleCtrls, MSTSCLib_TLB,
  Vcl.StdCtrls, Vcl.Grids, inifiles;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheet1: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting;
    sgConnectionInfo: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
var
  as7 : IMsRdpClientAdvancedSettings7;
begin
  MsRdpClient9NotSafeForScripting1.Server := '192.168.2.21';
  MsRdpClient9NotSafeForScripting1.Domain := '.';
  MsRdpClient9NotSafeForScripting1.UserName := 'z';
  MsRdpClient9NotSafeForScripting1.AdvancedSettings9.ClearTextPassword := 'P@$$w0rd';
  MsRdpClient9NotSafeForScripting1.SecuredSettings3.KeyboardHookMode := 1;
  as7 := MsRdpClient9NotSafeForScripting1.AdvancedSettings as IMsRdpClientAdvancedSettings7;
  as7.EnableCredSspSupport := true;
  MsRdpClient9NotSafeForScripting1.Connect;

end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  MsRdpClient9NotSafeForScripting1.Server := '192.168.2.21';
  MsRdpClient9NotSafeForScripting1.Domain := '.';
  MsRdpClient9NotSafeForScripting1.UserName := 'z';
  MsRdpClient9NotSafeForScripting1.AdvancedSettings9.ClearTextPassword := 'P@$$w0rd';
  MsRdpClient9NotSafeForScripting1.Connect;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    Ini.WriteInteger('Position','Column1', sgConnectionInfo.ColWidths[0]);
    Ini.WriteInteger('Position','Column2', sgConnectionInfo.ColWidths[1]);
    Ini.WriteInteger('Position','Column3', sgConnectionInfo.ColWidths[2]);
    Ini.WriteInteger('Position','Column4', sgConnectionInfo.ColWidths[3]);
    Ini.WriteBool( 'Form', 'InitMax', WindowState = wsMaximized );
  finally
     Ini.Free;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
  x : Integer;
begin
  sgConnectionInfo.Cells[0,0] := 'Hostname/IP';
  sgConnectionInfo.Cells[1,0] := 'Domain';
  sgConnectionInfo.Cells[2,0] := 'Username';
  sgConnectionInfo.Cells[3,0] := 'Password';

  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    x := Ini.ReadInteger('Position','Column1', 64);
    sgConnectionInfo.ColWidths[0] := Ini.ReadInteger('Position','Column1', 64);
    sgConnectionInfo.ColWidths[1] := Ini.ReadInteger('Position','Column2', 64);
    sgConnectionInfo.ColWidths[2] := Ini.ReadInteger('Position','Column3', 64);
    sgConnectionInfo.ColWidths[3] := Ini.ReadInteger('Position','Column4', 64);

    if Ini.ReadBool( 'Form', 'InitMax', false ) then
       WindowState := wsMaximized
     else
       WindowState := wsNormal;
  finally
    Ini.Free;
  end;
end;

end.

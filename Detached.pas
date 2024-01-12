unit Detached;

interface

uses
  inifiles,
  Winapi.Windows,
  Winapi.Messages,
  Shared,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.OleCtrls,
  MSTSCLib_TLB;

type
  TFormDetached = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    Frdp : TMsRdpClient9NotSafeForScripting;
  public
    { Public declarations }
    procedure RdpConnect(node : TNodeInformation);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  end;

var
  FormDetached: TFormDetached;

implementation
uses
  Vcl.StdCtrls;

{$R *.dfm}
procedure TFormDetached.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormDetached.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    Ini.WriteInteger('FormDetached','Top', self.Top);
    Ini.WriteInteger('FormDetached','Left', self.Left);
    Ini.WriteInteger('FormDetached','Width', self.Width);
    Ini.WriteInteger('FormDetached','Height', self.Height);
  finally
     Ini.Free;
  end;
end;

procedure TFormDetached.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    self.Top := Ini.ReadInteger( 'FormDetached', 'Top', 0);
    self.Left := Ini.ReadInteger( 'FormDetached', 'Left', 0);
    self.Width := Ini.ReadInteger( 'FormDetached', 'Width', 1024);
    self.Height := Ini.ReadInteger( 'FormDetached', 'Height', 768);
  finally
    Ini.Free;
  end;
end;

procedure TFormDetached.FormResize(Sender: TObject);
begin
  if Frdp <> nil then
  begin
    if FormDetached.Visible then
    begin
//      Frdp.DesktopWidth := FormDetached.ClientWidth;
//      Frdp.DesktopHeight := FormDetached.ClientHeight;
    end;
  end;
end;

procedure TFormDetached.RdpConnect(node : TNodeInformation);
begin
  if Frdp = nil then
  begin
    Frdp := TMsRdpClient9NotSafeForScripting.Create(FormDetached);
    Frdp.Parent := FormDetached;
    Frdp.Align := alClient;
  end;

  if Frdp.Connected = 1 then
  begin
    Frdp.Disconnect;
    Frdp.DesktopWidth := FormDetached.ClientWidth;
    Frdp.DesktopHeight := FormDetached.ClientHeight;
  end;

  Frdp.Server := node.HostOrIP;
  Frdp.AdvancedSettings8.RDPPort := node.Port;
  if node.Admin = TCheckBoxState.cbChecked then
    Frdp.AdvancedSettings8.ConnectToAdministerServer := true;

  Frdp.Domain := node.Domain;
  Frdp.UserName := node.Username;
  Frdp.Server := node.HostOrIP;
  if Length(node.password)>0 then
    Frdp.AdvancedSettings9.ClearTextPassword := node.password;
  Frdp.SecuredSettings3.KeyboardHookMode := 1;
  with Frdp.AdvancedSettings as IMsRdpClientAdvancedSettings7 do
  begin
    EnableCredSspSupport := true;
    SmartSizing := true;
  end;
  Frdp.Connect;

end;

end.


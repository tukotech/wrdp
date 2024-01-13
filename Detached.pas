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
    procedure MsRdpClient9NotSafeForScriptingDisconnected(ASender: TObject;
      discReason: Integer);
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
var
  w, h: Integer;
begin
  if Frdp <> nil then
  begin
    if FormDetached.Active then
    begin
      if Frdp.Connected = 1 then
      begin
        w := FormDetached.ClientWidth;
        h := FormDetached.ClientHeight;
        Frdp.UpdateSessionDisplaySettings(w,h,w,h,0,100,100);
      end;
    end;
  end;
end;

procedure TFormDetached.RdpConnect(node : TNodeInformation);
begin
  //Need to destroy Rdp object before it can be reused
  if Frdp <> nil then
  begin
    if Frdp.Connected = 1 then
    begin
      Frdp.Disconnect;
      FreeAndNil(Frdp);
    end;
  end;

  if Frdp = nil then
  begin
    Frdp := TMsRdpClient9NotSafeForScripting.Create(FormDetached);
    Frdp.Parent := FormDetached;
    Frdp.Align := alClient;
    Frdp.OnDisconnected := MsRdpClient9NotSafeForScriptingDisconnected;
  end;

  try
    Frdp.DesktopWidth := FormDetached.ClientWidth;
    Frdp.DesktopHeight := FormDetached.ClientHeight;

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
  except
    On E: Exception do
      ShowMessage(E.ClassName+' error raised, with message : '+
        E.Message);
  end;

end;

procedure TFormDetached.MsRdpClient9NotSafeForScriptingDisconnected(
  ASender: TObject; discReason: Integer);
var
  rdp : TMsRdpClient9NotSafeForScripting;
  msg : string;
begin
  rdp := ASender as TMsRdpClient9NotSafeForScripting;
  msg := IntToStr(discReason) + ' : ' + rdp.GetErrorDescription(discReason, rdp.ExtendedDisconnectReason);
  OutputDebugString(PWideChar(msg));
end;

end.


unit ConnInfo;

interface

uses
  inifiles,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormConnInfo = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditHostnameOrIp: TEdit;
    Label3: TLabel;
    EditDomain: TEdit;
    Label4: TLabel;
    EditUsername: TEdit;
    Label5: TLabel;
    EditPassword: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConnInfo: TFormConnInfo;

implementation

{$R *.dfm}

procedure TFormConnInfo.Button1Click(Sender: TObject);
begin
  ShowMessage(EditPassword.Text);
end;

procedure TFormConnInfo.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    Ini.WriteInteger('FormConnInfo','Top', self.Top);
    Ini.WriteInteger('FormConnInfo','Left', self.Left);
  finally
     Ini.Free;
  end;
end;

procedure TFormConnInfo.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    self.Top := Ini.ReadInteger( 'FormConnInfo', 'Top', 0);
    self.Left := Ini.ReadInteger( 'FormConnInfo', 'Left', 0);
  finally
    Ini.Free;
end;
end;

end.


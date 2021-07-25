unit Detached;

interface

uses
  inifiles,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, MSTSCLib_TLB;

type
  TFormDetached = class(TForm)
    Rdp: TMsRdpClient9NotSafeForScripting;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDetached: TFormDetached;

implementation

{$R *.dfm}

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

end.


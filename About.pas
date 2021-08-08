unit About;

interface

uses
  inifiles,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormAbout = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    LabelDedication: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

function GetFileVersion(exeName : string): string;
const
  c_StringInfo = 'StringFileInfo\040904E4\FileVersion';
var
  n, Len : cardinal;
  Buf, Value : PChar;
begin
  Result := '';
  n := GetFileVersionInfoSize(PChar(exeName),n);
  if n > 0 then begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(exeName),0,n,Buf);
      if VerQueryValue(Buf,PChar(c_StringInfo),Pointer(Value),Len) then begin
        Result := Trim(Value);
      end;
    finally
      FreeMem(Buf,n);
    end;
  end;
end;

procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    Ini.WriteInteger('FormAbout','Top', self.Top);
    Ini.WriteInteger('FormAbout','Left', self.Left);
    Ini.WriteInteger('FormAbout','Width', self.Width);
  finally
     Ini.Free;
  end;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    self.Top := Ini.ReadInteger( 'FormAbout', 'Top', 0);
    self.Left := Ini.ReadInteger( 'FormAbout', 'Left', 0);
    self.Width := Ini.ReadInteger( 'FormAbout', 'Width', 300);
  finally
    Ini.Free;
  end;

  self.Caption := self.Caption + ' v:' + GetFileVersion(ParamStr(0));
end;

end.


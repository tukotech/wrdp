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

procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    Ini.WriteInteger('FormAbout','Top', self.Top);
    Ini.WriteInteger('FormAbout','Left', self.Left);
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
  finally
    Ini.Free;
  end;
end;

end.


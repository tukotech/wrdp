unit main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.OleCtrls, MSTSCLib_TLB,
  Vcl.StdCtrls, Vcl.Grids, inifiles;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheet1: TTabSheet;
    MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting;
    sgConnectionInfo: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgConnectionInfoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure sgConnectionInfoDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure ConnectToServer;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

// Save a TStringGrid to a file

procedure SaveStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var
  f:    TextFile;
  i, k: Integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);
  with StringGrid do
  begin
    // Write number of Columns/Rows
    Writeln(f, ColCount);
    Writeln(f, RowCount);
    // loop through cells
    for i := 0 to ColCount - 1 do
      for k := 0 to RowCount - 1 do
        Writeln(F, Cells[i, k]);
  end;
  CloseFile(F);
end;

// Load a TStringGrid from a file

procedure LoadStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var
  f:          TextFile;
  iTmp, i, k: Integer;
  strTemp:    String;
begin
  AssignFile(f, FileName);
  Reset(f);
  with StringGrid do
  begin
    // Get number of columns
    Readln(f, iTmp);
    ColCount := iTmp;
    // Get number of rows
    Readln(f, iTmp);
    RowCount := iTmp;
    // loop through cells & fill in values
    for i := 0 to ColCount - 1 do
      for k := 0 to RowCount - 1 do
      begin
        Readln(f, strTemp);
        Cells[i, k] := strTemp;
      end;
  end;
  CloseFile(f);
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

  SaveStringGrid(sgConnectionInfo, ChangeFileExt( Application.ExeName, '.cfg' ));
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
  cfg : TFileName;
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
  cfg := ChangeFileExt( Application.ExeName, '.cfg' );
  if System.SysUtils.FileExists(cfg) then
    LoadStringGrid(sgConnectionInfo, cfg);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  sgConnectionInfo.SetFocus;
end;

procedure TFormMain.ConnectToServer();
var
  host : string;
  domain : string;
  username: string;
  password: string;
  row : Integer;
  as7 : IMsRdpClientAdvancedSettings7;
begin
  row := sgConnectionInfo.Row;
  host := sgConnectionInfo.Cells[0, row];
  domain := sgConnectionInfo.Cells[1, row];
  username := sgConnectionInfo.Cells[2, row];
  password := sgConnectionInfo.Cells[3, row];
  MsRdpClient9NotSafeForScripting1.Server := host;
  MsRdpClient9NotSafeForScripting1.Domain := domain;
  MsRdpClient9NotSafeForScripting1.UserName := username;
  MsRdpClient9NotSafeForScripting1.AdvancedSettings9.ClearTextPassword := password;
  MsRdpClient9NotSafeForScripting1.SecuredSettings3.KeyboardHookMode := 1;
  as7 := MsRdpClient9NotSafeForScripting1.AdvancedSettings as IMsRdpClientAdvancedSettings7;
  as7.EnableCredSspSupport := true;
  MsRdpClient9NotSafeForScripting1.Connect;
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormMain.sgConnectionInfoDblClick(Sender: TObject);
begin
  ConnectToServer;
end;

procedure TFormMain.sgConnectionInfoKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
  begin
    ConnectToServer;
  end;
end;

end.

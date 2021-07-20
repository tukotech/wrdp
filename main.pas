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
  TCustomGridHelper = class helper for TCustomGrid
  public
    procedure DelRow(ARow: Integer);
  end;

  TFormMain = class(TForm)
    PageControlMain: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheet1: TTabSheet;
    MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting;
    sgConnectionInfo: TStringGrid;
    TabSheet2: TTabSheet;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgConnectionInfoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure sgConnectionInfoDblClick(Sender: TObject);
    procedure sgConnectionInfoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgConnectionInfoSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
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
procedure TCustomGridHelper.DelRow(ARow: Integer);
begin
  Self.DeleteRow(ARow);
end;

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
  PageControlMain.ActivePage := TabSheetMain;
  sgConnectionInfo.SetFocus;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
  TabSheet : TTabSheet;
  rdp : TMsRdpClient9NotSafeForScripting;
begin
  TabSheet := TTabSheet.Create(PageControlMain);
  TabSheet.Caption := 'New Page';
  TabSheet.PageControl := PageControlMain;

  rdp := TMsRdpClient9NotSafeForScripting.Create(TabSheet);
  rdp.Align := alClient;
end;

procedure TFormMain.ConnectToServer();
var
  host : string;
  domain : string;
  username: string;
  password: string;
  row : Integer;
  as7 : IMsRdpClientAdvancedSettings7;
  TabSheet : TTabSheet;
  rdp : TMsRdpClient9NotSafeForScripting;
begin
  row := sgConnectionInfo.Row;
  host := sgConnectionInfo.Cells[0, row];
  domain := sgConnectionInfo.Cells[1, row];
  username := sgConnectionInfo.Cells[2, row];
  password := sgConnectionInfo.Cells[3, row];

  TabSheet := TTabSheet.Create(PageControlMain);
  TabSheet.Caption := host;
  TabSheet.PageControl := PageControlMain;

  rdp := TMsRdpClient9NotSafeForScripting.Create(TabSheet);
  rdp.Parent := TabSheet;
  rdp.Align := alClient;
//  rdp := TM

  rdp.Server := host;
  rdp.Domain := domain;
  rdp.UserName := username;
  rdp.AdvancedSettings9.ClearTextPassword := password;
  rdp.SecuredSettings3.KeyboardHookMode := 1;
  as7 := rdp.AdvancedSettings as IMsRdpClientAdvancedSettings7;
  as7.EnableCredSspSupport := true;
  rdp.Connect;
  PageControlMain.ActivePage := TabSheet;
end;

procedure TFormMain.sgConnectionInfoDblClick(Sender: TObject);
begin
  ConnectToServer;
end;

procedure TFormMain.sgConnectionInfoKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then begin ConnectToServer; end
end;

procedure TFormMain.sgConnectionInfoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN then
  begin
    if sgConnectionInfo.Cells[0,sgConnectionInfo.Row] <> '' then
    begin
      sgConnectionInfo.RowCount := sgConnectionInfo.RowCount + 1;
      sgConnectionInfo.Options := sgConnectionInfo.Options + [goEditing] - [goRowSelect];
      sgConnectionInfo.Row := sgConnectionInfo.RowCount - 1;
      sgConnectionInfo.Col := 0;
      sgConnectionInfo.EditorMode := true;
    end else
    begin
      sgConnectionInfo.Options := sgConnectionInfo.Options + [goEditing] - [goRowSelect]
    end;
  end
  else if Key = VK_DELETE then
  begin
    sgConnectionInfo.Options := sgConnectionInfo.Options - [goEditing] + [goRowSelect];
    sgConnectionInfo.DelRow(sgConnectionInfo.Row);
  end;
end;

procedure TFormMain.sgConnectionInfoSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if sgConnectionInfo.Cells[0,ARow] <> '' then
  begin
    sgConnectionInfo.Options := sgConnectionInfo.Options - [goEditing] + [goRowSelect]
  end;
end;

end.

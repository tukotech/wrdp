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
    LabelHostOrIp: TLabel;
    EditHostnameOrIp: TEdit;
    Label3: TLabel;
    EditDomain: TEdit;
    LabelUsername: TLabel;
    EditUsername: TEdit;
    Label5: TLabel;
    EditPassword: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    ButtonCancel: TButton;
    ButtonSave: TButton;
    CheckBoxInherit: TCheckBox;
    EditPort: TEdit;
    LabelPort: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonCancelClick(Sender: TObject);
    procedure CheckBoxInheritClick(Sender: TObject);
  private
    { Private declarations }
    FCancelClose : Boolean;
  public
    { Public declarations }
  end;

var
  FormConnInfo: TFormConnInfo;

implementation

{$R *.dfm}


procedure TFormConnInfo.ButtonCancelClick(Sender: TObject);
begin
  self.FCancelClose := true;
  self.ModalResult := mrCancel;
end;

procedure TFormConnInfo.ButtonSaveClick(Sender: TObject);
begin
  if (EditHostnameOrIp.GetTextLen = 0)
  and (CheckBoxInherit.State = cbUnchecked)
  then
    LabelHostOrIp.Font.Color := clRed
  else
    LabelHostOrIp.Font.Color := clWindowText;

  if (EditUsername.GetTextLen = 0)
  and (CheckBoxInherit.State <> cbChecked)
  then
    LabelUsername.Font.Color := clRed
  else
    LabelUsername.Font.Color := clWindowText;


  if (EditHostnameOrIp.GetTextLen > 0)
  and ((EditUsername.GetTextLen > 0)
    or (CheckBoxInherit.State = cbChecked)
    )
  then
  begin
    self.FCancelClose := true;
    self.ModalResult := mrOk;
  end
  else
    self.FCancelClose := false;

end;

procedure TFormConnInfo.CheckBoxInheritClick(Sender: TObject);
begin
  if CheckBoxInherit.State = cbUnchecked then
  begin
    EditDomain.Enabled := true;
    EditUsername.Enabled := true;
    EditPassword.Enabled := true;
  end else
  begin
    EditDomain.Enabled := false;
    EditUsername.Enabled := false;
    EditPassword.Enabled := false;
  end;
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

procedure TFormConnInfo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCancelClose;
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

  //Disable close button
  EnableMenuItem(GetSystemMenu(self.Handle, LongBool(False)),
    SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
end;

end.


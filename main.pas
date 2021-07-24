unit main;

interface

uses
  About,
  ConnInfo,
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.NetEncoding,
  System.Variants,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.OleCtrls, MSTSCLib_TLB,
  Vcl.StdCtrls, Vcl.Grids, inifiles, Vcl.Menus, VirtualTrees, Vcl.ExtCtrls;

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    Name: string;
    HostOrIP : string;
    Domain: string;
    Username: string;
    Password: string;
  end;

  TFormMain = class(TForm)
    PageControlMain: TPageControl;
    TabSheetMain: TTabSheet;
    PopupMenuRDP: TPopupMenu;
    CloseTab: TMenuItem;
    ListBoxInfo: TListBox;
    VST: TVirtualStringTree;
    PopupMenuVST: TPopupMenu;
    PopupMenuVST_AddHost: TMenuItem;
    PopupMenuVST_AddSubHost: TMenuItem;
    N1: TMenuItem;
    PopupMenuVST_EditMI: TMenuItem;
    PopupMenuVST_DeleteMI: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure PageControlMainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure CloseTabClick(Sender: TObject);
    procedure PopupMenuVST_AddHostClick(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VSTKeyPress(Sender: TObject; var Key: Char);
    procedure VSTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VSTSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VSTDblClick(Sender: TObject);
    procedure VSTContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PopupMenuVST_AddSubHostClick(Sender: TObject);
    procedure PopupMenuVST_EditMIClick(Sender: TObject);
    procedure PopupMenuVST_DeleteMIClick(Sender: TObject);
  private
    { Private declarations }
    FRecentNodeData : TNodeRec;
    procedure ConnectToServer(node: PNodeRec); overload;
    function GetInputHostInfo: Boolean;
    procedure WMSysCommand(var Msg: TWMSysCommand);
    message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}
const
  SC_AboutMenuItem = WM_USER + 1;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini : TIniFile;
begin
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    Ini.WriteBool( 'Form', 'InitMax', WindowState = wsMaximized );
  finally
     Ini.Free;
  end;

  VST.SaveToFile('VST.cfg');
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
begin
  AppendMenu(GetSystemMenu(Handle, FALSE), MF_SEPARATOR, 0, '');
  AppendMenu(GetSystemMenu(Handle, FALSE),
             MF_STRING,
             SC_AboutMenuItem,
             'About');

  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  try
    if Ini.ReadBool( 'Form', 'InitMax', false ) then
       WindowState := wsMaximized
     else
       WindowState := wsNormal;
  finally
    Ini.Free;
  end;

  VST.NodeDataSize := SizeOf(TNodeRec);

  if System.SysUtils.FileExists('VST.cfg') then
    VST.LoadFromFile('VST.cfg')
  else
    VST.RootNodeCount := 0;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  PageControlMain.ActivePage := TabSheetMain;
//  sgConnectionInfo.SetFocus;
  VST.SetFocus;
end;

procedure TFormMain.PageControlMainContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  with Sender as TPageControl do begin
    if [htOnItem] * GetHitTestInfoAt(MousePos.X, MousePos.Y) <> [] then
      PopupMenu := PopupMenuRDP
    else
      PopupMenu := nil;
  end;

  if PageControlMain.ActivePage = TabSheetMain then
    CloseTab.Enabled := false
  else
    CloseTab.Enabled := true;
end;

function TFormMain.GetInputHostInfo: Boolean;
var
  Name, HostnameOrIp, Domain, Username, Password: string;
  ret : Boolean;
begin
  ret := false;

  if FormConnInfo.ShowModal = mrOk then
  begin
    Name := FormConnInfo.EditName.Text;
    HostnameOrIp := FormConnInfo.EditHostnameOrIp.Text;
    Domain := FormConnInfo.EditDomain.Text;
    Username := FormConnInfo.EditUsername.Text;
    Password := FormConnInfo.EditPassword.Text;

    FRecentNodeData.Name := Name;
    FRecentNodeData.HostOrIP := HostnameOrIp;
    FRecentNodeData.Domain := Domain;
    FRecentNodeData.Username := Username;
    FRecentNodeData.Password := Password;
    ret := true;
  end;
  Result := ret;
end;

procedure TFormMain.PopupMenuVST_AddHostClick(Sender: TObject);
begin
  if GetInputHostInfo = true then
  begin
    with VST do
    begin
      RootNodeCount := RootNodeCount + 1;
    end;
  end;
end;

procedure TFormMain.PopupMenuVST_AddSubHostClick(Sender: TObject);
begin
  if GetInputHostInfo = true then
  begin
    with VST do
    begin
      ChildCount[FocusedNode] := ChildCount[FocusedNode] + 1;
      Expanded[FocusedNode] := True;
      InvalidateToBottom(FocusedNode);
    end;
  end;
end;

procedure TFormMain.PopupMenuVST_DeleteMIClick(Sender: TObject);
begin
  with VST do
  begin
    DeleteNode(FocusedNode);
  end;
end;

procedure TFormMain.PopupMenuVST_EditMIClick(Sender: TObject);
var
  Data: PNodeRec;
begin
  Data := VST.GetNodeData(VST.FocusedNode);

  FormConnInfo.EditName.Text := Data.Name;
  FormConnInfo.EditHostnameOrIp.Text := Data.HostOrIP;
  FormConnInfo.EditDomain.Text := Data.Domain;
  FormConnInfo.EditUsername.Text := Data.Username;
  FormConnInfo.EditPassword.Text := Data.Password;

  if FormConnInfo.ShowModal = mrOk then
  begin
    Data.Name := FormConnInfo.EditName.Text;
    Data.HostOrIP := FormConnInfo.EditHostnameOrIp.Text;
    Data.Domain := FormConnInfo.EditDomain.Text;
    Data.Username := FormConnInfo.EditUsername.Text;
    Data.Password := FormConnInfo.EditPassword.Text;

    VST.SetNodeData(VST.FocusedNode, Data^);
  end;
end;

procedure TFormMain.CloseTabClick(Sender: TObject);
begin
  PageControlMain.ActivePage.Free;
end;

procedure TFormMain.ConnectToServer(node: PNodeRec);
var
  host : string;
  domain : string;
  username: string;
  password: string;
  as7 : IMsRdpClientAdvancedSettings7;
  TabSheet : TTabSheet;
  rdp : TMsRdpClient9NotSafeForScripting;
begin
  host := node.HostOrIP;
  domain := node.Domain;
  username := node.Username;
  password := node.Password;

  TabSheet := TTabSheet.Create(PageControlMain);
  TabSheet.Caption := node.Name;
  TabSheet.PageControl := PageControlMain;
  TabSheet.PopupMenu := PopupMenuRDP;

  rdp := TMsRdpClient9NotSafeForScripting.Create(TabSheet);
  rdp.Parent := TabSheet;
  rdp.Align := alClient;

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

procedure TFormMain.VSTContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  aHitTest : THitInfo;
begin
  (Sender as TVirtualStringTree).GetHitTestInfoAt(MousePos.X, MousePos.Y, true, aHitTest);
  if Assigned(aHitTest.HitNode) then
  begin
    PopupMenuVST_AddHost.Enabled := false;
    PopupMenuVST_AddSubHost.Enabled := true;
    PopupMenuVST_EditMI.Enabled := true;
  end
  else
  begin
    PopupMenuVST_AddHost.Enabled := true;
    PopupMenuVST_AddSubHost.Enabled := true;
    PopupMenuVST_EditMI.Enabled := false;
  end;
end;

procedure TFormMain.VSTDblClick(Sender: TObject);
var
  Data: PNodeRec;
begin
  with VST do
  begin
    Data := GetNodeData(FocusedNode);
    ConnectToServer(Data);
  end;
end;

procedure TFormMain.VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PNodeRec;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TFormMain.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PNodeRec;
begin
  // A handler for the OnGetText event is always needed as it provides the tree with the string data to display.
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Name;
end;

procedure TFormMain.VSTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PNodeRec;
begin
  with Sender do
  begin
    Data := GetNodeData(Node);
    // Construct a node caption. This event is triggered once for each node but
    // appears asynchronously, which means when the node is displayed not when it is added.
    Data.Name := self.FRecentNodeData.Name;
    Data.HostOrIP := self.FRecentNodeData.HostOrIP;
    Data.Domain := self.FRecentNodeData.Domain;
    Data.Username := self.FRecentNodeData.Username;
    Data.Password := self.FRecentNodeData.Password;
  end;
end;

procedure TFormMain.VSTKeyPress(Sender: TObject; var Key: Char);
var
  Data: PNodeRec;
begin
  if ord(Key) = VK_RETURN then
  begin
    with VST do
    begin
      Data := GetNodeData(FocusedNode);
      ConnectToServer(Data);
    end;
  end;

end;

procedure TFormMain.VSTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  Data: PNodeRec;
  Len: Integer;
begin

  Data := VST.GetNodeData(Node);

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Name, Len);
  Stream.read(PChar(Data^.Name)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.HostOrIP, Len);
  Stream.read(PChar(Data^.HostOrIP)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Domain, Len);
  Stream.read(PChar(Data^.Domain)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Username, Len);
  Stream.read(PChar(Data^.Username)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Password, Len);
  Stream.read(PChar(Data^.Password)^, Len*SizeOf(Char));
end;

procedure TFormMain.VSTSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Stream: TStream);
var
  Data: PNodeRec;
  Len: Integer;
begin
  Data := VST.GetNodeData(Node);

  Len := Length(Data^.Name);
  Stream.WriteBuffer(Len, SizeOf(Len));
  Stream.WriteBuffer(PChar(Data^.Name)^, Len*SizeOf(Char));

  Len := Length(Data^.HostOrIP);
  Stream.WriteBuffer(Len, SizeOf(Len));
  Stream.WriteBuffer(PChar(Data^.HostOrIP)^, Len*SizeOf(Char));

  Len := Length(Data^.Domain);
  Stream.WriteBuffer(Len, SizeOf(Len));
  Stream.WriteBuffer(PChar(Data^.Domain)^, Len*SizeOf(Char));

  Len := Length(Data^.Username);
  Stream.WriteBuffer(Len, SizeOf(Len));
  Stream.WriteBuffer(PChar(Data^.Username)^, Len*SizeOf(Char));

  Len := Length(Data^.Password);
  Stream.WriteBuffer(Len, SizeOf(Len));
  Stream.WriteBuffer(PChar(Data^.Password)^, Len*SizeOf(Char));
end;

procedure TFormMain.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_AboutMenuItem then
    FormAbout.ShowModal else
    inherited;
end;

end.

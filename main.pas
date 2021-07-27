unit main;

interface

uses
  About,
  ConnInfo,
  Detached,
  Shared,
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.NetEncoding,
  System.Variants,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.OleCtrls, MSTSCLib_TLB,
  Vcl.StdCtrls, Vcl.Grids, inifiles, Vcl.Menus, VirtualTrees, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList;

type
  TFormMain = class(TForm)
    PageControlMain: TPageControl;
    TabSheetMain: TTabSheet;
    PopupMenuRDP: TPopupMenu;
    PopupMenuRDP_CloseTabMI: TMenuItem;
    ListBoxInfo: TListBox;
    VST: TVirtualStringTree;
    PopupMenuVST: TPopupMenu;
    PopupMenuVST_AddHost: TMenuItem;
    PopupMenuVST_AddSubHost: TMenuItem;
    N1: TMenuItem;
    PopupMenuVST_EditMI: TMenuItem;
    PopupMenuVST_DeleteMI: TMenuItem;
    PopupMenuRDP_DetachMI: TMenuItem;
    ActionList1: TActionList;
    ActionDelete: TAction;
    ActionEdit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure PageControlMainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PopupMenuRDP_CloseTabMIClick(Sender: TObject);
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
    procedure PopupMenuRDP_DetachMIClick(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure VSTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionEditExecute(Sender: TObject);
  private
    { Private declarations }
    FRecentNodeData : TNodeRec;
    FAddHostSelected : Boolean;

    procedure ConnectToServer;
    function GetInputHostInfo: Boolean;

    //Add About dialog box
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

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
  begin
    PopupMenuRDP_CloseTabMI.Enabled := false;
    PopupMenuRDP_DetachMI.Enabled := false;
  end
  else
  begin
    PopupMenuRDP_CloseTabMI.Enabled := true;
    PopupMenuRDP_DetachMI.Enabled := true;
  end;
end;

function TFormMain.GetInputHostInfo: Boolean;
var
  Name, HostnameOrIp, Domain, Username, Password: string;
  cbState : TCheckBoxState;
  ret : Boolean;
begin
  ret := false;

  if (VST.FocusedNode = nil)
  or (FAddHostSelected = true)
  then
  begin
    FormConnInfo.CheckBoxInherit.State := cbGrayed;
    FormConnInfo.CheckBoxInherit.Enabled := false;
    FormConnInfo.EditDomain.Enabled := true;
    FormConnInfo.EditUsername.Enabled := true;
    FormConnInfo.EditPassword.Enabled := true;
  end
  else
  begin
    FormConnInfo.CheckBoxInherit.State := cbChecked;
    FormConnInfo.CheckBoxInherit.Enabled := true;
    FormConnInfo.EditDomain.Text := '';
    FormConnInfo.EditDomain.Enabled := false;
    FormConnInfo.EditUsername.Text := '';
    FormConnInfo.EditUsername.Enabled := false;
    FormConnInfo.EditPassword.Text := '';
    FormConnInfo.EditPassword.Enabled := false;

    if VST.FocusedNode.Parent = nil then
      FormConnInfo.CheckBoxInherit.Enabled := false;

  end;

  if FormConnInfo.ShowModal = mrOk then
  begin
    Name := FormConnInfo.EditName.Text;
    HostnameOrIp := FormConnInfo.EditHostnameOrIp.Text;
    cbState := FormConnInfo.CheckBoxInherit.State;
    Domain := FormConnInfo.EditDomain.Text;
    Username := FormConnInfo.EditUsername.Text;
    Password := FormConnInfo.EditPassword.Text;

    FRecentNodeData.Name := Name;
    FRecentNodeData.HostOrIP := HostnameOrIp;
    FRecentNodeData.Inherit := cbState;
    FRecentNodeData.Domain := Domain;
    FRecentNodeData.Username := Username;
    FRecentNodeData.Password := Password;
    ret := true;
  end;
  Result := ret;
end;

procedure TFormMain.PopupMenuVST_AddHostClick(Sender: TObject);
begin
  FAddHostSelected := true;
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
  if VCL.Dialogs.MessageDlg('Delete nodes?',
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    with VST do
    begin
      DeleteNode(FocusedNode);
    end;
  end;
end;

procedure TFormMain.PopupMenuVST_EditMIClick(Sender: TObject);
var
  Data: PNodeRec;
begin
  Data := VST.GetNodeData(VST.FocusedNode);

  FormConnInfo.EditName.Text := Data.Name;
  FormConnInfo.EditHostnameOrIp.Text := Data.HostOrIP;
  FormConnInfo.CheckBoxInherit.State := Data.Inherit;

  if VST.FocusedNode.Parent = VST.FocusedNode.Parent.NextSibling then //this is a root node
  begin
    FormConnInfo.CheckBoxInherit.Enabled := false;
    FormConnInfo.CheckBoxInherit.AllowGrayed := true;
  end
  else
    FormConnInfo.CheckBoxInherit.AllowGrayed := false;

  if (FormConnInfo.CheckBoxInherit.State = cbUnchecked)
  or (FormConnInfo.CheckBoxInherit.State = cbGrayed)
  then
  begin
    FormConnInfo.EditDomain.Text := Data.Domain;
    FormConnInfo.EditUsername.Text := Data.Username;
    FormConnInfo.EditPassword.Text := Data.Password;

    FormConnInfo.EditDomain.Enabled := true;
    FormConnInfo.EditUsername.Enabled := true;
    FormConnInfo.EditPassword.Enabled := true;
  end
  else
  begin
    FormConnInfo.EditDomain.Text := '';
    FormConnInfo.EditDomain.Enabled := false;
    FormConnInfo.EditUsername.Text := '';
    FormConnInfo.EditUsername.Enabled := false;
    FormConnInfo.EditPassword.Text := '';
    FormConnInfo.EditPassword.Enabled := false;
  end;

  if FormConnInfo.ShowModal = mrOk then
  begin
    Data.Name := FormConnInfo.EditName.Text;
    Data.HostOrIP := FormConnInfo.EditHostnameOrIp.Text;
    Data.Inherit := FormConnInfo.CheckBoxInherit.State;
    Data.Domain := FormConnInfo.EditDomain.Text;
    Data.Username := FormConnInfo.EditUsername.Text;
    Data.Password := FormConnInfo.EditPassword.Text;

    VST.SetNodeData(VST.FocusedNode, Data^);
  end;
end;

procedure TFormMain.PopupMenuRDP_CloseTabMIClick(Sender: TObject);
var
  I : Integer;
begin
  //Need to clean-up the tags
  for I := 0 to PageControlMain.ActivePage.ControlCount-1 do
  begin
    if PageControlMain.ActivePage.Controls[I].ClassName = 'TMsRdpClient9NotSafeForScripting' then
    begin
      TNodeInformation(PageControlMain.ActivePage.Controls[I].Tag).Free;
      break;
    end;
  end;

  PageControlMain.ActivePage.Free;
end;

procedure TFormMain.PopupMenuRDP_DetachMIClick(Sender: TObject);
var
  I: Integer;
  node : TNodeInformation;
  as7: IMsRdpClientAdvancedSettings7;
begin
  node := nil;

  for I := 0 to PageControlMain.ActivePage.ControlCount-1 do
  begin
    if PageControlMain.ActivePage.Controls[I].ClassName = 'TMsRdpClient9NotSafeForScripting' then
    begin
      node := TNodeInformation(PageControlMain.ActivePage.Controls[I].Tag);
      break;
    end;
  end;

  if FormDetached.Rdp.Connected = 1 then
  begin
    FormDetached.Rdp.Disconnect;
  end;

  FormDetached.Rdp.DesktopWidth := FormDetached.ClientWidth;
  FormDetached.Rdp.DesktopHeight := FormDetached.ClientHeight;

  FormDetached.Rdp.Server := node.HostOrIP;
  FormDetached.Rdp.Domain := node.Domain;
  FormDetached.Rdp.UserName := node.Username;
  FormDetached.Rdp.Server := node.HostOrIP;
  if Length(node.password)>0 then
    FormDetached.Rdp.AdvancedSettings9.ClearTextPassword := node.password;
  FormDetached.Rdp.SecuredSettings3.KeyboardHookMode := 1;
  as7 := FormDetached.Rdp.AdvancedSettings as IMsRdpClientAdvancedSettings7;
  as7.EnableCredSspSupport := true;
  as7.SmartSizing := true;
  FormDetached.Rdp.Connect;

  FormDetached.Caption := node.Name;
  FormDetached.Show;
  PageControlMain.ActivePage.Free;
end;

procedure TFormMain.ActionDeleteExecute(Sender: TObject);
begin
  if VCL.Dialogs.MessageDlg('Delete nodes?',
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    with VST do
    begin
      DeleteNode(FocusedNode);
    end;
  end;
end;

procedure TFormMain.ActionEditExecute(Sender: TObject);
var
  Data: PNodeRec;
begin
  Data := VST.GetNodeData(VST.FocusedNode);

  FormConnInfo.EditName.Text := Data.Name;
  FormConnInfo.EditHostnameOrIp.Text := Data.HostOrIP;
  FormConnInfo.CheckBoxInherit.State := Data.Inherit;

  if VST.FocusedNode.Parent = VST.FocusedNode.Parent.NextSibling then //this is a root node
  begin
    FormConnInfo.CheckBoxInherit.Enabled := false;
    FormConnInfo.CheckBoxInherit.AllowGrayed := true;
  end
  else
    FormConnInfo.CheckBoxInherit.AllowGrayed := false;

  if (FormConnInfo.CheckBoxInherit.State = cbUnchecked)
  or (FormConnInfo.CheckBoxInherit.State = cbGrayed)
  then
  begin
    FormConnInfo.EditDomain.Text := Data.Domain;
    FormConnInfo.EditUsername.Text := Data.Username;
    FormConnInfo.EditPassword.Text := Data.Password;

    FormConnInfo.EditDomain.Enabled := true;
    FormConnInfo.EditUsername.Enabled := true;
    FormConnInfo.EditPassword.Enabled := true;
  end
  else
  begin
    FormConnInfo.EditDomain.Text := '';
    FormConnInfo.EditDomain.Enabled := false;
    FormConnInfo.EditUsername.Text := '';
    FormConnInfo.EditUsername.Enabled := false;
    FormConnInfo.EditPassword.Text := '';
    FormConnInfo.EditPassword.Enabled := false;
  end;

  if FormConnInfo.ShowModal = mrOk then
  begin
    Data.Name := FormConnInfo.EditName.Text;
    Data.HostOrIP := FormConnInfo.EditHostnameOrIp.Text;
    Data.Inherit := FormConnInfo.CheckBoxInherit.State;
    Data.Domain := FormConnInfo.EditDomain.Text;
    Data.Username := FormConnInfo.EditUsername.Text;
    Data.Password := FormConnInfo.EditPassword.Text;

    VST.SetNodeData(VST.FocusedNode, Data^);
  end;
end;
procedure TFormMain.ConnectToServer;
var
  Data, DataNext: PNodeRec;
  LData : TNodeRec;
  vn : PVirtualNode;
  TabSheet : TTabSheet;
  rdp : TMsRdpClient9NotSafeForScripting;
  ni : TNodeInformation;
begin
  with VST do
  begin
    Data := GetNodeData(FocusedNode);
    LData := Data^;
    if Data.Inherit = cbChecked then
    begin
      vn := FocusedNode;
      repeat
        vn := vn.Parent;
        DataNext := GetNodeData(vn);
      until DataNext.Inherit <> cbChecked;
      LData.Name := Data.Name;
      LData.HostOrIP := Data.HostOrIP;
      LData.Inherit := Data.Inherit;
      LData.Domain := DataNext.Domain;
      LData.Username := DataNext.Username;
      LData.Password := DataNext.Password;
    end;
  end;

  TabSheet := TTabSheet.Create(PageControlMain);
  TabSheet.Caption := LData.Name;
  TabSheet.PageControl := PageControlMain;
  TabSheet.PopupMenu := PopupMenuRDP;

  rdp := TMsRdpClient9NotSafeForScripting.Create(TabSheet);
  rdp.Parent := TabSheet;
  rdp.Align := alClient;

  rdp.Server := LData.HostOrIP;
  rdp.Domain := LData.Domain;
  rdp.UserName := LData.Username;
  if Length(LData.Password)>0 then
    rdp.AdvancedSettings9.ClearTextPassword := LData.Password;
  rdp.SecuredSettings3.KeyboardHookMode := 1;
  rdp.AdvancedSettings7.EnableCredSspSupport := true;

  ni := TNodeInformation.Create;
  ni.Name := LData.Name;
  ni.HostOrIp := LData.HostOrIP;
  ni.Inherit := LData.Inherit;
  ni.Domain := LData.Domain;
  ni.Username := LData.Username;
  ni.Password := LData.Password;
  rdp.Tag := Integer(ni); //Store NodeRec for detaching
  rdp.Connect;
  PageControlMain.ActivePage := TabSheet;
end;

procedure TFormMain.VSTContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  aHitTest : THitInfo;
begin
  FAddHostSelected := false;

  (Sender as TVirtualStringTree).GetHitTestInfoAt(MousePos.X, MousePos.Y, true, aHitTest);
  if Assigned(aHitTest.HitNode) then
  begin
    PopupMenuVST_AddHost.Enabled := false;
    PopupMenuVST_AddSubHost.Enabled := true;
    PopupMenuVST_EditMI.Enabled := true;
    PopupMenuVST_DeleteMI.Enabled := true;
  end
  else
  begin
    PopupMenuVST_AddHost.Enabled := true;
    PopupMenuVST_AddSubHost.Enabled := false;
    PopupMenuVST_EditMI.Enabled := false;
    PopupMenuVST_DeleteMI.Enabled := false;
  end;
end;

procedure TFormMain.VSTDblClick(Sender: TObject);
begin
  ConnectToServer;
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
    Data.Inherit := self.FRecentNodeData.Inherit;
    Data.Domain := self.FRecentNodeData.Domain;
    Data.Username := self.FRecentNodeData.Username;
    Data.Password := self.FRecentNodeData.Password;
  end;
end;

procedure TFormMain.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    ActionDelete.Execute
  else if Key = VK_F2 then
    ActionEdit.Execute;

end;

procedure TFormMain.VSTKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    ConnectToServer
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
  Stream.ReadBuffer(PChar(Data^.HostOrIP)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Data^.Inherit, SizeOf(TCheckBoxState));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Domain, Len);
  Stream.ReadBuffer(PChar(Data^.Domain)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Username, Len);
  Stream.ReadBuffer(PChar(Data^.Username)^, Len*SizeOf(Char));

  Stream.ReadBuffer(Len, SizeOf(Len));
  SetLength(Data^.Password, Len);
  Stream.ReadBuffer(PChar(Data^.Password)^, Len*SizeOf(Char));
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

  Stream.WriteBuffer(Data^.Inherit, SizeOf(TCheckBoxState));

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

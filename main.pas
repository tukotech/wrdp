unit main;

interface

uses
  About,
  ConnInfo,
  Detached,
  Shared,
  StrUtils,
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.NetEncoding,
  System.Variants,
  System.SysUtils,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
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
    ActionAddSubHost: TAction;
    ActionAddHost: TAction;
    ActionTabReconnect: TAction;
    ActionTabClose: TAction;
    ActionTabDetach: TAction;
    Reconnect1: TMenuItem;
    ActionConnect: TAction;
    N2: TMenuItem;
    ConnectF31: TMenuItem;
    ActionSaveCfg: TAction;
    ActionExport: TAction;
    Export1: TMenuItem;
    ActionImport: TAction;
    Import1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure PageControlMainContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
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
    procedure ActionDeleteExecute(Sender: TObject);
    procedure VSTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionAddSubHostExecute(Sender: TObject);
    procedure ActionAddHostExecute(Sender: TObject);
    procedure MsRdpClient9NotSafeForScriptingDisconnected(ASender: TObject;
      discReason: Integer);
    procedure ActionTabCloseExecute(Sender: TObject);
    procedure ActionTabDetachExecute(Sender: TObject);
    procedure ActionTabReconnectExecute(Sender: TObject);
    procedure MsRdpClient9NotSafeForScriptingConnected(Sender: TObject);
    procedure ActionConnectExecute(Sender: TObject);
    procedure MsRdpClient9NotSafeForScriptingFocusReleased(ASender: TObject;
      iDirection: Integer);
    procedure ActionSaveCfgExecute(Sender: TObject);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode;
      const SearchText: string; var Result: Integer);
    procedure ActionExportExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);

  private
    { Private declarations }
    FRecentNodeData : TNodeRec;
    FAddHostSelected : Boolean;
    FPopupMenuSelectedRDP : TMsRdpClient9NotSafeForScripting;
    FImportInProgress: Boolean;
    FSaveInProgress: Boolean;
    FVstNodesPreLoaded: Boolean; //import pre-loads all the nodes

    procedure ConnectToServer;
    function GetInputHostInfo: Boolean;

    function NodeUpdateCallback(Data: TStringList; Node: PVirtualNode) : PVirtualNode;

    //Add About dialog box
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation
uses
  ImportXml,
  Math,
  System.TypInfo,
  Xml.XMLIntf,
  Xml.XMLDoc;

{$R *.dfm}
const
  SC_AboutMenuItem = WM_USER + 1;

function TFormMain.NodeUpdateCallback(Data: TStringList; Node: PVirtualNode): PVirtualNode;
var
  NewNode: PVirtualNode;
  VstData: PNodeRec;

  function StringToCheckBoxState(const Str: string): TCheckBoxState;
  var
    ret: TCheckBoxState;
  begin
    ret := TCheckBoxState.cbUnchecked;

    if Str = 'cbUnchecked' then
      ret := TCheckBoxState.cbUnchecked
    else if Str = 'cbChecked' then
      ret := TCheckBoxState.cbChecked
    else if Str = 'cbGrayed' then
      ret := TCheckBoxState.cbGrayed;

    Result := ret;
  end;

begin
  OutputDebugString(PWideChar('Unit2: ' + Data.Values['Name']));

  with VST do
  begin
//    ChildCount[Node] := ChildCount[Node] + 1;
//    Expanded[Node] := True;
    NewNode := VST.AddChild(Node);

    VstData := VST.GetNodeData(NewNode);
    FRecentNodeData.Name := Data.Values['Name'];
    FRecentNodeData.HostOrIP := Data.Values['HostOrIP'];
    FRecentNodeData.Port := Data.Values['Port'].ToInteger();
    FRecentNodeData.Inherit := StringToCheckBoxState(Data.Values['Inherit']);
    FRecentNodeData.Admin := StringToCheckBoxState(Data.Values['Admin']);
    FRecentNodeData.Domain := Data.Values['Domain'];
    FRecentNodeData.Username := Data.Values['Username'];
    FRecentNodeData.Password := Data.Values['Password'];

    VstData := @FRecentNodeData;
    VST.SetNodeData(NewNode, VstData^);
  end;

  Result := NewNode;
end;

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
  ActionSaveCfg.Execute;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Ini : TIniFile;
begin
  FImportInProgress := false;
  FSaveInProgress := false;
  FVstNodesPreLoaded := false;

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
  VST.SetFocus;
end;

procedure TFormMain.PageControlMainContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  IsDisconnected : Boolean;
  IsRdpConnected : Boolean;
  i : integer;
  controlIndex : integer;
begin
  IsRdpConnected := false;
  //Only show popup on tab instead of the client area
  with Sender as TPageControl do begin
    i := IndexOfTabAt(MousePos.X, MousePos.Y);
    if [htOnItem] * GetHitTestInfoAt(MousePos.X, MousePos.Y) <> [] then
    begin
      if i > 0 then
      begin
        PopupMenu := PopupMenuRDP;
        IsDisconnected := ContainsText(Pages[i].Caption, '[x]');


        for controlIndex := 0 to Pages[i].ControlCount-1 do
        begin
          if Pages[i].Controls[controlIndex].ClassName = 'TMsRdpClient9NotSafeForScripting' then
          begin
            FPopupMenuSelectedRDP := TMsRdpClient9NotSafeForScripting(Pages[i].Controls[controlIndex]);
            IsRdpConnected := FPopupMenuSelectedRDP.Connected = 1;
            break;
          end;
        end;
        ActionTabDetach.Visible := (Not IsDisconnected) and (IsRdpConnected);
      end
      else
        PopupMenu := nil;
    end
  end;
end;

function TFormMain.GetInputHostInfo: Boolean;
var
  Name, HostnameOrIp, Domain, Username, Password: string;
  Port: integer;
  cbInherit, cbAdmin : TCheckBoxState;
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
    Port := StrToInt(FormConnInfo.EditPort.Text);
    cbInherit := FormConnInfo.CheckBoxInherit.State;
    cbAdmin := FormConnInfo.CheckBoxAdmin.State;
    Domain := FormConnInfo.EditDomain.Text;
    Username := FormConnInfo.EditUsername.Text;
    Password := FormConnInfo.EditPassword.Text;

    FRecentNodeData.Name := Name;
    FRecentNodeData.HostOrIP := HostnameOrIp;
    FRecentNodeData.Port := Port;
    FRecentNodeData.Inherit := cbInherit;
    FRecentNodeData.Admin := cbAdmin;
    FRecentNodeData.Domain := Domain;
    FRecentNodeData.Username := Username;
    FRecentNodeData.Password := Password;
    ActionSaveCfg.Execute;
    ret := true;
  end;
  Result := ret;
end;

procedure TFormMain.MsRdpClient9NotSafeForScriptingFocusReleased(
  ASender: TObject; iDirection: Integer);
begin
  PageControlMain.SetFocus; //This focuses the active tab, should now be able to switch to other applications
end;

procedure TFormMain.MsRdpClient9NotSafeForScriptingConnected(Sender: TObject);
var
  node : TNodeInformation;
  rdp : TMsRdpClient9NotSafeForScripting;
begin
  rdp := Sender as TMsRdpClient9NotSafeForScripting;
  if Assigned(rdp) then
  begin
    node := TNodeInformation(rdp.Tag);
    if Assigned(node) then
      TTabSheet((Sender as TControl).Parent).Caption := node.Name;
  end;
//
end;

procedure TFormMain.MsRdpClient9NotSafeForScriptingDisconnected(
  ASender: TObject; discReason: Integer);
var
  rdp : TMsRdpClient9NotSafeForScripting;
  msg : string;
begin
  rdp := ASender as TMsRdpClient9NotSafeForScripting;
  msg := IntToStr(discReason) + ' : ' + rdp.GetErrorDescription(discReason, rdp.ExtendedDisconnectReason) + ' : ' + TTabSheet(rdp.Parent).Caption;
  TTabSheet(rdp.Parent).Caption := '[x]' + TTabSheet(rdp.Parent).Caption;
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
  if MessageDlg('Delete nodes?',
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

procedure TFormMain.ActionAddHostExecute(Sender: TObject);
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

procedure TFormMain.ActionAddSubHostExecute(Sender: TObject);
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

procedure TFormMain.ActionConnectExecute(Sender: TObject);
begin
  ConnectToServer;
end;

procedure TFormMain.ActionDeleteExecute(Sender: TObject);
begin
  if MessageDlg('Delete node?',
    mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    with VST do
    begin
      DeleteNode(FocusedNode);
      ActionSaveCfg.Execute;
    end;
  end;
end;

procedure TFormMain.ActionEditExecute(Sender: TObject);
var
  Data: PNodeRec;
begin
  Data := VST.GetNodeData(VST.FocusedNode);
  if Data = nil then
  begin
    ShowMessage('Data is nil');
  end;

  FormConnInfo.EditName.Text := Data.Name;
  FormConnInfo.EditHostnameOrIp.Text := Data.HostOrIP;
  FormConnInfo.EditPort.Text := IntToStr(Data.Port);
  FormConnInfo.CheckBoxInherit.State := Data.Inherit;
  FormConnInfo.CheckBoxAdmin.State := Data.Admin;


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
    Data.Port := StrToInt(FormConnInfo.EditPort.Text);
    Data.Inherit := FormConnInfo.CheckBoxInherit.State;
    Data.Admin := FormConnInfo.CheckBoxAdmin.State;
    Data.Domain := FormConnInfo.EditDomain.Text;
    Data.Username := FormConnInfo.EditUsername.Text;
    Data.Password := FormConnInfo.EditPassword.Text;

    VST.SetNodeData(VST.FocusedNode, Data^);
    ActionSaveCfg.Execute;
  end;
end;

procedure ExportVSTToXML(VstRootNode: TVirtualStringTree; const FileName: string);
var
  XMLDoc: IXMLDocument;
  XMLRootNode: IXMLNode;

  procedure ProcessNode(Node: PVirtualNode; XMLParent: IXMLNode);
  var
    ChildNode: PVirtualNode;
    Data: PNodeRec;
    CurrentNode, BaseNode: IXMLNode;
  begin
    BaseNode := XMLParent;
//    CurrentNode := BaseNode.AddChild('Name');
//    CurrentNode.Text := VstRootNode.Text[Node, 0];
    if VstRootNode.Text[Node, 0] <> 'Node' then
    begin
      BaseNode := XMLParent.AddChild('Node');
      Data := VstRootNode.GetNodeData(Node);
      CurrentNode := BaseNode.AddChild('Name');
      CurrentNode.Text := Data.Name;
      CurrentNode := BaseNode.AddChild('HostOrIp');
      CurrentNode.Text := Data.HostOrIP;
      CurrentNode := BaseNode.AddChild('Port');
      CurrentNode.Text := IntToStr(Data.Port);
      CurrentNode := BaseNode.AddChild('Inherit');
      CurrentNode.Text := GetEnumName(TypeInfo(TCheckBoxState), Ord(Data.Inherit));
      CurrentNode := BaseNode.AddChild('Admin');
      CurrentNode.Text := GetEnumName(TypeInfo(TCheckBoxState), Ord(Data.Admin));
      CurrentNode := BaseNode.AddChild('Domain');
      CurrentNode.Text := Data.Domain;
      CurrentNode := BaseNode.AddChild('Username');
      CurrentNode.Text := Data.Username;
      CurrentNode := BaseNode.AddChild('Password');
      CurrentNode.Text := Data.Password;
    end;

    // Recursively process child nodes
    ChildNode := Node.FirstChild;
    while ChildNode <> nil do
    begin
      ProcessNode(ChildNode, BaseNode);
      ChildNode := ChildNode.NextSibling;
    end;
  end;

begin
  XMLDoc := NewXMLDocument;
  XMLRootNode := XMLDoc.AddChild('Nodes');

  ProcessNode(VstRootNode.RootNode, XMLRootNode);
  XMLDoc.SaveToFile(FileName);
end;

procedure TFormMain.ActionExportExecute(Sender: TObject);
begin
  ExportVSTToXML(VST, 'nodes.xml');
end;

procedure TFormMain.ActionImportExecute(Sender: TObject);
begin
  FImportInProgress := true;
  VST.BeginUpdate;
  ImportXmlToVst('C:\g\wrdp\Win32\Debug\nodes.xml', NodeUpdateCallback, VST.RootNode);
  VST.EndUpdate;
  FImportInProgress := false;
  FVstNodesPreLoaded := true;
end;

procedure TFormMain.ActionSaveCfgExecute(Sender: TObject);
begin
  if FImportInProgress = false then
    if FSaveInProgress = false then
    begin
      FSaveInProgress := true;
      VST.SaveToFile('VST.cfg');
      FSaveInProgress := false;
    end;
end;

procedure TFormMain.ActionTabCloseExecute(Sender: TObject);
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

procedure TFormMain.ActionTabDetachExecute(Sender: TObject);
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

  FormDetached.RdpConnect(node);
  FormDetached.Caption := node.Name;
  FormDetached.Show;
  PageControlMain.ActivePage.Free;
end;

procedure TFormMain.ActionTabReconnectExecute(Sender: TObject);
begin
  if FPopupMenuSelectedRDP.Connected=1 then
    FPopupMenuSelectedRDP.Reconnect(FPopupMenuSelectedRDP.Parent.ClientWidth,FPopupMenuSelectedRDP.Parent.ClientHeight)
  else
    FPopupMenuSelectedRDP.Connect;
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
      LData.Port := Data.Port;
      LData.Inherit := Data.Inherit;
      LData.Admin := Data.Admin;
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
  rdp.AdvancedSettings8.RDPPort := LData.Port;
  if LData.Admin = TCheckBoxState.cbChecked then
    rdp.AdvancedSettings8.ConnectToAdministerServer := true;
  rdp.UserName := LData.Username;
  if Length(LData.Password)>0 then
    rdp.AdvancedSettings9.ClearTextPassword := LData.Password;
  rdp.SecuredSettings3.KeyboardHookMode := 1;
  rdp.AdvancedSettings7.EnableCredSspSupport := true;

  ni := TNodeInformation.Create;
  ni.Name := LData.Name;
  ni.HostOrIp := LData.HostOrIP;
  ni.Port := LData.Port;
  ni.Inherit := LData.Inherit;
  ni.Admin := Data.Admin;
  ni.Domain := LData.Domain;
  ni.Username := LData.Username;
  ni.Password := LData.Password;
  rdp.Tag := Integer(ni); //Store NodeRec for detaching
  rdp.OnDisconnected := MsRdpClient9NotSafeForScriptingDisconnected;
  rdp.OnConnected := MsRdpClient9NotSafeForScriptingConnected;
  rdp.OnFocusReleased := MsRdpClient9NotSafeForScriptingFocusReleased;
  rdp.AdvancedSettings8.BitmapPersistence := 0;
  rdp.Connect;
  PageControlMain.ActivePage := TabSheet;
end;

procedure TFormMain.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PNodeRec;
begin
  Data1 := VST.GetNodeData(Node1);
  Data2 := VST.GetNodeData(Node2);
  if LowerCase(Data1.Name) < LowerCase(Data2.Name) then
    Result := -1
  else
    Result := 1;
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
    ActionConnect.Enabled := true;
    ActionExport.Visible  := false;
    ActionImport.Visible  := false;
  end
  else
  begin
    PopupMenuVST_AddHost.Enabled := true;
    PopupMenuVST_AddSubHost.Enabled := false;
    PopupMenuVST_EditMI.Enabled := false;
    PopupMenuVST_DeleteMI.Enabled := false;
    ActionConnect.Enabled := false;
    if VST.TotalCount = 0 then
    begin
      ActionExport.Visible := false;
      ActionImport.Visible := true;
    end
    else
    begin
      ActionExport.Visible  := true;
      ActionImport.Visible := false;
    end;
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

//This method is called when a node is added, e.g., adding a host/sub-host
procedure TFormMain.VSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  Data: PNodeRec;
begin
  with Sender do
  begin
    Data := GetNodeData(Node);
    if ContainsText(Data.Name, SearchText) then
      Result := 0
    else
      Result := 1;
  end
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
    if FVstNodesPreLoaded = false then
    begin
      Data.Name := self.FRecentNodeData.Name;
      Data.HostOrIP := self.FRecentNodeData.HostOrIP;
      Data.Port := self.FRecentNodeData.Port;
      Data.Inherit := self.FRecentNodeData.Inherit;
      Data.Admin := self.FRecentNodeData.Admin;
      Data.Domain := self.FRecentNodeData.Domain;
      Data.Username := self.FRecentNodeData.Username;
      Data.Password := self.FRecentNodeData.Password;
    end;
    ActionSaveCfg.Execute;
  end;
end;

procedure TFormMain.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    ActionDelete.Execute
  else if Key = VK_F2 then
    ActionEdit.Execute
  else if Key = VK_INSERT then
    if ssShift in Shift then
      ActionAddHost.Execute
    else
      ActionAddSubHost.Execute;

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

  Stream.ReadBuffer(Data^.Port, SizeOf(Integer));
  Stream.ReadBuffer(Data^.Inherit, SizeOf(TCheckBoxState));
  Stream.ReadBuffer(Data^.Admin, SizeOf(TCheckBoxState));

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

  Stream.WriteBuffer(Data^.Port, SizeOf(Integer));

  Stream.WriteBuffer(Data^.Inherit, SizeOf(TCheckBoxState));
  Stream.WriteBuffer(Data^.Admin, SizeOf(TCheckBoxState));

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

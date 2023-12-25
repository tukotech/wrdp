unit ImportXml;

interface

uses
  System.Classes,
  VirtualTrees,
  Xml.XMLIntf;

type
  TNodeUpdateCallback = function(Data: TStringList; Node: PVirtualNode): PVirtualNode of object;

procedure ImportXmlToVst(Filename: String; Callback: TNodeUpdateCallback; Node: PVirtualNode);

implementation
uses
  Winapi.Windows,
  Xml.XMLDoc;


procedure ImportXmlToVst(Filename: String; Callback: TNodeUpdateCallback; Node: PVirtualNode);
var
  XmlDoc : IXMLDocument;


  procedure ProcessNodes(CurrentNode: IXMLNode; CurrentVNode: PVirtualNode);
  var
    i: Integer;
    XNode: IXMLNode;
    Data: TStringList;
    VstNode: PVirtualNode;
  begin
    if CurrentNode.LocalName = 'Node' then
    begin
//      OutputDebugString(PWideChar(CurrentNode.ChildNodes.FindNode('HostOrIp').Text));

      Data := TStringList.Create;
      Data.Add('Name=' + CurrentNode.ChildNodes.FindNode('Name').Text);
      Data.Add('HostOrIp=' + CurrentNode.ChildNodes.FindNode('HostOrIp').Text);
      Data.Add('Port=' + CurrentNode.ChildNodes.FindNode('Port').Text);
      Data.Add('Inherit=' + CurrentNode.ChildNodes.FindNode('Inherit').Text);
      Data.Add('Admin=' + CurrentNode.ChildNodes.FindNode('Admin').Text);
      Data.Add('Domain=' + CurrentNode.ChildNodes.FindNode('Domain').Text);
      Data.Add('Username=' + CurrentNode.ChildNodes.FindNode('Username').Text);
      Data.Add('Password=' + CurrentNode.ChildNodes.FindNode('Password').Text);
      OutputDebugString(PWideChar(Data.Values['Name']));
      VstNode := Callback(Data, CurrentVNode);
    end else
    begin
      VstNode := CurrentVNode;
    end;


    for i := 0 to CurrentNode.ChildNodes.Count - 1 do
    begin
      XNode := CurrentNode.ChildNodes[i];
      if XNode.LocalName = 'Node'	 then
        ProcessNodes(XNode, VstNode);  // Recursively call for child nodes
    end;
  end;
begin
  XmlDoc := TXMLDocument.Create(nil);

  XmlDoc := LoadXMLDocument(Filename);
  XmlDoc.Active := True;

  ProcessNodes(XmlDoc.DocumentElement, Node);

  XmlDoc.Active := False;
  XmlDoc := nil;
end;

end.

object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Wicked RDP'
  ClientHeight = 610
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 922
    Height = 610
    ActivePage = TabSheetMain
    Align = alClient
    TabOrder = 0
    object TabSheetMain: TTabSheet
      Caption = 'Main'
      object sgConnectionInfo: TStringGrid
        Left = 0
        Top = 0
        Width = 914
        Height = 582
        Align = alClient
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goRowSelect]
        TabOrder = 0
        OnDblClick = sgConnectionInfoDblClick
        OnKeyPress = sgConnectionInfoKeyPress
        OnKeyUp = sgConnectionInfoKeyUp
        OnSelectCell = sgConnectionInfoSelectCell
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'VM1'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting
        Left = 0
        Top = 0
        Width = 914
        Height = 582
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 200
        ExplicitTop = 136
        ExplicitWidth = 192
        ExplicitHeight = 192
        ControlData = {0008000008000200000000000B0000000B000000}
      end
    end
  end
end

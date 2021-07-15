object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Wicked RDP'
  ClientHeight = 610
  ClientWidth = 712
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 712
    Height = 610
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 635
    ExplicitHeight = 258
    object TabSheetMain: TTabSheet
      Caption = 'Main'
      ExplicitWidth = 627
      ExplicitHeight = 230
    end
    object TabSheet1: TTabSheet
      Caption = 'VM1'
      ImageIndex = 1
      ExplicitWidth = 627
      ExplicitHeight = 230
      object MsRdpClient91: TMsRdpClient9
        Left = 0
        Top = 0
        Width = 704
        Height = 582
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 224
        ExplicitTop = 128
        ExplicitWidth = 192
        ExplicitHeight = 192
        ControlData = {0008000008000200000000000B0000000B000000}
      end
    end
  end
end

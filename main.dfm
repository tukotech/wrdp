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
      object Button1: TButton
        Left = 32
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 32
        Top = 63
        Width = 75
        Height = 25
        Caption = 'Button2'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'VM1'
      ImageIndex = 1
      object MsRdpClient91: TMsRdpClient9
        Left = 0
        Top = 0
        Width = 914
        Height = 582
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 144
        ExplicitTop = 3
        ExplicitWidth = 721
        ExplicitHeight = 446
        ControlData = {0008000008000200000000000B0000000B000000}
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 2
      object MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting
        Left = 0
        Top = 0
        Width = 914
        Height = 582
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 152
        ExplicitTop = 64
        ExplicitWidth = 192
        ExplicitHeight = 192
        ControlData = {0008000008000200000000000B0000000B000000}
      end
    end
  end
end

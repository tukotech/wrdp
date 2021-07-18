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
    ActivePage = TabSheet1
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
      object MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting
        Left = 200
        Top = 136
        Width = 192
        Height = 192
        TabOrder = 0
        ControlData = {0008000008000200000000000B0000000B000000}
      end
    end
  end
end

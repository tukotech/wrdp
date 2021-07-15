object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Wicked RDP'
  ClientHeight = 258
  ClientWidth = 635
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
    Width = 635
    Height = 258
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheetMain: TTabSheet
      Caption = 'Main'
    end
    object TabSheet1: TTabSheet
      Caption = 'VM1'
      ImageIndex = 1
    end
  end
end

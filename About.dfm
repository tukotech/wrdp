object FormAbout: TFormAbout
  Left = 0
  Top = 0
  Caption = 'About Wicked RDP'
  ClientHeight = 196
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    288
    196)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 151
    Height = 48
    Caption = 
      'Designed using Delphi'#13#10' 10.4CE : 0.3.x to latest'#13#10' 10.3CE : 0.0.' +
      'x to 0.3.x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelDedication: TLabel
    Left = 8
    Top = 70
    Width = 166
    Height = 80
    Caption = 
      'This work is dedicated to:'#13#10' Pedro M. Hernan'#13#10' Sarah I. Hernan'#13#10 +
      ' Pesarlito T. Hernan'#13#10' Percival T. Hernan'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 205
    Top = 163
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end

object FormAbout: TFormAbout
  Left = 0
  Top = 0
  Caption = 'About Wicked RDP'
  ClientHeight = 170
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
    170)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 187
    Height = 16
    Caption = 'Designed using Delphi 10.3CE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelDedication: TLabel
    Left = 8
    Top = 46
    Width = 166
    Height = 64
    Caption = 
      'This work is dedicated to:'#13#10'>Pedro M. Hernan'#13#10'>Pesarlito T. Hern' +
      'an'#13#10'>Percival T. Hernan'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 205
    Top = 137
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    ExplicitLeft = 174
  end
end

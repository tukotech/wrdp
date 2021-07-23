object FormConnInfo: TFormConnInfo
  Left = 0
  Top = 0
  Caption = 'Connection Info'
  ClientHeight = 193
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 276
    Height = 152
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 634
    ExplicitHeight = 185
    DesignSize = (
      276
      152)
    object Label1: TLabel
      Left = 59
      Top = 11
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label2: TLabel
      Left = 12
      Top = 38
      Width = 78
      Height = 13
      Caption = 'Hostname or IP:'
    end
    object Label3: TLabel
      Left = 51
      Top = 65
      Width = 39
      Height = 13
      Caption = 'Domain:'
    end
    object Label4: TLabel
      Left = 38
      Top = 92
      Width = 52
      Height = 13
      Caption = 'Username:'
    end
    object Label5: TLabel
      Left = 40
      Top = 119
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Edit1: TEdit
      Left = 96
      Top = 8
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 96
      Top = 35
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 96
      Top = 62
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 96
      Top = 89
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 96
      Top = 116
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 152
    Width = 276
    Height = 41
    Margins.Top = 5
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 216
    ExplicitWidth = 634
    object Button1: TButton
      AlignWithMargins = True
      Left = 116
      Top = 4
      Width = 75
      Height = 33
      Align = alRight
      Caption = 'Button1'
      TabOrder = 0
      ExplicitLeft = 346
      ExplicitTop = 14
      ExplicitHeight = 43
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 197
      Top = 4
      Width = 75
      Height = 33
      Align = alRight
      Caption = 'Button2'
      TabOrder = 1
      ExplicitLeft = 550
      ExplicitTop = 14
      ExplicitHeight = 67
    end
  end
end

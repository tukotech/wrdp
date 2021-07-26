object FormConnInfo: TFormConnInfo
  Left = 0
  Top = 0
  Caption = 'Connection Info'
  ClientHeight = 212
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 276
    Height = 171
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 152
    DesignSize = (
      276
      171)
    object Label1: TLabel
      Left = 59
      Top = 11
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object LabelHostOrIp: TLabel
      Left = 12
      Top = 38
      Width = 78
      Height = 13
      Caption = 'Hostname or IP:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 51
      Top = 88
      Width = 39
      Height = 13
      Caption = 'Domain:'
    end
    object LabelUsername: TLabel
      Left = 38
      Top = 115
      Width = 52
      Height = 13
      Caption = 'Username:'
    end
    object Label5: TLabel
      Left = 40
      Top = 142
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object EditName: TEdit
      Left = 96
      Top = 8
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object EditHostnameOrIp: TEdit
      Left = 96
      Top = 35
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object EditDomain: TEdit
      Left = 96
      Top = 85
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object EditUsername: TEdit
      Left = 96
      Top = 112
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object EditPassword: TEdit
      Left = 96
      Top = 139
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 5
    end
    object CheckBoxInherit: TCheckBox
      Left = 96
      Top = 62
      Width = 49
      Height = 17
      AllowGrayed = True
      Caption = 'Inherit'
      TabOrder = 2
      OnClick = CheckBoxInheritClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 171
    Width = 276
    Height = 41
    Margins.Top = 5
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 152
    object ButtonCancel: TButton
      AlignWithMargins = True
      Left = 116
      Top = 4
      Width = 75
      Height = 33
      Align = alRight
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 0
      OnClick = ButtonCancelClick
    end
    object ButtonSave: TButton
      AlignWithMargins = True
      Left = 197
      Top = 4
      Width = 75
      Height = 33
      Align = alRight
      Caption = '&Save'
      Default = True
      TabOrder = 1
      OnClick = ButtonSaveClick
    end
  end
end

object FormConnInfo: TFormConnInfo
  Left = 0
  Top = 0
  Caption = 'Connection Info'
  ClientHeight = 241
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 276
    Height = 200
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 272
    ExplicitHeight = 199
    DesignSize = (
      276
      200)
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
      Top = 115
      Width = 39
      Height = 13
      Caption = 'Domain:'
    end
    object LabelUsername: TLabel
      Left = 38
      Top = 142
      Width = 52
      Height = 13
      Caption = 'Username:'
    end
    object Label5: TLabel
      Left = 40
      Top = 169
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object LabelPort: TLabel
      Left = 66
      Top = 66
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object EditName: TEdit
      Left = 96
      Top = 8
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 164
    end
    object EditHostnameOrIp: TEdit
      Left = 96
      Top = 35
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 164
    end
    object EditDomain: TEdit
      Left = 96
      Top = 112
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      ExplicitWidth = 164
    end
    object EditUsername: TEdit
      Left = 96
      Top = 139
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      ExplicitWidth = 164
    end
    object EditPassword: TEdit
      Left = 96
      Top = 166
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 7
      ExplicitWidth = 164
    end
    object CheckBoxInherit: TCheckBox
      Left = 96
      Top = 89
      Width = 57
      Height = 17
      AllowGrayed = True
      Caption = 'Inherit'
      TabOrder = 3
      OnClick = CheckBoxInheritClick
    end
    object EditPort: TEdit
      Left = 96
      Top = 62
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      NumbersOnly = True
      TabOrder = 2
      Text = '3389'
      ExplicitWidth = 164
    end
    object CheckBoxAdmin: TCheckBox
      Left = 168
      Top = 89
      Width = 57
      Height = 17
      Caption = 'Admin'
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 200
    Width = 276
    Height = 41
    Margins.Top = 5
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 199
    ExplicitWidth = 272
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
      ExplicitLeft = 112
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
      ExplicitLeft = 193
    end
  end
end

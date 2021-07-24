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
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 276
    Height = 152
    Align = alClient
    TabOrder = 0
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
      Top = 65
      Width = 39
      Height = 13
      Caption = 'Domain:'
    end
    object LabelUsername: TLabel
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
      Top = 62
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object EditUsername: TEdit
      Left = 96
      Top = 89
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object EditPassword: TEdit
      Left = 96
      Top = 116
      Width = 176
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
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

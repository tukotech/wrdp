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
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControlMain: TPageControl
    Left = 0
    Top = 0
    Width = 922
    Height = 610
    ActivePage = TabSheetMain
    Align = alClient
    PopupMenu = PopupMenuRDP
    TabOrder = 0
    OnContextPopup = PageControlMainContextPopup
    object TabSheetMain: TTabSheet
      Caption = 'Main'
      ExplicitLeft = 8
      ExplicitTop = 48
      object ListBoxInfo: TListBox
        Left = 0
        Top = 432
        Width = 914
        Height = 150
        Align = alBottom
        ItemHeight = 13
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 914
        Height = 432
        Align = alClient
        TabOrder = 1
        ExplicitLeft = 24
        ExplicitTop = 80
        ExplicitWidth = 873
        ExplicitHeight = 337
        object sgConnectionInfo: TStringGrid
          Left = 1
          Top = 1
          Width = 352
          Height = 430
          Align = alLeft
          ColCount = 4
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goRowSelect]
          TabOrder = 0
          OnDblClick = sgConnectionInfoDblClick
          OnEnter = sgConnectionInfoEnter
          OnGetEditText = sgConnectionInfoGetEditText
          OnKeyPress = sgConnectionInfoKeyPress
          OnKeyUp = sgConnectionInfoKeyUp
          OnSelectCell = sgConnectionInfoSelectCell
          OnSetEditText = sgConnectionInfoSetEditText
        end
        object VST: TVirtualStringTree
          Left = 353
          Top = 1
          Width = 560
          Height = 430
          Align = alClient
          Header.AutoSizeIndex = 0
          Header.MainColumn = -1
          PopupMenu = PopupMenuVST
          TabOrder = 1
          OnFreeNode = VSTFreeNode
          OnGetText = VSTGetText
          OnInitNode = VSTInitNode
          OnKeyPress = VSTKeyPress
          OnLoadNode = VSTLoadNode
          OnSaveNode = VSTSaveNode
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          ExplicitLeft = 544
          ExplicitTop = 120
          ExplicitWidth = 200
          ExplicitHeight = 100
          Columns = <>
        end
      end
    end
  end
  object PopupMenuRDP: TPopupMenu
    Left = 508
    Top = 504
    object CloseTab: TMenuItem
      Caption = 'Close'
      OnClick = CloseTabClick
    end
  end
  object PopupMenuVST: TPopupMenu
    Left = 676
    Top = 512
    object AddGroupMI: TMenuItem
      Caption = 'Add Group'
      OnClick = AddGroupMIClick
    end
    object AddTraget1: TMenuItem
      Caption = 'Add Traget'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
    end
  end
end

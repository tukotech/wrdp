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
    ActivePage = TabSheet1
    Align = alClient
    PopupMenu = PopupMenuRDP
    TabOrder = 0
    OnContextPopup = PageControlMainContextPopup
    object TabSheetMain: TTabSheet
      Caption = 'Main'
      object ListBoxInfo: TListBox
        Left = 0
        Top = 432
        Width = 914
        Height = 150
        Align = alBottom
        ItemHeight = 13
        TabOrder = 0
      end
      object VST: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 914
        Height = 432
        Align = alClient
        Header.AutoSizeIndex = 0
        Header.MainColumn = -1
        PopupMenu = PopupMenuVST
        TabOrder = 1
        OnContextPopup = VSTContextPopup
        OnDblClick = VSTDblClick
        OnFreeNode = VSTFreeNode
        OnGetText = VSTGetText
        OnInitNode = VSTInitNode
        OnKeyPress = VSTKeyPress
        OnLoadNode = VSTLoadNode
        OnSaveNode = VSTSaveNode
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Columns = <>
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ImageIndex = 1
      object Button1: TButton
        Left = 112
        Top = 80
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
      end
    end
  end
  object PopupMenuRDP: TPopupMenu
    Left = 508
    Top = 504
    object PopupMenuRDP_CloseTabMI: TMenuItem
      Caption = 'Close'
      OnClick = PopupMenuRDP_CloseTabMIClick
    end
    object PopupMenuRDP_DetachMI: TMenuItem
      Caption = 'Detach'
      OnClick = PopupMenuRDP_DetachMIClick
    end
  end
  object PopupMenuVST: TPopupMenu
    Left = 676
    Top = 512
    object PopupMenuVST_AddHost: TMenuItem
      Caption = 'Add &Host'
      OnClick = PopupMenuVST_AddHostClick
    end
    object PopupMenuVST_AddSubHost: TMenuItem
      Caption = 'Add &Sub Host'
      OnClick = PopupMenuVST_AddSubHostClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PopupMenuVST_EditMI: TMenuItem
      Caption = '&Edit'
      OnClick = PopupMenuVST_EditMIClick
    end
    object PopupMenuVST_DeleteMI: TMenuItem
      Caption = '&Delete'
      OnClick = PopupMenuVST_DeleteMIClick
    end
  end
end

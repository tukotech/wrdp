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
        Top = 528
        Width = 914
        Height = 54
        Align = alBottom
        ItemHeight = 13
        TabOrder = 0
        Visible = False
      end
      object VST: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 914
        Height = 528
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
        OnKeyDown = VSTKeyDown
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
      object MsRdpClient9NotSafeForScripting1: TMsRdpClient9NotSafeForScripting
        Left = 328
        Top = 160
        Width = 192
        Height = 192
        TabOrder = 0
        OnDisconnected = MsRdpClient9NotSafeForScripting1Disconnected
        OnLogonError = MsRdpClient9NotSafeForScripting1LogonError
        ControlData = {0008000008000200000000000B0000000B000000}
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
      Action = ActionAddHost
    end
    object PopupMenuVST_AddSubHost: TMenuItem
      Action = ActionAddSubHost
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PopupMenuVST_EditMI: TMenuItem
      Action = ActionEdit
    end
    object PopupMenuVST_DeleteMI: TMenuItem
      Action = ActionDelete
    end
  end
  object ActionList1: TActionList
    Left = 252
    Top = 512
    object ActionDelete: TAction
      Category = 'VSTPopup'
      Caption = 'Delete'
      OnExecute = ActionDeleteExecute
    end
    object ActionEdit: TAction
      Category = 'VSTPopup'
      Caption = 'Edit'
      OnExecute = ActionEditExecute
    end
    object ActionAddSubHost: TAction
      Category = 'VSTPopup'
      Caption = 'Add Sub Host'
      OnExecute = ActionAddSubHostExecute
    end
    object ActionAddHost: TAction
      Category = 'VSTPopup'
      Caption = 'Add Host'
      OnExecute = ActionAddHostExecute
    end
  end
end

inherited fFormGetZhiKa: TfFormGetZhiKa
  Left = 351
  Top = 280
  Width = 431
  Height = 467
  BorderStyle = bsSizeable
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 415
    Height = 429
    inherited BtnOK: TButton
      Left = 269
      Top = 396
      Caption = #30830#23450
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 339
      Top = 396
      TabOrder = 7
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 338
      Height = 116
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 249
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditID: TcxButtonEdit [3]
      Left = 81
      Top = 157
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 124
    end
    object EditSalesMan: TcxComboBox [4]
      Left = 268
      Top = 157
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditSalesManPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 2
      Width = 121
    end
    object EditName: TcxComboBox [5]
      Left = 81
      Top = 182
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditNamePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      OnKeyPress = EditNameKeyPress
      Width = 185
    end
    object ListDetail: TcxListView [6]
      Left = 23
      Top = 264
      Width = 355
      Height = 154
      Checkboxes = True
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 120
        end
        item
          Caption = #21333#20215'('#20803'/'#21544')'
          Width = 100
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      ViewStyle = vsReport
    end
    object EditZK: TcxComboBox [7]
      Left = 81
      Top = 239
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 20
      Properties.OnEditValueChanged = EditZKPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 4
      OnKeyPress = EditNameKeyPress
      Width = 368
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = '1.'#36873#25321#23458#25143
        object dxLayout1Item7: TdxLayoutItem
          AlignVert = avTop
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          AlignVert = avBottom
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #23458#25143#32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #19994#21153#20154#21592':'
            Control = EditSalesMan
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item10: TdxLayoutItem
          AlignHorz = ahClient
          AlignVert = avBottom
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AlignVert = avClient
        CaptionOptions.Text = '2.'#36873#25321#32440#21345
        ButtonOptions.Buttons = <>
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #32440#21345#21015#34920':'
          Control = EditZK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AlignVert = avClient
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

inherited fFormBill: TfFormBill
  Left = 608
  Top = 168
  ClientHeight = 460
  ClientWidth = 419
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 419
    Height = 460
    OptionsItem.AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 273
      Top = 427
      Caption = #24320#21333
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 343
      Top = 427
      TabOrder = 9
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 351
      Height = 116
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 273
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 8
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 296
      Width = 372
      Height = 113
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end
        item
          Caption = #25552#36135#36710#36742
          Width = 70
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
    end
    object EditValue: TcxTextEdit [4]
      Left = 81
      Top = 271
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditTruck: TcxTextEdit [5]
      Left = 264
      Top = 182
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 116
    end
    object EditStock: TcxComboBox [6]
      Left = 81
      Top = 246
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 18
      Properties.OnChange = EditStockPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      OnKeyPress = EditLadingKeyPress
      Width = 115
    end
    object BtnAdd: TButton [7]
      Left = 357
      Top = 246
      Width = 39
      Height = 17
      Caption = #28155#21152
      TabOrder = 4
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [8]
      Left = 357
      Top = 271
      Width = 39
      Height = 18
      Caption = #21024#38500
      TabOrder = 7
      OnClick = BtnDelClick
    end
    object EditLading: TcxComboBox [9]
      Left = 81
      Top = 182
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135
        'X=X'#12289#36816#21368)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditFQ: TcxTextEdit [10]
      Left = 264
      Top = 157
      ParentFont = False
      Properties.MaxLength = 100
      Properties.OnEditValueChanged = EditFQPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 13
      Width = 120
    end
    object EditType: TcxComboBox [11]
      Left = 81
      Top = 157
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 14
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object PrintGLF: TcxCheckBox [12]
      Left = 11
      Top = 427
      Caption = #25171#21360#36807#36335#36153
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 15
      Transparent = True
      Width = 95
    end
    object PrintHY: TcxCheckBox [13]
      Left = 111
      Top = 427
      Caption = #25171#21360#21270#39564#21333
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 16
      Transparent = True
      Width = 95
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #25552#36135#36890#36947':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #23553#31614#32534#21495':'
            Control = EditFQ
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item12: TdxLayoutItem
            AlignHorz = ahLeft
            CaptionOptions.Text = #25552#36135#26041#24335':'
            Control = EditLading
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AlignVert = avClient
        CaptionOptions.Text = #25552#21333#26126#32454
        ButtonOptions.Buttons = <>
        object dxLayout1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #27700#27877#31867#22411':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button1'
              CaptionOptions.Visible = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #21150#29702#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button2'
              CaptionOptions.Visible = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'New Item'
          CaptionOptions.Visible = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem [0]
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Visible = False
          Control = PrintGLF
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem [1]
          CaptionOptions.Visible = False
          Control = PrintHY
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

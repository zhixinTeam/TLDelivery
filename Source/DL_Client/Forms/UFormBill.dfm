inherited fFormBill: TfFormBill
  Left = 491
  Top = 215
  ClientHeight = 466
  ClientWidth = 468
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 468
    Height = 466
    OptionsItem.AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 322
      Top = 433
      Caption = #24320#21333
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 392
      Top = 433
      TabOrder = 12
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 368
      Height = 224
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 290
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditValue: TcxTextEdit [3]
      Left = 289
      Top = 338
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditTruck: TcxTextEdit [4]
      Left = 289
      Top = 313
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 116
    end
    object EditLading: TcxComboBox [5]
      Left = 81
      Top = 338
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
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object EditType: TcxComboBox [6]
      Left = 81
      Top = 313
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
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 145
    end
    object PrintGLF: TcxCheckBox [7]
      Left = 11
      Top = 433
      Caption = #25171#21360#36807#36335#36153
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Transparent = True
      Width = 95
    end
    object PrintHY: TcxCheckBox [8]
      Left = 111
      Top = 433
      Caption = #25171#21360#36136#26816#21333
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Transparent = True
      Width = 111
    end
    object cxLabel1: TcxLabel [9]
      Left = 23
      Top = 363
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 370
    end
    object EditDate: TcxDateEdit [10]
      Left = 81
      Top = 401
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 13
      Width = 145
    end
    object editTrans: TcxComboBox [11]
      Left = 81
      Top = 376
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 14
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          AlignVert = avClient
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AlignVert = avBottom
        CaptionOptions.Text = #25552#21333#26126#32454
        ButtonOptions.Buttons = <>
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
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
            object dxLayout1Item9: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #25552#36135#36710#36742':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group6: TdxLayoutGroup
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
            object dxLayout1Item8: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #21150#29702#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #36816#36755#20844#21496':'
          Control = editTrans
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item15: TdxLayoutItem
          CaptionOptions.Text = #34917#21333#26102#38388
          Control = EditDate
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

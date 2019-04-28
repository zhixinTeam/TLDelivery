inherited fFormCusLimit: TfFormCusLimit
  Left = 254
  Top = 127
  Caption = #21306#22495#25552#36135#38480#21046
  ClientHeight = 539
  ClientWidth = 533
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 533
    Height = 539
    inherited BtnOK: TButton
      Left = 387
      Top = 506
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 457
      Top = 506
      TabOrder = 6
    end
    object cbbStockNo: TcxComboBox [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.OnChange = cbbStockNoPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      Width = 264
    end
    object cxCheckBox1: TcxCheckBox [3]
      Left = 350
      Top = 36
      Caption = #21551#29992#23458#25143#21457#36135#26085#38480#39069
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 1
      Transparent = True
      OnClick = cxCheckBox1Click
      Width = 150
    end
    object ListDetail: TcxListView [4]
      Left = 23
      Top = 152
      Width = 487
      Height = 342
      Columns = <
        item
          Alignment = taCenter
          Caption = #21306#22495#21517#31216
          Width = 200
        end
        item
          Alignment = taCenter
          Caption = #26085#38480#39069'('#21544')'
          Width = 150
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 4
      ViewStyle = vsReport
      OnClick = ListDetailClick
    end
    object editCusNo: TcxTextEdit [5]
      Left = 81
      Top = 98
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 2
      Width = 152
    end
    object editValue: TcxTextEdit [6]
      Left = 296
      Top = 98
      ParentFont = False
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 3
      OnExit = editValueExit
      Width = 214
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            CaptionOptions.Text = #29289#26009#21517#31216':'
            Control = cbbStockNo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            CaptionOptions.Text = 'cxCheckBox1'
            CaptionOptions.Visible = False
            Control = cxCheckBox1
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxlytgrpLayout1Group2: TdxLayoutGroup [1]
        AlignVert = avClient
        CaptionOptions.Text = #35814#32454#20449#24687
        ButtonOptions.Buttons = <>
        object dxlytgrpLayout1Group3: TdxLayoutGroup
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            CaptionOptions.Text = #21306#22495#21517#31216':'
            Control = editCusNo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            CaptionOptions.Text = #38480#25552#21544#25968':'
            Control = editValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          AlignVert = avBottom
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

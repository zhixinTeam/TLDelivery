inherited fFormBatcodeEdit: TfFormBatcodeEdit
  Left = 476
  Top = 336
  ClientHeight = 261
  ClientWidth = 444
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 444
    Height = 261
    inherited BtnOK: TButton
      Left = 298
      Top = 228
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 368
      Top = 228
      TabOrder = 12
    end
    object EditName: TcxTextEdit [2]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 116
    end
    object EditBatch: TcxTextEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      Width = 125
    end
    object EditRund: TcxTextEdit [4]
      Left = 269
      Top = 157
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Text = '0'
      Width = 121
    end
    object EditStock: TcxComboBox [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 18
      Properties.ItemHeight = 20
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      Width = 121
    end
    object EditInit: TcxTextEdit [6]
      Left = 269
      Top = 132
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Text = '0'
      Width = 271
    end
    object EditPlan: TcxTextEdit [7]
      Left = 81
      Top = 132
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Text = '2000'
      Width = 125
    end
    object EditWarn: TcxTextEdit [8]
      Left = 81
      Top = 157
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Text = '5'
      Width = 125
    end
    object Check1: TcxCheckBox [9]
      Left = 11
      Top = 228
      Caption = #26159#21542#21551#29992
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 10
      Transparent = True
      Width = 121
    end
    object cxLabel1: TcxLabel [10]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Style.Edges = []
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 16
      Width = 280
    end
    object EditDays: TcxTextEdit [11]
      Left = 81
      Top = 182
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 8
      Text = '3'
      Width = 125
    end
    object cxLabel2: TcxLabel [12]
      Left = 211
      Top = 182
      Caption = #27880': '#20174#32534#21495#21551#29992#24320#22987','#36807#26399#33258#21160#23553#23384'.'
      ParentFont = False
      Style.Edges = []
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #25209' '#27425' '#21495':'
          Control = EditBatch
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #29289#26009#32534#21495':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #29289#26009#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group2: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              CaptionOptions.Text = #35745#21010#24635#37327':'
              Control = EditPlan
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #21021#22987#24050#21457':'
              Control = EditInit
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
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
              object dxLayout1Item8: TdxLayoutItem
                CaptionOptions.Text = #39044#35686'('#20313'):'
                Control = EditWarn
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item3: TdxLayoutItem
                AlignHorz = ahClient
                CaptionOptions.Text = #36864' '#36135' '#37327':'
                Control = EditRund
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group7: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item14: TdxLayoutItem
                CaptionOptions.Text = #26377#25928#22825#25968':'
                Control = EditDays
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item15: TdxLayoutItem
                CaptionOptions.Text = 'cxLabel2'
                CaptionOptions.Visible = False
                Control = cxLabel2
                ControlOptions.ShowBorder = False
              end
            end
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item10: TdxLayoutItem [0]
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

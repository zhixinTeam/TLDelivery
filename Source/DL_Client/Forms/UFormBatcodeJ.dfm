inherited fFormBatcode: TfFormBatcode
  Left = 476
  Top = 336
  ClientHeight = 394
  ClientWidth = 472
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 472
    Height = 394
    inherited BtnOK: TButton
      Left = 326
      Top = 361
      TabOrder = 17
    end
    inherited BtnExit: TButton
      Left = 396
      Top = 361
      TabOrder = 18
    end
    object EditName: TcxTextEdit [2]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 80
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 116
    end
    object EditPrefix: TcxTextEdit [3]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 135
    end
    object EditStock: TcxComboBox [4]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 18
      Properties.ItemHeight = 20
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      Width = 121
    end
    object EditInc: TcxTextEdit [5]
      Left = 279
      Top = 111
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Text = '1'
      Width = 271
    end
    object EditBase: TcxTextEdit [6]
      Left = 81
      Top = 111
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Text = '1'
      Width = 135
    end
    object EditLen: TcxTextEdit [7]
      Left = 279
      Top = 86
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Text = '6'
      Width = 135
    end
    object Check1: TcxCheckBox [8]
      Left = 23
      Top = 136
      Caption = #20351#29992#26085#26399#32534#30721'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Transparent = True
      Width = 165
    end
    object EditLow: TcxTextEdit [9]
      Left = 81
      Top = 253
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 10
      Text = '80'
      Width = 135
    end
    object EditHigh: TcxTextEdit [10]
      Left = 81
      Top = 278
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 12
      Text = '100'
      Width = 135
    end
    object Check2: TcxCheckBox [11]
      Left = 23
      Top = 328
      Caption = #26032#24180#26102#33258#21160#37325#32622','#32534#21495#22522#25968#20174'1'#24320#22987#35745#25968'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 16
      Transparent = True
      Width = 121
    end
    object cxLabel1: TcxLabel [12]
      Left = 221
      Top = 253
      Caption = #27880':'#35813#20540#20026#30334#20998#27604'(%),'#36229#36807#35813#20540#25552#37266'.'
      ParentFont = False
      Transparent = True
    end
    object cxLabel2: TcxLabel [13]
      Left = 221
      Top = 278
      Caption = #27880':'#35813#20540#20026#30334#20998#27604'(%),'#36229#36807#35813#20540#26356#25442#32534#21495'.'
      ParentFont = False
      Transparent = True
    end
    object EditValue: TcxTextEdit [14]
      Left = 81
      Top = 228
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 8
      Text = '0'
      Width = 135
    end
    object cxLabel3: TcxLabel [15]
      Left = 221
      Top = 228
      Caption = #27880':'#27599#22810#23569#21544#26816#27979#19968#27425'.'
      ParentFont = False
      Transparent = True
    end
    object EditWeek: TcxTextEdit [16]
      Left = 81
      Top = 303
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 14
      Text = '20'
      Width = 135
    end
    object cxLabel4: TcxLabel [17]
      Left = 221
      Top = 303
      Caption = #27880':'#20174#31532#19968#36710#21551#29992#24320#22987#19981#36229#36807#22810#23569#22825'.'
      ParentFont = False
      Transparent = True
    end
    object Check3: TcxCheckBox [18]
      Left = 23
      Top = 162
      Caption = #21069#32512#21518#38754#28155#21152#20004#20301#24180#20221'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Transparent = True
      Width = 165
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
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
        object dxLayout1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group6: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              AlignHorz = ahLeft
              CaptionOptions.Text = #32534#21495#21069#32512':'
              Control = EditPrefix
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #32534#21495#38271#24230':'
              Control = EditLen
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              CaptionOptions.Text = #32534#21495#22522#25968':'
              Control = EditBase
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #32534#21495#22686#37327':'
              Control = EditInc
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            ShowBorder = False
            object dxLayout1Item10: TdxLayoutItem
              CaptionOptions.Text = 'cxCheckBox1'
              CaptionOptions.Visible = False
              Control = Check1
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item3: TdxLayoutItem
              CaptionOptions.Visible = False
              Control = Check3
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        CaptionOptions.Text = #32534#21495#21464#26356
        ButtonOptions.Buttons = <>
        object dxLayout1Group9: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item16: TdxLayoutItem
            CaptionOptions.Text = #26816' '#27979' '#37327':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item17: TdxLayoutItem
            CaptionOptions.Text = 'cxLabel3'
            CaptionOptions.Visible = False
            Control = cxLabel3
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayout1Group7: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item11: TdxLayoutItem
              CaptionOptions.Text = #36229#21457#25552#37266':'
              Control = EditLow
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item14: TdxLayoutItem
              CaptionOptions.Text = 'cxLabel1'
              CaptionOptions.Visible = False
              Control = cxLabel1
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group8: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            ShowBorder = False
            object dxLayout1Group10: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item12: TdxLayoutItem
                AlignHorz = ahLeft
                CaptionOptions.Text = #36229#21457#19978#38480':'
                Control = EditHigh
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item15: TdxLayoutItem
                CaptionOptions.Text = 'cxLabel2'
                CaptionOptions.Visible = False
                Control = cxLabel2
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group11: TdxLayoutGroup
              CaptionOptions.Visible = False
              ButtonOptions.Buttons = <>
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item18: TdxLayoutItem
                CaptionOptions.Text = #32534#21495#21608#26399':'
                Control = EditWeek
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item19: TdxLayoutItem
                CaptionOptions.Text = 'cxLabel4'
                CaptionOptions.Visible = False
                Control = cxLabel4
                ControlOptions.ShowBorder = False
              end
            end
          end
        end
        object dxLayout1Item13: TdxLayoutItem
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = Check2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

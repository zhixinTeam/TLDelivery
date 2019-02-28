inherited fFormRFIDCard: TfFormRFIDCard
  Caption = #20851#32852#30005#23376#26631#31614
  ClientHeight = 183
  ClientWidth = 332
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 332
    Height = 183
    inherited BtnOK: TButton
      Left = 186
      Top = 150
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 256
      Top = 150
      TabOrder = 6
    end
    object edtTruck: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    object chkValue: TcxCheckBox [3]
      Left = 11
      Top = 150
      Caption = #21551#29992#30005#23376#26631#31614
      ParentFont = False
      State = cbsChecked
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 4
      Transparent = True
      Width = 105
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 86
      Caption = #22914#26524#20351#29992#36828#31243#35835#21345#22120#33719#21462#26631#31614#21495','#35831#36873#25321#35774#22791':'
      ParentFont = False
      Style.HotTrack = False
      Transparent = True
    end
    object EditReaders: TcxComboBox [5]
      Left = 81
      Top = 107
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      Width = 121
    end
    object edtRFIDCard: TcxButtonEdit [6]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edtRFIDCardPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = edtTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #30005#23376#26631#31614':'
          Control = edtRFIDCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #35774#22791#20301#32622':'
          Control = EditReaders
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem [0]
          Control = chkValue
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object tmrReadCard: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrReadCardTimer
    Top = 24
  end
end

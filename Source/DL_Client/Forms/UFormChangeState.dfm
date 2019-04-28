inherited fFormChangeState: TfFormChangeState
  Caption = 'fFormChangeState'
  ClientHeight = 232
  ClientWidth = 334
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 334
    Height = 232
    inherited BtnOK: TButton
      Left = 188
      Top = 199
      Caption = #37325#26032#36807#27611
      Enabled = False
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 258
      Top = 199
      TabOrder = 7
    end
    object editBillNo: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 0
      OnKeyPress = editBillNoKeyPress
      Width = 121
    end
    object editCustomer: TcxTextEdit [3]
      Left = 81
      Top = 61
      Enabled = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 1
      Width = 121
    end
    object editTruck: TcxTextEdit [4]
      Left = 81
      Top = 86
      Enabled = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 2
      Width = 121
    end
    object editStock: TcxTextEdit [5]
      Left = 81
      Top = 111
      Enabled = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 3
      Width = 121
    end
    object editState: TcxTextEdit [6]
      Left = 81
      Top = 136
      Enabled = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 4
      Width = 121
    end
    object editNextState: TcxTextEdit [7]
      Left = 81
      Top = 161
      Enabled = False
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 5
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #25552#36135#21333#21495':'
          Control = editBillNo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Enabled = False
          Control = editCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Enabled = False
          Control = editTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #29289#26009#20449#24687':'
          Enabled = False
          Control = editStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #24403#21069#29366#24577':'
          Enabled = False
          Control = editState
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #19979#19968#29366#24577':'
          Enabled = False
          Control = editNextState
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        inherited dxLayout1Item1: TdxLayoutItem
          Enabled = False
        end
      end
    end
  end
end

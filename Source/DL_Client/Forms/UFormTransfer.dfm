inherited fFormTransfer: TfFormTransfer
  Left = 438
  Top = 340
  Caption = #20498#26009#31649#29702
  ClientHeight = 251
  ClientWidth = 385
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 385
    Height = 251
    inherited BtnOK: TButton
      Left = 239
      Top = 218
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 309
      Top = 218
      TabOrder = 9
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 96
    end
    object EditSrcAddr: TcxTextEdit [3]
      Left = 81
      Top = 136
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 96
    end
    object EditDstAddr: TcxTextEdit [4]
      Left = 81
      Top = 186
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 96
    end
    object EditMID: TcxComboBox [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.OnChange = EditMIDPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      Width = 121
    end
    object EditDC: TcxComboBox [6]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.OnChange = EditDCPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      Width = 121
    end
    object EditDR: TcxComboBox [7]
      Left = 81
      Top = 161
      ParentFont = False
      Properties.OnChange = EditDCPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 5
      Width = 121
    end
    object EditTruck: TcxButtonEdit [8]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = EditTruckKeyPress
      Width = 121
    end
    object CheckBox1: TCheckBox [9]
      Left = 11
      Top = 218
      Width = 97
      Height = 17
      Caption = #27492#21345#20026#22266#23450#21345
      Color = clWindow
      ParentColor = False
      TabOrder = 7
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #21407#26009#32534#21495':'
          Control = EditMID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #21407#26009#21517#31216':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          CaptionOptions.Text = #20498#20986#32534#21495':'
          Control = EditDC
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #20498#20986#22320#28857':'
          Control = EditSrcAddr
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          CaptionOptions.Text = #20498#20837#32534#21495':'
          Control = EditDR
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #20498#20837#22320#28857':'
          Control = EditDstAddr
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item10: TdxLayoutItem [0]
          CaptionOptions.Text = 'CheckBox1'
          CaptionOptions.Visible = False
          Control = CheckBox1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
    object TdxLayoutGroup
      ButtonOptions.Buttons = <>
    end
  end
end

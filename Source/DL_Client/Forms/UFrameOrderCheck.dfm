inherited fFrameOrderCheck: TfFrameOrderCheck
  inherited ToolBar1: TToolBar
    inherited BtnAdd: TToolButton
      Caption = #37096#38376#23457#26680
      ImageIndex = 1
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #32463#29702#23457#26680
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited dxLayout1: TdxLayoutControl
    object EditDate: TcxButtonEdit [0]
      Left = 265
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 192
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitlePanel1: TZnBitmapPanel
    inherited TitleBar: TcxLabel
      Caption = #37319#36141#25298#25910#21333#25454#23457#25209
      Style.IsFontAssigned = True
      AnchorX = 301
      AnchorY = 11
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 88
    object N1: TMenuItem
      Caption = #23457#26680#36890#36807
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #23457#26680#25298#32477
      OnClick = N2Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 64
    Top = 88
    object N3: TMenuItem
      Caption = #23457#26680#36890#36807
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #23457#26680#25298#32477
      OnClick = N4Click
    end
  end
end

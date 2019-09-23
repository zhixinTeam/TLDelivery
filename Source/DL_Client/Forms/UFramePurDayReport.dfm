inherited fFramePurDayReport: TfFramePurDayReport
  inherited dxLayout1: TdxLayoutControl
    object Button1: TButton [0]
      Left = 242
      Top = 36
      Width = 75
      Height = 25
      Caption = #32479#35745
      TabOrder = 1
      OnClick = Button1Click
    end
    object editDate: TcxDateEdit [1]
      Left = 81
      Top = 36
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      Width = 156
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = #36873#25321#26085#26399':'
          Control = editDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = 'Button1'
          CaptionOptions.Visible = False
          Control = Button1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitlePanel1: TZnBitmapPanel
    inherited TitleBar: TcxLabel
      Caption = #37319#36141#26085#25253#34920
      Style.IsFontAssigned = True
      AnchorX = 301
      AnchorY = 11
    end
  end
end

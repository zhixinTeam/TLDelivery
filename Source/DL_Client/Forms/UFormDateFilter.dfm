object fFormDateFilter: TfFormDateFilter
  Left = 361
  Top = 321
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 133
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 263
    Height = 133
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object EditStart: TcxDateEdit
      Left = 81
      Top = 36
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 0
      Width = 156
    end
    object EditEnd: TcxDateEdit
      Left = 81
      Top = 66
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      Width = 156
    end
    object BtnOK: TButton
      Left = 120
      Top = 98
      Width = 62
      Height = 22
      Caption = #30830#23450
      TabOrder = 2
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 187
      Top = 98
      Width = 62
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 3
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        CaptionOptions.Text = #26085#26399#35774#23450
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Item1: TdxLayoutItem
          CaptionOptions.Text = #24320#22987#26085#26399':'
          Control = EditStart
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          CaptionOptions.Text = #32467#26463#26085#26399':'
          Offsets.Top = 5
          Control = EditEnd
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item3: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button1'
          CaptionOptions.Visible = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button2'
          CaptionOptions.Visible = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

inherited fFormNormal: TfFormNormal
  Left = 489
  Top = 305
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 129
  ClientWidth = 223
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 223
    Height = 129
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 77
      Top = 96
      Width = 65
      Height = 22
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 147
      Top = 96
      Width = 65
      Height = 22
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object dxGroup1: TdxLayoutGroup
        AlignVert = avClient
        CaptionOptions.Text = #22522#26412#20449#24687
        ButtonOptions.Buttons = <>
      end
      object dxLayout1Group1: TdxLayoutGroup
        AlignVert = avBottom
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayout1Item1: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button1'
          CaptionOptions.Visible = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
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

inherited fFormTransDetail: TfFormTransDetail
  Left = 420
  Top = 165
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 308
  ClientWidth = 366
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 366
    Height = 308
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object EditMemo: TcxMemo
      Left = 81
      Top = 212
      Hint = 'T.T_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Edges = [bBottom]
      TabOrder = 7
      Height = 45
      Width = 385
    end
    object BtnOK: TButton
      Left = 210
      Top = 275
      Width = 70
      Height = 22
      Caption = #20445#23384
      TabOrder = 8
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 285
      Top = 275
      Width = 70
      Height = 22
      Caption = #21462#28040
      TabOrder = 9
      OnClick = BtnExitClick
    end
    object EditTruck: TcxTextEdit
      Left = 81
      Top = 36
      Hint = 'T.T_Truck'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      Width = 262
    end
    object EditSrc: TcxTextEdit
      Left = 81
      Top = 62
      Hint = 'T.T_SrcAddr'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      Width = 121
    end
    object EditDest: TcxTextEdit
      Left = 81
      Top = 87
      Hint = 'T.T_DestAddr'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Width = 121
    end
    object EditMName: TcxTextEdit
      Left = 81
      Top = 112
      Hint = 'T.T_StockName'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 121
    end
    object EditPValue: TcxTextEdit
      Left = 81
      Top = 137
      Hint = 'T.T_PValue'
      ParentFont = False
      Properties.OnEditValueChanged = EditMValuePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Text = '0.00'
      Width = 121
    end
    object EditMValue: TcxTextEdit
      Left = 81
      Top = 162
      Hint = 'T.T_MValue'
      ParentFont = False
      Properties.OnEditValueChanged = EditMValuePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Text = '0.00'
      Width = 121
    end
    object EditValue: TcxTextEdit
      Left = 81
      Top = 187
      Hint = 'T.T_Value'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Text = '0.00'
      Width = 121
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahParentManaged
      AlignVert = avParentManaged
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        CaptionOptions.Text = #22522#26412#20449#24687
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Item1: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          CaptionOptions.Text = #20498#20986#22320#22336':'
          Control = EditSrc
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          CaptionOptions.Text = #20498#20837#22320#22336':'
          Control = EditDest
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item6: TdxLayoutItem
          CaptionOptions.Text = #29289#26009#21517#31216':'
          Control = EditMName
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item7: TdxLayoutItem
          CaptionOptions.Text = #30382#37325'('#21544'):'
          Control = EditPValue
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item8: TdxLayoutItem
          CaptionOptions.Text = #27611#37325'('#21544'):'
          Control = EditMValue
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item9: TdxLayoutItem
          CaptionOptions.Text = #20928#37325'('#21544'):'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AlignVert = avBottom
        CaptionOptions.Visible = False
        ButtonOptions.Buttons = <>
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button3'
          CaptionOptions.Visible = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AlignHorz = ahRight
          CaptionOptions.Text = 'Button4'
          CaptionOptions.Visible = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

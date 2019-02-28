inherited fFormMaterails: TfFormMaterails
  Left = 485
  Top = 217
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 424
  ClientWidth = 371
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 371
    Height = 424
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object EditName: TcxTextEdit
      Left = 81
      Top = 61
      Hint = 'T.M_Name'
      ParentFont = False
      Properties.MaxLength = 30
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 1
      OnKeyDown = FormKeyDown
      Width = 138
    end
    object EditMemo: TcxMemo
      Left = 81
      Top = 161
      Hint = 'T.M_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Edges = [bBottom]
      TabOrder = 7
      Height = 40
      Width = 268
    end
    object InfoList1: TcxMCListBox
      Left = 23
      Top = 338
      Width = 397
      Height = 105
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 105
        end
        item
          AutoSize = True
          Text = #20869#23481
          Width = 288
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 14
    end
    object InfoItems: TcxComboBox
      Left = 81
      Top = 288
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 10
      Width = 75
    end
    object EditInfo: TcxTextEdit
      Left = 81
      Top = 313
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 12
      Width = 90
    end
    object BtnAdd: TButton
      Left = 303
      Top = 288
      Width = 45
      Height = 17
      Caption = #28155#21152
      TabOrder = 11
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 303
      Top = 313
      Width = 45
      Height = 18
      Caption = #21024#38500
      TabOrder = 13
      OnClick = BtnDelClick
    end
    object BtnOK: TButton
      Left = 216
      Top = 390
      Width = 69
      Height = 23
      Caption = #20445#23384
      TabOrder = 15
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 290
      Top = 390
      Width = 70
      Height = 23
      Caption = #21462#28040
      TabOrder = 16
      OnClick = BtnExitClick
    end
    object cxTextEdit3: TcxTextEdit
      Left = 81
      Top = 86
      Hint = 'T.M_Unit'
      ParentFont = False
      Properties.MaxLength = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 2
      Text = #21544
      OnKeyDown = FormKeyDown
      Width = 92
    end
    object EditPrice: TcxTextEdit
      Left = 260
      Top = 86
      Hint = 'T.M_Price'
      HelpType = htKeyword
      HelpKeyword = 'D'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Text = '0'
      Width = 107
    end
    object EditPValue: TcxComboBox
      Left = 81
      Top = 111
      Hint = 'T.M_PrePValue'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'Y'#12289#20801#35768
        'N'#12289#31105#27490)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 4
      Width = 92
    end
    object EditPTime: TcxTextEdit
      Left = 260
      Top = 111
      Hint = 'T.M_PrePTime'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Text = '1'
      Width = 121
    end
    object EditID: TcxTextEdit
      Left = 81
      Top = 36
      Hint = 'T.M_ID'
      ParentFont = False
      Properties.MaxLength = 30
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      OnKeyDown = FormKeyDown
      Width = 282
    end
    object cxbLs: TcxComboBox
      Left = 81
      Top = 136
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'N'#12289#21542
        'Y'#12289#26159)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 6
      Text = 'N'#12289#21542
      Width = 121
    end
    object editYSTime: TcxComboBox
      Left = 81
      Top = 206
      Hint = 'T.M_YS2Times'
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #19968#27425#39564#25910
        #20004#27425#39564#25910)
      Properties.OnChange = cxComboBox1PropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 8
      Width = 121
    end
    object editYSBM: TcxComboBox
      Left = 81
      Top = 231
      Hint = 'T.M_HYSYS'
      ParentFont = False
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #29289#27969#37096#39564#25910
        #21270#39564#23460#39564#25910)
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 9
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
        object dxLayoutControl1Group9: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Item13: TdxLayoutItem
            CaptionOptions.Text = #21407#26009#32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #21407#26009#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Group6: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item14: TdxLayoutItem
              AlignHorz = ahLeft
              CaptionOptions.Text = #35745#37327#21333#20301':'
              Control = cxTextEdit3
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item1: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #21333#20215'('#20803'/'#21544'):'
              Control = EditPrice
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Group8: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item3: TdxLayoutItem
            CaptionOptions.Text = #39044#32622#30382#37325':'
            Control = EditPValue
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item12: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #39044#32622#26102#38480'('#22825'):'
            Control = EditPTime
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item15: TdxLayoutItem
          CaptionOptions.Text = #29983#25104#27969#27700':'
          Control = cxbLs
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item16: TdxLayoutItem
          CaptionOptions.Text = #39564#25910#27169#24335':'
          Control = editYSTime
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item17: TdxLayoutItem
          CaptionOptions.Text = #39564#25910#37096#38376':'
          Control = editYSBM
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AlignVert = avClient
        CaptionOptions.Text = #38468#21152#20449#24687
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Group4: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group7: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item6: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #20449' '#24687' '#39033':'
              Control = InfoItems
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item8: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button1'
              CaptionOptions.Visible = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group10: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item7: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #20449#24687#20869#23481':'
              Control = EditInfo
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item9: TdxLayoutItem
              AlignHorz = ahRight
              CaptionOptions.Text = 'Button2'
              CaptionOptions.Visible = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          AlignVert = avClient
          Control = InfoList1
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

inherited fFormCustomer: TfFormCustomer
  Left = 420
  Top = 165
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 530
  ClientWidth = 480
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 480
    Height = 530
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    object EditName: TcxTextEdit
      Left = 81
      Top = 36
      Hint = 'T.C_Name'
      ParentFont = False
      Properties.MaxLength = 80
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 0
      Width = 121
    end
    object EditPhone: TcxTextEdit
      Left = 81
      Top = 111
      Hint = 'T.C_Addr'
      ParentFont = False
      Properties.MaxLength = 100
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 208
    end
    object EditMemo: TcxMemo
      Left = 81
      Top = 261
      Hint = 'T.C_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Edges = [bBottom]
      TabOrder = 14
      Height = 45
      Width = 385
    end
    object InfoList1: TcxMCListBox
      Left = 23
      Top = 393
      Width = 438
      Height = 131
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 105
        end
        item
          AutoSize = True
          Text = #20869#23481
          Width = 329
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 19
    end
    object InfoItems: TcxComboBox
      Left = 81
      Top = 343
      ParentFont = False
      Properties.DropDownRows = 15
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 20
      Properties.MaxLength = 30
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 15
      Width = 100
    end
    object EditInfo: TcxTextEdit
      Left = 81
      Top = 368
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 17
      Width = 120
    end
    object BtnAdd: TButton
      Left = 411
      Top = 343
      Width = 46
      Height = 18
      Caption = #28155#21152
      TabOrder = 16
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 412
      Top = 368
      Width = 45
      Height = 17
      Caption = #21024#38500
      TabOrder = 18
      OnClick = BtnDelClick
    end
    object BtnOK: TButton
      Left = 324
      Top = 497
      Width = 70
      Height = 22
      Caption = #20445#23384
      TabOrder = 21
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 399
      Top = 497
      Width = 70
      Height = 22
      Caption = #21462#28040
      TabOrder = 22
      OnClick = BtnExitClick
    end
    object cxTextEdit1: TcxTextEdit
      Left = 280
      Top = 86
      Hint = 'T.C_FaRen'
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 3
      Width = 165
    end
    object cxTextEdit2: TcxTextEdit
      Left = 81
      Top = 136
      Hint = 'T.C_LiXiRen'
      ParentFont = False
      Properties.MaxLength = 50
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 136
    end
    object cxTextEdit3: TcxTextEdit
      Left = 280
      Top = 136
      Hint = 'T.C_Phone'
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 121
    end
    object cxTextEdit4: TcxTextEdit
      Left = 81
      Top = 161
      Hint = 'T.C_Fax'
      ParentFont = False
      Properties.MaxLength = 15
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 7
      Width = 136
    end
    object cxTextEdit5: TcxTextEdit
      Left = 280
      Top = 161
      Hint = 'T.C_Tax'
      ParentFont = False
      Properties.MaxLength = 32
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 8
      Width = 121
    end
    object EditBank: TcxComboBox
      Left = 81
      Top = 186
      Hint = 'T.C_Bank'
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 20
      Properties.MaxLength = 35
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 9
      Width = 136
    end
    object cxTextEdit6: TcxTextEdit
      Left = 280
      Top = 186
      Hint = 'T.C_Account'
      ParentFont = False
      Properties.MaxLength = 18
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 10
      Width = 121
    end
    object EditCredit: TcxTextEdit
      Left = 81
      Top = 211
      Hint = 'Tmp.A_CreditLimit'
      HelpType = htKeyword
      ParentFont = False
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 11
      Text = '0'
      Width = 136
    end
    object cxLabel1: TcxLabel
      Left = 222
      Top = 211
      AutoSize = False
      Caption = #20803'  '#22791#27880':'#25480#20449#32473#23458#25143#30340#26368#39640#21487#27424#27454#37329#39069'.'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 272
      AnchorY = 221
    end
    object EditSaleMan: TcxComboBox
      Left = 81
      Top = 86
      Hint = 'T.C_SaleMan'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 2
      Width = 136
    end
    object Check1: TcxCheckBox
      Left = 11
      Top = 497
      Hint = 'T.C_XuNi'
      Caption = #38750#27491#24335#23458#25143': '#27491#24120#26597#35810#26102#19981#20104#26174#31034'.'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 20
      Transparent = True
      Width = 218
    end
    object EditWX: TcxComboBox
      Left = 81
      Top = 236
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ItemHeight = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 13
      Width = 121
    end
    object editArea: TcxButtonEdit
      Left = 81
      Top = 61
      Hint = 'T.C_Area'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = editAreaPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
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
        object dxLayoutControl1Item2: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item23: TdxLayoutItem
          CaptionOptions.Text = #25152#23646#21306#22495':'
          Control = editArea
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group12: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group11: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item21: TdxLayoutItem
              AlignHorz = ahLeft
              CaptionOptions.Text = #19994#21153#20154#21592':'
              Control = EditSaleMan
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item12: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = #20225#19994#27861#20154':'
              Control = cxTextEdit1
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            CaptionOptions.Text = #32852#31995#22320#22336':'
            Control = EditPhone
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group8: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item13: TdxLayoutItem
            CaptionOptions.Text = #32852' '#31995' '#20154':'
            Control = cxTextEdit2
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item14: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #32852#31995#30005#35805':'
            Control = cxTextEdit3
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group7: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item15: TdxLayoutItem
            CaptionOptions.Text = #20256'    '#30495':'
            Control = cxTextEdit4
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item16: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #31246'   '#21495':'
            Control = cxTextEdit5
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group6: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item17: TdxLayoutItem
            CaptionOptions.Text = #24320' '#25143' '#34892':'
            Control = EditBank
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item18: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #38134#34892#36134#25143':'
            Control = cxTextEdit6
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group10: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group14: TdxLayoutGroup
            CaptionOptions.Visible = False
            ButtonOptions.Buttons = <>
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item19: TdxLayoutItem
              CaptionOptions.Text = #20449#29992#37329#39069':'
              Control = EditCredit
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item20: TdxLayoutItem
              AlignHorz = ahClient
              CaptionOptions.Text = 'cxLabel1'
              CaptionOptions.Visible = False
              Control = cxLabel1
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Item22: TdxLayoutItem
            CaptionOptions.Text = #24494#20449#36134#21495':'
            Control = EditWX
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          CaptionOptions.Text = #22791#27880#20449#24687':'
          Control = EditMemo
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
          object dxLayoutControl1Group13: TdxLayoutGroup
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
          object dxLayoutControl1Group3: TdxLayoutGroup
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
        object dxLayoutControl1Item1: TdxLayoutItem
          CaptionOptions.Text = 'cxCheckBox1'
          CaptionOptions.Visible = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
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

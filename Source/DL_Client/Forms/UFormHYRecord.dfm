object fFormHYRecord: TfFormHYRecord
  Left = 234
  Top = 92
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 565
  ClientWidth = 903
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 903
    Height = 565
    Align = alClient
    TabOrder = 0
    TabStop = False
    LayoutLookAndFeel = FDM.dxLayoutWeb1
    OptionsItem.AutoControlTabOrders = False
    object BtnOK: TButton
      Left = 747
      Top = 531
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 822
      Top = 531
      Width = 70
      Height = 23
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 81
      Top = 36
      Hint = 'E.R_SerialNo'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 2
      Width = 799
    end
    object EditStock: TcxComboBox
      Left = 81
      Top = 61
      Hint = 'E.R_PID'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 4
      Width = 128
    end
    object wPanel: TPanel
      Left = 23
      Top = 143
      Width = 415
      Height = 262
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 3
      object Label17: TLabel
        Left = 6
        Top = 309
        Width = 72
        Height = 12
        Caption = '3'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label18: TLabel
        Left = 6
        Top = 278
        Width = 72
        Height = 12
        Caption = '3'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Label25: TLabel
        Left = 237
        Top = 309
        Width = 78
        Height = 12
        Caption = '28'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label26: TLabel
        Left = 237
        Top = 278
        Width = 78
        Height = 12
        Caption = '28'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Bevel2: TBevel
        Left = 6
        Top = 242
        Width = 827
        Height = 7
        Shape = bsBottomLine
      end
      object Label19: TLabel
        Left = 8
        Top = 109
        Width = 54
        Height = 12
        Caption = #30897' '#21547' '#37327':'
        Transparent = True
      end
      object Label20: TLabel
        Left = 150
        Top = 31
        Width = 54
        Height = 12
        Caption = #19981' '#28342' '#29289':'
        Transparent = True
      end
      object Label21: TLabel
        Left = 8
        Top = 135
        Width = 54
        Height = 12
        Caption = #31264'    '#24230':'
        Transparent = True
      end
      object Label22: TLabel
        Left = 8
        Top = 83
        Width = 54
        Height = 12
        Caption = #32454'    '#24230':'
        Transparent = True
      end
      object Label23: TLabel
        Left = 8
        Top = 187
        Width = 54
        Height = 12
        Caption = #27695' '#31163' '#23376':'
        Transparent = True
      end
      object Label24: TLabel
        Left = 8
        Top = 5
        Width = 54
        Height = 12
        Caption = #27687' '#21270' '#38209':'
        Transparent = True
      end
      object Label27: TLabel
        Left = 150
        Top = 57
        Width = 54
        Height = 12
        Caption = #21021#20957#26102#38388':'
        Transparent = True
      end
      object Label28: TLabel
        Left = 150
        Top = 83
        Width = 54
        Height = 12
        Caption = #32456#20957#26102#38388':'
        Transparent = True
      end
      object Label29: TLabel
        Left = 150
        Top = 5
        Width = 54
        Height = 12
        Caption = #27604#34920#38754#31215':'
        Transparent = True
      end
      object Label30: TLabel
        Left = 150
        Top = 109
        Width = 54
        Height = 12
        Caption = #23433' '#23450' '#24615':'
        Transparent = True
      end
      object Label31: TLabel
        Left = 8
        Top = 31
        Width = 54
        Height = 12
        Caption = #19977#27687#21270#30827':'
      end
      object Label32: TLabel
        Left = 8
        Top = 57
        Width = 54
        Height = 12
        Caption = #28903' '#22833' '#37327':'
      end
      object Label34: TLabel
        Left = 8
        Top = 160
        Width = 54
        Height = 12
        Caption = #28216' '#31163' '#38041':'
        Transparent = True
      end
      object Label38: TLabel
        Left = 150
        Top = 187
        Width = 54
        Height = 12
        Caption = #30789' '#37240' '#30416':'
        Transparent = True
      end
      object Label39: TLabel
        Left = 150
        Top = 160
        Width = 54
        Height = 12
        Caption = #38041' '#30789' '#27604':'
        Transparent = True
      end
      object Label40: TLabel
        Left = 150
        Top = 134
        Width = 54
        Height = 12
        Caption = #20445' '#27700' '#29575':'
        Transparent = True
      end
      object Label41: TLabel
        Left = 306
        Top = 5
        Width = 54
        Height = 12
        Caption = #30707#33167#31181#31867':'
        Transparent = True
      end
      object Label42: TLabel
        Left = 306
        Top = 31
        Width = 54
        Height = 12
        Caption = #30707' '#33167' '#37327':'
      end
      object Label43: TLabel
        Left = 306
        Top = 57
        Width = 54
        Height = 12
        Caption = #28151#21512#26448#31867':'
      end
      object Label44: TLabel
        Left = 306
        Top = 83
        Width = 54
        Height = 12
        Caption = #28151#21512#26448#37327':'
        Transparent = True
      end
      object Label1: TLabel
        Left = 305
        Top = 111
        Width = 54
        Height = 12
        Caption = #27700#28342#24615#38124':'
      end
      object Label2: TLabel
        Left = 295
        Top = 137
        Width = 66
        Height = 12
        Caption = #25918#23556#24615#20869#29031':'
      end
      object Label3: TLabel
        Left = 295
        Top = 163
        Width = 66
        Height = 12
        Caption = #25918#23556#24615#22806#29031':'
        Transparent = True
      end
      object Label5: TLabel
        Left = 485
        Top = 5
        Width = 60
        Height = 12
        Caption = '3'#22825#27700#21270#28909':'
        Transparent = True
      end
      object Label6: TLabel
        Left = 485
        Top = 31
        Width = 60
        Height = 12
        Caption = '7'#22825#27700#21270#28909':'
      end
      object Label7: TLabel
        Left = 443
        Top = 57
        Width = 102
        Height = 12
        Caption = #27687#21270#38048#34920#31034#30340#30897#24230':'
      end
      object Label8: TLabel
        Left = 479
        Top = 83
        Width = 66
        Height = 12
        Caption = #28216#31163#28082#21547#37327':'
        Transparent = True
      end
      object Label9: TLabel
        Left = 449
        Top = 111
        Width = 96
        Height = 12
        Caption = '38'#176'C'#24120#21387'8h'#25239#21387':'
      end
      object Label10: TLabel
        Left = 449
        Top = 137
        Width = 96
        Height = 12
        Caption = '60'#176'C'#24120#21387'8h'#25239#21387':'
      end
      object Label11: TLabel
        Left = 467
        Top = 163
        Width = 78
        Height = 12
        Caption = '15-30min'#31264#24230':'
        Transparent = True
      end
      object Label12: TLabel
        Left = 309
        Top = 187
        Width = 54
        Height = 12
        Caption = #31264#21270#26102#38388':'
        Transparent = True
      end
      object Label13: TLabel
        Left = 504
        Top = 189
        Width = 42
        Height = 12
        Caption = #27700#28784#27604':'
        Transparent = True
      end
      object Label14: TLabel
        Left = 693
        Top = 7
        Width = 66
        Height = 12
        Caption = #21161#30952#21058#31181#31867':'
      end
      object Label15: TLabel
        Left = 693
        Top = 33
        Width = 66
        Height = 12
        Caption = #21161#30952#21058#25530#37327':'
      end
      object Label16: TLabel
        Left = 705
        Top = 59
        Width = 54
        Height = 12
        Caption = #30789#37240#19977#38041':'
        Transparent = True
      end
      object Label33: TLabel
        Left = 705
        Top = 87
        Width = 54
        Height = 12
        Caption = #38109#37240#19977#38041':'
      end
      object Label35: TLabel
        Left = 621
        Top = 113
        Width = 138
        Height = 12
        Caption = #38081#38109#37240#22235#38041'+2'#20493#38109#37240#19977#38041':'
      end
      object Label36: TLabel
        Left = 693
        Top = 139
        Width = 72
        Height = 12
        Caption = '14d'#32447#33192#32960#29575':'
        Transparent = True
      end
      object Label4: TLabel
        Left = 469
        Top = 309
        Width = 72
        Height = 12
        Caption = '7'#22825#25239#21387#24378#24230':'
        Transparent = True
      end
      object Label37: TLabel
        Left = 469
        Top = 278
        Width = 72
        Height = 12
        Caption = '7'#22825#25239#25240#24378#24230':'
        Transparent = True
      end
      object Label45: TLabel
        Left = 693
        Top = 163
        Width = 66
        Height = 12
        Caption = #38081#38109#37240#22235#38041':'
        Transparent = True
      end
      object Label46: TLabel
        Left = 669
        Top = 191
        Width = 90
        Height = 12
        Caption = #26631#20934#31264#24230#29992#27700#37327':'
      end
      object Label47: TLabel
        Left = 3
        Top = 209
        Width = 60
        Height = 12
        Caption = '28d'#32784#30952#24615':'
      end
      object Label48: TLabel
        Left = 153
        Top = 211
        Width = 54
        Height = 12
        Caption = '28d'#24178#32553#29575
        Transparent = True
      end
      object Label49: TLabel
        Left = 293
        Top = 211
        Width = 72
        Height = 12
        Caption = 'C3S('#36873#25321#24615'):'
        Transparent = True
      end
      object Label50: TLabel
        Left = 472
        Top = 213
        Width = 72
        Height = 12
        Caption = 'C3A('#36873#25321#24615'):'
        Transparent = True
      end
      object cxTextEdit29: TcxTextEdit
        Left = 76
        Top = 273
        Hint = 'E.R_3DZhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 44
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit30: TcxTextEdit
        Left = 76
        Top = 298
        Hint = 'E.R_3DYa1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 47
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit31: TcxTextEdit
        Left = 316
        Top = 273
        Hint = 'E.R_28Zhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 53
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit32: TcxTextEdit
        Left = 316
        Top = 298
        Hint = 'E.R_28Ya1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 56
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit33: TcxTextEdit
        Left = 356
        Top = 273
        Hint = 'E.R_28Zhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 54
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit34: TcxTextEdit
        Left = 395
        Top = 273
        Hint = 'E.R_28Zhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 55
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit35: TcxTextEdit
        Left = 356
        Top = 298
        Hint = 'E.R_28Ya2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 57
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit36: TcxTextEdit
        Left = 395
        Top = 298
        Hint = 'E.R_28Ya3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 58
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit37: TcxTextEdit
        Left = 116
        Top = 273
        Hint = 'E.R_3DZhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 45
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit38: TcxTextEdit
        Left = 116
        Top = 298
        Hint = 'E.R_3DYa2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 48
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit39: TcxTextEdit
        Left = 156
        Top = 273
        Hint = 'E.R_3DZhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 46
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit40: TcxTextEdit
        Left = 156
        Top = 298
        Hint = 'E.R_3DYa3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 49
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit41: TcxTextEdit
        Left = 76
        Top = 315
        Hint = 'E.R_3DYa4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 50
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit42: TcxTextEdit
        Left = 116
        Top = 315
        Hint = 'E.R_3DYa5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 51
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit43: TcxTextEdit
        Left = 156
        Top = 315
        Hint = 'E.R_3DYa6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 52
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit47: TcxTextEdit
        Left = 316
        Top = 315
        Hint = 'E.R_28Ya4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 59
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit48: TcxTextEdit
        Left = 356
        Top = 315
        Hint = 'E.R_28Ya5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 60
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit49: TcxTextEdit
        Left = 395
        Top = 315
        Hint = 'E.R_28Ya6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 61
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit17: TcxTextEdit
        Left = 66
        Top = 0
        Hint = 'E.R_MgO'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 0
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit18: TcxTextEdit
        Left = 66
        Top = 180
        Hint = 'E.R_CL'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 7
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit19: TcxTextEdit
        Left = 66
        Top = 78
        Hint = 'E.R_XiDu'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 3
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit20: TcxTextEdit
        Left = 66
        Top = 130
        Hint = 'E.R_ChouDu'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 5
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit21: TcxTextEdit
        Left = 210
        Top = 26
        Hint = 'E.R_BuRong'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 10
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit22: TcxTextEdit
        Left = 66
        Top = 104
        Hint = 'E.R_Jian'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 4
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit23: TcxTextEdit
        Left = 66
        Top = 26
        Hint = 'E.R_SO3'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 1
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit24: TcxTextEdit
        Left = 66
        Top = 52
        Hint = 'E.R_ShaoShi'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 2
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit25: TcxTextEdit
        Left = 210
        Top = 104
        Hint = 'E.R_AnDing'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 13
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit26: TcxTextEdit
        Left = 210
        Top = 0
        Hint = 'E.R_BiBiao'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 9
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit27: TcxTextEdit
        Left = 210
        Top = 78
        Hint = 'E.R_ZhongNing'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 12
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit28: TcxTextEdit
        Left = 210
        Top = 52
        Hint = 'E.R_ChuNing'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 11
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit45: TcxTextEdit
        Left = 66
        Top = 155
        Hint = 'E.R_YLiGai'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 6
        OnKeyPress = cxTextEdit17KeyPress
        Width = 74
      end
      object cxTextEdit52: TcxTextEdit
        Left = 210
        Top = 182
        Hint = 'E.R_KuangWu'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 16
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit53: TcxTextEdit
        Left = 210
        Top = 155
        Hint = 'E.R_GaiGui'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 15
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit54: TcxTextEdit
        Left = 210
        Top = 129
        Hint = 'E.R_Water'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 14
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit55: TcxTextEdit
        Left = 362
        Top = 0
        Hint = 'E.R_SGType'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 18
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit56: TcxTextEdit
        Left = 362
        Top = 26
        Hint = 'E.R_SGValue'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 19
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit57: TcxTextEdit
        Left = 362
        Top = 52
        Hint = 'E.R_HHCType'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 20
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit58: TcxTextEdit
        Left = 362
        Top = 78
        Hint = 'E.R_HHCValue'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 21
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit1: TcxTextEdit
        Left = 362
        Top = 106
        Hint = 'E.R_SrxGe'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 22
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit2: TcxTextEdit
        Left = 362
        Top = 132
        Hint = 'E.R_FXNei'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 23
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit3: TcxTextEdit
        Left = 362
        Top = 158
        Hint = 'E.R_FXWai'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 24
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit5: TcxTextEdit
        Left = 544
        Top = 0
        Hint = 'E.R_3DSHR'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 27
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit6: TcxTextEdit
        Left = 544
        Top = 26
        Hint = 'E.R_7DSHR'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 28
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit7: TcxTextEdit
        Left = 544
        Top = 52
        Hint = 'E.R_NaOJD'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 29
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit8: TcxTextEdit
        Left = 544
        Top = 78
        Hint = 'E.R_YLYHL'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 30
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit9: TcxTextEdit
        Left = 544
        Top = 106
        Hint = 'E.R_38C8HKY'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 31
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit10: TcxTextEdit
        Left = 544
        Top = 132
        Hint = 'E.R_60C8HKY'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 32
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit11: TcxTextEdit
        Left = 544
        Top = 158
        Hint = 'E.R_15To30CD'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 33
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit12: TcxTextEdit
        Left = 362
        Top = 182
        Hint = 'E.R_CHTime'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 25
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit13: TcxTextEdit
        Left = 546
        Top = 184
        Hint = 'E.R_SHB'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 34
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit14: TcxTextEdit
        Left = 762
        Top = 2
        Hint = 'E.R_ZMJType'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 36
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit15: TcxTextEdit
        Left = 762
        Top = 28
        Hint = 'E.R_ZmjVal'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 37
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit16: TcxTextEdit
        Left = 762
        Top = 54
        Hint = 'E.R_GSSG'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 38
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit44: TcxTextEdit
        Left = 762
        Top = 82
        Hint = 'E.R_LSSG'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 39
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit46: TcxTextEdit
        Left = 762
        Top = 108
        Hint = 'E.R_TLS2BLS'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 40
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit50: TcxTextEdit
        Left = 762
        Top = 134
        Hint = 'E.R_4DXPZL'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 41
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit4: TcxTextEdit
        Left = 548
        Top = 273
        Hint = 'E.R_7DZhe1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 62
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit51: TcxTextEdit
        Left = 548
        Top = 298
        Hint = 'E.R_7DYa1'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 65
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit59: TcxTextEdit
        Left = 588
        Top = 273
        Hint = 'E.R_7DZhe2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 63
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit60: TcxTextEdit
        Left = 627
        Top = 273
        Hint = 'E.R_7DZhe3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 64
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit61: TcxTextEdit
        Left = 588
        Top = 298
        Hint = 'E.R_7DYa2'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 66
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit62: TcxTextEdit
        Left = 627
        Top = 298
        Hint = 'E.R_7DYa3'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 67
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit63: TcxTextEdit
        Left = 548
        Top = 315
        Hint = 'E.R_7DYa4'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bTop, bBottom]
        TabOrder = 68
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit64: TcxTextEdit
        Left = 588
        Top = 315
        Hint = 'E.R_7DYa5'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 69
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit65: TcxTextEdit
        Left = 627
        Top = 315
        Hint = 'E.R_7DYa6'
        ParentFont = False
        Properties.MaxLength = 20
        Style.Edges = [bLeft, bRight, bBottom]
        TabOrder = 70
        OnKeyPress = cxTextEdit17KeyPress
        Width = 42
      end
      object cxTextEdit66: TcxTextEdit
        Left = 762
        Top = 158
        Hint = 'E.R_TLSSG'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 42
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit67: TcxTextEdit
        Left = 762
        Top = 186
        Hint = 'E.R_BZCDYS'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 43
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit68: TcxTextEdit
        Left = 66
        Top = 204
        Hint = 'E.R_28DNM'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 8
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit69: TcxTextEdit
        Left = 210
        Top = 206
        Hint = 'E.R_28DGSL'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 17
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit70: TcxTextEdit
        Left = 362
        Top = 206
        Hint = 'E.R_C3S'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 26
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
      object cxTextEdit71: TcxTextEdit
        Left = 546
        Top = 208
        Hint = 'E.R_C3A'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 35
        OnKeyPress = cxTextEdit17KeyPress
        Width = 75
      end
    end
    object EditDate: TcxDateEdit
      Left = 81
      Top = 86
      Hint = 'E.R_Date'
      ParentFont = False
      Properties.Kind = ckDateTime
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 5
      Width = 155
    end
    object EditMan: TcxTextEdit
      Left = 287
      Top = 86
      Hint = 'E.R_Man'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 120
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
          CaptionOptions.Text = #27700#27877#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item12: TdxLayoutItem
          AlignHorz = ahClient
          CaptionOptions.Text = #25152#23646#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          CaptionOptions.Visible = False
          ButtonOptions.Buttons = <>
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item2: TdxLayoutItem
            CaptionOptions.Text = #21462#26679#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            AlignHorz = ahClient
            CaptionOptions.Text = #24405#20837#20154':'
            Control = EditMan
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AlignVert = avClient
        CaptionOptions.Text = #26816#39564#25968#25454
        ButtonOptions.Buttons = <>
        object dxLayoutControl1Item4: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'Panel1'
          CaptionOptions.Visible = False
          Control = wPanel
          ControlOptions.AutoColor = True
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

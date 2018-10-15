inherited fFormGetZhiKa: TfFormGetZhiKa
  Left = 351
  Top = 280
  Width = 786
  Height = 514
  BorderStyle = bsSizeable
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 770
    Height = 476
    inherited BtnOK: TButton
      Left = 624
      Top = 443
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 694
      Top = 443
      TabOrder = 3
    end
    object GridOrders: TcxGrid [2]
      Left = 23
      Top = 61
      Width = 250
      Height = 200
      TabOrder = 1
      object cxView1: TcxGridDBTableView
        OnDblClick = BtnOKClick
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        object cxView1Column1: TcxGridDBColumn
          Caption = #35746#21333#32534#21495
          DataBinding.FieldName = 'contractCode'
          HeaderAlignmentHorz = taCenter
          Width = 91
        end
        object cxView1Column3: TcxGridDBColumn
          Caption = #23458#25143#21517#31216
          DataBinding.FieldName = 'accountName'
          HeaderAlignmentHorz = taCenter
          Width = 177
        end
        object cxView1Column5: TcxGridDBColumn
          Caption = #20135#21697#21517#31216
          DataBinding.FieldName = 'prodName'
          HeaderAlignmentHorz = taCenter
          Width = 72
        end
        object cxView1Column7: TcxGridDBColumn
          Caption = #21253#35013#24418#24335
          DataBinding.FieldName = 'packFormName'
          HeaderAlignmentHorz = taCenter
          Width = 76
        end
        object cxView1Column8: TcxGridDBColumn
          Caption = #21333#20215
          DataBinding.FieldName = 'salePrice'
          HeaderAlignmentHorz = taCenter
          Width = 69
        end
        object cxView1Column9: TcxGridDBColumn
          Caption = #35746#21333#37327
          DataBinding.FieldName = 'reqQty'
          HeaderAlignmentHorz = taCenter
          Width = 80
        end
        object cxView1Column10: TcxGridDBColumn
          Caption = #20313#37327
          DataBinding.FieldName = 'leaveQty'
          HeaderAlignmentHorz = taCenter
          Width = 77
        end
        object cxView1Column11: TcxGridDBColumn
          Caption = #24050#25552#37327
          DataBinding.FieldName = 'pickQty'
          HeaderAlignmentHorz = taCenter
          Width = 98
        end
        object cxView1Column2: TcxGridDBColumn
          Caption = #23458#25143#32534#21495
          DataBinding.FieldName = 'accountCode'
          HeaderAlignmentHorz = taCenter
          Width = 84
        end
        object cxView1Column4: TcxGridDBColumn
          Caption = #21512#21516#31181#31867
          DataBinding.FieldName = 'contractTypeName'
          HeaderAlignmentHorz = taCenter
          Width = 87
        end
      end
      object cxLevel1: TcxGridLevel
        GridView = cxView1
      end
    end
    object EditCus: TcxButtonEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      ParentShowHint = False
      Properties.Buttons = <
        item
          Default = True
          Hint = #26597#25214
          Kind = bkEllipsis
        end
        item
          Caption = #8730
          Hint = #21047#26032
          Kind = bkText
        end>
      Properties.OnButtonClick = EditCusPropertiesButtonClick
      ShowHint = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 228
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = #35746#21333#21015#34920
        object dxLayout1Item4: TdxLayoutItem
          AlignHorz = ahLeft
          CaptionOptions.Text = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = 'cxGrid1'
          CaptionOptions.Visible = False
          Control = GridOrders
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 44
    Top = 122
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 72
    Top = 122
  end
end

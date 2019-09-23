inherited fFormSetPriceLimit: TfFormSetPriceLimit
  Caption = #26368#20302#38480#20215#35774#32622
  ClientHeight = 144
  ClientWidth = 392
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 392
    Height = 144
    inherited BtnOK: TButton
      Left = 246
      Top = 111
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 316
      Top = 111
      TabOrder = 2
    end
    object editPrice: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #26368#20302#38480#20215':'
          Control = editPrice
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

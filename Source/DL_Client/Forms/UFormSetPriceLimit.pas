unit UFormSetPriceLimit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxLayoutControl, StdCtrls, dxLayoutcxEditAdapters, cxContainer, cxEdit,
  cxTextEdit;

type
  TfFormSetPriceLimit = class(TfFormNormal)
    editPrice: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FormID: integer; override;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
  end;

var
  fFormSetPriceLimit: TfFormSetPriceLimit;

implementation

{$R *.dfm}

uses
  USysDB, USysConst, UDataModule, UMgrControl, UFormBase, ULibFun;

class function TfFormSetPriceLimit.FormID: integer;
begin
  Result := cFI_FormSetPriceLimit;
end;

procedure TfFormSetPriceLimit.FormCreate(Sender: TObject);
var
  nStr:string;
begin
  nStr := 'select D_Value from %s where D_Name=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_PriceLimit]);
  with FDM.QueryTemp(nStr) do
    editPrice.text := fieldbyname('D_Value').AsString;
end;

procedure TfFormSetPriceLimit.BtnOKClick(Sender: TObject);
var
  nStr:string;
begin
  try
    nStr := 'update %s set D_Value=%s where D_Name=''%s''';
    nStr := Format(nStr,[sTable_SysDict,editPrice.Text,sFlag_PriceLimit]);
    FDM.ExecuteSQL(nStr);
    ShowMessage('设置成功.');
    close;
  except
    ShowMessage('设置失败.');
    exit;
  end;
end;

class function TfFormSetPriceLimit.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  with TfFormSetPriceLimit.Create(Application) do
  begin
    ShowModal;
    Free;
  end;  
end;

initialization
  gControlManager.RegCtrl(TfFormSetPriceLimit, TfFormSetPriceLimit.FormID);
end.

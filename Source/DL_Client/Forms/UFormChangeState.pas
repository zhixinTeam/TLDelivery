unit UFormChangeState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxLayoutControl, StdCtrls, dxLayoutcxEditAdapters, cxContainer, cxEdit,
  cxTextEdit;

type
  TfFormChangeState = class(TfFormNormal)
    editBillNo: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    editCustomer: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    editTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    editStock: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    editState: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    editNextState: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure editBillNoKeyPress(Sender: TObject; var Key: Char);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormChangeState: TfFormChangeState;

implementation

{$R *.dfm}

{ TfFormChangeState }

uses
  USysConst, UMgrControl, USysDB, UDataModule;

class function TfFormChangeState.FormID: integer;
begin
  Result := cFI_FormChangeState;
end;

procedure TfFormChangeState.editBillNoKeyPress(Sender: TObject;
  var Key: Char);
var
  nStr: string;
begin
  nStr := Trim(editBillNo.Text);
  if nStr = '' then Exit;
  if key = #13 then
  begin
    key := #0;
    nStr := 'select * from %s where L_Id=''%s''';
    nStr := Format(nStr,[sTable_Bill,editBillNo.Text]);
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMessage('提货单不存在.');
        editBillNo.SetFocus;
        Exit;
      end;
      editCustomer.Text := FieldByName('L_CusName').asstring;
      editTruck.Text := FieldByName('L_Truck').asstring;
      editStock.Text := FieldByName('L_StockName').asstring;
      editState.Text := FieldByName('L_Status').asstring;
      editNextState.Text := FieldByName('L_NextStatus').asstring;
      BtnOK.Enabled := true;
    end;
  end;
end;

procedure TfFormChangeState.BtnOKClick(Sender: TObject);
var
  nStr: string;
begin
  if editNextState.Text = sFlag_TruckBFM then
  begin
    ShowMessage('当前状态已经是可以过毛重状态.');
    editBillNo.SetFocus;
    Exit;
  end;
  if (editState.Text <> sFlag_TruckBFM) and (editNextState.Text <> sFlag_TruckOut) then
  begin
    ShowMessage('当前状态不支持重新过毛重.');
    editBillNo.SetFocus;
    Exit;
  end;
  nStr := 'update %s set L_Status=''%s'',L_NextStatus=''%s'' where L_ID=''%s''';
  nStr := Format(nStr,[sTable_Bill,sFlag_TruckFH,sFlag_TruckBFM,editBillNo.Text]);
  try
    FDM.ExecuteSQL(nStr);
    ShowMessage('修改状态成功.');
  except
    ShowMessage('修改状态失败.');
    Exit;
  end;
  Close;
end;

class function TfFormChangeState.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  with TfFormChangeState.Create(Application) do
  begin
    ActiveControl := editBillNo;
    ShowModal;
    Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormChangeState, TfFormChangeState.FormID);
end.

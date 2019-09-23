unit UFrameOrderCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, dxLayoutControl, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxLayoutcxEditAdapters, cxTextEdit, cxMaskEdit,
  cxButtonEdit, Menus;

type
  TfFrameOrderCheck = class(TfFrameNormal)
    EditDate: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PopupMenu2: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure CheckOrder(nType,nChkRet:string);
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameOrderCheck: TfFrameOrderCheck;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl,UDataModule, UFrameBase, UFormBase, USysBusiness,
  USysConst, USysDB, UFormDateFilter, UFormInputbox, UFormCtrl;

class function TfFrameOrderCheck.FrameID: integer;
begin
  Result := cFI_FrameOrderCheck;
end;

function TfFrameOrderCheck.InitFormDataSQL(const nWhere: string): string;
begin
    EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select * From $OD od Left Join $OO oo on od.D_OID=oo.O_ID ';
  //xxxxxx

  if nWhere = '' then
       Result := Result + ' Where (D_YTime >=''$ST'' and D_YTime<''$End'') '
  else Result := Result + ' Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$OD', sTable_OrderDtl)]);

  Result := MacroValue(Result, [MI('$OD', sTable_OrderDtl),MI('$OO', sTable_Order),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameOrderCheck.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameOrderCheck.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameOrderCheck.BtnAddClick(Sender: TObject);
var
  nP:TPoint;
begin
  nP.X:= 0;
  nP.Y:= 0;
  nP:= BtnAdd.ClientToScreen(nP);
  PopupMenu1.Popup(nP.x, nP.y + btnadd.Height);
end;

procedure TfFrameOrderCheck.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFrameOrderCheck.cxButtonEdit1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  FWhere := 'D_Truck like ''%' + EditTruck.Text + '%''';
  InitFormData(FWhere);
end;

procedure TfFrameOrderCheck.N1Click(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要审核的记录', sHint); Exit;
  end;

  CheckOrder('Bmsh',sFlag_Yes);
end;

procedure TfFrameOrderCheck.CheckOrder(nType, nChkRet: string);
var nStr, nID, nField: string;
    nP: TFormCommandParam;
begin
  with nP do
  begin
    nID := SQLQuery.FieldByName('D_ID').AsString;
    nStr := Format('请填写单据[ %s ]的审核意见', [nID]);

    FCommand := cCmd_EditData;
    FParamA := nStr;
    FParamB := 320;
    FParamD := 10;

    if nType = 'Leader' then
      nField := 'D_LeaderMemo'
    else
      nField := 'D_BMMemo';

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    FParamC := 'Update %s Set %s=''$Memo'' Where R_ID=%s';
    FParamC := Format(FParamC, [sTable_OrderDtl, nField, nStr]);

    CreateBaseFormItem(cFI_FormMemo, '', @nP);
    if (FCommand <> cCmd_ModalResult) or (FParamA <> mrOK) then Exit;
  end;

  try
    if nType = 'Leader' then
      nStr := MakeSQLByStr([
              SF('D_LeaderCheck', nChkRet),
              SF('D_Leader', gSysParam.FUserName),
              SF('D_LeaderCheckTime', sField_SQLServer_Now, sfVal)
              ], sTable_OrderDtl, sF('D_ID',nID), False)
    else
      nStr := MakeSQLByStr([
              SF('D_BMCheck', nChkRet),
              SF('D_BMCheckMan', gSysParam.FUserName),
              SF('D_BMCheckTime', sField_SQLServer_Now, sfVal)
              ], sTable_OrderDtl, sF('D_ID',nID), False);

    fdm.ExecuteSQL(nStr);


    InitFormData(FWhere);
    ShowMsg('审核成功.', sHint);
  except
    ShowMsg('审核失败.', sHint);
  end;
end;

procedure TfFrameOrderCheck.N2Click(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要审核的记录', sHint); Exit;
  end;

  CheckOrder('Bmsh',sFlag_No);
end;

procedure TfFrameOrderCheck.BtnEditClick(Sender: TObject);
var
  nP:TPoint;
begin
  nP.X:= 0;
  nP.Y:= 0;
  nP:= BtnEdit.ClientToScreen(nP);
  PopupMenu2.Popup(nP.x, nP.y + BtnEdit.Height);
end;

procedure TfFrameOrderCheck.N3Click(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要审核的记录', sHint); Exit;
  end;

  CheckOrder('Leader',sFlag_Yes);
end;

procedure TfFrameOrderCheck.N4Click(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要审核的记录', sHint); Exit;
  end;

  CheckOrder('Leader',sFlag_No);
end;

initialization
  gControlManager.RegCtrl(TfFrameOrderCheck, TfFrameOrderCheck.FrameID);
end.

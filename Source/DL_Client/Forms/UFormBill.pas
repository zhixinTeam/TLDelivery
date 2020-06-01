{*******************************************************************************
  作者: dmzn@163.com 2017-09-26
  描述: 开提货单
*******************************************************************************}
unit UFormBill;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxCheckBox,
  cxMaskEdit, cxDropDownEdit, cxTextEdit, cxListView, cxMCListBox,
  dxLayoutControl, StdCtrls, cxMemo, cxLabel, cxCalendar, dxSkinsCore,
  dxSkinsDefaultPainters, dxLayoutcxEditAdapters, DB, ADODB;

type
  TfFormBill = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditLading: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    EditType: TcxComboBox;
    PrintGLF: TcxCheckBox;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item14: TdxLayoutItem;
    PrintHY: TcxCheckBox;
    dxLayout1Group3: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxDateEdit;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    editTrans: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
//    procedure chkMaxMValueClick(Sender: TObject);
  protected
    { Protected declarations }
    FMsgNo: Cardinal;
    FBuDanFlag: string;
    //补单标记
    procedure LoadFormData;
    //载入数据
  public
    { Public declarations }
    FTransList: TStrings;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, IniFiles, UMgrControl, UFormBase, UDataModule, UAdjustForm,
  UBusinessConst, USysPopedom, USysBusiness, USysDB, USysGrid, USysConst,
  UBusinessPacker, UFormWait;

var
  gBillItem: TLadingBillItem;
  //提单数据

class function TfFormBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nBool,nBuDan: Boolean;
    nDef: TLadingBillItem;
    nP: PFormCommandParam;
begin
  Result := nil;
  //if GetSysValidDate < 1 then Exit;

  nP := nil;
  try
    if not Assigned(nParam) then
    begin
      New(nP);
      FillChar(nP^, SizeOf(TFormCommandParam), #0);
    end else nP := nParam;

    nBuDan := nPopedom = 'MAIN_D04';
    FillChar(nDef, SizeOf(nDef), #0);
    nP.FParamF := @nDef;

    CreateBaseFormItem(cFI_FormGetZhika, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    gBillItem := nDef;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormBill.Create(Application) do
  try
    Caption := '开提货单';
    FMsgNo := GetTickCount;

    if nBuDan then //补单
         FBuDanFlag := sFlag_Yes
    else FBuDanFlag := sFlag_No;

    nBool := not gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    EditLading.Properties.ReadOnly := nBool;
    LoadFormData;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := gBillItem.FID
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBill.FormID: integer;
begin
  Result := cFI_FormBill;
end;

procedure TfFormBill.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(Name, 'FQLabel', '');

    PrintHY.Checked := False;
    //随车开单
    LoadMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;

  {$IFDEF PrintGLF}
  dxLayout1Item13.Visible := True;
  {$ELSE}
  dxLayout1Item13.Visible := False;
  PrintGLF.Checked := False;
  {$ENDIF}

  {$IFDEF PrintHYEach}
  dxLayout1Item14.Visible := True;
  {$ELSE}
  dxLayout1Item14.Visible := False;
  PrintHY.Checked := False;
  {$ENDIF}

//  chkMaxMValue.OnClick(nil);

  AdjustCtrlData(Self);

  FTransList := TStringList.Create;
  nStr := 'select * from MDM.MDM_Account where flag=''COMMIT'' and acctypecode like ''%TRA%''';
  with FDM.QueryTemp(nStr, True) do
  begin
    First;
    while not Eof do
    begin
      FTransList.Add(FieldByName('accountcode').AsString);
      editTrans.Properties.Items.Add(FieldByName('accountname').AsString);
      Next;
    end;
  end;
end;

procedure TfFormBill.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteBool(Name, 'PrintHY', PrintHY.Checked);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
end;

//Desc: 回车键
procedure TfFormBill.EditLadingKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditTruck then ActiveControl := EditValue else
    //xxxxx

    if Sender = EditValue then
         ActiveControl := BtnOK
    else Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  if (Sender = EditTruck) and (Key = Char(VK_SPACE)) then
  begin
    Key := #0;
    {$IFDEF GetTruckNoFromERP}
    nP.FParamA := gBillItem.FZhiKa;
    CreateBaseFormItem(cFI_FormGetWTTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
    begin
      EditTruck.Text := nP.FParamB;
      EditValue.Text := nP.FParamC;
      EditWT.Text    := nP.FParamD;
    end;
    {$ELSE}
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
    begin
      EditTruck.Text := nP.FParamB;
//      EditPhone.Text := nP.FParamD;
    end;
    {$ENDIF}

    EditTruck.SelectAll;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入界面数据
procedure TfFormBill.LoadFormData;
var nStr: string;
begin
  dxGroup1.AlignVert := avClient;
  dxGroup2.AlignVert := avBottom;

  EditDate.Date := Now();
  dxLayout1Item15.Visible := FBuDanFlag = sFlag_Yes;

  ActiveControl := EditTruck;

  with gBillItem,ListInfo do
  begin
    Clear;
    Items.Add(Format('订单编号:%s %s', [Delimiter, FZhiKa]));

    //Items.Add(Format('%s ', [Delimiter]));
    Items.Add(Format('客户编号:%s %s', [Delimiter, FCusID]));
    Items.Add(Format('客户名称:%s %s', [Delimiter, FCusName]));

    Items.Add(Format('%s ', [Delimiter]));
    Items.Add(Format('物料编号:%s %s', [Delimiter, FStockNo]));
    Items.Add(Format('物料名称:%s %s', [Delimiter, FStockName]));

    //if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';
    Items.Add(Format('包装类型:%s %s', [Delimiter, FType]));
    Items.Add(Format('单价:%s %.2f', [Delimiter, FPrice]));
    Items.Add(Format('合同余量:%s %.2f吨', [Delimiter, FValue]));
  end;
end;

function TfFormBill.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

//  if Sender = EditMaxMValue then
//  begin
//    if chkMaxMValue.Checked then
//    begin
//      Result := IsNumber(EditMaxMValue.Text, True)
//                and (StrToFloat(EditMaxMValue.Text)>StrToFloat(EditValue.Text));
//      nHint := '请填写有效的毛重限值';
//    end;
//  end else

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '车牌号长度应大于2位';
  end else

  if Sender = EditLading then
  begin
    Result := EditLading.ItemIndex > -1;
    nHint := '请选择提货方式';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and
             (StrToFloat(EditValue.Text) > 0) and
             (StrToFloat(EditValue.Text) <= gBillItem.FValue);
    nHint := '请填写有效的办理量';
    if not Result then Exit;
  end;
end;

//Desc: 保存
procedure TfFormBill.BtnOKClick(Sender: TObject);
var nPrint: Boolean;
    nList, nStocks, nTmp: TStrings;
    nHint,nStr: string;
begin
  if not OnVerifyCtrl(EditTruck, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;
  if not OnVerifyCtrl(EditLading, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;
  if not OnVerifyCtrl(EditValue, nHint) then
  begin
    ShowMsg(nHint,sHint);
    Exit;
  end;

  nStr := 'select * from %s where C_Id=''%s''';
  nStr := Format(nStr,[sTable_Customer,gBillItem.FCusID]);
  with FDM.QueryTemp(nStr) do
    if recordcount < 1 then
    begin
      ShowMsg('客户档案没有该客户,请先同步客户.',sHint);
      Exit;
    end;

  nStocks := TStringList.Create;
  nList := TStringList.Create;
  nTmp := TStringList.Create;
  try
    nList.Clear;
    nPrint := False;
    LoadSysDictItem(sFlag_PrintBill, nStocks);

    with nTmp,gBillItem do
    begin
      if Pos('袋',FType) >0 then
      begin
        Values['Type'] := sFlag_Dai;
        Values['StockNO'] := FStockNO + sFlag_Dai;
      end
      else
      begin
        Values['Type'] := sFlag_San;
        Values['StockNO'] := FStockNO + sFlag_San;
      end;        

      Values['StockName'] := FStockName;
      Values['Price'] := FloatToStr(FPrice);
      Values['Value'] := EditValue.text;

      if PrintGLF.Checked  then
           Values['PrintGLF'] := sFlag_Yes
      else Values['PrintGLF'] := sFlag_No;

      if PrintHY.Checked  then
           Values['PrintHY'] := sFlag_Yes
      else Values['PrintHY'] := sFlag_No;


      nList.Add(PackerEncodeStr(nTmp.Text));
      //new bill

      if (not nPrint) and (FBuDanFlag <> sFlag_Yes) then
        nPrint := nStocks.IndexOf(FStockNO) >= 0;
      //xxxxx
    end;
    with nList do
    begin
      Values['Bills'] := PackerEncodeStr(nList.Text);
      Values['ZhiKa'] := gBillItem.FZhiKa;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := GetCtrlData(EditLading);
      Values['IsVIP'] := GetCtrlData(EditType);
      Values['BuDan'] := FBuDanFlag;
      Values['OrderNo'] := gBillItem.FFactory; //itemcode

      Values['Lading']       := GetCtrlData(EditLading);
      Values['IsVIP']        := GetCtrlData(EditType);
      Values['BuDan']        := FBuDanFlag;

      Values['CusID'] := gBillItem.FCusID;
      Values['CusName'] := gBillItem.FCusName;

      if editTrans.ItemIndex <> -1 then
      begin
        Values['TransCode'] := FTransList.strings[editTrans.ItemIndex];
        Values['TransName'] := editTrans.Text;
      end;
    end;

    BtnOK.Enabled := False;
    try
      ShowWaitForm(Self, '正在保存', True);
      gBillItem.FID := SaveBill(PackerEncodeStr(nList.Text));
    finally
      BtnOK.Enabled := True;
      CloseWaitForm;
    end;
    //call mit bus
    if gBillItem.FID = '' then Exit;
    //save failed
  finally
    nList.Free;
    nStocks.Free;
  end;

  if FBuDanFlag <> sFlag_Yes then
    SetBillCard(gBillItem.FID, EditTruck.Text, True);
  //办理磁卡

  if nPrint then
    PrintBillReport(gBillItem.FID, True);
  //print report

  ModalResult := mrOk;
  ShowMsg('提货单保存成功', sHint);
end;

//procedure TfFormBill.chkMaxMValueClick(Sender: TObject);
//begin
//  if chkMaxMValue.Checked then
//    dxLayout1Item5.Visible := True
//  else
//    dxLayout1Item5.Visible := False;
//end;

initialization
  gControlManager.RegCtrl(TfFormBill, TfFormBill.FormID);
end.

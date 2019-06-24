{*******************************************************************************
  作者: juner11212436@163.com 2017-12-28
  描述: 自助办卡窗口--单厂版
*******************************************************************************}
unit uZXNewCard;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, Menus, StdCtrls, cxButtons, cxGroupBox,
  cxRadioGroup, cxTextEdit, cxCheckBox, ExtCtrls, dxLayoutcxEditAdapters,
  dxLayoutControl, cxDropDownEdit, cxMaskEdit, cxButtonEdit,
  USysConst, cxListBox, ComCtrls,Contnrs,UFormCtrl,
  dxSkinsCore, dxSkinsDefaultPainters, DB, ADODB;

type

  TfFormNewCard = class(TForm)
    editWebOrderNo: TcxTextEdit;
    labelIdCard: TcxLabel;
    btnQuery: TcxButton;
    PanelTop: TPanel;
    PanelBody: TPanel;
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditValue: TcxTextEdit;
    EditCus: TcxTextEdit;
    EditCName: TcxTextEdit;
    EditStock: TcxTextEdit;
    EditSName: TcxTextEdit;
    EditTruck: TcxButtonEdit;
    EditType: TcxComboBox;
    EditPrice: TcxButtonEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxlytmLayout1Item3: TdxLayoutItem;
    dxlytmLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxlytmLayout1Item9: TdxLayoutItem;
    dxlytmLayout1Item10: TdxLayoutItem;
    dxGroupLayout1Group5: TdxLayoutGroup;
    dxlytmLayout1Item13: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxGroupLayout1Group6: TdxLayoutGroup;
    dxlytmLayout1Item12: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    dxLayoutGroup3: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    pnlMiddle: TPanel;
    cxLabel1: TcxLabel;
    lvOrders: TListView;
    Label1: TLabel;
    btnClear: TcxButton;
    TimerAutoClose: TTimer;
    dxLayout1Group2: TdxLayoutGroup;
    PrintHY: TcxCheckBox;
    ADOQuery1: TADOQuery;
    Button1: TButton;
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure lvOrdersClick(Sender: TObject);
    procedure editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
    procedure btnClearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FAutoClose:Integer; //窗口自动关闭倒计时（分钟）
    FWebOrderIndex:Integer; //商城订单索引
    FWebOrderItems:array of stMallOrderItem; //商城订单数组
    FCardData:TStrings; //云天系统返回的大票号信息
    Fbegin:TDateTime;
    procedure InitListView;
    procedure SetControlsReadOnly;
    function DownloadOrder(const nCard:string):Boolean;
    procedure Writelog(nMsg:string);
    procedure AddListViewItem(var nWebOrderItem:stMallOrderItem);
    procedure LoadSingleOrder;
    function IsRepeatCard(const nWebOrderItem:string):Boolean;
    function VerifyCtrl(Sender: TObject; var nHint: string): Boolean;
    function SaveBillProxy:Boolean;
    function SaveWebOrderMatch(const nBillID,nWebOrderID,nBillType:string):Boolean;
  public
    { Public declarations }
    procedure SetControlsClear;
    //property SzttceApi:TSzttceApi read FSzttceApi write FSzttceApi;
  end;

var
  fFormNewCard: TfFormNewCard;

implementation
uses
  ULibFun,UBusinessPacker,USysLoger,UBusinessConst,UFormMain,USysBusiness,USysDB,
  UAdjustForm,UFormBase,UDataReport,UDataModule,NativeXml,UFormWait, UMgrTTCEDispenser,
  DateUtils;
{$R *.dfm}

{ TfFormNewCard }

procedure TfFormNewCard.SetControlsClear;
var
  i:Integer;
  nComp:TComponent;
begin
  editWebOrderNo.Clear;
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Clear;
    end;
  end;
end;
procedure TfFormNewCard.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormNewCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FCardData.Free;
  Action:=  caFree;
  fFormNewCard := nil;
end;

procedure TfFormNewCard.FormShow(Sender: TObject);
begin
  SetControlsReadOnly;
  dxlytmLayout1Item13.Visible := False;
  EditTruck.Properties.Buttons[0].Visible := False;
  ActiveControl := editWebOrderNo;
  btnOK.Enabled := False;
  FAutoClose := gSysParam.FAutoClose_Mintue;
  TimerAutoClose.Interval := 60*1000;
  TimerAutoClose.Enabled := True;
  EditPrice.Properties.Buttons[0].Visible := False;
  dxLayout1Item11.Visible := False;
  {$IFDEF PrintHYEach}
  PrintHY.Checked := True;
  PrintHY.Enabled := False;
  {$ELSE}
  PrintHY.Checked := False;
  PrintHY.Enabled := True;
  {$ENDIF}
end;

procedure TfFormNewCard.SetControlsReadOnly;
var
  i:Integer;
  nComp:TComponent;
begin
  for i := 0 to dxLayout1.ComponentCount-1 do
  begin
    nComp := dxLayout1.Components[i];
    if nComp is TcxTextEdit then
    begin
      TcxTextEdit(nComp).Properties.ReadOnly := True;
    end;
  end;
  EditPrice.Properties.ReadOnly := True;
end;

procedure TfFormNewCard.TimerAutoCloseTimer(Sender: TObject);
begin
  if FAutoClose=0 then
  begin
    TimerAutoClose.Enabled := False;
    Close;
  end;
  Dec(FAutoClose);
end;

procedure TfFormNewCard.btnQueryClick(Sender: TObject);
var
  nCardNo,nStr:string;
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  btnQuery.Enabled := False;
  editWebOrderNo.SelectAll;
  try
    nCardNo := Trim(editWebOrderNo.Text);
    if nCardNo='' then
    begin
      nStr := '请先输入或扫描订单号';
      ShowMsg(nStr,sHint);
      Writelog(nStr);
      Exit;
    end;
    ShowWaitForm('正在连接云平台读取信息...');
    lvOrders.Items.Clear;
    if not DownloadOrder(nCardNo) then Exit;
    btnOK.Enabled := True;
  finally
    btnQuery.Enabled := True;
    ShowWaitForm('',False);
  end;
end;

function TfFormNewCard.DownloadOrder(const nCard: string): Boolean;
var
  nXmlStr,nData:string;
  nListA,nListB:TStringList;
  i:Integer;
  nWebOrderCount:Integer;
begin
  Result := False;
  FWebOrderIndex := 0;

  nXmlStr := PackerEncodeStr(nCard);

  FBegin := Now;
  nData := get_shoporderbyno(nXmlStr);
  if nData='' then
  begin
    ShowMsg('未查询到网上商城订单详细信息，请检查订单号是否正确',sHint);
    Writelog('未查询到网上商城订单详细信息，请检查订单号是否正确');
    Exit;
  end;
  Writelog('TfFormNewCard.DownloadOrder(nCard='''+nCard+''') 查询商城订单-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  //解析网城订单信息
  Writelog('get_shoporderbyno res:'+nData);
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := nData;

    nWebOrderCount := nListA.Count;
    SetLength(FWebOrderItems,nWebOrderCount);
    for i := 0 to nWebOrderCount-1 do
    begin
      nListB.Text := PackerDecodeStr(nListA.Strings[i]);
      FWebOrderItems[i].FOrder_id := nListB.Values['order_id'];
      FWebOrderItems[i].FOrdernumber := nListB.Values['ordernumber'];
      FWebOrderItems[i].FGoodsID := nListB.Values['goodsID'];
      FWebOrderItems[i].FGoodstype := nListB.Values['goodstype'];
      FWebOrderItems[i].FGoodsname := nListB.Values['goodsname'];
      FWebOrderItems[i].FData := nListB.Values['data'];
      FWebOrderItems[i].Ftracknumber := nListB.Values['tracknumber'];
      FWebOrderItems[i].FYunTianOrderId := nListB.Values['fac_order_no'];
      AddListViewItem(FWebOrderItems[i]);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;
  LoadSingleOrder;
end;

procedure TfFormNewCard.Writelog(nMsg: string);
var
  nStr:string;
begin
  nStr := 'weborder[%s]clientid[%s]clientname[%s]sotckno[%s]stockname[%s]';
  nStr := Format(nStr,[editWebOrderNo.Text,EditCus.Text,EditCName.Text,EditStock.Text,EditSName.Text]);
  gSysLoger.AddLog(nStr+nMsg);
end;

procedure TfFormNewCard.AddListViewItem(
  var nWebOrderItem: stMallOrderItem);
var
  nListItem:TListItem;
begin
  nListItem := lvOrders.Items.Add;
  nlistitem.Caption := nWebOrderItem.FOrdernumber;

  nlistitem.SubItems.Add(nWebOrderItem.FGoodsID);
  nlistitem.SubItems.Add(nWebOrderItem.FGoodsname);
  nlistitem.SubItems.Add(nWebOrderItem.Ftracknumber);
  nlistitem.SubItems.Add(nWebOrderItem.FData);
  nlistitem.SubItems.Add(nWebOrderItem.FYunTianOrderId);
end;

procedure TfFormNewCard.InitListView;
var
  col:TListColumn;
begin
  lvOrders.ViewStyle := vsReport;
  col := lvOrders.Columns.Add;
  col.Caption := '网上订单编号';
  col.Width := 300;
  col := lvOrders.Columns.Add;
  col.Caption := '水泥型号';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '水泥名称';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '提货车辆';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '办理吨数';
  col.Width := 150;
  col := lvOrders.Columns.Add;
  col.Caption := '订单编号';
  col.Width := 250;
end;

procedure TfFormNewCard.FormCreate(Sender: TObject);
begin
  editWebOrderNo.Properties.MaxLength := gSysParam.FWebOrderLength;
  FCardData := TStringList.Create;
  if not Assigned(FDR) then
  begin
    FDR := TFDR.Create(Application);
  end;
  InitListView;
  gSysParam.FUserID := 'AICM';
end;

procedure TfFormNewCard.LoadSingleOrder;
var
  nOrderItem:stMallOrderItem;
  nRepeat:Boolean;
  nWebOrderID, nType, nStockNo:string;
  nMsg,nStr:string;
  nPriceNow, nPriceGP, nZXFD, nPriceZX, nValue: Double;
  nPreFun, nSql, nAddOrDec : string;
begin
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := nOrderItem.FOrdernumber;

  FBegin := Now;
  nRepeat := IsRepeatCard(nWebOrderID);

  if nRepeat then
  begin
    nMsg := '此订单已成功办卡，请勿重复操作';
    ShowMsg(nMsg,sHint);
    Writelog(nMsg);
    Exit;
  end;
  writelog('TfFormNewCard.LoadSingleOrder 检查商城订单是否重复使用-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');

  //填充界面信息

  //基本信息
  EditCus.Text    := '';
  EditCName.Text  := '';

  nStockNo := Copy(nOrderItem.FGoodsID,1,Length(nOrderItem.FGoodsID)-1);
  nType := Copy(nOrderItem.FGoodsID,Length(nOrderItem.FGoodsID),1);

  if nType ='D' then
  begin
    if nStockNo = '0101010022' then
      nType := '007'
    else
      nType := '001';
  end
  else
  begin
    if nStockNo = '0101010022' then
      nType := '008'
    else if nStockNo = '02010001' then
      nType := '003'
    else
      nType := '002';
  end;

  //根据erp订单量限制开单
  nStr := 'select SUM(L_Value) from %s where L_ZhiKa=''%s'' and '+
          'L_StockNo=''%s'' and L_OutFact is null';
  nStr := Format(nStr,[sTable_Bill,nOrderItem.FYunTianOrderId,EditStock.Text+nType]);
  with fdm.QueryTemp(nStr) do
    nValue := Fields[0].AsFloat;
  //冻结量


  nStr := 'select accountCode,salePrice,accountName,realProj,reqQty-pickQty as leaveQty from sal.SAL_Contract_v where '+
          ' contractCode=''%s'' and prodCode=''%s'' and packForm=''%s'' and enableFlag=''Y''';
  nStr := Format(nStr,[nOrderItem.FYunTianOrderId,nStockNo,nType]);
  FDM.QueryData(ADOQuery1, nStr, True);
  with adoquery1 do
  begin
    if recordcount = 0 then
    begin
      nStr := '订单['+nOrderItem.FYunTianOrderId+'],品种['+nStockNo+
              '],类型['+nType+']在RRP中已关闭或者删除.';
      ShowMessage(nStr);
      writelog(nStr);
      Exit;
    end;
    if RecordCount > 0 then
    begin
      EditCus.Text    := Fields[0].AsString;
      EditCName.Text  := Fields[2].AsString;
    end;

    nValue := FieldByName('leaveQty').AsFloat - nValue;

    if nValue < StrToFloat(nOrderItem.FData) then
    begin
      nStr := '订单['+nOrderItem.FYunTianOrderId+'],品种['+nStockNo+
              '],类型['+nType+']RRP订单剩余量不够开单.';
      ShowMessage(nStr);
      writelog(nStr);
      Exit;
    end;

    nPriceNow := FieldByName('salePrice').AsFloat;
    nPreFun := FieldByName('realProj').AsString;

    nSql := 'select *,GETDATE() as dtNow from SAL.SAL_ProdPrice_v '+
          'where priceStat=''1'' and prodCode=''%s'' and packCode=''%s''';
    nSql := Format(nSql,[nStockNo,nType]);
  end;

  with FDM.QueryTemp(nSql, True) do
  begin
    if recordcount < 1 then
    begin
      showmessage('没有可用的挂牌价.');
      Exit;
    end;

    if (FieldByName('dtNow').AsDateTime >= FieldByName('enaBeginDate').AsDateTime)
      and (FieldByName('dtNow').AsDateTime < FieldByName('enaEndDate').AsDateTime) then
    begin
      nPriceGP := FieldByName('prodPrice').AsFloat;
      nAddOrDec := Copy(nPreFun,2,1);
      nZXFD := StrToFloat(Copy(nPreFun,3,Length(nPreFun)-2));
      if nAddOrDec = '-' then
        nPriceZX := nPriceGP - nZXFD
      else
        nPriceZX := nPriceGP + nZXFD;
    end
    else
    begin
      showmessage('挂牌价过期.');
      Exit;
    end;
  end;

  //如果当前合同价不等于最终执行价，修改合同价格
  if nPriceZX <> nPriceNow then
  begin
    nsql := 'update SAL.SAL_CTRItem set salePrice=''%s'' where contractCode=''%s'''+
            ' and prodCode=''%s'' and packForm=''%s''';
    nSql := Format(nSql,[FloatToStr(nPriceZX),nOrderItem.FYunTianOrderId, nStockNo,nType]);
    try
      fdm.ExecuteSQL(nSql,True);
    except
      ShowMessage('调整价格失败请新开单.');
      Exit;
    end;
  end;

  //提单信息
  EditType.ItemIndex := 0;
  EditStock.Text  := nOrderItem.FGoodsID;
  EditSName.Text  := nOrderItem.FGoodsname;
  EditValue.Text := nOrderItem.FData;
  EditTruck.Text := nOrderItem.Ftracknumber;
  EditPrice.Text  := FloatToStr(nPriceZX);

  BtnOK.Enabled := not nRepeat;
end;

function TfFormNewCard.IsRepeatCard(const nWebOrderItem: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'select * from %s where WOM_WebOrderID=''%s''';
  nStr := Format(nStr,[sTable_WebOrderMatch,nWebOrderItem]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount>0 then
    begin
      Result := True;
    end;
  end;
end;

function TfFormNewCard.VerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 3;
    if not Result then
    begin
      nHint := '车牌号长度应大于3位';
      Writelog(nHint);
      Exit;
    end;
  end;
  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    if not Result then
    begin
      nHint := '请填写有效的办理量';
      Writelog(nHint);
      Exit;
    end;
  end;
end;

procedure TfFormNewCard.BtnOKClick(Sender: TObject);
begin
  BtnOK.Enabled := False;
  try
    if not SaveBillProxy then
    begin
      BtnOK.Enabled := True;
      Exit;
    end;
    Close;
  except
  end;
end;

function TfFormNewCard.SaveBillProxy: Boolean;
var
  nHint:string;
  nList,nTmp,nStocks: TStrings;
  nPrint,nInFact:Boolean;
  nBillData:string;
  nBillID :string;
  nWebOrderID:string;
  nNewCardNo, nTruck, nStr, nType:string;
  nidx:Integer;
  i:Integer;
  nRet: Boolean;
  nOrderItem:stMallOrderItem;
  nValue: Double;
begin
  Result := False;
  nOrderItem := FWebOrderItems[FWebOrderIndex];
  nWebOrderID := editWebOrderNo.Text;

  if Trim(EditValue.Text) = '' then
  begin
    ShowMsg('获取物料价格异常！请联系管理员',sHint);
    Writelog('获取物料价格异常！请联系管理员');
    Exit;
  end;

  if not VerifyCtrl(EditTruck,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  {$IFDEF ForceEleCard}
  if not IsEleCardVaid(EditTruck.Text) then
  begin
    ShowMsg('车辆未办理电子标签或电子标签未启用！请联系管理员', sHint);
    Exit;
  end;
  {$ENDIF}

  if not VerifyCtrl(EditValue,nHint) then
  begin
    ShowMsg(nHint,sHint);
    Writelog(nHint);
    Exit;
  end;

  if IFHasBill(EditTruck.Text) then
  begin
    ShowMsg('车辆存在未完成的提货单,无法开单,请联系管理员',sHint);
    Exit;
  end;

  //验证GPS信息
  nTruck := EditTruck.Text+'%';
  if (Pos('熟料',EditSName.Text) =0) and (Pos('石灰石',EditSName.Text) =0) then
    if not GetGpsByTruck(nTruck,gSysParam.FGPSFactID,gSysParam.FGPSValidTime) then
    begin
      AddManualEventRecord(editWebOrderNo.Text,EditTruck.Text,nTruck,'自助机',
                          sFlag_Solution_OK, sFlag_DepDaTing, True);
      ShowMessage(nTruck);
      Exit;
    end;

  for nIdx:=0 to 3 do
  begin
    nNewCardNo := gDispenserManager.GetCardNo(gSysParam.FTTCEK720ID, nHint, False);
    if nNewCardNo <> '' then
      Break;
    Sleep(500);
  end;
  //连续三次读卡,成功则退出。

  if nNewCardNo = '' then
  begin
    nHint := '卡箱异常,请查看是否有卡.';
    ShowMsg(nHint, sWarn);
    Exit;
  end;

  WriteLog('读取到卡片: ' + nNewCardNo);
  //解析卡片
  if not IsCardValid(nNewCardNo) then
  begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);
    nHint := '卡号' + nNewCardNo + '非法,回收中,请稍后重新取卡';
    WriteLog(nHint);
    ShowMsg(nHint, sWarn);
    Exit;
  end;


  //保存提货单
  nStocks := TStringList.Create;
  nList := TStringList.Create;
  nTmp := TStringList.Create;
  try
    LoadSysDictItem(sFlag_PrintBill, nStocks);
    if Pos('散',EditSName.Text) > 0 then
      nTmp.Values['Type'] := 'S'
    else
      nTmp.Values['Type'] := 'D';
      
    nTmp.Values['StockNO'] := EditStock.Text;
    //nTmp.Values['StockName'] := EditSName.Text;
    nTmp.Values['StockName'] := copy(EditSName.Text,1,Length(EditSName.Text)-4);//EditSName.Text;
    nTmp.Values['Price'] := EditPrice.Text;
    nTmp.Values['Value'] := EditValue.Text;

    if PrintHY.Checked  then
         nTmp.Values['PrintHY'] := sFlag_Yes
    else nTmp.Values['PrintHY'] := sFlag_No;

    nList.Add(PackerEncodeStr(nTmp.Text));
    nPrint := nStocks.IndexOf(EditStock.Text) >= 0;

    with nList do
    begin
      Values['Bills'] := PackerEncodeStr(nList.Text);
      Values['ZhiKa'] := nOrderItem.FYunTianOrderId;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := sFlag_TiHuo;
      Values['Memo']  := EmptyStr;
      Values['IsVIP'] := Copy(GetCtrlData(EditType),1,1);
      Values['Seal'] := '';
      Values['HYDan'] := '';
      Values['WebOrderID'] := nWebOrderID;
    end;
    nBillData := PackerEncodeStr(nList.Text);
    FBegin := Now;
    nBillID := SaveBill(nBillData);
    if nBillID = '' then
    begin
      nHint := '保存提货单失败';
      ShowMsg(nHint,sError);
      Writelog(nHint);
      Exit;
    end;
    writelog('TfFormNewCard.SaveBillProxy 生成提货单['+nBillID+']-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
    FBegin := Now;
    SaveWebOrderMatch(nBillID,nWebOrderID,sFlag_Sale);
    writelog('TfFormNewCard.SaveBillProxy 保存商城订单号-耗时：'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  finally
    nStocks.Free;
    nList.Free;
    nTmp.Free;
  end;

  ShowMsg('提货单保存成功', sHint);

  //发卡2019-05-20
  if not SaveBillCard(nBillID,nNewCardNo) then
  begin
    nHint := '卡号[ %s ]关联订单失败,请到开票窗口重新关联磁卡.';
    nHint := Format(nHint, [nNewCardNo]);

    WriteLog(nHint);
    ShowMsg(nHint,sWarn);
  end
  else begin
    if not gDispenserManager.SendCardOut(gSysParam.FTTCEK720ID, nHint) then
      ShowMessage('出卡失败,请联系管理员将磁卡取出.')
    else
      ShowMsg('发卡成功,卡号['+nNewCardNo+'],请收好您的卡片',sHint);
  end;

  Result := True;
  if nPrint then
    PrintBillReport(nBillID, True);
  //print report
end;

function TfFormNewCard.SaveWebOrderMatch(const nBillID,
  nWebOrderID,nBillType: string):Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := MakeSQLByStr([
  SF('WOM_WebOrderID'   , nWebOrderID),
  SF('WOM_LID'          , nBillID),
  SF('WOM_StatusType'   , c_WeChatStatusCreateCard),
  SF('WOM_MsgType'      , cSendWeChatMsgType_AddBill),
  SF('WOM_BillType'     , nBillType),
  SF('WOM_deleted'     , sFlag_No)
  ], sTable_WebOrderMatch, '', True);
  fdm.ADOConn.BeginTrans;
  try
    fdm.ExecuteSQL(nStr);
    fdm.ADOConn.CommitTrans;
    Result := True;
  except
    fdm.ADOConn.RollbackTrans;
  end;
end;
procedure TfFormNewCard.lvOrdersClick(Sender: TObject);
var
  nSelItem:TListItem;
  i:Integer;
begin
  nSelItem := lvorders.Selected;
  if Assigned(nSelItem) then
  begin
    for i := 0 to lvOrders.Items.Count-1 do
    begin
      if nSelItem = lvOrders.Items[i] then
      begin
        FWebOrderIndex := i;
        LoadSingleOrder;
        Break;
      end;
    end;
  end;
end;

procedure TfFormNewCard.editWebOrderNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  if Key=Char(vk_return) then
  begin
    key := #0;
    btnQuery.SetFocus;
    btnQuery.Click;
  end;
end;

procedure TfFormNewCard.btnClearClick(Sender: TObject);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  editWebOrderNo.Clear;
  ActiveControl := editWebOrderNo;
end;

procedure TfFormNewCard.Button1Click(Sender: TObject);
var
  nTruck:string;
begin
  nTruck := editWebOrderNo.Text+'%';
  if not GetGpsByTruck(nTruck,gSysParam.FGPSFactID,gSysParam.FGPSValidTime) then
  begin
    ShowMessage(nTruck);
    Exit;
  end
  else
  ShowMessage('成功.');
end;

end.

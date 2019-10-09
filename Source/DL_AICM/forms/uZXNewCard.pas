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
    Button2: TButton;
    editTrans: TcxComboBox;
    dxLayout1Item1: TdxLayoutItem;
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
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FAutoClose:Integer; //窗口自动关闭倒计时（分钟）
    FWebOrderIndex:Integer; //商城订单索引
    FWebOrderItems:array of stMallOrderItem; //商城订单数组
    FCardData:TStrings; //云天系统返回的大票号信息
    Fbegin:TDateTime;
    FTransList :TStrings;
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
  FTransList.Free;
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
  nListA,nListB,nListC:TStringList;
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
  {$IFDEF UseWXServiceEx}
    nListA := TStringList.Create;
    nListB := TStringList.Create;
    nListC := TStringList.Create;
    try
      nListA.Text := PackerDecodeStr(nData);

      nListB.Text := PackerDecodeStr(nListA.Values['details']);
      nWebOrderCount := nListB.Count;
      SetLength(FWebOrderItems,nWebOrderCount);
      for i := 0 to nWebOrderCount-1 do
      begin
        nListC.Text := PackerDecodeStr(nListB[i]);

        FWebOrderItems[i].FOrder_id     := nListA.Values['orderId'];
        FWebOrderItems[i].FOrdernumber  := nListA.Values['orderNo'];
        FWebOrderItems[i].Ftracknumber  := nListA.Values['licensePlate'];
        FWebOrderItems[i].FfactoryName  := nListA.Values['factoryName'];
        FWebOrderItems[i].FdriverId     := nListA.Values['driverId'];
        FWebOrderItems[i].FdrvName      := nListA.Values['drvName'];
        FWebOrderItems[i].FdrvPhone     := nListA.Values['FdrvPhone'];
        FWebOrderItems[i].FType         := nListA.Values['type'];
        FWebOrderItems[i].FXHSpot       := nListA.Values['orderRemark'];
        FWebOrderItems[i].FPrice        := '';
        with nListC do
        begin
          FWebOrderItems[i].FCusID          := Values['clientNo'];
          FWebOrderItems[i].FCusName        := Values['clientName'];
          FWebOrderItems[i].FGoodsID        := Values['materielNo'];
          FWebOrderItems[i].FGoodstype      := Values['orderDetailType'];
          FWebOrderItems[i].FGoodsname      := Values['materielName'];
          FWebOrderItems[i].FData           := Values['quantity'];
          FWebOrderItems[i].ForderDetailType:= Values['orderDetailType'];
          FWebOrderItems[i].FYunTianOrderId := Values['contractNo'];
          FWebOrderItems[i].FStatus         := Values['status'];
          AddListViewItem(FWebOrderItems[i]);
        end;
      end;
    finally
      nListC.Free;
      nListB.Free;
      nListA.Free;
    end;
  {$ELSE}
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
      {$IFDEF YHTL}
      FWebOrderItems[i].FGoodsID := nListB.Values['goodsID'];
      {$ELSE}
      FWebOrderItems[i].FGoodsID := nListB.Values['goodsID'];
      {$ENDIF}
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
  {$ENDIF}
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
var
  nStr: string;
begin
  editWebOrderNo.Properties.MaxLength := gSysParam.FWebOrderLength;
  FCardData := TStringList.Create;
  if not Assigned(FDR) then
  begin
    FDR := TFDR.Create(Application);
  end;
  InitListView;
  gSysParam.FUserID := 'AICM';
  
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
  {$IFNDEF YHTL}
  dxLayout1Item1.Visible := False;
  {$ENDIF}
end;

procedure TfFormNewCard.LoadSingleOrder;
var
  nOrderItem:stMallOrderItem;
  nRepeat, nIsSale:Boolean;
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

  {$IFDEF UseWXServiceEx}
  if Pos('销售',nOrderItem.FType) > 0 then
    nIsSale := True
  else
    nIsSale := False;

  if not nIsSale then
  begin
    nMsg := '此订单不是销售订单！';
    ShowMsg(nMsg,sHint);
    Writelog(nMsg);
    Exit;
  end;

  if nOrderItem.FStatus <> '1' then
  begin
    if nOrderItem.FStatus = '0' then
      nMsg := '此订单状态未知'
    else if nOrderItem.FStatus = '6' then
      nMsg := '此订单已取消'
    else if nOrderItem.FStatus = '7' then
      nMsg := '此订单已过期'
    else
      nMsg := '此订单已使用';
    ShowMsg(nMsg,sHint);
    Writelog(nMsg+nOrderItem.FStatus);
    Exit;
  end;
  {$ENDIF}

  //填充界面信息
  //基本信息
  EditCus.Text    := '';
  EditCName.Text  := '';
  {$IFDEF QSTL}
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
  nStr := Format(nStr,[sTable_Bill,nOrderItem.FYunTianOrderId,nOrderItem.FGoodsID]);
  with fdm.QueryTemp(nStr) do
    nValue := Fields[0].AsFloat;
  //冻结量

  nStr := 'select accountCode,salePrice,accountName,realProj,reqQty-pickQty as leaveQty,itemcode from sal.SAL_Contract_v where '+
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
    //FWebOrderItems[FWebOrderIndex].FItemCode := fieldbyname('itemcode').AsString;暂时保存

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
  {$ELSE}
  nStockNo := Copy(nOrderItem.FGoodsID,1,Pos('-',nOrderItem.FGoodsID)-1);
  nType :=  Copy(nOrderItem.FGoodsID,Pos('-',nOrderItem.FGoodsID)+1,Length(nOrderItem.FGoodsID)-Pos('-',nOrderItem.FGoodsID)-1);

  nStr := ' select SUM(L_Value) from %s where L_ZhiKa=''%s'' and L_StockNo=''%s'' and L_OutFact is null';
  nStr := Format(nStr,[sTable_Bill,nOrderItem.FYunTianOrderId,nStockNo+sFlag_San]);
  with FDM.QueryTemp(nStr) do
    nValue := Fields[0].AsFloat;

  nStr := 'select reqQty-pickQty as leaveQty,* from sal.SAL_Contract_v where '+
          ' contractCode=''%s'' and itemcode=''%s'' and enableFlag=''Y''';
  nStr := Format(nStr,[nOrderItem.FYunTianOrderId,nType]);
  with FDM.QueryTemp(nStr, True) do
  begin
    if RecordCount < 1 then
    begin
      ShowMessage('订单[ '+ nOrderItem.FYunTianOrderId +' ]已丢失.');
      Exit;
    end;

    if RecordCount > 0 then
    begin                                      
      EditCus.Text    := fieldbyname('accountCode').AsString;
      EditCName.Text  := fieldbyname('accountName').AsString;
    end;

    if (FieldByName('contractStat').AsString <> 'Formal') and (FieldByName('contractStat').AsString <> 'Balance') then
    begin
      ShowMessage('订单[ '+nOrderItem.FYunTianOrderId+' ]已被管理员作废.');
      Exit;
    end;
    nPriceZX := FieldByName('salePrice').AsFloat;

    if FieldByName('salePrice').AsFloat- nValue - StrToFloat(nOrderItem.FData) < 0 then
    begin
      showmessage('ERP中订单数量不足,无法下单.');
      Exit;
    end;

    nOrderItem.FGoodsID := nStockNo+sFlag_San;
    FWebOrderItems[FWebOrderIndex].FGoodsID := nStockNo+sFlag_San;
    FWebOrderItems[FWebOrderIndex].FItemCode := nType;
  end;

  {$ENDIF}

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
  nNewCardNo, nTruck, nStr, nType, nMsg:string;
  nidx:Integer;
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
  {$IFDEF YHTL}
  if (EditCus.Text = '000072') and (editTrans.ItemIndex=-1) then
  begin
    editTrans.SetFocus;
    ShowMsg('请选择运输公司.',sHint);
    exit;
  end;
  {$ENDIF}

  //验证GPS信息
  {$IFDEF QSTL}
  nTruck := EditTruck.Text +'%';
  if (Pos('熟料',EditSName.Text) =0) and (Pos('石灰石',EditSName.Text) =0) then
    if not GetGpsByTruck(nTruck,gSysParam.FGPSFactID,gSysParam.FGPSValidTime) then
    begin
      nTruck := EditTruck.Text;
      if not GetGpsByTruck_New(nTruck) then
      begin
        AddManualEventRecord(editWebOrderNo.Text,EditTruck.Text,nTruck,'自助机',
                        sFlag_Solution_OK, sFlag_DepDaTing, True);
        ShowMessage(nTruck);
        Exit;
      end
      else
      begin
        if nTruck <> '' then
          ShowMessage(nTruck);
      end;
    end;
  {$ENDIF}

  for nIdx:=0 to 6 do
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
    {$IFDEF QSTL}
    if Pos('散',EditSName.Text) > 0 then
      nTmp.Values['Type'] := 'S'
    else
      nTmp.Values['Type'] := 'D';
    nTmp.Values['StockName'] := copy(EditSName.Text,1,Length(EditSName.Text)-4);
    {$ELSE}
    nTmp.Values['Type'] := 'S';
    nTmp.Values['StockName'] := EditSName.Text;
    {$ENDIF}
    nTmp.Values['StockNO'] := EditStock.Text;
    //EditSName.Text;
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
      Values['OrderNo'] := nOrderItem.FItemCode;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := sFlag_TiHuo;
      Values['Memo']  := EmptyStr;
      Values['IsVIP'] := Copy(GetCtrlData(EditType),1,1);
      Values['Seal'] := '';
      Values['HYDan'] := '';
      Values['WebOrderID'] := nWebOrderID;
      {$IFDEF YHTL}
      if editTrans.ItemIndex <> -1 then
      begin
        Values['TransCode'] := FTransList.strings[editTrans.ItemIndex];
        Values['TransName'] := editTrans.Text;
      end;
      {$ENDIF}
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

  //ShowMsg('提货单保存成功', sHint);
  nRet := SaveBillCard(nBillID, nNewCardNo);

  if not nRet then
  begin
    nMsg := '办理磁卡失败,请重试.';
    ShowMsg(nMsg, sHint);
    Exit;
  end;

  nRet := gDispenserManager.SendCardOut(gSysParam.FTTCEK720ID, nHint);
  //发卡

  if nRet then
  begin
    nMsg := '提货单[ %s ]发卡成功,卡号[ %s ],请收好您的卡片';
    nMsg := Format(nMsg, [nBillID, nNewCardNo]);

    WriteLog(nMsg);
    ShowMsg(nMsg,sWarn);
  end
  else begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);

    nMsg := '卡号[ %s ]出卡失败,请联系工作人员将卡片取出.';
    nMsg := Format(nMsg, [nNewCardNo]);

    WriteLog(nMsg);
    ShowMsg(nMsg,sWarn);
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
    if btnQuery.CanFocus then
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

procedure TfFormNewCard.Button2Click(Sender: TObject);
var
  nTruck:string;
begin
//  nTruck := editWebOrderNo.Text;
//  if not GetGpsByTruck_New(nTruck) then
//  begin
//    ShowMessage(nTruck);
//    Exit;
//  end
//  else
//  ShowMessage('成功.');

  nTruck := editWebOrderNo.Text;
  if not GetGpsByTruck_New(nTruck) then
  begin
    ShowMessage(nTruck);
    Exit;
  end
  else
  begin
    if nTruck <> '' then
      ShowMessage(nTruck);
  end;
end;

end.

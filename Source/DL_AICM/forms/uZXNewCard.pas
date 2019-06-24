{*******************************************************************************
  ����: juner11212436@163.com 2017-12-28
  ����: �����쿨����--������
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
    FAutoClose:Integer; //�����Զ��رյ���ʱ�����ӣ�
    FWebOrderIndex:Integer; //�̳Ƕ�������
    FWebOrderItems:array of stMallOrderItem; //�̳Ƕ�������
    FCardData:TStrings; //����ϵͳ���صĴ�Ʊ����Ϣ
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
      nStr := '���������ɨ�趩����';
      ShowMsg(nStr,sHint);
      Writelog(nStr);
      Exit;
    end;
    ShowWaitForm('����������ƽ̨��ȡ��Ϣ...');
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
    ShowMsg('δ��ѯ�������̳Ƕ�����ϸ��Ϣ�����鶩�����Ƿ���ȷ',sHint);
    Writelog('δ��ѯ�������̳Ƕ�����ϸ��Ϣ�����鶩�����Ƿ���ȷ');
    Exit;
  end;
  Writelog('TfFormNewCard.DownloadOrder(nCard='''+nCard+''') ��ѯ�̳Ƕ���-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  //�������Ƕ�����Ϣ
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
  col.Caption := '���϶������';
  col.Width := 300;
  col := lvOrders.Columns.Add;
  col.Caption := 'ˮ���ͺ�';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := 'ˮ������';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '�������';
  col.Width := 200;
  col := lvOrders.Columns.Add;
  col.Caption := '�������';
  col.Width := 150;
  col := lvOrders.Columns.Add;
  col.Caption := '�������';
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
    nMsg := '�˶����ѳɹ��쿨�������ظ�����';
    ShowMsg(nMsg,sHint);
    Writelog(nMsg);
    Exit;
  end;
  writelog('TfFormNewCard.LoadSingleOrder ����̳Ƕ����Ƿ��ظ�ʹ��-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');

  //��������Ϣ

  //������Ϣ
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

  //����erp���������ƿ���
  nStr := 'select SUM(L_Value) from %s where L_ZhiKa=''%s'' and '+
          'L_StockNo=''%s'' and L_OutFact is null';
  nStr := Format(nStr,[sTable_Bill,nOrderItem.FYunTianOrderId,EditStock.Text+nType]);
  with fdm.QueryTemp(nStr) do
    nValue := Fields[0].AsFloat;
  //������


  nStr := 'select accountCode,salePrice,accountName,realProj,reqQty-pickQty as leaveQty from sal.SAL_Contract_v where '+
          ' contractCode=''%s'' and prodCode=''%s'' and packForm=''%s'' and enableFlag=''Y''';
  nStr := Format(nStr,[nOrderItem.FYunTianOrderId,nStockNo,nType]);
  FDM.QueryData(ADOQuery1, nStr, True);
  with adoquery1 do
  begin
    if recordcount = 0 then
    begin
      nStr := '����['+nOrderItem.FYunTianOrderId+'],Ʒ��['+nStockNo+
              '],����['+nType+']��RRP���ѹرջ���ɾ��.';
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
      nStr := '����['+nOrderItem.FYunTianOrderId+'],Ʒ��['+nStockNo+
              '],����['+nType+']RRP����ʣ������������.';
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
      showmessage('û�п��õĹ��Ƽ�.');
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
      showmessage('���Ƽ۹���.');
      Exit;
    end;
  end;

  //�����ǰ��ͬ�۲���������ִ�мۣ��޸ĺ�ͬ�۸�
  if nPriceZX <> nPriceNow then
  begin
    nsql := 'update SAL.SAL_CTRItem set salePrice=''%s'' where contractCode=''%s'''+
            ' and prodCode=''%s'' and packForm=''%s''';
    nSql := Format(nSql,[FloatToStr(nPriceZX),nOrderItem.FYunTianOrderId, nStockNo,nType]);
    try
      fdm.ExecuteSQL(nSql,True);
    except
      ShowMessage('�����۸�ʧ�����¿���.');
      Exit;
    end;
  end;

  //�ᵥ��Ϣ
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
      nHint := '���ƺų���Ӧ����3λ';
      Writelog(nHint);
      Exit;
    end;
  end;
  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    if not Result then
    begin
      nHint := '����д��Ч�İ�����';
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
    ShowMsg('��ȡ���ϼ۸��쳣������ϵ����Ա',sHint);
    Writelog('��ȡ���ϼ۸��쳣������ϵ����Ա');
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
    ShowMsg('����δ������ӱ�ǩ����ӱ�ǩδ���ã�����ϵ����Ա', sHint);
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
    ShowMsg('��������δ��ɵ������,�޷�����,����ϵ����Ա',sHint);
    Exit;
  end;

  //��֤GPS��Ϣ
  nTruck := EditTruck.Text+'%';
  if (Pos('����',EditSName.Text) =0) and (Pos('ʯ��ʯ',EditSName.Text) =0) then
    if not GetGpsByTruck(nTruck,gSysParam.FGPSFactID,gSysParam.FGPSValidTime) then
    begin
      AddManualEventRecord(editWebOrderNo.Text,EditTruck.Text,nTruck,'������',
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
  //�������ζ���,�ɹ����˳���

  if nNewCardNo = '' then
  begin
    nHint := '�����쳣,��鿴�Ƿ��п�.';
    ShowMsg(nHint, sWarn);
    Exit;
  end;

  WriteLog('��ȡ����Ƭ: ' + nNewCardNo);
  //������Ƭ
  if not IsCardValid(nNewCardNo) then
  begin
    gDispenserManager.RecoveryCard(gSysParam.FTTCEK720ID, nHint);
    nHint := '����' + nNewCardNo + '�Ƿ�,������,���Ժ�����ȡ��';
    WriteLog(nHint);
    ShowMsg(nHint, sWarn);
    Exit;
  end;


  //���������
  nStocks := TStringList.Create;
  nList := TStringList.Create;
  nTmp := TStringList.Create;
  try
    LoadSysDictItem(sFlag_PrintBill, nStocks);
    if Pos('ɢ',EditSName.Text) > 0 then
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
      nHint := '���������ʧ��';
      ShowMsg(nHint,sError);
      Writelog(nHint);
      Exit;
    end;
    writelog('TfFormNewCard.SaveBillProxy ���������['+nBillID+']-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
    FBegin := Now;
    SaveWebOrderMatch(nBillID,nWebOrderID,sFlag_Sale);
    writelog('TfFormNewCard.SaveBillProxy �����̳Ƕ�����-��ʱ��'+InttoStr(MilliSecondsBetween(Now, FBegin))+'ms');
  finally
    nStocks.Free;
    nList.Free;
    nTmp.Free;
  end;

  ShowMsg('���������ɹ�', sHint);

  //����2019-05-20
  if not SaveBillCard(nBillID,nNewCardNo) then
  begin
    nHint := '����[ %s ]��������ʧ��,�뵽��Ʊ�������¹����ſ�.';
    nHint := Format(nHint, [nNewCardNo]);

    WriteLog(nHint);
    ShowMsg(nHint,sWarn);
  end
  else begin
    if not gDispenserManager.SendCardOut(gSysParam.FTTCEK720ID, nHint) then
      ShowMessage('����ʧ��,����ϵ����Ա���ſ�ȡ��.')
    else
      ShowMsg('�����ɹ�,����['+nNewCardNo+'],���պ����Ŀ�Ƭ',sHint);
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
  ShowMessage('�ɹ�.');
end;

end.

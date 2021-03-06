{*******************************************************************************
  作者: dmzn@163.com 2014-10-20
  描述: 自动称重通道项
*******************************************************************************}
unit UFramePoundAutoItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UBusinessConst, UFrameBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, StdCtrls,
  UTransEdit, ExtCtrls, cxRadioGroup, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, ULEDFont, DateUtils, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TfFrameAutoPoundItem = class(TBaseFrame)
    GroupBox1: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    ImageGS: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ImageBT: TImage;
    Label18: TLabel;
    ImageBQ: TImage;
    ImageOff: TImage;
    ImageOn: TImage;
    HintLabel: TcxLabel;
    EditTruck: TcxComboBox;
    EditMID: TcxComboBox;
    EditPID: TcxComboBox;
    EditMValue: TcxTextEdit;
    EditPValue: TcxTextEdit;
    EditJValue: TcxTextEdit;
    Timer1: TTimer;
    EditBill: TcxComboBox;
    EditZValue: TcxTextEdit;
    GroupBox2: TGroupBox;
    RadioPD: TcxRadioButton;
    RadioCC: TcxRadioButton;
    EditMemo: TcxTextEdit;
    EditWValue: TcxTextEdit;
    RadioLS: TcxRadioButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    Timer2: TTimer;
    Timer_ReadCard: TTimer;
    TimerDelay: TTimer;
    MemoLog: TZnTransMemo;
    Timer_SaveFail: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer_ReadCardTimer(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure Timer_SaveFailTimer(Sender: TObject);
    procedure EditBillKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FLogin: Integer;
    //摄像机登陆
    FCardUsed: string;
    //卡片类型
    FLEDContent: string;
    //显示屏内容
    FIsWeighting, FIsSaving: Boolean;
    //称重标识,保存标识
    FPoundTunnel: PPTTunnelItem;
    //磅站通道
    FLastGS,FLastBT,FLastBQ: Int64;
    //上次活动
    FIsChkPoundStatus: Boolean;  //地磅状态
    FBillItems: TLadingBillItems;
    FUIData,FInnerData: TLadingBillItem;
    //称重数据
    FLastCardDone: Int64;
    FLastCard, FCardTmp, FLastReader, FLastBusinessCard: string;
    //上次卡号, 临时卡号, 读卡器编号, 上次执行刷卡动作业务卡
    FELabelList: TStrings;
    //电子标签列表
    FSampleIndex: Integer;
    FValueSamples: array of Double;
    //数据采样
    FVirPoundID: string;
    //虚拟地磅编号
    FBarrierGate: Boolean;
    //是否采用道闸
    FEmptyPoundInit, FDoneEmptyPoundInit: Int64;
    //空磅计时,过磅保存后空磅
    FEmptyPoundIdleLong, FEmptyPoundIdleShort: Int64;

    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //界面数据
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    //设置状态
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //关联通道
    procedure OnPoundDataEvent(const nValue: Double);
    procedure OnPoundData(const nValue: Double);
    //读取磅重
    procedure LoadBillItems(const nCard: string);
    //读取交货单
    procedure InitSamples;
    procedure AddSample(const nValue: Double);
    function IsValidSamaple: Boolean;
    //处理采样
    function SavePoundSale: Boolean;
    function SavePoundData: Boolean;
    //保存称重
    procedure WriteLog(nEvent: string);
    //记录日志
    procedure PlayVoice(const nStrtext: string);
    //播放语音
    procedure LEDDisplay(const nContent: string);
    //LED显示
    function IfForceLable:Boolean;
    //检查磅的重量
    function ChkPoundStatus:Boolean;
  public
    { Public declarations }
    class function FrameID: integer; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //子类继承
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    //属性相关
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, {$IFDEF HR1847}UKRTruckProber,{$ELSE}UMgrTruckProbe,{$ENDIF}
  UMgrRemoteVoice, UMgrVoiceNet, UDataModule, USysBusiness, UMgrLEDDisp,
  USysLoger, USysConst, USysDB;
                                   
const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameAutoPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameAutoPoundItem.OnCreateFrame;
begin
  inherited;
  FPoundTunnel := nil;
  FIsWeighting := False;

  FLEDContent := '';
  FEmptyPoundInit := 0;
  FLogin := -1;
  FELabelList := TStringList.Create;
end;

procedure TfFrameAutoPoundItem.OnDestroyFrame;
begin
  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
  //关闭表头端口
  {$IFDEF CapturePictureEx}
  FreeCapture(FLogin);
  {$ENDIF}
  FELabelList.Free;
  inherited;
end;

//Desc: 设置运行状态图标
procedure TfFrameAutoPoundItem.SetImageStatus(const nImage: TImage;
  const nOff: Boolean);
begin
  if nOff then
  begin
    if nImage.Tag <> cFlag_OFF then
    begin
      nImage.Tag := cFlag_OFF;
      nImage.Picture.Bitmap := ImageOff.Picture.Bitmap;
    end;
  end else
  begin
    if nImage.Tag <> cFlag_ON then
    begin
      nImage.Tag := cFlag_ON;
      nImage.Picture.Bitmap := ImageOn.Picture.Bitmap;
    end;
  end;
end;

procedure TfFrameAutoPoundItem.WriteLog(nEvent: string);
var nInt: Integer;
begin
  with MemoLog do
  try
    Lines.BeginUpdate;
    if Lines.Count > 20 then
     for nInt:=1 to 10 do
      Lines.Delete(0);
    //清理多余

    Lines.Add(DateTime2Str(Now) + #9 + nEvent);
  finally
    Lines.EndUpdate;
    Perform(EM_SCROLLCARET,0,0);
    Application.ProcessMessages;
  end;
end;

procedure WriteSysLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameAutoPoundItem, '自动称重业务', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 更新运行状态
procedure TfFrameAutoPoundItem.Timer1Timer(Sender: TObject);
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 5 * 1000);
end;

//Desc: 关闭红绿灯
procedure TfFrameAutoPoundItem.Timer2Timer(Sender: TObject);
begin
  Timer2.Tag := Timer2.Tag + 1;
  if Timer2.Tag < 10 then Exit;

  Timer2.Tag := 0;
  Timer2.Enabled := False;

  {$IFNDEF MITTruckProber}
    {$IFDEF HR1847}
    gKRMgrProber.TunnelOC(FPoundTunnel.FID,False);
    {$ELSE}
    gProberManager.TunnelOC(FPoundTunnel.FID,False);
    {$ENDIF}
  {$ENDIF}
end;

//Desc: 设置通道
procedure TfFrameAutoPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
begin
  FBarrierGate := False;
  FEmptyPoundIdleLong := -1;
  FEmptyPoundIdleShort:= -1;

  FPoundTunnel := nTunnel;
  SetUIData(True);

  {$IFDEF CapturePictureEx}
  if not InitCapture(FPoundTunnel,FLogin) then
    WriteLog('通道:'+ FPoundTunnel.FID+'初始化失败,错误码:'+IntToStr(FLogin))
  else
    WriteLog('通道:'+ FPoundTunnel.FID+'初始化成功,登陆ID:'+IntToStr(FLogin));
  {$ENDIF}

  if Assigned(FPoundTunnel.FOptions) then
  with FPoundTunnel.FOptions do
  begin
    FVirPoundID  := Values['VirPoundID'];
    FBarrierGate := Values['BarrierGate'] = sFlag_Yes;
    FEmptyPoundIdleLong := StrToInt64Def(Values['EmptyIdleLong'], 60);
    FEmptyPoundIdleShort:= StrToInt64Def(Values['EmptyIdleShort'], 5);
  end;
end;

//Desc: 重置界面数据
procedure TfFrameAutoPoundItem.SetUIData(const nReset,nOnlyData: Boolean);
var nStr: string;
    nInt: Integer;
    nVal: Double;
    nItem: TLadingBillItem;
begin
  if nReset then
  begin
    FillChar(nItem, SizeOf(nItem), #0);
    //init

    with nItem do
    begin
      FPModel := sFlag_PoundPD;
      FFactory := gSysParam.FFactNum;
    end;

    FUIData := nItem;
    FInnerData := nItem;
    if nOnlyData then Exit;

    SetLength(FBillItems, 0);
    EditValue.Text := '0.00';
    EditBill.Properties.Items.Clear;

    FIsSaving    := False;
    FEmptyPoundInit := 0;

    if not FIsWeighting then
    begin
      gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
      //关闭表头端口

      Timer_ReadCard.Enabled := True;
      //启动读卡
    end;
  end;

  with FUIData do
  begin
    EditBill.Text := FID;
    EditTruck.Text := FTruck;
    EditMID.Text := FStockName;
    EditPID.Text := FCusName;

    EditMValue.Text := Format('%.2f', [FMData.FValue]);
    EditPValue.Text := Format('%.2f', [FPData.FValue]);
    EditZValue.Text := Format('%.2f', [FValue]);

    if (FValue > 0) and (FMData.FValue > 0) and (FPData.FValue > 0) then
    begin
      nVal := FMData.FValue - FPData.FValue;
      EditJValue.Text := Format('%.2f', [nVal]);
      EditWValue.Text := Format('%.2f', [FValue - nVal]);
    end else
    begin
      EditJValue.Text := '0.00';
      EditWValue.Text := '0.00';
    end;

    RadioPD.Checked := FPModel = sFlag_PoundPD;
    RadioCC.Checked := FPModel = sFlag_PoundCC;
    RadioLS.Checked := FPModel = sFlag_PoundLS;

    RadioLS.Enabled := (FPoundID = '') and (FID = '');
    //已称过重量或销售,禁用临时模式
    RadioCC.Enabled := FID <> '';
    //只有销售有出厂模式

    EditBill.Properties.ReadOnly := (FID = '') and (FTruck <> '');
    EditTruck.Properties.ReadOnly := FTruck <> '';
    EditMID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    EditPID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    //可输入项调整

    EditMemo.Properties.ReadOnly := True;
    EditMValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditPValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditJValue.Properties.ReadOnly := True;
    EditZValue.Properties.ReadOnly := True;
    EditWValue.Properties.ReadOnly := True;
    //可输入量调整

    if FTruck = '' then
    begin
      EditMemo.Text := '';
      Exit;
    end;
  end;

  nInt := Length(FBillItems);
  if nInt > 0 then
  begin
    if nInt > 1 then
         nStr := '销售并单'
    else nStr := '销售';

    if FCardUsed = sFlag_Provide then nStr := '供应';

    if FUIData.FNextStatus = sFlag_TruckBFP then
    begin
      RadioCC.Enabled := False;
      EditMemo.Text := nStr + '称皮重';
    end else
    begin
      RadioCC.Enabled := True;
      EditMemo.Text := nStr + '称毛重';
    end;
  end else
  begin
    if RadioLS.Checked then
      EditMemo.Text := '车辆临时称重';
    //xxxxx

    if RadioPD.Checked then
      EditMemo.Text := '车辆配对称重';
    //xxxxx
  end;
end;

//Date: 2014-09-19
//Parm: 磁卡或交货单号
//Desc: 读取nCard对应的交货单
procedure TfFrameAutoPoundItem.LoadBillItems(const nCard: string);
var nRet, nValidELabel: Boolean;
    nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nStr,nHint, nVoice, nLabel, nPos: string;
begin
  nStr := Format('读取到卡号[ %s ],开始执行业务.', [nCard]);
  WriteLog(nStr);
  {$IFDEF UseELabel}
  FCardUsed := sFlag_DuanDao;
  {$ELSE}
  FCardUsed := GetCardUsed(nCard);
  {$ENDIF}
  if FCardUsed = sFlag_Tx then
  begin
    nVoice := '通行卡';
    PlayVoice(nVoice);

    OpenDoorByReader(FLastReader);
    //打开主道闸
    OpenDoorByReader(FLastReader, sFlag_No);

    WriteSysLog(nVoice + nCard);
    SetUIData(True);
    Exit;
  end else
  if FCardUsed = sFlag_Provide then
     nRet := GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills) else
  if FCardUsed=sFlag_DuanDao then
     nRet := GetDuanDaoItems(nCard, sFlag_TruckBFP, nBills) else
  if FCardUsed=sFlag_Sale then
     nRet := GetLadingBills(nCard, sFlag_TruckBFP, nBills) else nRet := False;

  if (not nRet) or (Length(nBills) < 1) then
  begin
    nVoice := '读取磁卡信息失败,请联系管理员';
    PlayVoice(nVoice);
    WriteLog(nVoice);
    SetUIData(True);
    Exit;
  end;

  //进厂规定时间内不过皮视为无效单据
  {$IFDEF QSTL}
  if (FCardUsed=sFlag_Provide) and (nBills[0].FNextStatus = sFlag_TruckBFP) then
  begin
    nStr := 'select * from %s where D_Name=''%s''';
    nStr := Format(nStr,[sTable_SysDict,sFlag_InFactWaiteTime]);
    with fdm.QueryTemp(nStr) do
      nIdx := FieldByName('D_Value').AsInteger;

    nStr := 'select * from %s where l_id=''%s''';
    nStr := Format(nStr,[sTable_Bill,nBills[0].FID]);
    with fdm.QueryTemp(nStr) do
    begin
      if MinuteOf(Now) - MinuteOf(FieldByName('L_InTime').AsDateTime) > nIdx then
      begin
        nStr := '进厂和过皮中时间间隔过大,请联系管理员.';
        WriteSysLog('提货单'+nBills[0].FID+nStr);
        PlayVoice(nStr);
        Exit;
      end;
    end;
  end;
  {$ENDIF}

  nHint := '';
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    if (FStatus <> sFlag_TruckBFP) and (FNextStatus = sFlag_TruckZT) then
      FNextStatus := sFlag_TruckBFP;
    //状态校正

    FSelected := (FNextStatus = sFlag_TruckBFP) or
                 (FNextStatus = sFlag_TruckBFM);
    //可称重状态判定

    //供应类业务,且物流部未验收，则直接跳出循环
    if (FCardUsed=sFlag_Provide) and (FNextStatus = sFlag_TruckBFM) and GetWlbYsStatus(FStockNo,FID) then
    begin
      nInt := 0;
      nVoice := '物流部未验收,车辆 %s 不能过磅';
      nVoice := Format(nVoice, [FTruck]);

      nStr := '※.单号:[ %s ] 状态: 物流部未验收';
      nstr := Format(nStr,[FID]);
      nHint := nStr;
      Break;
    end;

    //启用拒收审核
    {$IFDEF CGJSSP}
    if (FCardUsed=sFlag_Provide) and (FNextStatus = sFlag_TruckBFM) and (FYSValid = sFlag_No) then
    begin
      nStr := 'select * from %s where D_ID=''%s''';
      nStr := Format(nStr,[sTable_OrderDtl,FID]);
      with fdm.QueryTemp(nStr) do
      begin
        if recordcount = 0 then
        begin
          nInt := 0;
          nVoice := '采购单不存在,车辆 %s 不能过磅';
          nVoice := Format(nVoice, [FTruck]);

          nStr := '※.单号:[ %s ] 状态: 物流部未验收';
          nstr := Format(nStr,[FID]);
          nHint := nStr;
          Break;
        end;

        if (FieldByName('D_BMCheck').AsString <> sFlag_Yes) and
          (FieldByName('D_YSResult').AsString = sFlag_No) then
        begin
          nInt := 0;
          nVoice := '采购拒收车辆部门经理未审批,车辆 %s 不能过磅';
          nVoice := Format(nVoice, [FTruck]);

          nStr := '※.单号:[ %s ] 状态: 采购拒收车辆部门经理未审批';
          nstr := Format(nStr,[FID]);
          nHint := nStr;
          Break;
        end;

        if (FieldByName('D_LeaderCheck').AsString <> sFlag_Yes) and
          (FieldByName('D_YSResult').AsString = sFlag_No) then
        begin
          nInt := 0;
          nVoice := '采购拒收车辆总经理未审批,车辆 %s 不能过磅';
          nVoice := Format(nVoice, [FTruck]);

          nStr := '※.单号:[ %s ] 状态: 采购拒收车辆总经理未审批';
          nstr := Format(nStr,[FID]);
          nHint := nStr;
          Break;
        end;
      end;
    end;
    {$ENDIF}

    if FSelected then
    begin
      Inc(nInt);
      Continue;
    end;

    nStr := '※.单号:[ %s ] 状态:[ %-6s -> %-6s ]   ';
    if nIdx < High(nBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [FID,
            TruckStatusToStr(FStatus), TruckStatusToStr(FNextStatus)]);
    nHint := nHint + nStr;

    nVoice := '车辆 %s 不能过磅,应该去 %s ';
    nVoice := Format(nVoice, [FTruck, TruckStatusToStr(FNextStatus)]);
  end;

  if nInt = 0 then
  begin
    PlayVoice(nVoice);
    //车辆状态异常

    nHint := '该车辆当前不能过磅,详情如下: ' + #13#10#13#10 + nHint;
    WriteSysLog(nStr);
    SetUIData(True);
    Exit;
  end;

  {$IFDEF RemoteSnap}
  if not VerifySnapTruck(FLastReader, nBills[0], nHint, nPos) then
  begin
    nVoice := '%s车牌识别失败,请移动车辆或联系管理员';
    nVoice := Format(nVoice, [nBills[0].FTruck]);
    PlayVoice(nVoice);
    RemoteSnapDisPlay(nPos, nVoice,sFlag_No);
    WriteSysLog(nVoice);
    SetUIData(True);
    Exit;
  end
  else
  begin
    if nHint <> '' then
    begin
      RemoteSnapDisPlay(nPos, nHint,sFlag_Yes);
      WriteSysLog(nHint);
    end;
  end;
  {$ENDIF}

  EditBill.Properties.Items.Clear;
  SetLength(FBillItems, nInt);
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    if FSelected then
    begin
      FPoundID := '';
      //该标记有特殊用途

      if nInt = 0 then
           FInnerData := nBills[nIdx]
      else FInnerData.FValue := FInnerData.FValue + FValue;
      //累计量

      EditBill.Properties.Items.Add(FID);
      FBillItems[nInt] := nBills[nIdx];
      Inc(nInt);
    end;
  end;

  FInnerData.FPModel := sFlag_PoundPD;
  FUIData := FInnerData;
  SetUIData(False);

  nInt := GetTruckLastTime(FUIData.FTruck);
  if (nInt > 0) and (nInt < FPoundTunnel.FCardInterval) then
  begin
    nStr := '磅站[ %s.%s ]: 车辆[ %s ]需等待 %d 秒后才能过磅';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            FUIData.FTruck, FPoundTunnel.FCardInterval - nInt]);
    WriteSysLog(nStr);
    SetUIData(True);
    Exit;
  end;
  //指定时间内车辆禁止过磅

  {$IFDEF PoundElabelControlEx}
  if FVirPoundID <> '' then
  begin
    nLabel := GetTruckRealLabel(FUIData.FTruck);
    //强制电子标签
    if IfForceLable and (nLabel='') then
    begin
      nStr := '请办理电子标签.';
      WriteSysLog(nStr);
      PlayVoice(nStr);
      Exit;
    end;

    nHint := ReadPoundCardEx(nStr, FVirPoundID);

    if (nHint <> '') and (FELabelList.IndexOf(nHint) < 0) then
      FELabelList.Add(nHint);

    nStr := '磅站[ %s.%s ]: 车辆[ %s.%s ]当前电子标签列表[ %s ]';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            FUIData.FTruck, nLabel, FELabelList.Text]);
    WriteSysLog(nStr);

    nValidELabel := False;
    for nIdx := 0 to FELabelList.Count - 1 do
    begin
      if Pos(nLabel, FELabelList.Strings[nIdx]) > 0 then
      begin
        nValidELabel := True;
        WriteSysLog('电子标签匹配无误.nLabel::'+nLabel+',nHint'+FELabelList.Strings[nIdx]);
        Break;
      end;
    end;

    if not nValidELabel then
    begin     //if (nHint = '') or (Pos(nLabel, nHint) < 1) then
      if nHint = '' then
      begin
        nStr := '未识别电子签,请移动车辆.';
        PlayVoice(nStr);
      end
      else
      if Pos(nLabel, nHint) < 1 then
      begin
        nStr := '电子标签不匹配,请重新绑定.';
        PlayVoice(nStr);
      end;

      nStr := '磅站[ %s.%s ]: 车辆[ %s.%s ]电子标签不匹配[ %s ],禁止上磅';
      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
              FUIData.FTruck, nLabel, nHint]);
      WriteSysLog(nStr);
      SetUIData(True);
      Exit;
    end;
  end;
  //判断车辆是否就位
  {$ELSE}
  if FVirPoundID <> '' then
  begin
    nLabel := GetTruckRealLabel(FUIData.FTruck);
    //强制电子标签
    if IfForceLable and (nLabel='') then
    begin
      nStr := '请办理电子标签.';
      WriteSysLog(nStr);
      PlayVoice(nStr);
      Exit;
    end;

    begin
      nHint := ReadPoundCardEx(nStr, FVirPoundID);
      if (nHint = nLabel) or (Pos(nLabel, nHint) > 0) then
      begin
        WriteSysLog('电子标签匹配无误.nLabel::'+nLabel+',nHint'+nHint);
      end
      else
      begin     //if (nHint = '') or (Pos(nLabel, nHint) < 1) then
        nStr := '未识别电子签,请移动车辆.';
        PlayVoice(nStr);

        nStr := '磅站[ %s.%s ]: 车辆[ %s.%s ]电子标签不匹配[ %s ],禁止上磅';
        nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
                FUIData.FTruck, nLabel, nHint]);
        WriteSysLog(nStr);
        SetUIData(True);
        Exit;
      end;
    end;
  end;
  //判断车辆是否就位
  {$ENDIF}

  InitSamples;
  //初始化样本

  if not FPoundTunnel.FUserInput then
  if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
         OnPoundDataEvent, True) then
  begin
    nHint := '连接地磅表头失败，请联系管理员检查硬件连接';
    WriteSysLog(nHint);

    nVoice := nHint;
    PlayVoice(nVoice);

    SetUIData(True);
    Exit;
  end;

  Timer_ReadCard.Enabled := False;
  FDoneEmptyPoundInit := 0;
  FIsWeighting := True;
  //停止读卡,开始称重

  if FBarrierGate then
  begin
    {$IFDEF ZZSJ}
    if (FUIData.FStatus = sFlag_TruckIn) or
       (FUIData.FStatus = sFlag_TruckBFP) then
    begin
      nStr := '[n1]%s刷卡成功请上磅,并熄火停车,进厂请系好安全带,戴好安全帽';
      nStr := Format(nStr, [FUIData.FTruck]);
    end;
    {$ELSE}
    nStr := '[n1]%s刷卡成功请上磅,并熄火停车';
    nStr := Format(nStr, [FUIData.FTruck]);
    {$ENDIF}
    
    PlayVoice(nStr);
    //读卡成功，语音提示

    {$IFNDEF DEBUG}
    OpenDoorByReader(FLastReader);
    //打开主道闸
    {$ENDIF}
  end;
  //车辆上磅
end;

//------------------------------------------------------------------------------
//Desc: 由定时读取交货单
procedure TfFrameAutoPoundItem.Timer_ReadCardTimer(Sender: TObject);
var nStr,nCard,nLabel: string;
    nLast, nDoneTmp: Int64;
begin
  if gSysParam.FIsManual then Exit;
  Timer_ReadCard.Tag := Timer_ReadCard.Tag + 1;
  if Timer_ReadCard.Tag < 5 then Exit;

  Timer_ReadCard.Tag := 0;
  if FIsWeighting then Exit;

  try
    WriteLog('正在读取磁卡号.');
    {$IFNDEF DEBUG}
    nCard := Trim(ReadPoundCard(FPoundTunnel.FID, FLastReader));
    {$ENDIF}
    if nCard = '' then Exit;

    //电子标签过磅，直接去掉H
    {$IFDEF UseELabel}
    nCard := Copy(nCard,2,Length(nCard)-1);
    {$ENDIF}
    if nCard <> FLastCard then
         nDoneTmp := 0
    else nDoneTmp := FLastCardDone;
    //新卡时重置

    if nCard <> FLastBusinessCard then//新卡时清空电子标签列表
    begin
      FLastBusinessCard := nCard;
      FELabelList.Clear;
    end
    else
    begin
      nLabel := GetReaderCard(FLastReader, 'RFID102');//读取该电子标签卡号
      if (nLabel <> '') and (FELabelList.IndexOf(nLabel) < 0) then
      FELabelList.Add(nLabel);
    end;

    {$IFDEF DEBUG}
    nStr := '磅站[ %s.%s ]: 读取到新卡号::: %s =>旧卡号::: %s';
    nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
            nCard, FLastCard]);
    WriteSysLog(nStr);
    {$ENDIF}

    nLast := Trunc((GetTickCount - nDoneTmp) / 1000);
    if (nDoneTmp <> 0) and (nLast < FPoundTunnel.FCardInterval)  then
    begin
      nStr := '磅站[ %s.%s ]: 磁卡[ %s ]需等待 %d 秒后才能过磅';
      nStr := Format(nStr, [FPoundTunnel.FID, FPoundTunnel.FName,
              nCard, FPoundTunnel.FCardInterval - nLast]);
      WriteSysLog(nStr);
      Exit;
    end;

    {$IFNDEF UseELabel}  //在磅上刷卡的话，不检查磅上是否有重量
    if Not ChkPoundStatus then Exit;
    {$ENDIF}

    FCardTmp := nCard;
    EditBill.Text := nCard;
    LoadBillItems(EditBill.Text);
  except
    on E: Exception do
    begin
      nStr := Format('磅站[ %s.%s ]: ',[FPoundTunnel.FID,
              FPoundTunnel.FName]) + E.Message;
      WriteSysLog(nStr);

      SetUIData(True);
      //错误则重置
    end;
  end;
end;

//Desc: 保存销售
function TfFrameAutoPoundItem.SavePoundSale: Boolean;
var nStr: string;
    nVal,nNet,nLoadLimit: Double;
begin
  Result := False;
  //init

  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
  begin
    if FUIData.FPData.FValue <= 0 then
    begin
      WriteLog('请先称量皮重');
      Exit;
    end;

    nNet := GetTruckEmptyValue(FUIData.FTruck);
    nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

    if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
    begin
      {$IFDEF AutoPoundInManual}
      nStr := '车辆[%s]实时皮重误差较大,请通知司机检查车厢';
      nStr := Format(nStr, [FUIData.FTruck]);
      PlayVoice(nStr);

      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10#13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10#13#10 +
              '是否继续保存?';
      nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
              nNet, nVal]);
      if not QueryDlg(nStr, sAsk) then Exit;
      {$ELSE}
      nStr := '车辆[ %s ]实时皮重误差较大,详情如下:' + #13#10 +
              '※.实时皮重: %.2f吨' + #13#10 +
              '※.历史皮重: %.2f吨' + #13#10 +
              '※.误差量: %.2f公斤' + #13#10 +
              '允许过磅,请选是;禁止过磅,请选否.';
      nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
              nNet, nVal]);

      if not VerifyManualEventRecord(FUIData.FID + sFlag_ManualB, nStr,
        sFlag_Yes, False) then
      begin
        AddManualEventRecord(FUIData.FID + sFlag_ManualB, FUIData.FTruck, nStr,
            sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepDaTing, True);
        WriteSysLog(nStr);

        nStr := '[n1]%s皮重超出预警,请下磅联系开票员处理后再次过磅';
        nStr := Format(nStr, [FUIData.FTruck]);
        PlayVoice(nStr);
        Exit;
      end;
      {$ENDIF}
    end;
  end else
  begin
    if FUIData.FMData.FValue <= 0 then
    begin
      WriteLog('请先称量毛重');
      Exit;
    end;
  end;

  nLoadLimit := GetTruckLoadLimit(FUIData.FTruck, FUIData.FStockName);
  //获取限载值
      
  if FUIData.FMData.FValue > nLoadLimit then
  begin
    nStr := '超出最大限载重量，请返厂卸车';
    WriteLog(nStr);
    PlayVoice(nStr);
    exit;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FBillItems[0].FYSValid <> sFlag_Yes then //判断是否空车出厂
    begin
      if FUIData.FPData.FValue > FUIData.FMData.FValue then
      begin
        WriteLog('皮重应小于毛重');
        Exit;
      end;

      nNet := FUIData.FMData.FValue - FUIData.FPData.FValue;
      //净重
      nVal := nNet * 1000 - FInnerData.FValue * 1000;
      //与开票量误差(公斤)

      with gSysParam,FBillItems[0] do
      begin
        {$IFDEF DaiStepWuCha}
        if FType = sFlag_Dai then
        begin
          GetPoundAutoWuCha(FPoundDaiZ, FPoundDaiF, FInnerData.FValue);
          //计算误差
        end;
        {$ELSE}
        if FDaiPercent and (FType = sFlag_Dai) then
        begin
          if nVal > 0 then
               FPoundDaiZ := Float2Float(FInnerData.FValue * FPoundDaiZ_1 * 1000,
                                         cPrecision, False)
          else FPoundDaiF := Float2Float(FInnerData.FValue * FPoundDaiF_1 * 1000,
                                         cPrecision, False);
        end;
        {$ENDIF}

        if ((FType = sFlag_Dai) and (
            ((nVal > 0) and (FPoundDaiZ > 0) and (nVal > FPoundDaiZ)) or
            ((nVal < 0) and (FPoundDaiF > 0) and (-nVal > FPoundDaiF)))) then
        begin
          {$IFDEF AutoPoundInManual}
          nStr := '车辆[%s]实际装车量误差较大，请通知司机点验包数';
          nStr := Format(nStr, [FTruck]);
          PlayVoice(nStr);

          nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10#13#10 +
                  '※.开单量: %.2f吨' + #13#10 +
                  '※.装车量: %.2f吨' + #13#10 +
                  '※.误差量: %.2f公斤';

          if FDaiWCStop then
          begin
            nStr := nStr + #13#10#13#10 + '请通知司机点验包数.';
            nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);

            ShowDlg(nStr, sHint);
            Exit;
          end else
          begin
            nStr := nStr + #13#10#13#10 + '是否继续保存?';
            nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);
            if not QueryDlg(nStr, sAsk) then Exit;
          end;
          {$ELSE}
          nStr := '车辆[ %s ]实际装车量误差较大,详情如下:' + #13#10 +
                  '※.开单量: %.2f吨' + #13#10 +
                  '※.装车量: %.2f吨' + #13#10 +
                  '※.误差量: %.2f公斤' + #13#10 +
                  '检测完毕后,请点确认重新过磅.';
          nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, nVal]);

          if not VerifyManualEventRecord(FID + sFlag_ManualC, nStr) then
          begin
            AddManualEventRecord(FID + sFlag_ManualC, FTruck, nStr,
              sFlag_DepBangFang, sFlag_Solution_YN, sFlag_DepJianZhuang, True);
            WriteSysLog(nStr);

            nStr := '车辆[n1]%s净重[n2]%.2f吨,开票量[n2]%.2f吨,'+
                    '误差量[n2]%.2f公斤,请去包装点包';
            nStr := Format(nStr, [FTruck, nNet, FInnerData.FValue, nVal]);
            PlayVoice(nStr);

            nStr := GetTruckNO(FTruck) + '请去包装点包';
            LEDDisplay(nStr);

            {$IFDEF ProberShow}
              {$IFDEF MITTruckProber}
              ProberShowTxt(FPoundTunnel.FID, nStr);
              {$ELSE}
              gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
              {$ENDIF}
            {$ENDIF}
            Exit;
          end;
          {$ENDIF}
        end;

        if (FType = sFlag_San) and IsStrictSanValue and
           FloatRelation(FValue, nNet, rtLess, cPrecision) then
        begin
          nStr := '车辆[n1]%s[p500]净重[n2]%.2f吨[p500]开票量[n2]%.2f吨,请卸货';
          nStr := Format(nStr, [FTruck, Float2Float(nNet, cPrecision, True),
                  Float2Float(FValue, cPrecision, True)]);
          WriteSysLog(nStr);
          PlayVoice(nStr);
          Exit;
        end;
      end;
    end
    else
    begin
      nNet := FUIData.FMData.FValue;
      nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

      if (nNet > 0) and (Abs(nVal) > gSysParam.FEmpTruckWc) then
      begin
        nVal := nVal - gSysParam.FEmpTruckWc;
        nStr := '车辆[n1]%s[p500]空车出厂超差[n2]%.2f公斤,请司机联系司磅管理员检查车厢';
        nStr := Format(nStr, [FBillItems[0].FTruck, Float2Float(nVal, cPrecision, True)]);
        WriteSysLog(nStr);
        PlayVoice(nStr);
        Exit;
      end;
    end;
  end;

  with FBillItems[0] do
  begin
    FPModel := FUIData.FPModel;
    FFactory := gSysParam.FFactNum;

    with FPData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FPData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    with FMData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FMData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    FPoundID := sFlag_Yes;
    //标记该项有称重数据
    Result := SaveLadingBills(FNextStatus, FBillItems, FPoundTunnel, FLogin);
    //保存称重
  end;
end;

//------------------------------------------------------------------------------
//Desc: 原材料或临时
function TfFrameAutoPoundItem.SavePoundData: Boolean;
var nNextStatus, nStr: string;
    nVal, nLimitYL, nLimitZL, nDoneVal, nLoadLimit: Double;   //nLimitYL:富余量
begin
  Result := False;
  //init

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FUIData.FPData.FValue > FUIData.FMData.FValue then
    begin
      WriteLog('皮重应小于毛重');
      Exit;
    end;
  end;

  nLoadLimit := GetOrderTruckLimit;
  //获取限载值

  if FUIData.FMData.FValue > nLoadLimit then
  begin
    nStr := '超出最大限载重量.';
    WriteLog(nStr);
    PlayVoice(nStr);
    exit;
  end;

  {$IFDEF YHTL}    //提货量超出退货量，禁止过磅
  if FCardUsed = sFlag_Provide then
  begin
    nVal := Abs(FUIData.FMData.FValue - FUIData.FPData.FValue);
    nStr := 'select o_ctid,O_OrderType from %s ,%s where O_ID=D_OID'+
                ' and D_ID=''%s''';
    nStr := Format(nStr,[sTable_Order,sTable_OrderDtl,FUIData.FID]);
    with fdm.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      //如果是退货
      if FieldByName('O_OrderType').asstring='T' then
      begin
        nStr := 'select * from %s where T_ID=''%s''';
        nStr := Format(nStr,[sTable_OrderReturn,FieldByName('o_ctid').asstring]);
        with fdm.QueryTemp(nStr) do
        if RecordCount > 0 then
        begin
          //如果超量
          if nVal > FieldByName('T_Value').AsFloat - FieldByName('T_ValDone').AsFloat then
          begin
            nStr := '已提退货量超出批准退货量,超出:[%s]吨,请返厂卸车.';
            nStr := Format(nStr,[FloatToStr(nVal-FieldByName('T_Value').AsFloat +
                    FieldByName('T_ValDone').AsFloat)]);
            WriteSysLog('退货单'+ FUIData.FID + nStr);
            PlayVoice(nStr);
            Exit;
          end;
        end;
      end;
    end;

    //采购限量
    nStr := 'select * from %s where D_Name=''%s'' and D_ParamB=''%s''';
    nStr := Format(nStr,[sTable_SysDict,sFlag_ProdLimit,FUIData.FStockNo]);
    with fdm.QueryTemp(nStr) do
    begin
      if recordcount > 0 then
      if FieldByName('D_Value').AsString = sflag_yes then
      begin
        nStr := 'select * from sys_dict where d_name=''%s''';
        nStr := Format(nStr,[sFlag_ProdLimitYL]);
        with fdm.QueryTemp(nStr) do
          nLimitYL := FieldByName('D_Value').AsFloat;

        nStr := 'select L_Value from %s where L_ProdNo=''%s'' and L_StockNo=''%s''';
        nStr := Format(nStr,[sTable_ProdLimit,FUIData.FCusID,FUIData.FStockNo]);
        with FDM.QueryTemp(nStr) do
          nLimitZL := fieldbyname('L_Value').AsFloat;

        nStr := 'Select sum(D_Value) as D_Value from %s where D_StockNo=''%s'''+
                ' and D_InTime >= ''%s'' and D_InTime < ''%s'' and D_ProId=''%s''';
        nStr := Format(nStr,[sTable_OrderDtl,FUIData.FStockNo,
              Date2Str(Date,True)+' 00:00:00',Date2Str(Date+1,True)+' 00:00:00',
              FUIData.FCusID]);
        with FDM.QueryTemp(nStr) do
        begin
          nDoneVal := FieldByName('D_Value').AsFloat;
          if nLimitZL + nLimitYL < nVal + nDoneVal then
          begin
            nStr := '送货量超出日限额,超出:[%s]吨,请返厂卸车.';
            nStr := Format(nStr,[FloatToStr(nval + nDoneVal - nLimitZL - nLimitYL)]);
            WriteSysLog('采购单'+ FUIData.FID + nStr);
            PlayVoice(nStr);
            Exit;
          end;
        end;
      end;
    end;
  end;
  {$ENDIF}

  nNextStatus := FBillItems[0].FNextStatus;
  //暂存过磅状态

  SetLength(FBillItems, 1);
  FBillItems[0] := FUIData;
  //复制用户界面数据
  
  with FBillItems[0] do
  begin
    FFactory := gSysParam.FFactNum;
    //xxxxx
    
    if FNextStatus = sFlag_TruckBFP then
         FPData.FStation := FPoundTunnel.FID
    else FMData.FStation := FPoundTunnel.FID;
  end;
  
  if FCardUsed = sFlag_Provide then
       Result := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel, FLogin)
  else Result := SaveDuanDaoItems(nNextStatus, FBillItems, FPoundTunnel, FLogin);
  //保存称重
  //Result := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel)
  //保存称重
end;

//Desc: 读取表头数据
procedure TfFrameAutoPoundItem.OnPoundDataEvent(const nValue: Double);
begin
  try
    if FIsSaving then Exit;
    //正在保存。。。

    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      SetUIData(True);
    end;
  end;
end;

//Desc: 处理表头数据
procedure TfFrameAutoPoundItem.OnPoundData(const nValue: Double);
var nRet: Boolean;
    nInt: Int64;
    nStr: string;
    nVal:Double;
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);

  if FIsChkPoundStatus then Exit;
  //不在检查状态中
  if not FIsWeighting then Exit;
  //不在称重中
  if gSysParam.FIsManual then Exit;
  //手动时无效

  if nValue < FPoundTunnel.FPort.FMinValue then //空磅
  begin
    if FEmptyPoundInit = 0 then
      FEmptyPoundInit := GetTickCount;
    nInt := GetTickCount - FEmptyPoundInit;

    if (nInt > FEmptyPoundIdleLong * 1000) then
    begin
      FIsWeighting :=False;
      Timer_SaveFail.Enabled := True;

      WriteSysLog('刷卡后司机无响应,退出称重.');
      Exit;
    end;
    //上磅时间,延迟重置

    if (nInt > FEmptyPoundIdleShort * 1000) and   //保证空磅
       (FDoneEmptyPoundInit>0) and (GetTickCount-FDoneEmptyPoundInit>nInt) then
    begin
      FIsWeighting :=False;
      Timer_SaveFail.Enabled := True;

      WriteSysLog('司机已下磅,退出称重.');
      Exit;
    end;
    //上次保存成功后,空磅超时,认为车辆下磅

    Exit;
  end else
  begin
    FEmptyPoundInit := 0;
    if FDoneEmptyPoundInit > 0 then
      FDoneEmptyPoundInit := GetTickCount;
    //车辆称重完毕后，未下磅
  end;

  AddSample(nValue);
  if not IsValidSamaple then Exit;
  //样本验证不通过

  if Length(FBillItems) < 1 then Exit;
  //无称重数据

  //if FCardUsed = sFlag_Provide then
  //临时过磅也对调重量
  if FCardUsed <> sFlag_Sale then
  begin
    if FCardUsed =sFlag_Provide then
    begin
      nStr := 'select * from %s where D_ID=''%s''';
      nStr := Format(nStr,[sTable_OrderDtl,FUIData.FID]);
      with fdm.QueryTemp(nStr) do
      if ((FieldByName('D_YSResult').AsString = sFlag_No) or (FieldByName('D_WlbYS').AsString = sFlag_No))
        and (FUIData.FNextStatus = sFlag_TruckBFM) then
      begin
        if FInnerData.FPData.FValue < nValue then
        begin
          nStr := '采购拒收订单出厂重量不能超过进厂重量.';
          PlayVoice(nStr);
          WriteSysLog(nStr);
          if FBarrierGate then
            OpenDoorByReader(FLastReader, sFlag_No);
          Timer_SaveFail.Enabled := True;
          Exit;
        end;

        nVal := FInnerData.FPData.FValue - nValue;
        if  nVal > gSysParam.FJsWc then
        begin
          //nStr := '采购拒收订单出厂重量超出误差范围.';
          nStr := '采购拒收车辆误差:'+floattostr(nVal)+',允许误差:'+floattostr(gSysParam.FJsWc)+
                ',皮毛重误差超出标准值,皮重:['+floattostr(FInnerData.FPData.FValue)+
                '],毛重:['+floattostr(nValue)+'],请联系管理员处理.';
          PlayVoice(nStr);
          WriteSysLog(nStr);
          if FBarrierGate then
            OpenDoorByReader(FLastReader, sFlag_No);
          Timer_SaveFail.Enabled := True;
          Exit;
        end;
      end;
    end;
    
    if FInnerData.FPData.FValue > 0 then
    begin
      if nValue <= FInnerData.FPData.FValue then
      begin
        FUIData.FPData := FInnerData.FMData;
        FUIData.FMData := FInnerData.FPData;

        FUIData.FPData.FValue := nValue;
        FUIData.FNextStatus := sFlag_TruckBFP;
        //切换为称皮重
      end else
      begin
        FUIData.FPData := FInnerData.FPData;
        FUIData.FMData := FInnerData.FMData;

        FUIData.FMData.FValue := nValue;
        FUIData.FNextStatus := sFlag_TruckBFM;
        //切换为称毛重
      end;
    end else FUIData.FPData.FValue := nValue;
  end else
  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
       FUIData.FPData.FValue := nValue
  else FUIData.FMData.FValue := nValue;

  SetUIData(False);
  //更新界面
  {$IFDEF MITTruckProber}
    if not IsTunnelOK(FPoundTunnel.FID) then
  {$ELSE}
    {$IFDEF HR1847}
    if not gKRMgrProber.IsTunnelOK(FPoundTunnel.FID) then
    {$ELSE}
    if not gProberManager.IsTunnelOK(FPoundTunnel.FID) then
    {$ENDIF}
  {$ENDIF}
  begin
    nStr := '车辆未停到位,请移动车辆.';
    PlayVoice(nStr);
    LEDDisplay(nStr);

    {$IFDEF ProberShow}
      {$IFDEF MITTruckProber}
      ProberShowTxt(FPoundTunnel.FID, nStr);
      {$ELSE}
      gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
      {$ENDIF}
    {$ENDIF}
    InitSamples;
    Exit;
  end;
  FIsSaving := True;
//  if FCardUsed = sFlag_Provide then
//       nRet := SavePoundData
//  else nRet := SavePoundSale;

  if FCardUsed = sFlag_Sale then
       nRet := SavePoundSale
  else nRet := SavePoundData;

  if nRet then
  begin
    if (FCardUsed = sFlag_Sale) and (FBillItems[0].FType = sFlag_Dai)
       and (FBillItems[0].FNextStatus = sFlag_TruckBFM) then
      nStr := GetTruckNO(FUIData.FTruck) + '票重:' +
              GetValue(StrToFloatDef(EditZValue.Text,0))
    else
      nStr := GetTruckNO(FUIData.FTruck) + '重量:' + GetValue(nValue);
    LEDDisplay(nStr);

    {$IFDEF ProberShow}
      {$IFDEF MITTruckProber}
      ProberShowTxt(FPoundTunnel.FID, nStr);
      {$ELSE}
      gProberManager.ShowTxt(FPoundTunnel.FID, nStr);
      {$ENDIF}
    {$ENDIF}

    TimerDelay.Enabled := True
  end
  else
  begin
    Timer_SaveFail.Enabled := True;
    nStr := '本次称重无效,请下磅后联系管理员处理.';
    PlayVoice(nStr);
    LEDDisplay(nStr);
    WriteSysLog('车辆[ '+FUIData.FTruck+' ]称重无效.');
    Exit;
  end;

  if FBarrierGate and nRet then
    OpenDoorByReader(FLastReader, sFlag_No);
  //打开副道闸
end;

procedure TfFrameAutoPoundItem.TimerDelayTimer(Sender: TObject);
begin
  try
    TimerDelay.Enabled := False;
    WriteSysLog(Format('对车辆[ %s ]称重完毕.', [FUIData.FTruck]));
    PlayVoice(#9 + FUIData.FTruck);
    //播放语音

    FLastCard     := FCardTmp;
    FLastCardDone := GetTickCount;
    FDoneEmptyPoundInit := GetTickCount;
    //保存状态

    if not FBarrierGate then
      FIsWeighting := False;
    //磅上无道闸时，即时过磅完毕

    {$IFDEF MITTruckProber}
        TunnelOC(FPoundTunnel.FID, True);
    {$ELSE}
      {$IFDEF HR1847}
      gKRMgrProber.TunnelOC(FPoundTunnel.FID, True);
      {$ELSE}
      gProberManager.TunnelOC(FPoundTunnel.FID, True);
      {$ENDIF}
    {$ENDIF} //开红绿灯

    Timer2.Enabled := True;
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化样本
procedure TfFrameAutoPoundItem.InitSamples;
var nIdx: Integer;
begin
  SetLength(FValueSamples, FPoundTunnel.FSampleNum);
  FSampleIndex := Low(FValueSamples);

  for nIdx:=High(FValueSamples) downto FSampleIndex do
    FValueSamples[nIdx] := 0;
  //xxxxx
end;

//Desc: 添加采样
procedure TfFrameAutoPoundItem.AddSample(const nValue: Double);
begin
  FValueSamples[FSampleIndex] := nValue;
  Inc(FSampleIndex);

  if FSampleIndex >= FPoundTunnel.FSampleNum then
    FSampleIndex := Low(FValueSamples);
  //循环索引
end;

//Desc: 验证采样是否稳定
function TfFrameAutoPoundItem.IsValidSamaple: Boolean;
var nIdx: Integer;
    nVal: Integer;
begin
  Result := False;

  for nIdx:=FPoundTunnel.FSampleNum-1 downto 1 do
  begin
    if FValueSamples[nIdx] < 0.02 then Exit;
    //样本不完整

    nVal := Trunc(FValueSamples[nIdx] * 1000 - FValueSamples[nIdx-1] * 1000);
    if Abs(nVal) >= FPoundTunnel.FSampleFloat then Exit;
    //浮动值过大
  end;

  Result := True;
end;

procedure TfFrameAutoPoundItem.PlayVoice(const nStrtext: string);
begin
  {$IFNDEF DEBUG}
  if (Assigned(FPoundTunnel.FOptions)) and
     (CompareText('NET', FPoundTunnel.FOptions.Values['Voice']) = 0) then
       gNetVoiceHelper.PlayVoice(nStrtext, FPoundTunnel.FID, 'pound')
  else gVoiceHelper.PlayVoice(nStrtext);
  {$ENDIF}
end;

procedure TfFrameAutoPoundItem.Timer_SaveFailTimer(Sender: TObject);
begin
  inherited;
  try
    FDoneEmptyPoundInit := GetTickCount;
    Timer_SaveFail.Enabled := False;
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

procedure TfFrameAutoPoundItem.EditBillKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  try
    Key := #0;
    EditBill.Text := Trim(EditBill.Text);

    if FIsWeighting or EditBill.Properties.ReadOnly or
       (EditBill.Text = '') then
    begin
      SwitchFocusCtrl(ParentForm, True);
      Exit;
    end;

    {$IFDEF DEBUG}
    FCardTmp := EditBill.Text;
    LoadBillItems(EditBill.Text);
    {$ENDIF}
  finally
    EditBill.Enabled := True;
  end;
end;

procedure TfFrameAutoPoundItem.LEDDisplay(const nContent: string);
begin
  {$IFDEF BFLED}
  WriteSysLog(Format('LEDDisplay:%s.%s', [FPoundTunnel.FID, nContent]));
  if Assigned(FPoundTunnel.FOptions) And
     (UpperCase(FPoundTunnel.FOptions.Values['LEDEnable'])='Y') then
  begin
    if FLEDContent = nContent then Exit;
    FLEDContent := nContent;
    gDisplayManager.Display(FPoundTunnel.FID, nContent);
  end;
  {$ENDIF}
end;

function TfFrameAutoPoundItem.IfForceLable: Boolean;
var
  nStr: string;
begin
  Result := False;
  nStr := 'select * from %s where D_Name=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_IfFocreLabel]);
  with fdm.QueryTemp(nStr) do
  begin
    if FieldByName('D_Value').AsString = sflag_Yes then
      Result := True;
  end;
end;

function TfFrameAutoPoundItem.ChkPoundStatus: Boolean;
var nIdx:Integer;
    nHint : string;
begin
  Result:= True;
  try
    try
      FIsChkPoundStatus:= True;
      if not FPoundTunnel.FUserInput then
      if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
             OnPoundDataEvent, True) then
      begin
        nHint := '检查地磅：连接地磅表头失败，请联系管理员检查硬件连接';
        WriteSysLog(nHint);
        PlayVoice(nHint);
        Result:= False;
        Exit;
      end;

      for nIdx:= 0 to 5 do
      begin
        Sleep(500);
        Application.ProcessMessages;
        if StrToFloatDef(Trim(EditValue.Text), -1) > 0.12 then
        begin
          Result:= False;
          nHint := '检查地磅：地磅称重重量 %s ,不能进行称重作业';
          nhint := Format(nHint, [EditValue.Text]);
          WriteSysLog(nHint);

          PlayVoice('当前地磅不在称重状态,相关车辆及人员请下磅');
          Break;
        end;
      end;
    except  on E: Exception do
      begin
        WriteSysLog(Format('磅站 %s.%s : 检查地磅状态 %s', [FPoundTunnel.FID,
                                                 FPoundTunnel.FName, E.Message]));
      end;
    end;
  finally
    FIsChkPoundStatus:= False;
    SetUIData(True);
  end;
end;

end.

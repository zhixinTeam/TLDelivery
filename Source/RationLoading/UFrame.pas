unit UFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,PLCController, ULEDFont, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, UMgrPoundTunnels,
  ExtCtrls, IdTCPServer, IdContext, IdGlobal, UBusinessConst, ULibFun,
  Menus, cxButtons, UMgrSendCardNo, USysLoger, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxSpinEdit, DateUtils;

type
  TFrame1 = class(TFrame)
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    btnPause: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton1: TToolButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    cxLabel4: TcxLabel;
    EditBill: TcxComboBox;
    cxLabel5: TcxLabel;
    EditTruck: TcxComboBox;
    cxLabel7: TcxLabel;
    EditCusID: TcxComboBox;
    cxLabel8: TcxLabel;
    EditStockID: TcxComboBox;
    cxLabel6: TcxLabel;
    EditMaxValue: TcxTextEdit;
    cxLabel1: TcxLabel;
    editPValue: TcxTextEdit;
    cxLabel2: TcxLabel;
    editZValue: TcxTextEdit;
    editNetValue: TLEDFontNum;
    editBiLi: TLEDFontNum;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    IncTon: TcxSpinEdit;
    BtnStop: TButton;
    ControlTimer: TTimer;
    cxLabel11: TcxLabel;
    IncMin: TcxSpinEdit;
    BtnStart: TButton;
    LblWarn: TcxLabel;
    procedure ControlTimerTimer(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure IncMinPropertiesChange(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
  private
    { Private declarations }
    FUserCtrl: Boolean;           //手动控制
    FCardUsed: string;            //卡片类型
    FUIData: TLadingBillItem;     //界面数据
    FPoundTunnel: PPTTunnelItem;  //磅站通道
    FCard : string;
    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //设置界面数据
    procedure OnPoundDataEvent(const nValue: Double);
    procedure OnPoundData(const nValue: Double);
    //读取磅重
    procedure SetTunnel(const Value: PPTTunnelItem);
    procedure WriteLog(const nEvent: string);
    function CalControlTime: Boolean;
  public
    FrameId:Integer;              //PLC通道
    FIsBusy: Boolean;             //占用标识
    FSysLoger : TSysLoger;
    Fcontroller:TPLCController;
    FTCPSer:TIdTCPServer;
    FSpd: Integer;//放灰速度(秒)
    FPreKd: Double;//预扣量
    FTimeControl: Boolean;//是否启用定时
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    procedure LoadBillItems(const nCard: string);
    //读取交货单
    procedure StopPound;
  end;

implementation

{$R *.dfm}

uses
   USysBusiness, USysDB, USysConst, UDataModule, UFormInputbox;

//Parm: 磁卡或交货单号
//Desc: 读取nCard对应的交货单
procedure TFrame1.LoadBillItems(const nCard: string);
var
  nStr, nHint, nTmp: string;
  nIdx: integer;
  nBills: TLadingBillItems;
  nRet: Boolean;
begin
  FCard := nCard;
  FCardUsed := GetCardUsed(nCard);
  if FCardUsed=sFlag_Provide then
       nRet := GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)
  else nRet := GetLadingBills(nCard, sFlag_TruckBFP, nBills);

  if (not nRet) or (Length(nBills) < 1) then
  begin
    nStr := '读取磁卡信息失败,请联系管理员';
    WriteLog(nStr);
    SetUIData(True);
    Exit;
  end;

  //获取最大限载值
  //nBills[0].FMData.FValue := StrToFloatDef(GetLimitValue(nBills[0].FTruck),0);

  FUIData := nBills[0];

  FTimeControl := False;
  FPreKd := 0;
  LblWarn.Caption := '';

  if Assigned(FPoundTunnel.FOptions) And
     (UpperCase(FPoundTunnel.FOptions.Values['SPT']) <> '') then
  begin
    FTimeControl := True;
    FSpd := StrToIntDef(FPoundTunnel.FOptions.Values['SPT'],5);
    FPreKd := StrToFloatDef(FPoundTunnel.FOptions.Values['PreKd'],0.05);
  end
  else
  begin
    cxLabel1.Visible := False;
    IncMin.Visible := False;
  end;

  if Assigned(FPoundTunnel.FOptions) then
  begin
    FPreKd := StrToFloatDef(FPoundTunnel.FOptions.Values['PreKd'],0.05);
  end;

  SetUIData(False);

  if not FPoundTunnel.FUserInput then
  if not gPoundTunnelManager.ActivePort(FPoundTunnel.FID,
         OnPoundDataEvent, True) then
  begin
    nHint := '连接地磅表头失败，请联系管理员检查硬件连接';
    WriteLog(nHint);
    SetUIData(True);
    Exit;
  end;

  if FTimeControl  then
  begin
    if CalControlTime then
      ControlTimer.Enabled := True
    else
    begin
      ControlTimer.Enabled := False;
      StopPound;
      Exit;
    end;
  end;

  FIsBusy := True;

end;

procedure TFrame1.SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
var
  nItem: TLadingBillItem;
begin
  if nReset then
  begin
    FillChar(nItem, SizeOf(nItem), #0);
    nItem.FFactory := gSysParam.FFactNum;

    FUIData := nItem;
    if nOnlyData then Exit;

    EditValue.Text := '0.00';
    editNetValue.Text := '0.00';
    editBiLi.Text := '0';
    EditBill.Properties.Items.Clear;
  end;

  with FUIData do
  begin
    EditBill.Text := FID;
    EditTruck.Text := FTruck;
    EditStockID.Text := FStockName;
    EditCusID.Text := FCusName;

    EditMaxValue.Text := Format('%.2f', [FMData.FValue]);
    EditPValue.Text := Format('%.2f', [FPData.FValue]);
    EditZValue.Text := Format('%.2f', [FValue]);
  end;
end;

procedure TFrame1.OnPoundDataEvent(const nValue: Double);
begin
  try
    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteLog(Format('磅站[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      SetUIData(True);
    end;
  end;
end;

procedure TFrame1.OnPoundData(const nValue: Double);
var
  nStr: string;
  nPValue, nZValue, nNetValue, nBiLi, nManuValue : Double;
  nFD: integer;
begin
  nPValue := StrToFloat(editPValue.Text);    //皮重
  nZValue := StrToFloat(editZValue.Text);    //票重
  nNetValue := nValue - nPValue;             //净重

  nManuValue := IncTon.Value;                //人工干预量

  nBiLi := 0;
  if nZValue > 0 then
    nBiLi := nNetValue/nZValue *100;                //完成比例

  EditValue.Text := Format('%.2f', [nValue]);
  editNetValue.Text := Format('%.2f',[nNetValue]);
  editBiLi.Text := Format('%.2f',[nBiLi]);

  //超时停止放灰
  if FTimeControl and ( ControlTimer.Tag <= 0 ) then
  begin
    StopPound;
    writelog(GroupBox1.Caption+' 装车超时,自动发送停止指令,时间：'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
    //ShowMsg('超过限载,自动发送停止指令.',sHint);
    Exit;
  end;

  //超过限载重量停止放灰
  if (nValue+0.1 > FUIData.FMData.FValue) and (FUIData.FMData.FValue>1) then
  begin
    StopPound;
    writelog(GroupBox1.Caption+' 超过限载,自动发送停止指令,时间：'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
    //ShowMsg('超过限载,自动发送停止指令.',sHint);
    Exit;
  end;
  //达到提货量停止放灰
  if (nNetValue - nManuValue +0.1 > FUIData.FValue * (1 - FPreKd)) and (FUIData.FValue > 0.1) then
  begin
    StopPound;
    LblWarn.Caption := FUIData.FTruck + '达到提货量,发送停止命令';
    writelog(GroupBox1.Caption+' 达到提货量,自动发送停止指令,时间：'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
    Exit;
  end;

end;

procedure TFrame1.WriteLog(const nEvent: string);
begin
  FSysLoger.AddLog(TFrame, '定置装车主单元', nEvent);
end;

procedure TFrame1.SetTunnel(const Value: PPTTunnelItem);
begin
  FPoundTunnel := Value;
  SetUIData(true);
  FUserCtrl := false;
end;

procedure TFrame1.StopPound;
begin
  LineClose(FPoundTunnel.FID, sFlag_Yes);
  SetUIData(true);
  FIsBusy := False;
  ControlTimer.Enabled := False;
  BtnStop.Caption := '停止';
  writelog(GroupBox1.Caption+' 停止称重, 时间：'+formatdatetime('yyyy-mm-dd HH:MM:ss',Now));
end;

function TFrame1.CalControlTime: Boolean;
var nValue : Double;
begin
  Result := False;
  try
    nValue := StrToFloatDef(editZValue.Text,0) * (1 - FPreKd) * FSpd + IncMin.Value * 60;
    if Trim(FUIData.FLadeTime) <> '' then
      nValue := nValue - SecondsBetween(Now, StrToDateTime(FUIData.FLadeTime));
    ControlTimer.Tag := Round(nValue);

    Result := ControlTimer.Tag > 0;

    if not Result then
      LblWarn.Caption := FUIData.FTruck + '提货时间:' + FUIData.FLadeTime
                         + '提货超时';
  except
  end;
end;

procedure TFrame1.ControlTimerTimer(Sender: TObject);
var nStr, nTmp: string;
begin
  ControlTimer.Tag := ControlTimer.Tag - 1;

//  nStr := FUIData.FTruck + StringOfChar(' ', 12 - Length(FUIData.FTruck));
//  nTmp := '倒计时';
//  nStr := nStr + nTmp + IntToStr(ControlTimer.Tag);
//  //xxxxx
//
//  ShowLedText(FPoundTunnel.FID,nStr);

  BtnStop.Caption := IntToStr(ControlTimer.Tag) + '秒后停止,点击停止';
  if ControlTimer.Tag <= 0 then
    StopPound;
end;

procedure TFrame1.BtnStopClick(Sender: TObject);
begin
  StopPound;
end;

procedure TFrame1.IncMinPropertiesChange(Sender: TObject);
begin
  CalControlTime;
end;

procedure TFrame1.BtnStartClick(Sender: TObject);
var nStr: string;
begin
  nStr := FCard;
  if not ShowInputBox('请输入磁卡号:', '提示', nStr) then Exit;
  LineClose(FPoundTunnel.FID, sFlag_No);
  LoadBillItems(nStr);
end;

end.

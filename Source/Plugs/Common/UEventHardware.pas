{*******************************************************************************
  作者: dmzn@163.com 2013-11-23
  描述: 模块工作对象,用于响应框架事件
*******************************************************************************}
unit UEventHardware;

{$I Link.Inc}
interface

uses
  Windows, Classes, UMgrPlug, UBusinessConst, ULibFun, UMITConst, UPlugConst;

type
  THardwareWorker = class(TPlugEventWorker)
  public
    class function ModuleInfo: TPlugModuleInfo; override;
    procedure RunSystemObject(const nParam: PPlugRunParameter); override;
    procedure InitSystemObject; override;
    //主程序启动时初始化
    procedure BeforeStartServer; override;
    //服务启动之前调用
    procedure AfterStopServer; override;
    //服务关闭之后调用
    {$IFDEF DEBUG}
    procedure GetExtendMenu(const nList: TList); override;
    {$ENDIF}
  end;

var
  gPlugRunParam: TPlugRunParameter;
  //运行参数

implementation

uses
  SysUtils, USysLoger, UHardBusiness, UMgrTruckProbe, UMgrParam,
  UMgrQueue, UMgrLEDCard, UMgrHardHelper, UMgrRemotePrint, U02NReader,
  {$IFDEF MultiReplay}UMultiJS_Reply, {$ELSE}UMultiJS, {$ENDIF}
  UMgrERelay, UMgrRemoteVoice, UMgrCodePrinter, UMgrTTCEM100,
  UMgrRFID102, UMgrVoiceNet, UBlueReader, UMgrSendCardNo,
  UMgrRemoteSnap, UMgrBXFontCard;

class function THardwareWorker.ModuleInfo: TPlugModuleInfo;
begin
  Result := inherited ModuleInfo;
  with Result do
  begin
    FModuleID := sPlug_ModuleHD;
    FModuleName := '硬件守护';
    FModuleVersion := '2014-09-30';
    FModuleDesc := '提供水泥一卡通发货的硬件处理对象';
    FModuleBuildTime:= Str2DateTime('2014-09-30 15:01:01');
  end;
end;

procedure THardwareWorker.RunSystemObject(const nParam: PPlugRunParameter);
var nStr,nCfg: string;
begin
  gPlugRunParam := nParam^;
  nCfg := gPlugRunParam.FAppPath + 'Hardware\';

  try
    {$IFDEF DL_LEDPlay}
    nStr := 'LED';
    gCardManager.TempDir := nCfg + 'Temp\';
    gCardManager.FileName := nCfg + 'LED.xml';
    {$ENDIF}

    nStr := '远距读头';
    gHardwareHelper.LoadConfig(nCfg + '900MK.xml');

    nStr := '蓝卡读卡器';
    gBlueReader.LoadConfig(nCfg + 'BlueCardReader.XML');

    nStr := '近距读头';
    g02NReader.LoadConfig(nCfg + 'Readers.xml');

    {$IFDEF DL_Count}
    nStr := '计数器';
    gMultiJSManager.LoadFile(nCfg + 'JSQ.xml');
    {$ENDIF}

    nStr := '继电器';
    gERelayManager.LoadConfig(nCfg + 'ERelay.xml');

    nStr := '远程打印';
    gRemotePrinter.LoadConfig(nCfg + 'Printer.xml');

    nStr := '语音服务';
    gVoiceHelper.LoadConfig(nCfg + 'Voice.xml');

    nStr := '网络语音服务';
    if FileExists(nCfg + 'NetVoice.xml') then
    begin
      if not Assigned(gNetVoiceHelper) then
        gNetVoiceHelper := TNetVoiceManager.Create;
      gNetVoiceHelper.LoadConfig(nCfg + 'NetVoice.xml');
    end;

    {$IFDEF DL_CodePrint}
    nStr := '喷码机';
    gCodePrinterManager.LoadConfig(nCfg + 'CodePrinter.xml');
    {$ENDIF}

    {$IFDEF HYRFID201}
    nStr := '华益RFID102';
    if not Assigned(gHYReaderManager) then
    begin
      gHYReaderManager := THYReaderManager.Create;
      gHYReaderManager.LoadConfig(nCfg + 'RFID102.xml');
    end;
    {$ENDIF}

    {$IFDEF TTCEM100}
    nStr := '三合一读卡器';
    if not Assigned(gM100ReaderManager) then
    begin
      gM100ReaderManager := TM100ReaderManager.Create;
      gM100ReaderManager.LoadConfig(nCfg + cTTCE_M100_Config);
    end;
    {$ENDIF}

    nStr := '车辆检测器';
    if FileExists(nCfg + 'TruckProber.xml') then
    begin
      gProberManager := TProberManager.Create;
      gProberManager.LoadConfig(nCfg + 'TruckProber.xml');
    end;

    {$IFDEF FixLoad}
    nStr := '定置装车';
    gSendCardNo.LoadConfig(nCfg + 'PLCController.xml');
    {$ENDIF}

    {$IFDEF RemoteSnap}
    nStr := '海康威视远程抓拍';
    if FileExists(nCfg + 'RemoteSnap.xml') then
    begin
      //gHKSnapHelper := THKSnapHelper.Create;
      gHKSnapHelper.LoadConfig(nCfg + 'RemoteSnap.xml');
    end;
    {$ENDIF}

    {$IFDEF OutDoorLedPlay}
    nStr := '出厂票箱LED显示';
    if FileExists(nCfg + 'BXFontLED.xml') then
    begin
      if not Assigned(gBXFontCardManager) then
        gBXFontCardManager := TBXFontCardManager.Create;
      gBXFontCardManager.LoadConfig(nCfg + 'BXFontLED.xml');
    end;
    {$ENDIF}
  except
    on E:Exception do
    begin
      nStr := Format('加载[ %s ]配置文件失败: %s', [nStr, E.Message]);
      gSysLoger.AddLog(nStr);
    end;
  end;
end;

{$IFDEF DEBUG}
procedure THardwareWorker.GetExtendMenu(const nList: TList);
var nItem: PPlugMenuItem;
begin
  New(nItem);
  nList.Add(nItem);
  nItem.FName := 'Menu_Param_2';

  nItem.FModule := ModuleInfo.FModuleID;
  nItem.FCaption := '硬件测试';
  nItem.FFormID := cFI_FormTest2;
  nItem.FDefault := False;
end;
{$ENDIF}

procedure THardwareWorker.InitSystemObject;
begin
  gHardwareHelper := THardwareHelper.Create;
  //远距读头

  if not Assigned(g02NReader) then
    g02NReader := T02NReader.Create;
  //近距读头

  {$IFDEF DL_Count}
  if not Assigned(gMultiJSManager) then
    gMultiJSManager := TMultiJSManager.Create;
  //计数器
  {$ENDIF}

  gHardShareData := WhenBusinessMITSharedDataIn;
  //hard monitor share

  {$IFDEF FixLoad}
  gSendCardNo := TReaderHelper.Create;
  {$ENDIF}

  {$IFDEF RemoteSnap}
  gHKSnapHelper := THKSnapHelper.Create;
  //remote snap
  {$ENDIF}

  {$IFDEF OutDoorLedPlay}
  gBXFontCardManager := TBXFontCardManager.Create;
  {$ENDIF}
end;

procedure THardwareWorker.BeforeStartServer;
begin
  gTruckQueueManager.StartQueue(gParamManager.ActiveParam.FDB.FID);
  //truck queue

  gHardwareHelper.OnProce := WhenReaderCardArrived;
  gHardwareHelper.StartRead;
  //long reader

  gBlueReader.OnCardArrived := WhenBlueReaderCardArrived;
  if not gHardwareHelper.ConnHelper then gBlueReader.StartReader;
  //blue reader, 如果不使用硬件守护服务器，则服务器独自读卡

  {$IFDEF HYRFID201}
  if Assigned(gHYReaderManager) then
  begin
    gHYReaderManager.OnCardProc := WhenHYReaderCardArrived;
    gHYReaderManager.StartReader;
  end;
  {$ENDIF}

  g02NReader.OnCardIn := WhenReaderCardIn;
  g02NReader.OnCardOut := WhenReaderCardOut;
  g02NReader.StartReader;
  //near reader

  {$IFDEF DL_Count}
  gMultiJSManager.SaveDataProc := WhenSaveJS;
  gMultiJSManager.GetTruckProc := GetJSTruck;
  gMultiJSManager.StartJS;
  //counter
  {$ENDIF}

  gERelayManager.ControlStart;
  //erelay

  gRemotePrinter.StartPrinter;
  //printer
  gVoiceHelper.StartVoice;
  //voice

  if Assigned(gNetVoiceHelper) then
    gNetVoiceHelper.StartVoice;
  //NetVoice

  {$IFDEF DL_LEDPlay}
  gCardManager.StartSender;
  //led display
  {$ENDIF}

  {$IFDEF MITTruckProber}
  gProberManager.StartProber;
  {$ENDIF} //truck

  {$IFDEF TTCEM100}
  if Assigned(gM100ReaderManager) then
  begin
    gM100ReaderManager.OnCardProc := WhenTTCE_M100_ReadCard;
    gM100ReaderManager.StartReader;
  end; //三合一读卡器
  {$ENDIF}

  {$IFDEF FixLoad}
  if Assigned(gSendCardNo) then
  gSendCardNo.StartPrinter;
  //sendcard
  {$ENDIF}

  {$IFDEF RemoteSnap}
  gHKSnapHelper.StartSnap;
  //remote snap
  {$ENDIF}

  {$IFDEF OutDoorLedPlay}
  if Assigned(gBXFontCardManager) then
    gBXFontCardManager.StartService;
  {$ENDIF}
end;

procedure THardwareWorker.AfterStopServer;
begin
  gVoiceHelper.StopVoice;
  //voice
  gRemotePrinter.StopPrinter;
  //printer
  if Assigned(gNetVoiceHelper) then
    gNetVoiceHelper.StopVoice;
  //NetVoice

  gERelayManager.ControlStop;
  //erelay

  {$IFDEF DL_Count}
  gMultiJSManager.StopJS;
  //counter
  {$ENDIF}

  g02NReader.StopReader;
  g02NReader.OnCardIn := nil;
  g02NReader.OnCardOut := nil;

  gHardwareHelper.StopRead;
  gHardwareHelper.OnProce := nil;
  //reader

  gBlueReader.StopReader;
  gBlueReader.OnCardArrived := nil;
  //blue reader

  {$IFDEF HYRFID201}
  if Assigned(gHYReaderManager) then
  begin
    gHYReaderManager.StopReader;
    gHYReaderManager.OnCardProc := nil;
  end;
  {$ENDIF}

  {$IFDEF DL_LEDPlay}
  gCardManager.StopSender;
  //led
  {$ENDIF}

  {$IFDEF MITTruckProber}
  gProberManager.StopProber;
  {$ENDIF} //truck

  {$IFDEF TTCEM100}
  if Assigned(gM100ReaderManager) then
  begin
    gM100ReaderManager.StopReader;
    gM100ReaderManager.OnCardProc := nil;
  end; //三合一读卡器
  {$ENDIF}

  gTruckQueueManager.StopQueue;
  //queue

  {$IFDEF FixLoad}
  if Assigned(gSendCardNo) then
  gSendCardNo.StopPrinter;
  //sendcard
  {$ENDIF}

  {$IFDEF RemoteSnap}
  gHKSnapHelper.StopSnap;
  //remote snap
  {$ENDIF}

  {$IFDEF OutDoorLedPlay}
  gBXFontCardManager.StopService;
  //outDoor Led
  {$ENDIF}
end;

end.

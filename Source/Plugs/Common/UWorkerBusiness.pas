{*******************************************************************************
  ����: dmzn@163.com 2013-12-04
  ����: ģ��ҵ�����
*******************************************************************************}
unit UWorkerBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, UBase64,
  USysLoger, USysDB, UMITConst, DateUtils, IdHTTP, SuperObject, IdURI;

type
  TBusWorkerQueryField = class(TBusinessWorkerBase)
  private
    FIn: TWorkerQueryFieldData;
    FOut: TWorkerQueryFieldData;
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
  end;

  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //������
    FDBConn: PDBWorker;
    //����ͨ��
    FDataIn,FDataOut: PBWDataBase;
    //��γ���
    FDataOutNeedUnPack: Boolean;
    //��Ҫ���
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //�������
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //��֤���
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //����ҵ��
  public
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
    procedure WriteLog(const nEvent: string);
    //��¼��־
  end;

  TK3SalePalnItem = record
    FInterID: string;       //������
    FEntryID: string;       //������
    FTruck: string;         //���ƺ�
  end;

  TWorkerBusinessCommander = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCardUsed(var nData: string): Boolean;
    //��ȡ��Ƭ����
    function Login(var nData: string):Boolean;
    function LogOut(var nData: string): Boolean;
    //��¼ע���������ƶ��ն�
    function GetServerNow(var nData: string): Boolean;
    //��ȡ������ʱ��
    function GetSerailID(var nData: string): Boolean;
    //��ȡ����
    function IsSystemExpired(var nData: string): Boolean;
    //ϵͳ�Ƿ��ѹ���
    function GetCustomerValidMoney(var nData: string): Boolean;
    //��ȡ�ͻ����ý�
    function GetZhiKaValidMoney(var nData: string): Boolean;
    //��ȡֽ�����ý�
    function CustomerHasMoney(var nData: string): Boolean;
    //��֤�ͻ��Ƿ���Ǯ
    function SaveTruck(var nData: string): Boolean;
    function UpdateTruck(var nData: string): Boolean;
    //���泵����Truck��
    function GetTruckPoundData(var nData: string): Boolean;
    function SaveTruckPoundData(var nData: string): Boolean;
    //��ȡ������������
    function GetStockBatcode(var nData: string): Boolean;
    //��ȡƷ�����κ�
    function SyncRemoteStockBill(var nData: string): Boolean;
    //ͬ����������ERP
    function SyncBillToGPS(var nData: string): Boolean;
    //ͬ����������GPSϵͳ
    function SyncRemoteStockOrder(var nData: string): Boolean;
    //ͬ���ɹ�����ERP
    function SyncRemoteCustomer(var nData: string): Boolean;
    //ͬ���ͻ�
    function SyncRemoteProviders(var nData: string): Boolean;
    //ͬ����Ӧ��

    procedure SaveHyDanEvent(const nStockno,nEvent,
          nFrom,nSolution,nDepartment: string);
    //���ɻ��鵥�����¼�
    function GetCardLength(var nData: string): Boolean;
    //��ȡ�����Ƿ��ǳ��ڿ�
    function VerifySnapTruck(var nData: string): Boolean;
    //���Ʊȶ�
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

class function TBusWorkerQueryField.FunctionName: string;
begin
  Result := sBus_GetQueryField;
end;

function TBusWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
  end;
end;

function TBusWorkerQueryField.DoWork(var nData: string): Boolean;
begin
  FOut.FData := '*';
  FPacker.UnPackIn(nData, @FIn);

  case FIn.FType of
   cQF_Bill: 
    FOut.FData := '*';
  end;

  Result := True;
  FOut.FBase.FResult := True;
  nData := FPacker.PackOut(@FOut);
end;

//------------------------------------------------------------------------------
//Date: 2012-3-13
//Parm: ���������
//Desc: ��ȡ�������ݿ��������Դ
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      nData := FPacker.PackOut(FDataOut);

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

//Date: 2012-3-22
//Parm: �������;���
//Desc: ����ҵ��ִ����Ϻ����β����
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: �������
//Desc: ��֤��������Ƿ���Ч
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: ��¼nEvent��־
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TWorkerBusinessCommander.FunctionName: string;
begin
  Result := sBus_BusinessCommand;
end;

constructor TWorkerBusinessCommander.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessCommander.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessCommander.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TWorkerBusinessCommander.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-22
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessCommander.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
    cBC_GetCardUsed         : Result := GetCardUsed(nData);
    cBC_ServerNow           : Result := GetServerNow(nData);
    cBC_GetSerialNO         : Result := GetSerailID(nData);
    cBC_IsSystemExpired     : Result := IsSystemExpired(nData);
    cBC_GetCustomerMoney    : Result := GetCustomerValidMoney(nData);
    cBC_GetZhiKaMoney       : Result := GetZhiKaValidMoney(nData);
    cBC_CustomerHasMoney    : Result := CustomerHasMoney(nData);
    cBC_SaveTruckInfo       : Result := SaveTruck(nData);
    cBC_UpdateTruckInfo     : Result := UpdateTruck(nData);
    cBC_GetTruckPoundData   : Result := GetTruckPoundData(nData);
    cBC_SaveTruckPoundData  : Result := SaveTruckPoundData(nData);
    cBC_UserLogin           : Result := Login(nData);
    cBC_UserLogOut          : Result := LogOut(nData);
    cBC_GetStockBatcode     : Result := GetStockBatcode(nData);

    //ͬ�����������ɹ������ͻ�����Ӧ��
    cBC_SyncStockBill       : Result := SyncRemoteStockBill(nData);
    cBC_SyncStockOrder      : Result := SyncRemoteStockOrder(nData);
    cBC_SyncCustomer        : Result := SyncRemoteCustomer(nData);
    cBC_SyncProvider        : Result := SyncRemoteProviders(nData);

    cBC_GetCardLength       : Result := GetCardLength(nData);     //��ȡ���Ƿ��ǳ��ڿ�
    cBC_VerifySnapTruck     : Result := VerifySnapTruck(nData);

    cBC_SyncBillToGPS       :  Result := SyncBillToGPS(nData);
  else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;

//Date: 2014-09-05
//Desc: ��ȡ��Ƭ���ͣ�����S;�ɹ�P;����O
function TWorkerBusinessCommander.GetCardUsed(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select C_Used From %s Where C_Card=''%s'' ' +
          'or C_Card3=''%s'' or C_Card2=''%s''';
  nStr := Format(nStr, [sTable_Card, FIn.FData, FIn.FData, FIn.FData]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then
    begin
      nData := '�ſ�[ %s ]��Ϣ������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FOut.FData := Fields[0].AsString;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: �û��������룻�����û�����
//Desc: �û���¼
function TWorkerBusinessCommander.Login(var nData: string): Boolean;
var
  nStr: string;
  nID, nWLBId, nHysID:string;
begin
  Result := False;

  FListA.Clear;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if FListA.Values['User']='' then Exit;
  //δ�����û���

  nStr := 'Select U_Password,U_Group From %s Where U_Name=''%s''';
  nStr := Format(nStr, [sTable_User, FListA.Values['User']]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    nStr := Fields[0].AsString;
    if nStr<>FListA.Values['Password'] then Exit;
    nID := Fields[1].AsString;

    nStr := 'select * from %s where D_Name=''%s''';
    nStr := Format(nStr,[sTable_SysDict,sFlag_HYSGroup]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount<1 then Exit;

      nHysID := FieldByName('D_Value').AsString;
    end;

    nStr := 'select * from %s where D_Name=''%s''';
    nStr := Format(nStr,[sTable_SysDict,sFlag_WLBGroup]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount<1 then Exit;
      
      nWLBId := FieldByName('D_Value').AsString;
    end;
    if nID = nHysID then
      FOut.FData := sFlag_HYSGroup
    else
    if nID = nWLBId then
      FOut.FData := sFlag_WLBGroup
    else
    begin
      FOut.FData := 'û������Ȩ��.';
      Exit;
    end;
    
    Result := True;
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: �û�������֤����
//Desc: �û�ע��
function TWorkerBusinessCommander.LogOut(var nData: string): Boolean;
//var nStr: string;
begin
  {nStr := 'delete From %s Where I_ItemID=''%s''';
  nStr := Format(nStr, [sTable_ExtInfo, PackerDecodeStr(FIn.FData)]);
  //card status

  
  if gDBConnManager.WorkerExec(FDBConn, nStr)<1 then
       Result := False
  else Result := True;     }

  Result := True;
end;

//Date: 2014-09-05
//Desc: ��ȡ��������ǰʱ��
function TWorkerBusinessCommander.GetServerNow(var nData: string): Boolean;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  //sql

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    FOut.FData := DateTime2Str(Fields[0].AsDateTime);
    Result := True;
  end;
end;

//Date: 2012-3-25
//Desc: �������������б��
function TWorkerBusinessCommander.GetSerailID(var nData: string): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    Result := False;
    FListA.Text := FIn.FData;
    //param list

    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, FListA.Values['Group'],
            FListA.Values['Object']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
            FListA.Values['Group'], FListA.Values['Object']]);
    //xxxxx

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := 'û��[ %s.%s ]�ı�������.';
        nData := Format(nData, [FListA.Values['Group'], FListA.Values['Object']]);

        FDBConn.FConn.RollbackTrans;
        Exit;
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if FIn.FExtParam = sFlag_Yes then //�����ڱ���
      begin
        nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
        //old date

        if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
           (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
        begin
          nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                  'Where B_Group=''%s'' And B_Object=''%s''';
          nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                  FListA.Values['Group'], FListA.Values['Object']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nB := '1';
          nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
          //now date
        end;

        System.Delete(nStr, 1, 2);
        //yymmdd
        nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
        FOut.FData := nP + nStr + StringOfChar('0', nInt) + nB;
      end else
      begin
        nInt := nInt - Length(nP) - Length(nB);
        nStr := StringOfChar('0', nInt);
        FOut.FData := nP + nStr + nB;
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-05
//Desc: ��֤ϵͳ�Ƿ��ѹ���
function TWorkerBusinessCommander.IsSystemExpired(var nData: string): Boolean;
var nStr: string;
    nDate: TDate;
    nInt: Integer;
begin
  nDate := Date();
  //server now

  nStr := 'Select D_Value,D_ParamB From %s ' +
          'Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := 'dmzn_stock_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if nStr = Fields[1].AsString then
      nDate := Str2Date(Fields[0].AsString);
    //xxxxx
  end;

  nInt := Trunc(nDate - Date());
  Result := nInt > 0;

  if nInt <= 0 then
  begin
    nStr := 'ϵͳ�ѹ��� %d ��,����ϵ����Ա!!';
    nData := Format(nStr, [-nInt]);
    Exit;
  end;

  FOut.FData := IntToStr(nInt);
  //last days

  if nInt <= 7 then
  begin
    nStr := Format('ϵͳ�� %d ������', [nInt]);
    FOut.FBase.FErrDesc := nStr;
    FOut.FBase.FErrCode := sFlag_ForceHint;
  end;
end;

{$IFDEF COMMON}
//Date: 2014-09-05
//Desc: ��ȡָ���ͻ��Ŀ��ý��
function TWorkerBusinessCommander.GetCustomerValidMoney(var nData: string): Boolean;
var nStr, nCont, nCusId: string;
    nUseCredit: Boolean;
    nVal,nFrozen: Double;
    nCErpWorker: PDBWorker;
begin
  Result := False;
  nCErpWorker := nil;
  nCusId := FIn.FData;
  
  nStr := 'select contractCode from sal.SAL_Contract_v '+
          ' where (contractStat in (''Formal'' , ''Balance'')) '+
          ' and enableFlag=''Y'' and accountCode=''%s''';
  nStr := Format(nStr,[FIn.FData]);

  try
    with gDBConnManager.SQLQuery(nStr, nCErpWorker, sFlag_CErp) do
    begin
      if recordcount <> 1 then
      begin
        nData := '�ͻ�û�����۶���.';
        Exit;
      end;
      if recordcount = 0 then
      begin
        nData := '�ͻ��ж���һ�����۶���.';
        Exit;
      end;
      nCont := fieldbyname('contractCode').AsString;
      fin.FData := nCont;
    end;
    if not GetZhiKaValidMoney(nCont) then
    begin
      nData := '��ѯ�ͻ��ʽ�ʧ��.';
      Exit;
    end;
    nVal := StrToFloat(FOut.FData);
  finally
    gDBConnManager.ReleaseConnection(nCErpWorker);
  end;

  nStr := 'select * from %s where A_CID=''%s''';
  nStr := Format(nStr,[sTable_CusAccount,nCusId]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
      nFrozen := fieldbyname('A_FreezeMoney').AsFloat;
  end;
  nVal := nVal + nfrozen;
  nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;

  FOut.FData := FloatToStr(nVal);

  FOut.FData := FloatToStr(nVal);
  FOut.FExtParam := FloatToStr(nFrozen);
  Result := True;
end;
{$ENDIF}

{$IFDEF COMMON}
//Date: 2014-09-05
//Desc: ��ȡָ��ֽ���Ŀ��ý��
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr, nCusId: string;
    nCErpWorker, nCErpWorker2: PDBWorker;
    nVal,nMoney,nCredit: Double;
begin
  Result := False;
  nCErpWorker := nil;
  nCErpWorker2 := nil;
  nVal := 0;
  nCredit := 0;

  nStr := 'select isnull(sum(rtnSum), 0) as col_0_0_,accountCode from '+
          ' SAL.SAL_ContractRtn where contractCode=''$ZID'' group by accountCode';
  nStr := MacroValue(nStr, [ MI('$ZID', FIn.FData)]);
  //xxxxx
  try
    with gDBConnManager.SQLQuery(nStr, nCErpWorker, sFlag_CErp) do
    begin
      if RecordCount < 1 then
      begin
        nData := '���Ϊ[ %s ]�ĺ�ͬ������,���ͬ��Ч.';
        nData := Format(nData, [FIn.FData]);

        Result := False;
        Exit;
      end;
      nMoney := Fields[0].AsFloat;
      nCusId := Fields[1].AsString;
    end;

    nStr := 'select * from SAL.SAL_Contract where contractCode=''%s''' ;
    nStr := Format(nStr,[FIn.FData]);
    with gDBConnManager.SQLQuery(nStr, nCErpWorker2, sFlag_CErp) do
    begin
      if RecordCount > 0 then
      begin
        {$IFDEF QSTL}
        if FieldByName('contracttypecode').AsString = '00006' then  //��Ƿ��ͬ
        {$ELSE}
        if FieldByName('paytypecode').AsString = '00002' then  //��Ƿ��ͬ
        {$ENDIF}
          nCredit := FieldByName('oweValue').AsFloat;
      end;

      if FieldByName('invalidDate').AsDateTime < Now then
      begin
        nData := '���Ϊ['+FIn.FData+']��ͬ�Ѿ�����';
        Result := False;
        Exit;
      end;
    end;

    nStr := 'select * from %s where A_CID=''%s''';
    nStr := Format(nStr,[sTable_CusAccount,nCusId]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount > 0 then
        nVal := fieldbyname('A_FreezeMoney').AsFloat;
    end;

    FOut.FData := FloatToStr(nMoney + nCredit - nVal);

    writelog('����['+FIn.FData+'],���['+FloatToStr(nMoney)+'],��Ƿ['+FloatToStr(nCredit)+
             '],����['+FloatToStr(nVal)+'],����['+FOut.FData+']');

    Result := True;
  finally
    gDBConnManager.ReleaseConnection(nCErpWorker);
    gDBConnManager.ReleaseConnection(nCErpWorker2);
  end;
end;
{$ENDIF}

//Date: 2014-09-05
//Desc: ��֤�ͻ��Ƿ���Ǯ,�Լ������Ƿ����
function TWorkerBusinessCommander.CustomerHasMoney(var nData: string): Boolean;
var nStr,nName: string;
    nM,nC: Double;
begin
  FIn.FExtParam := sFlag_No;
  Result := GetCustomerValidMoney(nData);
  if not Result then Exit;

  nM := StrToFloat(FOut.FData);
  FOut.FData := sFlag_Yes;
  if nM > 0 then Exit;

  nStr := 'Select C_Name From %s Where C_ID=''%s''';
  nStr := Format(nStr, [sTable_Customer, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
         nName := Fields[0].AsString
    else nName := '��ɾ��';
  end;

  nC := StrToFloat(FOut.FExtParam);
  if (nC <= 0) or (nC + nM <= 0) then
  begin
    nData := Format('�ͻ�[ %s ]���ʽ�����.', [nName]);
    Result := False;
    Exit;
  end;

  nStr := 'Select MAX(C_End) From %s ' +
          'Where C_CusID=''%s'' and C_Money>=0 and C_Verify=''%s''';
  nStr := Format(nStr, [sTable_CusCredit, FIn.FData, sFlag_Yes]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
     (Fields[0].AsDateTime <= Now()) then
  begin
    nData := Format('�ͻ�[ %s ]�������ѹ���.', [nName]);
    Result := False;
  end;
end;

//Date: 2014-10-02
//Parm: ���ƺ�[FIn.FData];
//Desc: ���泵����sTable_Truck��
function TWorkerBusinessCommander.SaveTruck(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
  FIn.FData := UpperCase(FIn.FData);
  
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, FIn.FData]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Truck, FIn.FData, GetPinYinOfStr(FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2016-02-16
//Parm: ���ƺ�(Truck); ���ֶ���(Field);����ֵ(Value)
//Desc: ���³�����Ϣ��sTable_Truck��
function TWorkerBusinessCommander.UpdateTruck(var nData: string): Boolean;
var nStr: string;
    nValInt: Integer;
    nValFloat: Double;
begin
  Result := True;
  FListA.Text := FIn.FData;

  if FListA.Values['Field'] = 'T_PValue' then
  begin
    nStr := 'Select T_PValue, T_PTime From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, FListA.Values['Truck']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nValInt := Fields[1].AsInteger;
      nValFloat := Fields[0].AsFloat;
    end else Exit;

    nValFloat := nValFloat * nValInt + StrToFloatDef(FListA.Values['Value'], 0);
    nValFloat := nValFloat / (nValInt + 1);
    nValFloat := Float2Float(nValFloat, cPrecision);

    nStr := 'Update %s Set T_PValue=%.2f, T_PTime=T_PTime+1 Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nValFloat, FListA.Values['Truck']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2014-09-25
//Parm: ���ƺ�[FIn.FData]
//Desc: ��ȡָ�����ƺŵĳ�Ƥ����(ʹ�����ģʽ,δ����)
function TWorkerBusinessCommander.GetTruckPoundData(var nData: string): Boolean;
var nStr: string;
    nPound: TLadingBillItems;
begin
  SetLength(nPound, 1);
  FillChar(nPound[0], SizeOf(TLadingBillItem), #0);

  nStr := 'Select * From %s Where P_Truck=''%s'' And ' +
          'P_MValue Is Null And P_PModel=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, FIn.FData, sFlag_PoundPD]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr),nPound[0] do
  begin
    if RecordCount > 0 then
    begin
      FCusID      := FieldByName('P_CusID').AsString;
      FCusName    := FieldByName('P_CusName').AsString;
      FTruck      := FieldByName('P_Truck').AsString;

      FType       := FieldByName('P_MType').AsString;
      FStockNo    := FieldByName('P_MID').AsString;
      FStockName  := FieldByName('P_MName').AsString;

      with FPData do
      begin
        FStation  := FieldByName('P_PStation').AsString;
        FValue    := FieldByName('P_PValue').AsFloat;
        FDate     := FieldByName('P_PDate').AsDateTime;
        FOperator := FieldByName('P_PMan').AsString;
      end;  

      FFactory    := FieldByName('P_FactID').AsString;
      FPModel     := FieldByName('P_PModel').AsString;
      FPType      := FieldByName('P_Type').AsString;
      FPoundID    := FieldByName('P_ID').AsString;

      FStatus     := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckBFM;
      FSelected   := True;
    end else
    begin
      FTruck      := FIn.FData;
      FPModel     := sFlag_PoundPD;

      FStatus     := '';
      FNextStatus := sFlag_TruckBFP;
      FSelected   := True;
    end;
  end;

  FOut.FData := CombineBillItmes(nPound);
  Result := True;
end;

//Date: 2014-09-25
//Parm: ��������[FIn.FData]
//Desc: ��ȡָ�����ƺŵĳ�Ƥ����(ʹ�����ģʽ,δ����)
function TWorkerBusinessCommander.SaveTruckPoundData(var nData: string): Boolean;
var nStr,nSQL: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  AnalyseBillItems(FIn.FData, nPound);
  //��������

  with nPound[0] do
  begin
    if FPoundID = '' then
    begin
      TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, FTruck, '', @nOut);
      //���泵�ƺ�

      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_PoundID;

      if not CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FPoundID := nOut.FData;
      //new id

      if FPModel = sFlag_PoundLS then
           nStr := sFlag_Other
      else nStr := sFlag_Provide;

      nSQL := MakeSQLByStr([
              SF('P_ID', FPoundID),
              SF('P_Type', nStr),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', sFlag_San),
              SF('P_PValue', FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', FFactory),
              SF('P_PStation', FPData.FStation),
              SF('P_Direction', '����'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end else
    begin
      nStr := SF('P_ID', FPoundID);
      //where

      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //����ʱ,����Ƥ�ش�,����Ƥë������
      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
      end;

      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    FOut.FData := FPoundID;
    Result := True;
  end;
end;

//Date: 2016-02-24
//Parm: ���ϱ��[FIn.FData];Ԥ�ۼ���[FIn.ExtParam];
//Desc: ����������ָ��Ʒ�ֵ����α��
function TWorkerBusinessCommander.GetStockBatcode(var nData: string): Boolean;
var nStr,nP, nBatchNew,nSelect: string;
    nNew: Boolean;
    nInt,nInc: Integer;
    nVal,nPer: Double;

    //���������κ�
    function NewBatCode: string;
    begin
      nStr := 'Select * From %s Where B_Stock=''%s''';
      nStr := Format(nStr, [sTable_StockBatcode, FIn.FData]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        nP := FieldByName('B_Prefix').AsString;
        nStr := FieldByName('B_UseYear').AsString;

        if nStr = sFlag_Yes then
        begin
          nStr := Copy(Date2Str(Now()), 3, 2);
          nP := nP + nStr;
          //ǰ׺����λ���
        end;

        nStr := FieldByName('B_Base').AsString;
        nInt := FieldByName('B_Length').AsInteger;
        nInt := nInt - Length(nP + nStr);

        if nInt > 0 then
             Result := nP + StringOfChar('0', nInt) + nStr
        else Result := nP + nStr;

        nStr := '����[ %s.%s ]������ʹ�����κ�[ %s ],��֪ͨ������ȷ���Ѳ���.';
        nStr := Format(nStr, [FieldByName('B_Stock').AsString,
                              FieldByName('B_Name').AsString, Result]);
        //xxxxx

        FOut.FBase.FErrCode := sFlag_ForceHint;
        FOut.FBase.FErrDesc := nStr;
      end;

      nStr := MakeSQLByStr([SF('B_Batcode', Result),
                SF('B_FirstDate', sField_SQLServer_Now, sfVal),
                SF('B_HasUse', 0, sfVal),
                SF('B_LastDate', sField_SQLServer_Now, sfVal)
                ], sTable_StockBatcode, SF('B_Stock', FIn.FData), False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;
    //Desc: ����¼
    procedure OutuseCode(const nID: string);
    begin
      nStr := 'Update %s Set D_Valid=''%s'',D_LastDate=%s Where D_ID=''%s''';
      nStr := Format(nStr, [sTable_BatcodeDoc, sFlag_No,
              sField_SQLServer_Now, nID]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;
begin
  Result := True;
  FOut.FData := '';
  
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_BatchAuto]);
  
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := Fields[0].AsString;
    if nStr <> sFlag_Yes then
    begin
      nStr := 'Select * from %s Where D_Stock=''%s'' and D_Valid=''%s'' '+
              'Order By D_UseDate';
      nStr := Format(nStr, [sTable_BatcodeDoc, FIn.FData, sFlag_Yes]);
      //xxxxxx


      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        if RecordCount < 1 then
        begin
          Result := False;
          nData := '����[ %s ]���β�����.';
          nData := Format(nData, [FIn.FData]);
          Exit;
        end;

        First;
        nVal := 0;
        nInc := 1;

        nBatchNew := '';
        nSelect := sFlag_No;

        while not Eof do
        try
          nVal := FieldByName('D_Plan').AsFloat - FieldByName('D_Sent').AsFloat +
                  FieldByName('D_Rund').AsFloat - FieldByName('D_Init').AsFloat -
                  StrToFloat(FListA.Values['Value']);

          if FloatRelation(nVal, 0, rtLE) then
          begin
            OutuseCode(FieldByName('D_ID').AsString);
            Continue;
          end; //����

          nInt := FieldByName('D_ValidDays').AsInteger;
          if (nInt > 0) and (Now() - FieldByName('D_UseDate').AsDateTime >= nInt) then
          begin
            OutuseCode(FieldByName('D_ID').AsString);
            Continue;
          end; //��Ź���

          if nInc = 1 then
          begin
            nStr := Trim(FListA.Values['CusID']);
            if (nStr <> '') and
               (nStr <> FieldByName('D_CusID').AsString) then Continue;
            //���ּ����ͻ�ר��
          end;

          nSelect   := sFlag_Yes;
          nBatchNew := FieldByName('D_ID').AsString;
          Break;
        finally
          Next;
          if Eof and (nInc = 1) and (nSelect <> sFlag_Yes) then
          begin
            Inc(nInc);
            First;
          end;
        end;

        if nSelect <> sFlag_Yes then
        begin
          Result := False;
          nData := '��������������[ %s.%s ]���β�����.';
          nData := Format(nData, [FIn.FData, FListA.Values['Brand']]);
          Exit;
        end;

        if nVal <= FieldByName('D_Warn').AsFloat then //��������
        begin
          nStr := '����[ %s.%s ]�����������κ�,��֪ͨ������׼��ȡ��.';
          nStr := Format(nStr, [FIn.FData,
                                FListA.Values['Brand']]);
          //xxxxx
      
          FOut.FBase.FErrCode := sFlag_ForceHint;
          FOut.FBase.FErrDesc := nStr;
          OutuseCode(nBatchNew);
        end;

        nStr := 'Update %s Set D_LastDate=null Where D_Valid=''%s'' ' +
                'And D_LastDate is not NULL';
        nStr := Format(nStr, [sTable_BatcodeDoc, sFlag_Yes]);
        gDBConnManager.WorkerExec(FDBConn, nStr);
        //����״̬�����κţ�ȥ����ֹʱ��

        FOut.FData := nBatchNew;
        if FOut.FBase.FErrCode = sFlag_ForceHint then
        begin
          {$IFDEF SaveHyDanEvent}
          SaveHyDanEvent(FIn.FData,FOut.FBase.FErrDesc,
                         sFlag_DepDaTing,sFlag_Solution_OK,sFlag_DepHuaYan);
          {$ENDIF}
        end;
        FOut.FBase.FResult := True;
        Result := True;
      end;
      Exit;
    end;
  end  else Exit;
  //Ĭ�ϲ�ʹ�����κ�

  Result := False; //Init
  nStr := 'Select *,%s as ServerNow From %s Where B_Stock=''%s''';
  nStr := Format(nStr, [sField_SQLServer_Now, sTable_StockBatcode, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '����[ %s ]δ�������κŹ���.';
      nData := Format(nData, [FIn.FData]);
      {$IFDEF SaveHyDanEvent}
      SaveHyDanEvent(FIn.FData,nData,sFlag_DepDaTing,sFlag_Solution_OK,sFlag_DepHuaYan);
      {$ENDIF}
      Exit;
    end;

    FOut.FData := FieldByName('B_Batcode').AsString;
    nInc := FieldByName('B_Incement').AsInteger;
    nNew := False;

    if FieldByName('B_UseDate').AsString = sFlag_Yes then
    begin
      nP := FieldByName('B_Prefix').AsString;
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime, False);

      nInt := FieldByName('B_Length').AsInteger;
      nInt := Length(nP + nStr) - nInt;

      if nInt > 0 then
      begin
        System.Delete(nStr, 1, nInt);
        FOut.FData := nP + nStr;
      end else
      begin
        nStr := StringOfChar('0', -nInt) + nStr;
        FOut.FData := nP + nStr;
      end;

      nNew := True;
    end;

    if (not nNew) and (FieldByName('B_AutoNew').AsString = sFlag_Yes) then      //Ԫ������
    begin
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime);
      nStr := Copy(nStr, 1, 4);
      nP := Date2Str(FieldByName('B_LastDate').AsDateTime);
      nP := Copy(nP, 1, 4);

      if nStr <> nP then
      begin
        nStr := 'Update %s Set B_Base=1 Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, FIn.FData]);
        
        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
        nNew := True;
      end;
    end;

    if not nNew then //��ų���
    begin
      nStr := Date2Str(FieldByName('ServerNow').AsDateTime);
      nP := Date2Str(FieldByName('B_FirstDate').AsDateTime);

      if (Str2Date(nP) > Str2Date('2000-01-01')) and
         (Str2Date(nStr) - Str2Date(nP) > FieldByName('B_Interval').AsInteger) then
      begin
        nStr := 'Update %s Set B_Base=B_Base+%d Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nInc, FIn.FData]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
        nNew := True;
      end;
    end;

    if not nNew then //��ų���
    begin
      nVal := FieldByName('B_HasUse').AsFloat + StrToFloat(FIn.FExtParam);
      //��ʹ��+Ԥʹ��
      nPer := FieldByName('B_Value').AsFloat * FieldByName('B_High').AsFloat / 100;
      //��������

      if nVal >= nPer then //����
      begin
        nStr := 'Update %s Set B_Base=B_Base+%d Where B_Stock=''%s''';
        nStr := Format(nStr, [sTable_StockBatcode, nInc, FIn.FData]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        FOut.FData := NewBatCode;
      end else
      begin
        nPer := FieldByName('B_Value').AsFloat * FieldByName('B_Low').AsFloat / 100;
        //����
      
        if nVal >= nPer then //��������
        begin
          nStr := '����[ %s.%s ]�����������κ�,��֪ͨ������׼��ȡ��.';
          nStr := Format(nStr, [FieldByName('B_Stock').AsString,
                                FieldByName('B_Name').AsString]);
          //xxxxx

          FOut.FBase.FErrCode := sFlag_ForceHint;
          FOut.FBase.FErrDesc := nStr;
        end;
      end;
    end;
  end;

  if FOut.FData = '' then
    FOut.FData := NewBatCode;
  //xxxxx

  if FOut.FBase.FErrCode = sFlag_ForceHint then
  begin
    {$IFDEF SaveHyDanEvent}
    SaveHyDanEvent(FIn.FData,FOut.FBase.FErrDesc,
                   sFlag_DepDaTing,sFlag_Solution_OK,sFlag_DepHuaYan);
    {$ENDIF}
  end;
  Result := True;
  FOut.FBase.FResult := True;
end;


procedure TWorkerBusinessCommander.SaveHyDanEvent(const nStockno,nEvent,
          nFrom,nSolution,nDepartment: string);
var
  nStr:string;
  nEID:string;
begin
  try
    nEID := nStockno + FormatDateTime('YYYYMMDD',Now);
    nStr := 'Delete From %s Where E_ID=''%s''';
    nStr := Format(nStr, [sTable_ManualEvent, nEID]);

    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := MakeSQLByStr([
        SF('E_ID', nEID),
        SF('E_Key', ''),
        SF('E_From', nFrom),
        SF('E_Event', nEvent),
        SF('E_Solution', nSolution),
        SF('E_Departmen', nDepartment),
        SF('E_Date', sField_SQLServer_Now, sfVal)
        ], sTable_ManualEvent, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  except
    on E: Exception do
    begin
      WriteLog(e.message);
    end;
  end;
end;

//ͬ����������ERPϵͳ
function TWorkerBusinessCommander.SyncRemoteStockBill(var nData: string): Boolean;
var
  nErpWorker, nMemWorker:PDBWorker;
  nStr, nSQL, nBill:string;
  nID, nIdx :Integer;
  nTmpDataSet: TDataSet;
  nMoney:Double;
begin
  Result := False;
  nErpWorker := nil;
  nMemWorker := nil;
  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  nSQL := 'select S_Bill.*,P_PStation,P_MStation From $BL left join $PL ' +
          'on L_ID=P_Bill where L_ID In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$BL', sTable_Bill), MI('$PL', sTable_PoundLog) , MI('$IN', nStr)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�Ľ�����������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nErpWorker := gDBConnManager.GetConnection(sFlag_CErp, FErrNum);
    if not Assigned(nErpWorker) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not nErpWorker.FConn.Connected then
      nErpWorker.FConn.Connected := True;
    //conn db

    nMemWorker := gDBConnManager.GetConnection(sFlag_Mem, FErrNum);
    if not Assigned(nMemWorker) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not nMemWorker.FConn.Connected then
      nMemWorker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    FListB.Clear;
    First;

    nBill := FieldByName('L_ID').AsString;
    nSQL := 'select * from SAL.SAL_PickBill where remark=''%s''';
    nSQL := Format(nSQL,[nBill]);
    with gDBConnManager.WorkerQuery(nErpWorker, nSQL) do
    begin
      if recordcount > 0 then
      begin
        Result := True;
        WriteLog('����'+nBill+'������,ֱ���˳�.');
        Exit;
      end;
    end;

    while not Eof do
    begin
      //���ɵ�����󵥺�
      nSQL := 'select isnull(max(tpickbill0_.pbillCode), '''') as col_0_0_ from '+
              'SAL.SAL_PickBill tpickbill0_ where 1=1 and (tpickbill0_.pbillCode like ''%s'')';
      nSQL := Format(nSQL,['TH'+formatdatetime('yyyymmdd',now)+'%']);

      with gDBConnManager.WorkerQuery(nErpWorker, nSQL) do
      begin
        if FieldByName('col_0_0_').AsString = '' then
        begin
          nBill := 'TH'+ formatdatetime('yyyymmdd',Now)+'00001';
        end
        else
        begin
          nBill := FieldByName('col_0_0_').AsString;
          nID := StrToInt(Copy(nBill,11,5));
          Inc(nID);
          nBill := inttostr(nID);
          while Length(nBill) < 5 do
            nBill := '0' + nBill;
          nBill := 'TH' + FormatDateTime('yyyymmdd',Now) + nBill;
        end;
      end;

      nSQL := 'select isnull(sum(rtnSum), 0) as col_0_0_ from SAL.SAL_ContractRtn '+
              'where contractCode=''%s''';
      nSQL := Format(nSQL,[FieldByName('L_ZhiKa').AsString]);
      with gDBConnManager.WorkerQuery(nErpWorker, nSQL) do
      begin
        nMoney := FieldByName('col_0_0_').AsFloat;
      end;

      nSQL := 'select reqQty-pickQty as leaveQty,* from sal.SAL_Contract_v '+
              'where contractcode=''%s'' and itemcode=''%s''';
      nSQL := Format(nSQL,[FieldByName('L_ZhiKa').AsString,FieldByName('L_Order').AsString]);
      nTmpDataSet:= gDBConnManager.WorkerQuery(nErpWorker, nSQL);

      //SAL.SAL_PickBill ���������
      nSQL := MakeSQLByStr([
                  SF('pBillCode',               nBill),  //�����
                  SF('contractCode',            FieldByName('L_ZhiKa').AsString),                        //��ͬ
                  SF('pbillDate',               FieldByName('L_Date').AsString),                         //
                  SF('pbillPerson',             FieldByName('L_Man').AsString),                          //������
                  SF('pbilltype',               'CTR'),                        //��������
                  SF('pbillPsnName',            FieldByName('L_Man').AsString),                          //������
                  SF('rcvAccountCode',          FieldByName('L_CusID').AsString),                        //
                  SF('rcvAccountName',          FieldByName('L_CusName').AsString),                      //
                  SF('transtyleCode',           nTmpDataSet.FieldByName('transtyleCode').AsString),      //��������
                  SF('transtyleName',           nTmpDataSet.FieldByName('transtyleName').AsString),      //
                  SF('pbillStat',               'End'),                                                  //���״̬���Ƿ����
                  SF('payTypeCode',             nTmpDataSet.FieldByName('payTypeCode').AsString),        //���ʽ
                  SF('payTypeName',             nTmpDataSet.FieldByName('payTypeName').AsString),        //
                  SF('carCode',                 FieldByName('L_Truck').AsString),                        //
                  SF('enaBeginDate',            FieldByName('L_inTime').AsString),                       //
                  SF('enaEndDate',              FIn.FExtParam), //FieldByName('L_OutFact').AsString),
                  SF('pickDate',                FieldByName('L_LadeTime').AsString),                     //
                  SF('blncTypeCode',            nTmpDataSet.FieldByName('blncTypeCode').AsString),       //
                  SF('blncTypeName',            nTmpDataSet.FieldByName('blncTypeName').AsString),       //
                  SF('originalDate',            FieldByName('L_Date').AsString),                         //
                  SF('balFlag',                 'Y'),
                  SF('balanceDate',             FIn.FExtParam),  //FieldByName('L_OutFact').AsString),//
                  SF('salOrgzCode',             '001'),
                  SF('remark',                  FieldByName('L_ID').AsString),
                  SF('transAccountCode',        FieldByName('L_TransCode').AsString),
                  SF('transAccountName',        FieldByName('L_TransName').AsString),
                  SF('fillDate',                FieldByName('L_Date').AsString)                                                     //
                  ], 'SAL.SAL_PickBill',             '', True);

      FListA.Add(nSQL);

      //SAL.SAL_PickBillItem ������ӱ�
      nSQL := MakeSQLByStr([
                  SF('pBillCode',               nBill),  //�����
                  SF('seqId',                   1),       //
                  SF('itemCode',                FieldByName('L_Order').AsString),      //����С���
                  SF('prodCode',                Copy(FieldByName('L_StockNo').AsString,1, Length(FieldByName('L_StockNo').AsString)-1)),
                  SF('prodName',                FieldByName('L_StockName').AsString),
                  SF('packForm',                nTmpDataSet.FieldByName('packForm').AsString),
                  SF('packFormName',            nTmpDataSet.FieldByName('packFormName').AsString),
                  SF('unitName',                nTmpDataSet.FieldByName('unitName').AsString),
                  SF('pickQty',                 FieldByName('L_Value').AsFloat),
                  SF('realPickQty',             FieldByName('L_Value').AsFloat),
                  SF('salePrice',               FieldByName('L_Price').AsFloat),
                  SF('totalSum',                FieldByName('L_Value').AsFloat*FieldByName('L_Price').AsFloat),
                  SF('grossWeight',             FieldByName('L_MValue').AsFloat),
                  SF('tareWeight',              FieldByName('L_PValue').AsFloat),
                  SF('outCode',                 FieldByName('L_HYDan').AsString),
                  SF('prodSpec',                nTmpDataSet.FieldByName('prodSpec').AsString),
                  SF('packages',                FieldByName('L_DaiTotal').AsFloat),
                  SF('workLine',                FieldByName('L_LineName').AsString)
                  ], 'SAL.SAL_PickBillItem',             '', True);
      FListA.Add(nSQL);

      //�ۿ���ϸ��
      nSQL := MakeSQLByStr([
                  SF('contractCode',            FieldByName('L_ZhiKa').AsString),  //�����
                  SF('rtnSum',                 -FieldByName('L_Value').AsFloat*FieldByName('L_Price').AsFloat, sfVal),
                  SF('accountCode',             FieldByName('L_CusID').AsString),
                  SF('accountName',             FieldByName('L_CusName').AsString),
                  SF('inputDate',               FIn.FExtParam),//FieldByName('L_OutFact').AsString),
                  SF('inputPsnName',            FieldByName('L_Man').AsString),
                  SF('remark',                  '�������'),
                  SF('feeType',                 'PICK'),
                  SF('totalSum',                nMoney-FieldByName('L_Value').AsFloat*FieldByName('L_Price').AsFloat, sfVal),
                  SF('rtnBillCode',             nBill)
                  ], 'SAL.SAL_ContractRtn',             '', True);
      FListA.Add(nSQL);

      //Mem_WTData ���ؼ�¼��
      nSQL := MakeSQLByStr([
                  SF('Order_Code',              nBill),  //�����
                  SF('PMp_id',                  FieldByName('P_MStation').AsString),
                  //SF('PMp_Name',                         ''),
                  SF('Item_Code',               Copy(FieldByName('L_StockNo').AsString,1, Length(FieldByName('L_StockNo').AsString)-1)),
                  SF('Item_Name',               FieldByName('L_StockName').AsString),

                  SF('Tare_Time',               FieldByName('L_PDate').AsString),         //Ƥ����Ϣ
                  SF('Tare_Weight',             FieldByName('L_PValue').AsFloat),
                  SF('T_Operator_Name',         FieldByName('L_PMan').AsString),
                  SF('T_Weight_Order',          FieldByName('P_PStation').AsString),       //Ƥ�ذ�վ���

                  SF('Gross_Time',               FieldByName('L_MDate').AsString),        //Ƥ����Ϣ
                  SF('Gross_Weight',             FieldByName('L_MValue').AsFloat),
                  SF('G_Operator_Name',          FieldByName('L_MMan').AsString),
                  SF('G_Weight_Order',           FieldByName('P_MStation').AsString),      //Ƥ�ذ�վ���

                  SF('Car_Code',                 FieldByName('L_Truck').AsString),
                  SF('Sup_Id',                   FieldByName('L_CusID').AsString),
                  SF('Sup_Name',                 FieldByName('L_CusName').AsString),

                  SF('Net_Weight',               FieldByName('L_Value').AsString)
                   ], 'MEM_WTData',             '', True);
      FListB.Add(nSQL);

      nSQL := 'update SAL.SAL_CTRItem set pickQty=pickQty+%s where contractCode=''%s'' and itemCode=''%s'''+
              ' and prodCode=''%s''';
      nSQL := Format(nSQL,[FieldByName('L_Value').AsString,FieldByName('L_ZhiKa').AsString,FieldByName('L_Order').AsString,
              Copy(FieldByName('L_StockNo').AsString,1, Length(FieldByName('L_StockNo').AsString)-1)]);
      FListA.Add(nSQL);

      Next;
    end;

    nErpWorker.FConn.BeginTrans;
    //nMemWorker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nErpWorker, FListA[nIdx]);
      //xxxxx
      nErpWorker.FConn.CommitTrans;
      {$IFDEF SyncMemDate}
      try
        for nIdx:=0 to FListB.Count - 1 do
          gDBConnManager.WorkerExec(nMemWorker, FListB[nIdx]);
        //xxxxx
      except
        nStr := 'ͬ�����������ݵ�MEMϵͳʧ��.';
        WriteLog(nStr);
        //raise Exception.Create(nStr);
      end;
      //nMemWorker.FConn.CommitTrans;
      {$ENDIF}

      Result := True;
    except
      nErpWorker.FConn.RollbackTrans;
      //nMemWorker.FConn.RollbackTrans;
      nStr := 'ͬ�����������ݵ�ERPϵͳʧ��.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nErpWorker);
    gDBConnManager.ReleaseConnection(nMemWorker);
  end;
end;

function TWorkerBusinessCommander.SyncBillToGPS(var nData: string): Boolean;
var
  nStr, nSQL, nAPIUrl: string;
  HttpClient: TIdHTTP;
  nResList: TStringStream;
  Jo:ISuperObject;
  nCode:Integer;
  nBegin: TDateTime;
begin
  Result := False;
  nBegin := Now;

  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);  
  nSQL := 'select S_Bill.*,P_PStation,P_MStation,C_Area,C_Addr From $BL left join $PL ' +
          'on L_ID=P_Bill left join S_Customer on l_cusid=C_ID where L_ID In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$BL', sTable_Bill), MI('$PL', sTable_PoundLog) , MI('$IN', nStr)]);

  nResList := TStringStream.Create('');
  HttpClient := TIdHttp.Create();

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�Ľ�����������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    nAPIUrl :='http://39.98.224.105:8012/GetDateServices.asmx/GetDate?method='+
              'LeaveTheFactoryRecord&ApplyId=or5zxujw7lo&PlateNumber=%s'+
              '&BillNumber=%s&OrderNumber=%s&CustomerCode=%s&CustomerName=%s'+
              '&MaterialName=%s&MaterialType=%s&PickupNum=%s&EnclosureType=0'+
              '&FactoryTime=%s&City=%s&Area=%s&Detailed=%s';

    nAPIUrl := Format(nAPIUrl, [UTF8Encode(FieldByName('L_Truck').AsString),
               FieldByName('L_ID').AsString,
               FieldByName('L_ZhiKa').AsString,
               FieldByName('L_CusId').AsString,
               UTF8Encode(FieldByName('L_CusName').AsString),
               UTF8Encode(FieldByName('L_StockName').AsString),
               FieldByName('L_Type').AsString,
               FieldByName('L_Value').AsString,
               IntToStr(DateTimeToUnix(StrToDateTime(FIn.FExtParam))*1000-28800000),
               UTF8Encode(FieldByName('C_Area').AsString),
               UTF8Encode(FieldByName('C_Addr').AsString),
               UTF8Encode(FieldByName('L_OutMan').AsString)]);
    nAPIUrl := TIdURI.URLEncode(nAPIUrl);
    HttpClient.Get(nAPIUrl,nResList);
    jo := so(UTF8Decode(nResList.DataString));
    nStr := Jo['success'].AsString;
    if nStr = 'true' then
    begin
      Result := true;
      Exit;
    end
    else
    begin
      nCode := Jo['errorCode'].AsInteger;
      case nCode of
        518:   nStr := 'GPS���ش�����:'+IntToStr(nCode)+':ApplyId��д����.';
        519:   nStr := 'GPS���ش�����:'+IntToStr(nCode)+':��������Ϊ��.';
        520:   nStr := 'GPS���ش�����:'+IntToStr(nCode)+':������ظ�����.';
        521:   nStr := 'GPS���ش�����:'+IntToStr(nCode)+':�����ṩ��������δ��ƥ�䵽��Ӧ����Χ��.';
        1002:  nStr := 'GPS���ش�����:'+IntToStr(nCode)+':�豸�ڻ�״̬';
        2000:  nStr := 'GPS���ش�����:'+IntToStr(nCode)+':���ݳ��ƺţ�δ��ƥ�䵽�豸��Ϣ.';
        50019: nStr := 'GPS���ش�����:'+IntToStr(nCode)+':ApplyId��ѯȨ�޲���.';
      end;
      writelog('���������['+FieldByName('L_ID').AsString+']��GPSʧ��,ԭ��:'+nStr);
    end;
    writelog('���������['+FieldByName('L_ID').AsString+']��GPS��ʱ:'+InttoStr(MilliSecondsBetween(Now, nBegin))+'ms');
  finally
    nResList.Free;
    HttpClient.Free;
  end;
end;

//ͬ���ɹ�����ERP
function TWorkerBusinessCommander.SyncRemoteStockOrder(var nData: string): Boolean;
var
  nSQL, nBill, nStr: string;
  nID, nIdx: Integer;
  nErpWorker, nMemWorker: PDBWorker;
  nTmpDataSet: TDataSet;
  nValue: Double;
begin
  Result := False;
  nErpWorker := nil;
  nMemWorker := nil;
  nsql:=FormatDateTime('yyyy-mm-dd 00:00:00',now);
  nSQL := 'select O_ID,O_Truck,O_SaleID,O_ProID,O_StockNo,O_StockPrc,O_Date,O_Man,O_BID,O_Value,' +
          ' D_ID, (D_MValue-D_PValue-isnull(D_KZValue,0)) as D_Value,D_InTime,D_PMan,D_MMan, ' +
          ' D_PValue, D_MValue, D_YSResult, D_KZValue,D_MDate,D_PDate, P_MStation,P_PStation, ' +
          ' O_StockName, O_ProName, D_OutFact,D_WlbYS,O_OrderType '+
          ' From $OD od , $OO oo, $PL pl ' +
          ' where od.D_OID=oo.O_ID and od.D_ID=pl.P_Order and D_ID=''$IN''';
  nSQL := MacroValue(nSQL, [MI('$OD', sTable_OrderDtl) ,
                            MI('$OO', sTable_Order),
                            MI('$PL', sTable_PoundLog),
                            MI('$IN', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�Ĳɹ���������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    if FieldByName('D_WlbYS').AsString=sFlag_No then
    begin          //����������
      Result := True;
      Exit;
    end;

    if FieldByName('D_YSResult').AsString=sFlag_No then
    begin          //����
      Result := True;
      Exit;
    end;

    nErpWorker := gDBConnManager.GetConnection(sFlag_CErp, FErrNum);
    if not Assigned(nErpWorker) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not nErpWorker.FConn.Connected then
      nErpWorker.FConn.Connected := True;
    //conn db

    nMemWorker := gDBConnManager.GetConnection(sFlag_Mem, FErrNum);
    if not Assigned(nMemWorker) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not nMemWorker.FConn.Connected then
      nMemWorker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    First;
    while not Eof do
    begin
      //���ɵ���
      nSQL := 'select isnull(max(billNum), '''') as col_0_0_ from PUR.PUR_InvCheckDetailCar '+
              ' where billNum like ''DH'+FormatDateTime('yyyymmdd',Now)+'%''';
      with gDBConnManager.WorkerQuery(nErpWorker, nSQL) do
      begin
        if FieldByName('col_0_0_').AsString = '' then
        begin
          nBill := 'DH' + formatdatetime('yyyymmdd',Now) + '00001';
        end
        else
        begin
          nBill := FieldByName('col_0_0_').AsString;
          nID := StrToInt(Copy(nBill,11,5));
          Inc(nID); 
          nBill := inttostr(nID);
          while Length(nBill) < 5 do
            nBill := '0' + nBill;
          nBill := 'DH' + FormatDateTime('yyyymmdd',Now) + nBill;

        end;
      end;

      if FieldByName('O_OrderType').AsString = sFlag_CaiTui then
        nStr := sFlag_CaiTui
      else
        nstr := sFlag_CaiGou;

      nSQL := 'select * from PUR.PUR_ContractMain where billNum=''%s''';
      nSQL := Format(nSQL,[FieldByName('O_BID').AsString]);
      nTmpDataSet:= gDBConnManager.WorkerQuery(nErpWorker, nSQL);

      //�ɹ���
      nSQL := MakeSQLByStr([
                    SF('billNum',               nBill),
                    SF('serialNum',             '1'),
                    SF('contractNum',           FieldByName('O_BID').AsString),
                    SF('billType',              nStr),
                    SF('supId',                 FieldByName('O_ProID').AsString),
                    SF('supName',               FieldByName('O_ProName').AsString),
                    SF('buyerID',               nTmpDataSet.FieldByName('makeEmpid').AsString),
                    SF('buyerName',             nTmpDataSet.FieldByName('makeEmpName').AsString),
                    SF('makeDate',              FieldByName('O_Date').AsString),
                    SF('makeEmpId',             FieldByName('O_Man').AsString),  //������
                    SF('makeEmpName',           FieldByName('O_Man').AsString),
                    SF('mdate',                 FieldByName('D_OutFact').AsString),  //��ë��ʱ��ĳɳ���ʱ��
                    SF('itemCode',              FieldByName('O_StockNo').AsString),
                    SF('itemName',              FieldByName('O_StockName').AsString),
                    SF('carNo',                 FieldByName('O_Truck').AsString),
                    //SF('qstate',                FieldByName('').AsString),  //�ʼ���� 1:�ѽ���  2:�����  A:δ���� 0:�ѱ���
                    //checkstate  T:�˻�   V:����
                    SF('mstate',                '1'),  //������� 1������ɣ�A��δ������
                    SF('mresult',               FieldByName('D_Value').AsFloat, sfVal),//
                    SF('carFlag',               '1'),  //�������  0:��  1:��
                    SF('editFlag',              '1'),
                    SF('realQty',               FieldByName('D_Value').AsFloat, sfval),//FieldByName('D_Value').AsFloat),
                    SF('unitName',              '��'),
                    SF('grossWeight',           FieldByName('D_MValue').AsFloat),
                    SF('tareWeight',            FieldByName('D_PValue').AsFloat),
                    SF('notes',                 FieldByName('D_ID').AsString),
                    SF('waterFlag',             '0')    //ȫ��0
                    ], 'PUR.PUR_InvCheckDetailCar',      '',    True);
      FListA.Add(nSQL);

      //Mem_WTdata ���ؼ�¼��
      nSQL := MakeSQLByStr([
                  SF('Order_Code',              nBill),  //�����
                  SF('PMp_id',                  FieldByName('P_MStation').AsString),
                  //SF('PMp_Name',                         ''),
                  SF('Item_Code',               FieldByName('O_StockNo').AsString),
                  SF('Item_Name',               FieldByName('O_StockName').AsString),

                  SF('Tare_Time',               FieldByName('D_PDate').AsString),         //Ƥ����Ϣ
                  SF('Tare_Weight',             FieldByName('D_PValue').AsFloat),
                  SF('T_Operator_Name',         FieldByName('D_PMan').AsString),
                  SF('T_Weight_Order',          FieldByName('P_PStation').AsString),       //Ƥ�ذ�վ���

                  SF('Gross_Time',               FieldByName('D_MDate').AsString),        //Ƥ����Ϣ
                  SF('Gross_Weight',             FieldByName('D_MValue').AsFloat),
                  SF('G_Operator_Name',          FieldByName('D_MMan').AsString),
                  SF('G_Weight_Order',           FieldByName('P_MStation').AsString),      //Ƥ�ذ�վ���

                  SF('Car_Code',                 FieldByName('O_Truck').AsString),
                  SF('Sup_Id',                   FieldByName('O_ProID').AsString),
                  SF('Sup_Name',                 FieldByName('O_ProName').AsString),

                  SF('Net_Weight',               FieldByName('D_Value').AsString)
                   ], 'MEM_WTData',             '',         True);
      FListB.Add(nSQL);
      
      Next;
    end;

    nErpWorker.FConn.BeginTrans;
    //nMemWorker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(nErpWorker, FListA[nIdx]);
      //xxxxx
      nErpWorker.FConn.CommitTrans;
      {$IFDEF SyncMemDate}
      try
        for nIdx:=0 to FListB.Count - 1 do
          gDBConnManager.WorkerExec(nMemWorker, FListB[nIdx]);
        //xxxxx
      except
        nStr := 'ͬ���ɹ������ݵ�MEMϵͳʧ��.';
        WriteLog(nStr);
        //raise Exception.Create(nStr);
      end;
      //nMemWorker.FConn.CommitTrans;
      {$ENDIF}

      Result := True;
    except
      nErpWorker.FConn.RollbackTrans;
      //nMemWorker.FConn.RollbackTrans;
      nStr := 'ͬ���ɹ������ݵ�ERPϵͳʧ��.';
      raise Exception.Create(nStr);
    end;
  finally
    gDBConnManager.ReleaseConnection(nErpWorker);
    gDBConnManager.ReleaseConnection(nMemWorker);
  end;
end;

//ͬ���ͻ���DLϵͳ
function TWorkerBusinessCommander.SyncRemoteCustomer(var nData: string): Boolean;
var nStr,nValid: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select S_Table,S_Action,S_Record,S_Param1,S_Param2,' +
            'accountCode,accountName,flag From %s' +
            ' Left Join %s On accountCode=S_Record where S_Table=''C''';

    nStr := Format(nStr, [sTable_K3_SyncItem, sTable_K3_Customer]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_CErp) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := FieldByName('S_Action').AsString;
        //action
        if FieldByName('flag').AsString='COMMIT' then
          nValid := sflag_yes
        else
          nValid := sFlag_No;

        if nStr = 'A' then //Add
        begin
          if FieldByName('accountCode').AsString = '' then Continue;
                  
          nStr := MakeSQLByStr([SF('C_ID', FieldByName('accountCode').AsString),
                  SF('C_Name', FieldByName('accountName').AsString),
                  SF('C_Valid', nValid),
                  SF('C_PY', GetPinYinOfStr(FieldByName('accountName').AsString)),
                  SF('C_XuNi', sFlag_No)
                  ], sTable_Customer, '', True);
          FListA.Add(nStr);

          nStr := MakeSQLByStr([SF('A_CID', FieldByName('accountCode').AsString),
                  SF('A_Date', sField_SQLServer_Now, sfVal)
                  ], sTable_CusAccount, '', True);
                  
          FListA.Add(nStr);
        end
        else
        if nStr = 'E' then //edit
        begin
          if FieldByName('accountCode').AsString = '' then Continue;

          nStr := SF('C_ID', FieldByName('accountCode').AsString);
          nStr := MakeSQLByStr([
                  SF('C_Name', FieldByName('accountName').AsString),
                  SF('C_Valid', nValid),
                  SF('C_PY', GetPinYinOfStr(FieldByName('accountName').AsString))
                  ], sTable_Customer, nStr, False);
                  
          FListA.Add(nStr);
        end
        else
        if nStr = 'D' then //delete
        begin
          nStr := 'Delete From %s Where C_ID=''%s''';
          nStr := Format(nStr, [sTable_Customer, FieldByName('S_Record').AsString]);
          FListA.Add(nStr);
        end;
      finally
        Next;
      end;
    end;

    if FListA.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //��������

      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);

      FDBConn.FConn.CommitTrans;

      nStr := 'Delete From ' + sTable_K3_SyncItem +' where S_Table = ''C''';
      gDBConnManager.WorkerExec(nDBWorker, nStr);
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//ͬ����Ӧ�̵�DLϵͳ
function TWorkerBusinessCommander.SyncRemoteProviders(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select S_Table,S_Action,S_Record,S_Param1,S_Param2,' +
            'accountCode,accountName From %s' +
            ' Left Join %s On accountCode=S_Record where S_Table=''P''';

    nStr := Format(nStr, [sTable_K3_SyncItem, sTable_K3_Customer]);

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_CErp) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := FieldByName('S_Action').AsString;
        //action

        if nStr = 'A' then //Add
        begin
          if FieldByName('accountCode').AsString = '' then Continue;
                  
          nStr := MakeSQLByStr([SF('P_ID', FieldByName('accountCode').AsString),
                  SF('P_Name', FieldByName('accountName').AsString),
                  SF('P_PY', GetPinYinOfStr(FieldByName('accountName').AsString))
                  ], sTable_Provider, '', True);
          FListA.Add(nStr);
        end
        else
        if nStr = 'E' then //edit
        begin
          if FieldByName('accountCode').AsString = '' then Continue;

          nStr := SF('P_ID', FieldByName('accountCode').AsString);
          nStr := MakeSQLByStr([
                  SF('C_Name', FieldByName('accountName').AsString),
                  SF('C_PY', GetPinYinOfStr(FieldByName('accountName').AsString))
                  ], sTable_Provider, nStr, False);
                  
          FListA.Add(nStr);
        end
        else
        if nStr = 'D' then //delete
        begin
          nStr := 'Delete From %s Where P_ID=''%s''';
          nStr := Format(nStr, [sTable_Provider, FieldByName('S_Record').AsString]);
          FListA.Add(nStr);
        end;
      finally
        Next;
      end;
    end;

    if FListA.Count > 0 then
    try
      FDBConn.FConn.BeginTrans;
      //��������

      for nIdx:=0 to FListA.Count - 1 do
        gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);

      FDBConn.FConn.CommitTrans;

      nStr := 'Delete From ' + sTable_K3_SyncItem +' where S_Table = ''P''';
      gDBConnManager.WorkerExec(nDBWorker, nStr);
    except
      if FDBConn.FConn.InTransaction then
        FDBConn.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

function TWorkerBusinessCommander.GetCardLength(
  var nData: string): Boolean;
var nStr: string;
begin
  Result := True;

  //��ʱҵ���Ƿ���
  nStr := 'select * from %s where B_Card=''%s''';
  nStr := Format(nStr, [sTable_TransBase, FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      if FieldByName('B_Ctype').AsString = sFlag_OrderCardG then
        Result := False;
      Exit;
    end;
  end;

  //�ɹ�ҵ���Ƿ���
  nStr := 'select * from %s where O_Card=''%s'' and O_CType=''%s''';
  nStr := Format(nStr, [sTable_Order, FIn.FData, sFlag_OrderCardG]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
      Result := False;
  end;
end;

//Date: 2017-12-2
//Parm: ���ƺ�(Truck); ��������(Bill);��λ(Pos)
//Desc: ץ�ıȶ�
function TWorkerBusinessCommander.VerifySnapTruck(var nData: string): Boolean;
var nStr: string;
    nTruck, nBill, nPos, nSnapTruck, nEvent, nDept, nPicName: string;
    nUpdate, nNeedManu: Boolean;
begin
  Result := False;
  FListA.Text := FIn.FData;
  nSnapTruck:= '';
  nEvent:= '' ;
  nNeedManu := False;

  nTruck := FListA.Values['Truck'];
  nBill  := FListA.Values['Bill'];
  nPos   := FListA.Values['Pos'];
  nDept  := FListA.Values['Dept'];

  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckInNeedManu,nPos]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      nNeedManu := FieldByName('D_Value').AsString = sFlag_Yes;
    end;
  end;
  WriteLog('����ʶ��:'+'��λ:'+nPos+'�¼����ղ���:'+nDept);

  nData := '����[ %s ]����ʶ��ʧ��';
  nData := Format(nData, [nTruck]);
  FOut.FData := nData;
  //default

  nStr := 'Select * From %s Where S_ID=''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_SnapTruck, nPos]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if not nNeedManu then
        Result := True;
      nData := '����[ %s ]ץ���쳣';
      nData := Format(nData, [nTruck]);
      FOut.FData := nData;
      Exit;
    end;

    nPicName := '';

    First;

    while not Eof do
    begin
      nSnapTruck := FieldByName('S_Truck').AsString;
      if nPicName = '' then//Ĭ��ȡ����һ��ץ��
        nPicName := FieldByName('S_PicName').AsString;
      if Pos(nTruck,nSnapTruck) > 0 then
      begin
        Result := True;
        nPicName := FieldByName('S_PicName').AsString;
        //ȡ��ƥ��ɹ���ͼƬ·��

        nData := '����[ %s ]ʶ��ɹ�';
        nData := Format(nData, [nTruck,nSnapTruck]);
        FOut.FData := nData;
        Exit;
      end;
      //����ʶ��ɹ�
      Next;
    end;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nBill+sFlag_ManualE]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      if FieldByName('E_Result').AsString = 'N' then
      begin
        nData := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ],����Ա��ֹ����';
        nData := Format(nData, [nTruck,nSnapTruck]);
        FOut.FData := nData;
        Exit;
      end;
      if FieldByName('E_Result').AsString = 'Y' then
      begin
        Result := True;
        nData := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ],����Ա����';
        nData := Format(nData, [nTruck,nSnapTruck]);
        FOut.FData := nData;
        Exit;
      end;
      nUpdate := True;
    end
    else
    begin
      nData := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ]';
      nData := Format(nData, [nTruck,nSnapTruck]);
      FOut.FData := nData;
      nUpdate := False;
      if not nNeedManu then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  nEvent := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ]';
  nEvent := Format(nEvent, [nTruck,nSnapTruck]);

  nStr := SF('E_ID', nBill+sFlag_ManualE);
  nStr := MakeSQLByStr([
          SF('E_ID', nBill+sFlag_ManualE),
          SF('E_Key', nPicName),
          SF('E_From', nDept),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_YN),
          SF('E_Departmen', nDept),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx
  gDBConnManager.WorkerExec(FDBConn, nStr);
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerQueryField, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessCommander, sPlug_ModuleBus);
end.

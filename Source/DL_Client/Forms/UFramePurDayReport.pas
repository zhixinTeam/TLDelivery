unit UFramePurDayReport;

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
  cxDropDownEdit, cxCalendar, StdCtrls, Menus, cxGridCustomPopupMenu,
  cxGridPopupMenu;

type
  TfFramePurDayReport = class(TfFrameNormal)
    Button1: TButton;
    dxLayout1Item1: TdxLayoutItem;
    editDate: TcxDateEdit;
    dxLayout1Item2: TdxLayoutItem;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function FrameID: integer; override;
    function MakeDate(var nIdx:Integer):TDate;
  end;

var
  fFramePurDayReport: TfFramePurDayReport;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, USysBusiness, USysConst, USysDB, UDataModule, UFormBase;

{ TfFramePurDayReport }

class function TfFramePurDayReport.FrameID: integer;
begin
  Result := cFI_FramePurDayReport;
end;

function TfFramePurDayReport.MakeDate(var nIdx: Integer): TDate;
var
  nEnd, nYear:string;
begin
  nYear := FormatDateTime('yyyy',Now);
  case nIdx of
    2:begin
      if StrToInt(nYear) mod 4=0 then
        nEnd := nYear+'-'+inttostr(nIdx)+'-29'
      else
        nEnd := nYear+'-'+inttostr(nIdx)+'-28';
    end;
    4,6,9,11: nEnd := nYear+'-'+inttostr(nIdx)+'-30';
    1,3,5,7,8,10,12:nEnd := nYear+'-'+inttostr(nIdx)+'-31';
  end;
  Result := StrToDate(nEnd);
end;

procedure TfFramePurDayReport.Button1Click(Sender: TObject);
var
  nStr, nSQL, nDate, nTable: string;
  nDateEnd: TDate;
  nIdx:Integer;
begin
  nTable :='Select D_ProID,D_ProName,D_OutFact,(case o_ordertype when ''T'''+
           ' then -D_Value else D_Value end) as D_value '+
           'From P_OrderDtl od Inner Join P_Order oo on od.D_OID=oo.O_ID';
  nDate := FormatDateTime('yyyy-mm-dd',editDate.date);
  FDM.ADOConn.BeginTrans;
  try
    nSQL := 'if object_id(''tempdb..#PDayReport'') is not null begin Drop '+
            'Table #PDayReport end ';
    FDM.ExecuteSQL(nSQL);
    //清理临时表

    nSQL := 'create table #PDayReport(D_ProId varchar(20),D_ProName varchar(50),'+
            'D_Value Decimal(15,2) default 0,'+
            'D_MonValue Decimal(15,2) default 0,'+
            'D_YearValue Decimal(15,2) default 0)';
    FDM.ExecuteSQL(nSQL);
    //创建临时表

    nSQL := 'insert into #PDayReport(D_ProId,D_ProName,D_Value'+
            ') select D_ProID,D_ProName,'+
            'CAST(Sum(d_value) as decimal(38, 2)) as d_value '+
            ' from (%s)as tt where D_OutFact>=''%s'' and D_OutFact<''%s'''+
            ' group by D_ProID,D_ProName';
    nSQL := Format(nSQL,[nTable,nDate,Date2Str(editDate.Date+1)]);
    FDM.ExecuteSQL(nSQL);
    //插入所选日期的提货汇总

    nDate := FormatDateTime('yyyy-mm-',editDate.date)+'01';
    nIdx :=  strtoint(FormatDateTime('mm',editDate.date));
    nDateEnd := MakeDate(nIdx);
    //生成月份起始日期

    nSQL := 'select D_ProID,D_ProName,'+
            'CAST(Sum(d_value) as decimal(38, 2)) as d_value '+
            ' from (%s)as tt where D_OutFact>=''%s'' and D_OutFact<''%s'''+
            ' group by D_ProID,D_ProName';
    nSQL := Format(nSQL,[nTable,nDate, Date2Str(nDateEnd+1)]);
    with FDM.QueryTemp(nSQL) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update #PDayReport set D_MonValue=%s where D_ProId=''%s''';
        nSQL := Format(nSQL,[FloatToStr(FieldByName('D_Value').AsFloat),
                FieldByName('D_ProID').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;
    //逐条更新月累计

    nDate := FormatDateTime('yyyy-',editDate.date)+'01-01';
    nDateEnd := StrToDate(FormatDateTime('yyyy-',editDate.date)+'12-31');

    nSQL := 'select D_ProID,D_ProName,'+
            'CAST(Sum(d_value) as decimal(38, 2)) as d_value '+
            ' from (%s)as tt  where D_OutFact>=''%s'' and D_OutFact<''%s'''+
            ' group by D_ProID,D_ProName';
    nSQL := Format(nSQL,[nTable,nDate, Date2Str(nDateEnd+1)]);
    with FDM.QueryTemp(nSQL) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update #PDayReport set D_YearValue=%s where D_ProId=''%s''';
        nSQL := Format(nSQL,[FloatToStr(FieldByName('D_Value').AsFloat),
                FieldByName('D_ProID').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;
    //逐条更新年累计

    nSQL := 'Select * From #PDayReport ';
    FDM.QueryData(SQLQuery, nSQL, FEnableBackDB);
    //查询结果

    nSQL := 'Drop Table #PDayReport';
    FDM.ExecuteSQL(nSQL);
    //删除临时表

    FDM.ADOConn.CommitTrans;    
  except
    FDM.ADOConn.RollbackTrans;
    ShowMessage('查询失败.');
    Exit;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurDayReport, TfFramePurDayReport.FrameID);
end.

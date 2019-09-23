unit UFrameSaleDayReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, dxLayoutControl, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, dxLayoutcxEditAdapters, StdCtrls, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar;

type
  TfFrameSaleDayReport = class(TfFrameNormal)
    editDate: TcxDateEdit;
    dxLayout1Item1: TdxLayoutItem;
    Button1: TButton;
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
  fFrameSaleDayReport: TfFrameSaleDayReport;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, USysBusiness, USysConst, USysDB, UDataModule, UFormBase;

{ TfFrameSaleDayReport }

class function TfFrameSaleDayReport.FrameID: integer;
begin
  Result := cFI_FrameSaleDayReport;
end;

procedure TfFrameSaleDayReport.Button1Click(Sender: TObject);
var
  nStr, nSQL, nDate: string;
  nDateEnd: TDate;
  nIdx:Integer;
begin
  nDate := FormatDateTime('yyyy-mm-dd',editDate.date);
  FDM.ADOConn.BeginTrans;
  try
    nSQL := 'if object_id(''tempdb..#DayReport'') is not null begin Drop '+
            'Table #DayReport end ';
    FDM.ExecuteSQL(nSQL);
    //清理临时表

    nSQL := 'create table #DayReport(D_CusId varchar(20),D_CusName varchar(50),'+
            'D_Value Decimal(15,2) default 0,D_money Decimal(15,2) default 0,'+
            'D_AvgPrice Decimal(15,2) default 0,D_MonValue Decimal(15,2) default 0,'+
            'D_YearValue Decimal(15,2) default 0)';
    FDM.ExecuteSQL(nSQL);
    //创建临时表

    nSQL := 'insert into #DayReport(D_CusId,D_CusName,D_Value,D_money,D_AvgPrice'+
            ') select L_CusID,L_CusName,'+
            'CAST(Sum(L_Value) as decimal(38, 2)) as L_Value, '+
            'CAST(Sum(L_Value*L_Price) as decimal(38, 2)) as L_Money,'+
            'CAST((Sum(L_Value*L_Price)/Sum(L_Value))as decimal(38, 2))'+
            ' as L_Price from S_Bill where L_OutFact>=''%s'' and L_OutFact<''%s'''+
            ' group by L_CusID,L_CusName';
    nSQL := Format(nSQL,[nDate,Date2Str(editDate.Date+1)]);
    FDM.ExecuteSQL(nSQL);
    //插入所选日期的提货汇总

    nDate := FormatDateTime('yyyy-mm-',editDate.date)+'01';
    nIdx :=  strtoint(FormatDateTime('mm',editDate.date));
    nDateEnd := MakeDate(nIdx);
    //生成月份起始日期

    nSQL := 'select L_CusID,L_CusName,'+
            'CAST(Sum(L_Value) as decimal(38, 2)) as L_Value '+
            ' from S_Bill where L_OutFact>=''%s'' and L_OutFact<''%s'''+
            ' group by L_CusID,L_CusName';
    nSQL := Format(nSQL,[nDate, Date2Str(nDateEnd+1)]);
    with FDM.QueryTemp(nSQL) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update #DayReport set D_MonValue=%s where D_CusId=''%s''';
        nSQL := Format(nSQL,[FieldByName('L_Value').AsString,
                FieldByName('L_CusID').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;
    //逐条更新月累计

    nDate := FormatDateTime('yyyy-',editDate.date)+'01-01';
    nDateEnd := StrToDate(FormatDateTime('yyyy-',editDate.date)+'12-31');

    nSQL := 'select L_CusID,L_CusName,'+
            'CAST(Sum(L_Value) as decimal(38, 2)) as L_Value '+
            ' from S_Bill where L_OutFact>=''%s'' and L_OutFact<''%s'''+
            ' group by L_CusID,L_CusName';
    nSQL := Format(nSQL,[nDate, Date2Str(nDateEnd+1)]);
    with FDM.QueryTemp(nSQL) do
    begin
      First;
      while not Eof do
      begin
        nSQL := 'update #DayReport set D_YearValue=%s where D_CusId=''%s''';
        nSQL := Format(nSQL,[FieldByName('L_Value').AsString,
                FieldByName('L_CusID').AsString]);
        FDM.ExecuteSQL(nSQL);
        Next;
      end;
    end;
    //逐条更新年累计

    nSQL := 'Select * From #DayReport ';
    FDM.QueryData(SQLQuery, nSQL, FEnableBackDB);
    //查询结果

    nSQL := 'Drop Table #DayReport';
    FDM.ExecuteSQL(nSQL);
    //删除临时表

    FDM.ADOConn.CommitTrans;    
  except
    FDM.ADOConn.RollbackTrans;
    ShowMessage('查询失败.');
    Exit;
  end;
end;

function TfFrameSaleDayReport.MakeDate(var nIdx: Integer): TDate;
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

initialization
  gControlManager.RegCtrl(TfFrameSaleDayReport, TfFrameSaleDayReport.FrameID);
end.

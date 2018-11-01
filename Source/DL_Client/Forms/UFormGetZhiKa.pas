{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 开提货单
*******************************************************************************}
unit UFormGetZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, ADODB, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, dxSkinsCore, dxSkinsDefaultPainters,
  dxLayoutcxEditAdapters, dxSkinscxPCPainter;

type
  TfFormGetZhiKa = class(TfFormNormal)
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    GridOrders: TcxGrid;
    dxLayout1Item3: TdxLayoutItem;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    EditCus: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxView1Column3: TcxGridDBColumn;
    cxView1Column4: TcxGridDBColumn;
    cxView1Column5: TcxGridDBColumn;
    cxView1Column7: TcxGridDBColumn;
    cxView1Column8: TcxGridDBColumn;
    cxView1Column9: TcxGridDBColumn;
    cxView1Column10: TcxGridDBColumn;
    cxView1Column11: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditCusPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    { Private declarations }
    FBillItem: PLadingBillItem;
    //订单数据
    procedure InitFormData(const nCusName: string);
    //初始化
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst,
  USysBusiness;

class function TfFormGetZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormGetZhiKa.Create(Application) do
  try
    Caption := '销售订单';
    FBillItem := nP.FParamF;
//    if not GetHhSalePlan('') then
//    begin
//      ShowMsg('获取销售计划失败',sHint);
//      Exit;
//    end;
    InitFormData('');

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormGetZhiKa.FormID: integer;
begin
  Result := cFI_FormGetZhika;
end;

procedure TfFormGetZhiKa.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  dxGroup1.AlignVert := avClient;
  LoadFormConfig(Self);

  for nIdx:=0 to cxView1.ColumnCount-1 do
    cxView1.Columns[nIdx].Tag := nIdx;
  InitTableView(Name, cxView1);
end;

procedure TfFormGetZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveUserDefineTableView(Name, cxView1);
end;

//------------------------------------------------------------------------------
procedure TfFormGetZhiKa.InitFormData(const nCusName: string);
var nStr: string;
begin
  nStr := 'select reqQty-pickQty as leaveQty,* from sal.SAL_Contract_v '+
          ' where (contractStat in (''Formal'' , ''Balance'')) '+
          ' and prodCode not in (select code from mdm.MDM_Item where state=''DELETE'')';

  if nCusName <> '' then
    nStr := nStr + ' And (' + nCusName + ')';
  FDM.QueryData(ADOQuery1, nStr, True);

  if ADOQuery1.Active and (ADOQuery1.RecordCount = 1) then
  begin
    ActiveControl := BtnOK;
  end else
  begin
    ActiveControl := EditCus;
    EditCus.SelectAll;
  end;
end;

procedure TfFormGetZhiKa.EditCusPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nWhere: string;
    nIdx: Integer;
begin
  if AButtonIndex = 1 then
  begin
    InitFormData('');
    ShowMsg('刷新成功', sHint);
    Exit;
  end;

  EditCus.Text := Trim(EditCus.Text);
  if EditCus.Text = '' then
  begin
    ShowMsg('请输入客户名称', sHint);
    Exit;
  end;

  nStr := ' accountName Like ''%%%s%%'' Or accountCode Like ''%%%s%%''';
  nWhere := Format(nStr, [EditCus.Text, EditCus.Text]);
  //客户名

  InitFormData(nWhere);
end;

procedure TfFormGetZhiKa.BtnOKClick(Sender: TObject);
var
  nStr, nType:string;
  nValue:Double;
begin
  if cxView1.DataController.GetSelectedCount < 0 then
  begin
    ShowMsg('请选择订单', sHint);
    Exit;
  end;

  with ADOQuery1,FBillItem^ do
  begin
    FZhiKa       := FieldByName('contractCode').AsString;
    FType        := FieldByName('packFormName').AsString;

    FStockNo     := FieldByName('ProdCode').AsString;
    FStockName   := FieldByName('ProdName').AsString;
    FCusID       := FieldByName('accountCode').AsString;
    FCusName     := FieldByName('accountName').AsString;
    FPrice       := FieldByName('salePrice').AsFloat;
    FFactory     := FieldByName('itemCode').AsString;

    //计算已开单未出厂的量，计算剩余可提货量

    if Pos('袋' , FType) > 0 then
         nType := sFlag_Dai
    else nType := sFlag_San;
    nStr := ' select SUM(L_Value) from %s where L_ZhiKa=''%s'' and L_StockNo=''%s'' and L_OutFact is null';
    nStr := Format(nStr,[sTable_Bill,FZhiKa,FStockNo+nType]);
    with FDM.QueryTemp(nStr) do
      nValue := Fields[0].AsFloat;

    FValue       := FieldByName('leaveQty').AsFloat - nValue;
    FStatus      := '';
  end;
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormGetZhiKa, TfFormGetZhiKa.FormID);
end.

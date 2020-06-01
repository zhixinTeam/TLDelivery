{*******************************************************************************
  ����: dmzn@163.com 2017-09-27
  ����: �������
*******************************************************************************}
unit UFormGetZhiKa;
{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, ADODB, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, Dialogs,
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
    //��������
    procedure InitFormData(const nCusName: string);
    //��ʼ��
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
    Caption := '���۶���';
    FBillItem := nP.FParamF;
//    if not GetHhSalePlan('') then
//    begin
//      ShowMsg('��ȡ���ۼƻ�ʧ��',sHint);
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
  nPrice:Double;
begin
  {$IFDEF YHTL}
  nStr := 'Select * from %s where D_Name=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_PriceLimit]);
  with FDM.QueryTemp(nStr) do
  begin
    if recordcount=0 then
      nPrice := 0
    else
      nPrice := fieldbyname('D_Value').AsFloat;
  end;
  {$ENDIF}

  nStr := 'select reqQty-pickQty as leaveQty,* from sal.SAL_Contract_v '+
          ' where (contractStat in (''Formal'' , ''Balance'')) '+
          {$IFDEF YHTL}
          ' and salePrice>='+floattostr(nPrice)+
          {$ENDIF}
          ' and enableFlag=''Y''' +
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
    ShowMsg('ˢ�³ɹ�', sHint);
    Exit;
  end;

  EditCus.Text := Trim(EditCus.Text);
  if EditCus.Text = '' then
  begin
    ShowMsg('������ͻ�����', sHint);
    Exit;
  end;

  nStr := ' accountName Like ''%%%s%%'' Or accountCode Like ''%%%s%%'' Or contractCode Like ''%%%s%%''';
  nWhere := Format(nStr, [EditCus.Text, EditCus.Text, EditCus.Text]);
  //�ͻ���

  InitFormData(nWhere);
end;

procedure TfFormGetZhiKa.BtnOKClick(Sender: TObject);
var
  nStr, nType, nSql, nPreFun, nAddOrDec:string;   //nPreFun �۸񷽰�  nAddOrDec ��or��
  nValue, nPriceNow, nPriceZX, nPriceGP, nZXFD:Double;
  //nPriceNow�ֺ�ͬ��  nPriceZX����ִ�м�  nPriceGP���Ƽ�   nZXFD���Ƽ�ִ�з���  ������
begin
  if cxView1.DataController.GetSelectedCount < 0 then
  begin
    ShowMsg('��ѡ�񶩵�', sHint);
    Exit;
  end;

  //��֤�۸��Ƿ������µ�
  {$IFDEF QSTL}
  with ADOQuery1 do
  begin
    nPriceNow := FieldByName('salePrice').AsFloat;
    nPreFun := FieldByName('realProj').AsString;

    nSql := 'select *,GETDATE() as dtNow from SAL.SAL_ProdPrice_v '+
          'where priceStat=''1'' and prodCode=''%s'' and packCode=''%s''';
    nSql := Format(nSql,[FieldByName('ProdCode').AsString,FieldByName('packForm').AsString]);
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
            ' and itemCode=''%s'' and prodCode=''%s'' and packForm=''%s''';
    with ADOQuery1 do
      nSql := Format(nSql,[FloatToStr(nPriceZX),FieldByName('contractCode').AsString,
              FieldByName('itemCode').AsString, FieldByName('prodCode').AsString,
              FieldByName('packForm').AsString]);
    try
      fdm.ExecuteSQL(nSql,True);
    except
      ShowMessage('�����۸�ʧ�����¿���.');
      Exit;
    end;
  end;
  {$ELSE}
  nPriceZX := ADOQuery1.FieldByName('salePrice').AsFloat;
  {$ENDIF}

  with ADOQuery1,FBillItem^ do
  begin
    FZhiKa       := FieldByName('contractCode').AsString;
    FType        := FieldByName('packFormName').AsString;

    FStockNo     := FieldByName('ProdCode').AsString;
    FStockName   := FieldByName('ProdName').AsString;
    FCusID       := FieldByName('accountCode').AsString;
    FCusName     := FieldByName('accountName').AsString;
    FPrice       := nPriceZX;//FieldByName('salePrice').AsFloat;
    FFactory     := FieldByName('itemCode').AsString;

    //�����ѿ���δ��������������ʣ��������

    if Pos('��' , FType) > 0 then
         nType := sFlag_Dai
    else nType := sFlag_San;
    
    nStr := ' select SUM(L_Value) from %s where L_ZhiKa=''%s'' and L_StockNo=''%s'' and L_order=''%s'' and L_OutFact is null';
    nStr := Format(nStr,[sTable_Bill,FZhiKa,FStockNo+nType, FieldByName('itemCode').AsString]);
    with FDM.QueryTemp(nStr) do
      nValue := Fields[0].AsFloat;

    FValue := FieldByName('leaveQty').AsFloat - nValue;

    if FValue < 0 then
    begin
      showmessage('ERP�ж�����������,�޷��µ�.');
      Exit;
    end;
    FStatus      := '';
  end;
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormGetZhiKa, TfFormGetZhiKa.FormID);
end.

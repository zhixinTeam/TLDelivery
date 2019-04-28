unit UFormCusLimit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, IniFiles,
  dxLayoutControl, StdCtrls, dxLayoutcxEditAdapters, cxContainer, cxEdit,
  cxCheckBox, cxTextEdit, cxMaskEdit, cxDropDownEdit, ComCtrls, cxListView;

type
  TCusLimit = record
    FArea:string;
    FValue:Double;
  end;

type
  TfFormCusLimit = class(TfFormNormal)
    dxlytgrpLayout1Group2: TdxLayoutGroup;
    cbbStockNo: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    cxCheckBox1: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    ListDetail: TcxListView;
    dxLayout1Item5: TdxLayoutItem;
    editCusNo: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    editValue: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxlytgrpLayout1Group3: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbbStockNoPropertiesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListDetailClick(Sender: TObject);
    procedure editValueExit(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure cxCheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    FStockList: TStrings;
    FCusLimitList: array of TCusLimit;
    FEditValue: Boolean;
    procedure InitFormData;
    procedure LoadLimitData;
    procedure LoadToListView;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormCusLimit: TfFormCusLimit;

implementation

{$R *.dfm}

uses
  USysConst, USysDB, UDataModule, ULibFun, USysGrid, UMgrControl, UFormCtrl;

{ TfFormCusLimit }

class function TfFormCusLimit.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  with TfFormCusLimit.Create(Application) do
  begin
    ShowModal;
    Free;
  end;
end;

class function TfFormCusLimit.FormID: integer;
begin
  FormID := cFI_FormCusLimit;
end;

procedure TfFormCusLimit.InitFormData;
begin
//
end;

procedure TfFormCusLimit.FormCreate(Sender: TObject);
var
  nSql:string;
  nIni: TIniFile;
begin
  inherited;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListDetail, nIni);
  finally
    nIni.Free;
  end;

  FStockList := TStringList.Create;
  nSql := 'Select D_Value,D_ParamB From %s Where D_Name=''%s''';
  nSql := Format(nSql,[sTable_SysDict,sFlag_StockItem]);
  with FDM.QueryTemp(nSql) do
  begin
    First;
    while not Eof do
    begin
      FStockList.Add(FieldByName('D_ParamB').AsString);
      cbbStockNo.Properties.Items.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end;

  FEditValue :=  False;
end;

procedure TfFormCusLimit.FormDestroy(Sender: TObject);
begin
  inherited;
  FStockList.Free;
end;

procedure TfFormCusLimit.LoadLimitData;
var
  nSQL, nStockNo:string;
  nIdx:integer;
begin
  SetLength(FCusLimitList,0);
  nStockNo := FStockList.strings[cbbStockNo.ItemIndex];

  nSQL := 'select a.*,b.* from %s a left join (select * from %s '+
          ' where l_stockno=''%s'')as b on a.b_text=b.L_Area';
  nSQL := Format(nSQL,[sTable_BaseInfo,sTable_AreaLimit,nStockNo]);

  with FDM.QueryTemp(nSql) do
  begin
    if RecordCount > 0 then
    begin
      SetLength(FCusLimitList,RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      with FCusLimitList[nIdx] do
      begin
        FArea := FieldByName('B_Text').AsString;
        FValue := FieldByName('L_Value').AsFloat;
        Inc(nIdx);
        Next;
      end;
    end;
  end;
  LoadToListView;

  nSql := 'Select * From %s where D_Name=''%s'' and D_ParamB=''%s''';
  nSql := Format(nSql,[sTable_SysDict,sFlag_AreaLimit, nStockNo]);
  with FDM.QueryTemp(nSql) do
  begin
    if RecordCount > 0 then
      cxCheckBox1.Checked := FieldByName('D_Value').AsString = sFlag_Yes
    else
      cxCheckBox1.Checked := False;
  end;
end;

procedure TfFormCusLimit.cbbStockNoPropertiesChange(Sender: TObject);
begin
  if FEditValue then
  if not QueryDlg('限提数据已经修改,确定不保存直接退出？', sAsk) then Exit;
  LoadLimitData;
end;

procedure TfFormCusLimit.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListDetail, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormCusLimit.LoadToListView;
var nIdx,nItem: integer;
begin
  nItem := ListDetail.ItemIndex;
  ListDetail.Items.BeginUpdate;
  try
    ListDetail.Items.Clear;

    for nIdx:=Low(FCusLimitList) to High(FCusLimitList) do
     with ListDetail.Items.Add do
     begin
       Caption := FCusLimitList[nIdx].FArea;
       //SubItems.Add(FCusLimitList[nIdx].FCusName);
       SubItems.Add(Format('%.2f', [FCusLimitList[nIdx].FValue]));
     end;
  finally
    ListDetail.Items.EndUpdate;
    ListDetail.ItemIndex := nItem;
  end;
end;

procedure TfFormCusLimit.ListDetailClick(Sender: TObject);
begin
  if ListDetail.ItemIndex < 0 then Exit;

  editCusNo.Text := FCusLimitList[ListDetail.ItemIndex].FArea;
  //editCusName.Text := FCusLimitList[ListDetail.ItemIndex].FCusName;
  editValue.Text := FloatToStr(FCusLimitList[ListDetail.ItemIndex].FValue);
  editValue.SetFocus;
end;

procedure TfFormCusLimit.editValueExit(Sender: TObject);
begin
  if (ListDetail.ItemIndex < 0) or (not (Sender is TcxTextEdit)) then Exit;
  if not IsNumber(EditValue.Text, True) then Exit;
  FCusLimitList[ListDetail.ItemIndex].FValue := StrToFloat(editValue.Text);
  ListDetail.Items[ListDetail.ItemIndex].SubItems.Strings[0] := editValue.Text;
  FEditValue := True;
  //LoadToListView;
end;

procedure TfFormCusLimit.BtnOKClick(Sender: TObject);
var
  nSql, nStockNo: string;
  nList:TStrings;
  nIdx:integer;
begin
  nStockNo := FStockList.Strings[cbbStockNo.ItemIndex];
  nList := TStringList.Create;

  FDM.ADOConn.BeginTrans;
  try
    nSql := 'Delete From %s Where L_StockNo=''%s''';
    nSql := Format(nSql,[sTable_AreaLimit,nStockNo]);
    FDM.ExecuteSQL(nSQL);

    for nIdx := Low(FCusLimitList) to High(FCusLimitList) do
    with FCusLimitList[nIdx] do
    begin
      if FValue > 0 then
      begin
        nSQL := MakeSQLByStr([SF('L_Area', FArea),
              SF('L_Value', FValue, sfVal),
              SF('L_StockNo', nStockNo),
              SF('L_Date', DateTime2Str(Now)),
              SF('L_User', gSysParam.FUserName)
              ], sTable_AreaLimit, '', True);
        nList.Add(nSql);
      end;
    end;

    for nIdx := nList.Count -1 downto 0 do
      FDM.ExecuteSQL(nList[nIdx]);

    FDM.ADOConn.CommitTrans;
    FreeAndNil(nList);
    ShowMsg('保存成功！',SHint);
    ModalResult := mrOk;
  except
    nList.Free;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('保存失败！',sError);
    Exit;
  end;
end;

procedure TfFormCusLimit.cxCheckBox1Click(Sender: TObject);
var
  nSql, nValue, nStockNo:string;
begin
  nStockNo := FStockList.strings[cbbStockNo.ItemIndex];
  
  if cxCheckBox1.Checked then
    nValue := sFlag_Yes
  else
    nValue := sFlag_No;

  nSql := 'select * from %s where D_Name=''%s'' and D_ParamB=''%s''';
  nSql := Format(nSql,[sTable_SysDict,sFlag_AreaLimit,nStockNo]);
  with FDM.QueryTemp(nSql) do
  begin
    if RecordCount = 0 then
    begin
      nSql := MakeSQLByStr([
              SF('D_Name',    sFlag_AreaLimit),
              SF('D_ParamB',  nStockNo),
              SF('D_Value',   nValue)], sTable_SysDict,'',True);
      FDM.ExecuteSQL(nSql);
    end
    else
    begin
      nSql := 'update %s set D_Value=''%s'' where D_Name=''%s'' and D_ParamB=''%s''';
      nSql := Format(nSql,[sTable_SysDict, nValue, sFlag_AreaLimit, nStockNo]);
      FDM.ExecuteSQL(nSql);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormCusLimit, TfFormCusLimit.FormID);
end.

{*******************************************************************************
  作者: dmzn@163.com 2014-09-01
  描述: 开提货单
*******************************************************************************}
unit UFormGetZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, dxSkinsCore, dxSkinsDefaultPainters,
  dxLayoutcxEditAdapters;

type
  TfFormGetZhiKa = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item8: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditSalesMan: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    EditName: TcxComboBox;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListDetail: TcxListView;
    dxLayout1Item4: TdxLayoutItem;
    EditZK: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSalesManPropertiesChange(Sender: TObject);
    procedure EditNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditZKPropertiesEditValueChanged(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Private declarations }
    FShowPrice: Boolean;
    //显示单价
    procedure InitFormData(const nID: string);
    //载入数据
    procedure ClearCustomerInfo;
    function LoadCustomerInfo(const nID: string): Boolean;
    //载入客户
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UDataModule,
  USysPopedom, USysGrid, USysDB, USysConst, USysBusiness;

var
  gParam: PFormCommandParam = nil;
  //全局使用

class function TfFormGetZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  gParam := nParam;

  with TfFormGetZhiKa.Create(Application) do
  try
    Caption := '选择纸卡';
    InitFormData('');
    FShowPrice := gPopedomManager.HasPopedom(nPopedom, sPopedom_ViewPrice);
    
    gParam.FCommand := cCmd_ModalResult;
    gParam.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormGetZhiKa.FormID: integer;
begin
  Result := cFI_FormGetZhika;
end;

procedure TfFormGetZhiKa.FormCreate(Sender: TObject);
begin
  dxGroup1.AlignVert := avTop;
  dxGroup2.AlignVert := avClient;
  
  LoadMCListBoxConfig(Name, ListInfo);
  LoadcxListViewConfig(Name, ListDetail);
end;

procedure TfFormGetZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, ListInfo);
  SavecxListViewConfig(Name, ListDetail);
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormGetZhiKa.InitFormData(const nID: string);
begin
  dxGroup1.AlignVert := avTop;
  ActiveControl := EditName; 
  LoadSaleMan(EditSalesMan.Properties.Items);
end;

//Desc: 清理客户信息
procedure TfFormGetZhiKa.ClearCustomerInfo;
begin
  if not EditID.Focused then EditID.Clear;
  if not EditName.Focused then EditName.ItemIndex := -1;

  ListInfo.Clear;
  ActiveControl := EditName;
end;

//Desc: 载入nID客户的信息
function TfFormGetZhiKa.LoadCustomerInfo(const nID: string): Boolean;
var nDS: TDataSet;
    nStr,nCusName,nSaleMan: string;
begin
  ClearCustomerInfo;
  nDS := USysBusiness.LoadCustomerInfo(nID, ListInfo, nStr);

  Result := Assigned(nDS);
  BtnOK.Enabled := Result;

  if not Result then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  with nDS do
  begin
    nCusName := FieldByName('C_Name').AsString;
    nSaleMan := FieldByName('C_SaleMan').AsString;
  end;
  
  EditID.Text := nID;
  SetCtrlData(EditSalesMan, nSaleMan);

  if GetStringsItemIndex(EditName.Properties.Items, nID) < 0 then
  begin
    nStr := Format('%s=%s.%s', [nID, nID, nCusName]);
    InsertStringsItem(EditName.Properties.Items, nStr);
  end;

  SetCtrlData(EditName, nID);
  //customer info done

  //----------------------------------------------------------------------------
  nStr := 'Z_ID=Select Z_ID, Z_Name From %s ' +
          'Where Z_Customer=''%s'' And Z_ValidDays>%s And ' +
          'IsNull(Z_InValid, '''')<>''%s'' And ' +
          'IsNull(Z_Freeze, '''')<>''%s'' Order By Z_ID';
  nStr := Format(nStr, [sTable_ZhiKa, nID, sField_SQLServer_Now, sFlag_Yes, sFlag_Yes]);

  with EditZK.Properties do
  begin
    AdjustStringsItem(Items, True);
    FDM.FillStringsData(Items, nStr, 0, '.');
    AdjustStringsItem(Items, False);

    if Items.Count > 0 then
      EditZK.ItemIndex := 0;
    //xxxxx

    ActiveControl := BtnOK;
    //准备开单
  end;
end;

procedure TfFormGetZhiKa.EditSalesManPropertiesChange(Sender: TObject);
var nStr: string;
begin
  if EditSalesMan.ItemIndex > -1 then
  begin
    nStr := Format('C_SaleMan=''%s''', [GetCtrlData(EditSalesMan)]);
    LoadCustomer(EditName.Properties.Items, nStr);
  end;
end;

procedure TfFormGetZhiKa.EditNamePropertiesEditValueChanged(Sender: TObject);
begin
  if (EditName.ItemIndex > -1) and EditName.Focused then
    LoadCustomerInfo(GetCtrlData(EditName));
  //xxxxx
end;

procedure TfFormGetZhiKa.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    ClearCustomerInfo;
    ShowMsg('请填写有效编号', sHint);
  end else LoadCustomerInfo(EditID.Text);
end;

procedure TfFormGetZhiKa.EditZKPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  ListDetail.Clear;
  if EditZK.ItemIndex < 0 then Exit;

  nStr := 'Select D_StockName,D_Price,D_Value From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, GetCtrlData(EditZK)]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 0 then Exit;
    //no data
    First;

    while not Eof do
    begin
      with ListDetail.Items.Add do
      begin
        Checked := True;
        Caption := Fields[0].AsString;

        if FShowPrice then
             nStr := Format('%.2f',[Fields[1].AsFloat])
        else nStr := '---';

        SubItems.Add(nStr);
        SubItems.Add(Format('%.2f',[Fields[2].AsFloat]));
      end;

      Next;
    end;
  end;
end;

//Desc: 选择客户
procedure TfFormGetZhiKa.EditNameKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
    nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    nP.FParamA := GetCtrlData(EditName);
    
    if nP.FParamA = '' then
      nP.FParamA := EditName.Text;
    //xxxxx

    CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    SetCtrlData(EditSalesMan, nP.FParamD);
    SetCtrlData(EditName, nP.FParamB);
    
    if EditName.ItemIndex < 0 then
    begin
      nStr := Format('%s=%s.%s', [nP.FParamB, nP.FParamB, nP.FParamC]);
      InsertStringsItem(EditName.Properties.Items, nStr);
      SetCtrlData(EditName, nP.FParamB);
    end;
  end;
end;

procedure TfFormGetZhiKa.BtnOKClick(Sender: TObject);
begin
  if EditZK.ItemIndex < 0 then
  begin
    ShowMsg('请选择纸卡', sHint);
    Exit;
  end;

  gParam.FParamB := GetCtrlData(EditZK);
  gParam.FParamC := GetCtrlData(EditName);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormGetZhiKa, TfFormGetZhiKa.FormID);
end.

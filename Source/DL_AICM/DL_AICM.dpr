program DL_AICM;

uses
  Forms,
  Windows,
  USysModule,
  UMITPacker,
  UDataModule in 'forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'forms\UFormMain.pas' {fFormMain},
  uReadCardThread in 'uReadCardThread.pas';

{$R *.res}
var
  gMutexHwnd: Hwnd;
  //������
begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_ZXAICM');
  //����������
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //����һ��ʵ��
  
  Application.Initialize;
  InitSystemObject;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.

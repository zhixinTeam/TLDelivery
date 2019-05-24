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
  //互斥句柄
begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_ZXAICM');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例
  
  Application.Initialize;
  InitSystemObject;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.

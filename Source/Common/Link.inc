//----------------------------------- 通用 -------------------------------------
{.$DEFINE DEBUG}
//调试模式

{.$DEFINE TrialVersion}
//试用版本

{$DEFINE UseReport}
//报表支持

{.$DEFINE RandomID}
//使用随机编号

{$DEFINE cxLibrary42}
//Ver4.2编译环境

{$DEFINE EnableBackupDB}
//备用数据库支持
{$DEFINE EnableDoubleDB}
//双数据库支持

//---------------------------------- 中间件 ------------------------------------
{.$DEFINE ClientMon}
//进程守护客户端

{$DEFINE HardMon}
//编译硬件守护

{.$DEFINE GenRODL}
//生成RODL资源

{$DEFINE COM_MIT}
//定义系统模式

//通用中间件
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {.$DEFINE ChannelPool}
  //启用通道支持
  {.$DEFINE AutoChannel}
  //启用通道平衡
  {.$DEFINE SAP}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//--------------------------------- 特定系统 -----------------------------------
{.$DEFINE COMMON}
//通用版本

{$DEFINE QSTL}
//特定系统

//确山同力
{$IFDEF QSTL}
  {$DEFINE COMMON}
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE MITTruckProber}
  //车检由中间件控制
  {$DEFINE MultiReplay}
  //计数器应答模式
  {$DEFINE PrintHYEach}
  //随车开化验单
  {.$DEFINE PrintHeGeZheng}
  {$DEFINE PrintHuaYanDan}
  //随车开单时打合格证、化验单
  {$DEFINE BatchInHYOfBill}
  //批次保存在化验单字段
  {$DEFINE DaiStepWuCha}
  //包装阶梯误差
  {$DEFINE AutoProId}
  //自动生成供应商编号
  {$DEFINE PrintHY}
  //出厂打印化验单
  {$DEFINE BFLED}
  //磅房小屏
  {$DEFINE SyncRemote}
  //远程同步
  {$DEFINE MicroMsg}
  //使用微信
  {$DEFINE ProberShow}
  //串口屏支持
  {$DEFINE TTCEM100}
  //自助收卡机  
  {$DEFINE WxShowCusMoney}
  //微信订单列表显示客户余额
  {$DEFINE CapturePictureEx}
  //抓拍扩展 
  {$DEFINE AllowMultiM}
  //允许多次过毛重
{$ENDIF}
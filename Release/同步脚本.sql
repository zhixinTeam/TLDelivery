if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)

INSERT INTO DL_SyncItem(S_Record, S_Table , S_Action , S_Time ) 
select accountCode,'C' as S_Table,'A' as S_Action,getdate() as S_Time From MDM.MDM_Account where flag='COMMIT' and (accTypeCode like '%SAL%')

--导入数据->DL_SyncItem
--客户信息


INSERT INTO DL_SyncItem(S_Record, S_Table , S_Action , S_Time )
select accountCode,'P' as S_Table,'A' as S_Action,getdate() as S_Time From MDM.MDM_Account where flag='COMMIT' and (accTypeCode like '%PUR%')

--导入数据->DL_SyncItem
--供应商
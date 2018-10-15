Create TRIGGER [Trig_Del] ON MDM.MDM_Account  
FOR DELETE  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)

  declare @ntype varchar(50);
  select @ntype =accTypeCode from DELETED
  if @ntype='SAL'
  begin
		INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
		select 'C','D',GetDate(),accountCode from DELETED	
  end
  else if @ntype='PUR'
  begin
		INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
		select 'P','D',GetDate(),accountCode from DELETED	
  end
end

go

/**************************************************************/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


Create TRIGGER [Trig_Update] ON MDM.MDM_Account 
FOR UPDATE  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)

  declare @InsID varchar(50),@ntype varchar(5);
  select @InsID =accountCode,@ntype =accTypeCode from INSERTED
  
  if @ntype='SAL'
  begin  
		INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
		select 'C','E',GetDate(),accountCode from DELETED where accountCode=@InsID	
  end
  else if @ntype='PUR'
  begin
		INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
		select 'P','E',GetDate(),accountCode from DELETED where accountCode=@InsID	
  end
end

/**************************************************************/

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


Create TRIGGER [Trig_Add] ON MDM.MDM_Account   
FOR INSERT  
AS 
begin 
  if not exists (SELECT * FROM dbo.sysobjects where id = object_id(N'DL_SyncItem')and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  begin	
	Create Table DL_SyncItem(R_ID bigint IDENTITY(1,1), 
					S_Table varChar(100),
					S_Action Char(1), 
					S_Record varChar(32), 
					S_Param1 varChar(100),
					S_Param2 float, 
					S_Time DateTime)
  end
  
  declare @ntype varchar(50);
  select @ntype =accTypeCode from INSERTED
  if @ntype='SAL'
  begin
		INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
		select 'C','A',GetDate(),accountCode from INSERTED	
  end
  else if @ntype='PUR'
  begin
		INSERT INTO DL_SyncItem(S_Table , S_Action , S_Time , S_Record)
		select 'P','A',GetDate(),accountCode from INSERTED	
  end
end



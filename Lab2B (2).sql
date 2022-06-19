Use Lab2B	-- or whatever you named your database
Go

Drop Table ConsignmentDetails
Drop Table Consignment
Drop Table StaffTraining
Drop Table Staff
Drop Table Customer
Drop Table Category
Drop Table StaffType
Drop Table Training
Drop Table Reward
Drop Table CustomerType
Go

Create Table CustomerType
(
	CustomerTypeID 			char(1) 		Not Null 
											Constraint PK_CustomerType_CustomerTypeID
												Primary Key Clustered,
	CustomerTypeDescription varchar(30)		Not Null
)

Create Table Reward
(
	RewardID 				char(4)			Not Null 
											Constraint PK_Reward_RewardID
												Primary Key Clustered,
	RewardDescription		varchar(30) 	Null,
	DiscountPercentage		tinyint			Not Null
)

Create Table Training
(
	TrainingID				int				identity(1,1)
											Not Null 
											Constraint PK_Training_TrainingID
												Primary Key Clustered,
	StartDate				smalldatetime	Not Null,
	EndDate					smalldatetime	Not Null, 
	TrainingDescription		varchar(70)		Not Null,
	Constraint CK_Training_EndDate_GreaterThan_StartDate
		Check (EndDate > StartDate)
)

Create Table StaffType
(
	StaffTypeID				smallint		identity(1,1)
											Not Null 
											Constraint PK_StaffType_StaffTypeID
												Primary Key Clustered,
	StaffTypeDescription	varchar(30)		Not Null	
)

Create Table Category
(
	CategoryCode			char(3)			Not Null 
											Constraint PK_Category_CategoryCode
												Primary Key Clustered,
	CategoryDescription		varchar(50)		Not Null,
	Cost					smallmoney		Not Null 
											Constraint CK_Category_Cost_GreaterOrEqualToZero
												Check (Cost >= 0 )
	
)

Create Table Customer
(
	CustomerID				int				identity(1,1)
											Not Null 
											Constraint PK_Customer_CustomerID
												Primary Key Clustered,
	FirstName				varchar(30)		Not Null,
	LastName				varchar(30)		Not Null,
	StreetAddress			varchar(30)		Null,
	City					varchar(20)		Null,
	Province				char(2)			Null 
											Constraint CK_Customer_Province_TwoCharacters
												Check (Province like '[A-Z][A-Z]')
											Constraint df_Province
												default 'AB',
	PostalCode				char(6)			Null 
											Constraint CK_Customer_PostalCode_Z9Z9Z9
												Check (PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Phone					char(14)		Null 
											Constraint CK_Customer_Phone_FullFormat
												Check (Phone like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	CustomerTypeID			char(1)			Not Null 
											Constraint FK_CustomerToCustomerType
												References CustomerType(CustomerTypeID),
	RewardID				char(4)			Not Null
											Constraint FK_CustomerToReward
												References Reward(RewardID)
)

Create Table Staff
(
	StaffID					char(6)			Not Null 
											Constraint PK_Staff_StaffID
												Primary Key Clustered,
	FirstName				varchar(30)		Not Null,
	LastName				varchar(30)		Not Null,
	Active					char(1)			Not Null,
	Wage					smallmoney		Not Null,
	StaffTypeID				smallint		Not Null 
											Constraint FK_StaffToStaffType
												References StaffType(StaffTypeID)
)

Create Table StaffTraining
(
	StaffID					char(6)			Not Null 
											Constraint FK_StaffTrainingToStaff
												References Staff(StaffID),
	TrainingID				int				Not Null 
											Constraint FK_StaffTrainingToTraining
												References Training(TrainingID),
	PassOrFail				char(1)			Null,
	Constraint PK_StaffTraining_StaffID_TrainingID
		Primary Key Clustered (StaffID, TrainingID)
)

Create Table Consignment
(
	ConsignmentID			int				identity(1,1)
											Not Null 
											Constraint PK_Consignment_ConsignmentID
												Primary Key Clustered,
	Date					datetime		Not Null,
	Subtotal				smallmoney		Not Null,
	GST						smallmoney		Not Null,
	Total					smallmoney		Not Null,
	RewardsDiscount			decimal(9,2)	Not Null,
	CustomerID				int				Not Null 
											Constraint FK_ConsignmentToCustomer
												References Customer(CustomerID),
	StaffID					char(6)			Not Null 
											Constraint FK_ConsignmentToStaff
												References Staff(StaffID)
)

Create Table ConsignmentDetails
(
	ConsignmentID			int				Not Null 
											Constraint FK_ConsignmentDetailsToConsignment
												References Consignment(ConsignmentID),
	LineID					int				Not Null,
	ItemDescription			varchar(40)		Not Null,
	StartPrice				smallmoney		Not Null,
	LowestPrice				smallmoney		Not Null,
	CategoryCode			char(3)			Not Null 
											Constraint FK_ConsignmentDetailsToCategory
												References Category(CategoryCode),
	Constraint PK_ConsignmentDetails_ConsignmentID_LineID
		Primary Key Clustered (ConsignmentID, LineID)
)
Go

--Insert Data
Insert into CustomerType
	(CustomerTypeID, CustomerTypeDescription)
Values
	('B', 'Business Client'), 
	('I', 'Individual'), 
	('N', 'Non Profit')

Insert into Reward
	(RewardID, RewardDescription, DiscountPercentage)
Values
	('A000', 'No Reward', 0), 
	('A120', 'Exclusive Customer', 20), 
	('A115', 'Preferred Customer', 15), 
	('A110', 'Exclusive', 10)


Insert into Training
	(StartDate, EndDate, TrainingDescription)
Values
	('Jan 1 2022', 'Jan 3 2022', 'Customer Retention'), 
	('Jan 20 2022', 'Jan 25 2022', 'Sales For Dummies'), 
	('Jan 25 2022', 'Jan 26 2022', 'How To Sell')


Insert into StaffType
	(StaffTypeDescription)
Values
	('Sales'), 
	('Promotion'), 
	('Human Resources'), 
	('Payroll')


Insert into Category
	(CategoryCode, CategoryDescription, Cost)
Values
	('ELT', 'Electronics', 2), 
	('VAL', 'Valuables', 3), 
	('SPT', 'Sports', 1), 
	('BKS', 'Books', 0.5), 
	('COL', 'Collectables', 3), 
	('CLO', 'Clothing', 2), 
	('VHC', 'Vehicles', 100), 
	('HLD', 'Household', 1)


Insert into Customer
	(FirstName, LastName, StreetAddress, City, Province, PostalCode, Phone, CustomerTypeID, RewardID)
Values
	('Fred', 'Flinstone', '1234 Boulder Street', 'Bedrock City', 'AB', 'T9E1H1', '1-555-123-4567', 'I', 'A000'), 
	('Susan', 'Sampson', '742 Evergreen Terrace', 'Springfield', 'AB', 'T9S9L1', '1-555-234-5678', 'I', 'A110'), 
	('Luke', 'Skywalker', '800 The Resistance Drive', 'Alderaan', 'BC', 'D1D1D1', '1-555-000-0000', 'B', 'A115'), 
	('Ariana', 'Grande', '443 Somewhere Street', 'MooseJaw', 'SK', 'M4L1D2', '1-111-222-3333', 'I', 'A120')


Insert into Staff
	(StaffID, FirstName, LastName, Active, wage, StaffTypeID)
Values
	('111111', 'Bob', 'Marley', 'Y', 20, 1), 
	('222222', 'Elvis', 'Presley', 'Y', 15, 2), 
	('333333', 'Tina', 'Turner', 'Y', 25, 3), 
	('444444', 'Joan', 'Jett', 'Y', 35, 1), 
	('555555', 'Buddy', 'Holly', 'Y', 18, 1), 
	('666666', 'Aretha', 'Franklin', 'Y', 35, 1), 
	('777777', 'Chuck', 'Barry', 'Y', 25, 2), 
	('888888', 'Stevie', 'Nicks', 'Y', 22, 2)


Insert into StaffTraining
	(StaffID, TrainingID, PassOrFail)
Values
	('111111', 1, 'P'), 
	('111111', 2, 'P'), 
	('222222', 3, 'P'), 
	('333333', 2, 'F'), 
	('222222', 2, 'P')


Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('May 07 2021', 3.00, 0.15, 3.15, 0, 1, 111111)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(1, 1, 'Stephen King Collection', 20, 15, 'BKS'), 
	(1, 2, 'Cooking for Dummies', 5, 4, 'BKS'), 
	(1, 3, 'PlayStation 2', 50, 40, 'ELT')


Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('May 24 2021', 103.00, 5.15, 108.15, 0, 1, 111111)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(2, 1, 'Nissan King Cab Truck', 5000, 4000, 'VHC'), 
	(2, 2, 'Stamp Collection', 100, 90, 'COL')

Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Jul 10 2021', 5.00, 0.25, 5.25, 0, 1, 111111)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(3, 1, 'Fur Coat', 5000, 4000, 'CLO'), 
	(3, 2, 'Gold Ring', 100, 90, 'VAL')

Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Jul 11 2021', 5.50, 0.28, 5.78, 0, 1, 444444)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(4, 1, 'FootBall', 10, 8, 'SPT'), 
	(4, 2, 'Signed Bobby Orr Jersey', 500, 400, 'SPT'), 
	(4, 3, 'Cooking With Yan', 5, 4, 'BKS'), 
	(4, 4, 'Diamond Necklace', 1000, 900, 'VAL')

Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Aug 06 2021', 102, 4.59, 106.59, 10.2, 2, 555555)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(5, 1, 'Dash Cam', 100, 90, 'ELT'), 
	(5, 2, 'GMC Truck', 2000, 1900, 'VHC')


Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Sep 10 2021', 6.00, 0.27, 6.27, 0.60, 2, 666666)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(6, 1, '55" TV', 100, 80, 'ELT'), 
	(6, 2, 'Pencil Sharpener', 5, 4, 'HLD'), 
	(6, 3, 'Lawn Mower', 150, 140, 'HLD'), 
	(6, 4, 'Camera', 50, 40, 'ELT')

Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Sep 11 2021', 2.00, 0.09, 1.79, 0.30, 3, 555555)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(7, 1, 'Bed Frame', 50, 40, 'HLD'), 
	(7, 2, 'Soccer Ball', 10, 8, 'SPT')

Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Dec 24 2021', 4.00, 0.17, 3.57, 0.60 , 3, 444444)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(8, 1, 'Lamp', 10, 8, 'HLD'), 
	(8, 2, 'Scanner', 80, 70, 'ELT'), 
	(8, 3, 'Bookcase', 20, 18, 'HLD')


Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Jan 08 2022', 4.50, 0.18, 3.78, 0.90, 4, 111111)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(9, 1, 'Couch', 50, 48, 'HLD'), 
	(9, 2, 'Plate Collection', 100, 90, 'COL'), 
	(9, 3, 'SQL For Dummies', 5, 4, 'BKS')

Insert into Consignment
	(Date, SubTotal, GST, Total, RewardsDiscount, CustomerID, StaffID)
Values
	('Feb 28 2022', 6.5, 0.33, 6.83, 0, 1, 444444)
Insert into ConsignmentDetails
	(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
Values 
	(10, 1, 'IPhone', 500, 400, 'ELT'), 
	(10, 2, 'Basketball Shoes', 15, 12, 'SPT'), 
	(10, 3, 'How To Play Chess', 5, 4, 'BKS'), 
	(10, 4, 'Gold Crown', 10000, 9000, 'VAL')

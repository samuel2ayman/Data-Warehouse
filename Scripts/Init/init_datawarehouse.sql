/*
This file is for initializing datawarehouse and creating database and schemas

*/

USE master

CREATE DATABASE datawarehouse;

USE datawarehouse

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO


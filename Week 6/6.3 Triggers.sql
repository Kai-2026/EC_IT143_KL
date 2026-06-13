--Add columns to track changes
ALTER TABLE SalesLT.Customer ADD LastModifiedDate DATETIME2(7) NULL

ALTER TABLE SalesLT.Customer ADD LastModifiedBy NVARCHAR(128) NULL;


--Make Trigger
CREATE TRIGGER ModifiedTrigger
ON SalesLT.Customer
AFTER UPDATE
AS
    UPDATE c
    SET
        LastModifiedDate = SYSDATETIME(),
        LastModifiedBy = ORIGINAL_LOGIN()
    FROM SalesLT.Customer c
--Uses special table 'inserted' to update the modifications columns only on the rows that were actually affected by the update
    INNER JOIN inserted i
        ON c.CustomerID = i.CustomerID;











DROP TRIGGER SalesLT.ModifiedTrigger;
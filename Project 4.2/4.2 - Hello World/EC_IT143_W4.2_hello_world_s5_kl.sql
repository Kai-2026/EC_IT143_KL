-- Q: What is the current date and time?

-- A: Let's ask SQL Server and find out...

SELECT v.my_message
     , v.current_date_time
INTO dbo.t_hello_world
FROM dbo.v_hello_world_load AS v;






DROP TABLE IF EXISTS dbo.t_hello_world;
GO

CREATE TABLE dbo.t_hello_world
(
    my_message        VARCHAR(25) NOT NULL,
    current_date_time DATETIME NOT NULL
        DEFAULT GETDATE(),

    CONSTRAINT PK_t_hello_world
        PRIMARY KEY CLUSTERED (my_message ASC)
);
GO
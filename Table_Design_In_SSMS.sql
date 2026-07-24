SELECT * FROM
INFORMATION_SCHEMA.TABLES;


/*

Understanding Rowstore and Columnstore
=>How physically data is store =>used for analytics
data is ultimately store in memeory (disk or memory)
=>
	two approch =>
				1.Traditioal database store data together in row format (Very efficient)
								=> physical representation
										Row 1
										--------------------------
										1 John 25 50000
								why => most application retrive one record at a time => example user login => data base need only one row 
										ex:select * from user where log_in=1
								why should we store/use cases =>
									Rowstore=> Good for=>
									Banking transactions
									Login systems
									Order entry
									CRUD applications
									OLTP

								What is b tree?
								dabase want answe like find customer 100 or find all orders between date range or return rows order by date
								then scanning million on rows would have been solve 
								so what data base does is basically store data in balance sorting format => classic b tree
								instead of storing => 
								5
								9
								11
								17
								20
								30
								it will store in 
								            17
										 /       \
									  9            30
									/   \        /    \
								   5    11      20    40


								format why because =>
								Question=> find 20
								Start at 17

										20 > 17

										↓

										Go right

										↓

										30

										20 < 30

										↓

										Go left

										↓

										20 found
										Think of a clustered B-tree as a book:
										Root = the table of contents ("Start in Chapter 8")
										Intermediate pages = chapter headings ("Go to pages 240-260")
										Leaf pages = the actual pages containing the information you want	

						

				2.columns are store instead of rows =>Columnstore
								=> physical representation
										ID
											1
											2
											3
								why => each column become my own file => must faster 
										ex:imagine we are retriving avg(salary)=> select avg(salary) from emp; considering every row most data is not necessary but when we 
										think from column level much faster input and output 
										columns are store compress much better 
										so imagine 
										physical representation
										Department
											IT
											IT
											IT
											IT
											IT
											HR
											HR
											HR
										becomes =>IT × 5;HR × 3
										instead of storing each value repetatively it become efficient to store value like this 
										1Less storage.
										2Less disk reads.
										3Better cache usage.
								why should we store/use cases =>
									Columnstore=> Good for=>
									Reporting
									Power BI
									Dashboards
									Data warehouse
									Aggregations
									Big tables
										
*/								
--Code
Create  table Sales (
Sales_id int primary key,
customer_id int,
amount  int); --SQL Server automatically creates a clustered B-tree index on sales_id unless you specify otherwise.

Create  table Sales_row_level (
Sales_id int primary key,
customer_id int,
amount  int);

CREATE CLUSTERED COLUMNSTORE INDEX CCI_Sales
ON Sales
WITH (DROP_EXISTING = ON);
 -- If you want the table to use a clustered columnstore index, create the primary key as NONCLUSTERED:
CREATE TABLE Sales
(
    sales_id INT PRIMARY KEY NONCLUSTERED,
    customer_id INT,
    amount INT
);
--Now create the columnstore index:

CREATE CLUSTERED COLUMNSTORE INDEX CCI_Sales
/*
Now the table has:
PK_Sales: nonclustered rowstore index, enforcing uniqueness
CCI_Sales: clustered columnstore index, storing the table in columnar format
*/
ON Sales;

--The key is that "clustered" does not necessarily mean "columnstore." It simply means this is the primary physical organization of the table's data.									
--There are two different types of clustered indexes in SQL Server:

--Type	Storage Format	Used For
--Clustered B-tree Index=>	Rows=>	OLTP, transactional systems
--Clustered Columnstore Index=>	Columns	Data warehouses, analytics
--Only one clustered index of any type can exist on a table because a table can only have one physical storage layout.

--Why only one clustered index?
--Imagine a book.
--You can arrange the pages:
--1.by page number (rowstore), or
--2.by grouping all chapters, all figures, all tables separately (columnstore).
--You can't physically arrange the same book in both ways at the same time. That's why SQL Server allows only one clustered storage structure per table.


/*
Adding Temporal History
=>Track historical changes automatically=>audit and understanding slow changing data
Identifying Sequences
=> find consecutice event and patterns => use in event analysis, fraud, user behavior

*/








--Reference: Read more if you like 
--https://www.youtube.com/watch?v=4Z9KEBexzcM&list=PL1LIXLIF50uXWJ9alDSXClzNCMynac38g
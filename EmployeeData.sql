-- 1. To create our datebase named Employeedata we use the below qurey,

Create Database Employeedata

/*2. To create our 2 tables use the qurey we use the below qurey

Table 1 Qurey*/

Create Table EmployeeD
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

--Table 2 Query:

Create Table EmployeeS
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)

/*3. To insert data into our tables

EmployeeD table*/

Insert into EmployeeD VALUES
(101, 'Paul', 'Smith', 30, 'Male'),
(102, 'Micheal', 'Molins', 30, 'Male'),
(103, 'Tina', 'May', 29, 'Female'),
(104, 'Angela', 'Martin', 31, 'Female'),
(105, 'Toby', 'Obrien', 32, 'Male'),
(106, 'Michael', 'Scott', 35, 'Male'),
(107, 'Samantha', 'John', 32, 'Female'),
(108, 'Steven', 'Samuel', 38, 'Male'),
(109, 'Kevin', '', 31, 'Male')

--EmployeeS Table:

Insert Into EmployeeS VALUES
(101, 'Salesman', 30000),
(102, 'Receptionist', 25000),
(103, 'Salesman', 63000),
(004, 'Accountant', 47000),
(105, 'HR', 50000),
(106, 'Regional Manager', 50000),
(107, 'Supplier Relations', 40000),
(108, 'Salesman', 48000),
(109, 'Accountant', 42000)

UPDATE EmployeeS
SET EmployeeID=104
Where EmployeeID=004 


/* 4. To view all data in each table

EmployeeD Table */

Select* 
From EmployeeD

--EmployeeS Table

Select* 
From EmployeeS

/*3.Where, 
Group by and Order By*/

Select Gender,Age, COUNT(Gender) as employeegroup
From EmployeeD
Where Age>20 or Age like '%2%'
Group by Gender,Age
Order by 2 ASC,employeegroup DESC


/*5. oins
To see the average Salary of salesman */

Select AVG(Salary) as Avgsalary,Jobtitle
From Employeedata..EmployeeD
INNER Join Employeedata..EmployeeS
On EmployeeD.EmployeeID=EmployeeS.EmployeeID
Where JobTitle='Salesman'
Group By JobTitle

--6.Use of Case statement

Select FirstName,LastName,Age,Gender,
CASE
 WHEN Age < 30 THEN 'Young'
 When Age = 30 Then 'Mid'
 WHEN Age BETWEEN 31 AND 32 THEN 'Class'
 ELSE 'Old'
End as Class
From EmployeeD
Where Age is not null 
Order by Age

--Case Statements with joins

Select FirstName +' '+ LastName AS Fullname,JobTitle,Salary,
Case
  When JobTitle = 'RegionalManager' And Salary < 55000 Then Salary +(Salary*.10)
  When Salary between 25000 and 30000 Then Salary +(Salary*0.5)
  When Salary >=33000 Then Salary +(Salary*0.3)
  Else Salary+ (Salary*0.2)
  End as PotentialSalary

From EmployeeD
Right Outer Join EmployeeS
On EmployeeD.EmployeeID=EmployeeS.EmployeeID
Where JobTitle is not null
Order by PotentialSalary DESC


--7. Using having to specify the function
 
Select JobTitle, COUNT(JobTitle), AVG(Salary) as Avgsalary
From EmployeeD
INNER Join EmployeeS
On EmployeeD.EmployeeID=EmployeeS.EmployeeID
Group By JobTitle
Having AVG(Salary)>40000
Order by Avgsalary DESC

--8. Partition by. 
Select FirstName +' '+LastName As FullName, Age, Gender,
COUNT(Gender) Over (Partition by Gender) As CountOfGender,Salary
From EmployeeD
INNER Join EmployeeS
On EmployeeD.EmployeeID=EmployeeS.EmployeeID
Order By Salary DESC

--9. CTE

With CTE_Employee as
(Select EmployeeD.EmployeeID,FirstName +''+LastName As FullName, Age, Gender,
COUNT(Gender) Over (Partition by Gender) As CountOfGender,Salary
From EmployeeD
INNER Join EmployeeS
On EmployeeD.EmployeeID=EmployeeS.EmployeeID
--Order By Salary DESC
)
Select EmployeeID,FullName,Age,Gender,CountOfGender
From CTE_Employee


--11.Usiing Temp table to store data

Drop Table if Exists #Temp_Employee
Create Table #Temp_Employee
(JobTitle Varchar(50), 
EmployeesPerJob int,
AvgAge int,
AvgSalary int, 
)
Insert Into #Temp_Employee
Select JobTitle, Count(JobTitle), AVG(Age),AVG(Salary)
From EmployeeS
INNER Join EmployeeD
On EmployeeS.EmployeeID=EmployeeD.EmployeeID
Group By JobTitle

--12. To give an example using substings and Trim we create a new table with errors


--Drop Table EmployeeErrors;

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 

(101 , 'Paulo', 'Smith'),
( 102, 'Mich', 'Molins'),
(105, 'TOby', 'Obrien -Fired')


Select *
From EmployeeErrors

-- Using Trimto eliminate white spaces infront and behind, LTRIM to leliminate white spaces in fromt and, RTRIM to elminate white spaces at the end

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

-- Using Replace

Select LastName, REPLACE(LastName, '-Fired', '') as LastNameFixed
FROM EmployeeErrors

	
--13.Substring using fuzzy  Matching

Select Substring(EmployeeErrors.FirstName,1,3), Substring(EmployeeD.FirstName,1,3), Substring(EmployeeErrors.LastName,1,3),Substring(EmployeeD.LastName,1,3)
FROM EmployeeErrors
JOIN EmployeeD
	on Substring(EmployeeErrors.FirstName,1,3) = Substring(EmployeeD.FirstName,1,3)
	and Substring(EmployeeErrors.LastName,1,3) = Substring(EmployeeD.LastName,1,3)

--14. Stored Procedure

CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM Employeedata..EmployeeD As emp
JOIN Employeedata..EmployeeS As sal
ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;

--To view

EXEC temp_employee

--To Alter procedure

ALTER PROCEDURE [dbo].[Temp_Employee]
@Jobtitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM Employeedata..EmployeeD As emp
JOIN Employeedata..EmployeeS As sal
ON emp.EmployeeID = sal.EmployeeID
Where JobTitle = @JobTitle
Group by JobTitle

Select * 
From #temp_employee
GO;


--
EXEC temp_employee @JobTitle='Receptionist'

--15. Subqurey
Select EmployeeID, JobTitle, Salary
From EmployeeS
Where EmployeeID in (Select EmployeeID From EmployeeD
Where Age <>20)
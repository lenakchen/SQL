Create table Employees
(
     ID int,
     FirstName nvarchar(50),
     LastName nvarchar(50),
     Gender nvarchar(50)
);

Create table Salaries
(
     ID int,
     Salary int
);

Insert into Employees values (1, 'Ben', 'Hoskins', 'Male');
Insert into Employees values (2, 'Mark', 'Hastings', 'Male');
Insert into Employees values (3, 'Steve', 'Pound', 'Male');
Insert into Employees values (4, 'Ben', 'Hoskins', 'Male');
Insert into Employees values (5, 'Philip', 'Hastings', 'Male');
Insert into Employees values (6, 'Mary', 'Lambeth', 'Female');
Insert into Employees values (7, 'Valarie', 'Vikings', 'Female');
Insert into Employees values (8, 'John', 'Stanmore', 'Male');

Insert into Salaries values (1, 70000);
Insert into Salaries values (2, 60000);
Insert into Salaries values (3, 45000);
Insert into Salaries values (4, 70000);
Insert into Salaries values (5, 45000);
Insert into Salaries values (6, 30000);
Insert into Salaries values (7, 35000);
Insert into Salaries values (8, 80000);

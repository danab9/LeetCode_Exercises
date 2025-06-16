-------- PROJECT -----------
-- Task 1 --
-- setting up employee table with given constraints

CREATE TABLE employees (
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	job_position TEXT NOT NULL, 
	salary NUMERIC(8,2),
	start_date DATE NOT NULL,
	birth_date DATE NOT NULL,
	store_id INT REFERENCES store(store_id),
	department_id INT,
	manager_id INT REFERENCES employees(emp_id)
);

SELECT * FROM employees;

-- set up an additional table called departments
-- no column should allow nulls

CREATE TABLE departments (
	department_id SERIAL PRIMARY KEY,
	department TEXT NOT NULL, 
	division TEXT NOT NULL
);


SELECT * FROM departments;

-- Task 2 --
/*
Alter the employees table as follows:
- set the column department_id to not null
- Add a default value of CURRENT_DATE to the column start_date
- Add the column end_date with an appropriate data type (one that you think makes sense)
- Add a constraint called birth_check that doesn't allow birth dates that are in the future
- Rename the column job_position to position_title
*/
SELECT * FROM employees;

ALTER TABLE employees
ALTER COLUMN department_id SET NOT NULL;

ALTER TABLE employees
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE;

ALTER TABLE employees
ADD COLUMN end_date DATE;

ALTER TABLE employee
ADD CONSTRAINT birth_check CHECK(birth_date <= CURRENT_DATE);

ALTER TABLE employees
RENAME COLUMN job_position TO position_title;


-- Task 3 --
/*
Insert the given values into the employee table.
There will be most likely an error when you try to insert the values.
So, try to insert the values and then fix the error.
*/
INSERT INTO employees
VALUES
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
(11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
(12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
(13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
(14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
(15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
(16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
(17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
(18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
(19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
(20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
(21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
(22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
(23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
(24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
(25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
(26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL)
;
-- ERROR:  column "end_date" is of type date but expression is of type integer
-- changed the end dates to be in ''

-- Insert the given values into the departments table.
INSERT INTO departments(department, division)
VALUES
('Analytics', 'IT'),
('Finance', 'Administration'),
('Sales', 'Sales'),
('Website', 'IT'),
('Back Office', 'Administration')
;

SELECT * FROM departments;

-- Task 4 -- 
/* 4.1
Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.

Update the values accordingly.
*/

UPDATE employees
SET position_title='Senior SQL Analyst'
WHERE first_name = 'Jack' AND last_name = 'Franklin';

/* 4.2
The responsible people decided to rename the position_title Customer Support to Customer Specialist.

Update the values accordingly.
*/
UPDATE employees
SET position_title = 'Customer Specialist'
WHERE position_title = 'Customer Support';

/* 4.3
All SQL Analysts including Senior SQL Analysts get a raise of 6%.

Upate the salaries accordingly.

*/
UPDATE employees 
SET salary = salary*1.06
WHERE position_title ILIKE '%SQL Analyst';

/* 4.4
Question:

What is the average salary of a SQL Analyst in the company (excluding Senior SQL Analyst)?
*/
SELECT
	ROUND(AVG(salary),2) AS avg
FROM employees
WHERE position_title = 'SQL Analyst';
 -- 8834.75

-- Task 5 --
/* 5.1
Write a query that adds a column called manager that contains 
first_name and last_name (in one column) in the data output.

Secondly, add a column called is_active with 'false' if the 
employee has left the company already, otherwise the value is 'true'.
*/ 
SELECT
	e1.*,
	e2.first_name || ' ' || e2.last_name AS manager,
	CASE WHEN
		e1.end_date IS NULL THEN 'true' ELSE 'false'
	END AS is_active
FROM employees e1
LEFT JOIN employees e2 
ON e1.manager_id = e2.emp_id;

/* 5.2
Create a view called v_employees_info from that previous query.
*/ 
CREATE VIEW v_employees_info
AS 
SELECT
	e1.*,
	e2.first_name || ' ' || e2.last_name AS manager,
	CASE WHEN
		e1.end_date IS NULL THEN 'true' ELSE 'false'
	END AS is_active
FROM employees e1
LEFT JOIN employees e2 
ON e1.manager_id = e2.emp_id;

SELECT * FROM v_employees_info;

-- Task 6 --
/* 
Write a query that returns the average salaries for each positions with appropriate roundings.
*/ 

SELECT
	position_title,
	ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY position_title;

/*
Question:

What is the average salary for a Software Engineer in the company.

6028.00
*/

-- Task 7 --
-- Write a query that returns the average salaries per division.

SELECT 
	division,
	ROUND(AVG(salary), 2) AS avg_salary
FROM employees e
NATURAL LEFT JOIN departments d
GROUP BY division;

-- What is the average salary in the Sales department?
-- 6107.41

-- Task 8 --
/*8.1
Write a query that returns the following:

emp_id,
first_name,
last_name,
position_title,
salary

and a column that returns the average salary for every position_title.
Order the results by the emp_id.
*/

SELECT
	emp_id,
	first_name,
	last_name,
	position_title,
	salary,
	(SELECT
		ROUND(AVG(salary), 2) AS avg_salary_per_position
	FROM employees e2
	WHERE e2.position_title = e1.position_title
	GROUP BY position_title)
FROM employees e1
ORDER BY emp_id ASC;

/* 8.2
How many people earn less than there avg_position_salary?
Write a query that answers that question.

Ideally, the output just shows that number directly.
*/

SELECT
	COUNT(emp_id)
FROM (SELECT
	emp_id,
	first_name,
	last_name,
	position_title,
	salary,
	(SELECT
		ROUND(AVG(salary), 2) AS avg_salary_per_position
	FROM employees e2
	WHERE e2.position_title = e1.position_title
	GROUP BY position_title)
FROM employees e1)
WHERE salary < avg_salary_per_position;

-- 9

-- Task 9 --
/*
Write a query that returns a running total of the salary development by the start_date.

In your calculation, you can assume their salary has not changed over time, and you 
can disregard the fact that people have left the company (write the query as if they 
were still working for the company).
*/

SELECT * FROM employees;

SELECT
	emp_id,
	salary,
	start_date,
	SUM(salary) OVER(ORDER BY start_date) AS running_total_of_salary
FROM employees;

-- Question:
-- What was the total salary after 2018-12-31?
-- 184684.96 -----> check solutiont?

-- Task 10 --
/*
Create the same running total but now also consider the fact 
that people were leaving the company.
Note:
This challenge is actually very difficult.
Don't worry if you can't solve it you are not expected to do so.
It is possible to solve the challenge even without the hints.
If you want you can try to solve it using the hints and it is 
still a difficult challenge.
*/
SELECT
	emp_id,
	salary,
	date,
	SUM(salary) OVER(ORDER BY date) AS running_total_of_salary
FROM
	(SELECT
		emp_id,
		salary,
		start_date AS date,
		is_active
	FROM v_employees_info
UNION
	SELECT
		emp_id,
		salary * (-1) AS salary,
		end_date AS date,
		is_active
	FROM v_employees_info
	WHERE is_active='false')
;

-- What was the total salary after 2018-12-31?
-- 166348.10

-- Task 11 -- 
/*
11.1
Write a query that outputs only the top earner per position_title 
including first_name and position_title and their salary.
*/

SELECT *  FROM employees;

SELECT
	first_name,
	position_title,
	salary
FROM
	employees p1
WHERE salary = (SELECT MAX(salary)
				FROM employees p2
				WHERE p1.position_title = p2.position_title);

-- What is the top earner with the position_title SQL Analyst?
-- Summer with 10085.90

/*
11.2
Add also the average salary per position_title.
*/
SELECT
	first_name,
	position_title,
	salary,
	(SELECT ROUND(AVG(salary),2)
	FROM employees p3
	WHERE p3.position_title = p1.position_title
	GROUP BY(position_title)
	) AS avg_in_position
FROM
	employees p1
WHERE salary = (SELECT MAX(salary)
				FROM employees p2
				WHERE p1.position_title = p2.position_title);


/*
11.3
Remove those employees from the output of the previous query that has the same 
salary as the average of their position_title.

These are the people that are the only ones with their position_title.
*/

SELECT
	first_name,
	position_title,
	salary,
	(SELECT ROUND(AVG(salary),2)
	FROM employees p3
	WHERE p3.position_title = p1.position_title
	GROUP BY(position_title)
	) AS avg_in_position
FROM
	employees p1
WHERE 
	salary = (SELECT MAX(salary)
			FROM employees p2
			WHERE p1.position_title = p2.position_title)
	AND
	salary != (SELECT AVG(salary)
			FROM employees p4
			WHERE p1.position_title = p4.position_title)
;


-- Task 12 --
/*

Write a query that returns all meaningful aggregations of:
	- sum of salary
	- number of employees
	- average salary
	
grouped by all meaningful combinations of:
	- division
	- department
	- position_title
	
Consider the levels of hierarchies in a meaningful way.
*/


SELECT
	division,
	department,
	position_title,
	SUM(salary) AS sum_salary,
	COUNT(emp_id) AS no_of_employees,
	ROUND(AVG(salary),2) AS avg_salary
FROM employees e
LEFT JOIN
departments d
ON d.department_id = e.department_id
GROUP BY
	ROLLUP(department, division, position_title)
ORDER BY 1,2,3 ASC
;


-- Task 13 --
/*
Write a query that returns all employees (emp_id) including their position_title, 
department, their salary, and the rank of that salary partitioned by department.

The highest salary per division should have rank 1.
*/

SELECT
	emp_id,
	position_title,
	department,
	salary,
	RANK() OVER(PARTITION BY department ORDER BY salary DESC)
FROM employees
NATURAL JOIN departments;

-- Which employee (emp_id) is in rank 7 in the department Analytics?
-- 26

-- Task 14 --
/*
Write a query that returns only the top earner of each department 
including their emp_id, position_title, department, and their salary.
*/

SELECT
	emp_id,
	position_title,
	department,
	salary
FROM 
	(SELECT *, RANK() OVER(PARTITION BY department ORDER BY salary DESC)
	FROM employees
	NATURAL JOIN departments)
WHERE rank=1 -- Using a subquery to utilize rank, since it's a window function, therefor can't be used in a WHERE clause
;
-- Which employee (emp_id) is the top earner in the department Finance?
-- emp_id 8





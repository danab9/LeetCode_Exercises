/*
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId is the column with unique values for this table.
Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 

Table: Bonus

+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId is the column of unique values for this table.
empId is a foreign key (reference column) to empId from the Employee table.
Each row of this table contains the id of an employee and their respective bonus.
 

Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.
*/

/*
My solution:
I use Left Join to include all employees in the Employee table, and then filter out the employees with a bonus less than 1000, or NULL bonus.
Main Take Away: NULL < 1000 will produce 'unknown' value and not 'false', which is why we need to include the condition bonus IS NULL.
*/
SELECT name, bonus
FROM Employee e
LEFT JOIN Bonus b
    ON e.empId = b.empId
WHERE bonus IS NULL OR bonus < 1000;
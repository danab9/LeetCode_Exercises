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
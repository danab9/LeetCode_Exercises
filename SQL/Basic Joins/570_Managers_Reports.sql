/*
my solution:  
Join the Employee table with itself to match employees with their managers. 
Then group the results by the manager's name and uses the 
HAVING clause to filter out managers with fewer than five direct reports.

main take away:
	•	WHERE filters rows before aggregation (like SUM(), COUNT(), AVG()).
	•	HAVING filters groups after aggregation.
*/

SELECT e2.name
FROM Employee e1
JOIN Employee e2
    ON e1.managerId = e2.id
GROUP BY e2.name, e1.managerId -- include e1.managerId not count by name, because there can be multiple employees with the same name
HAVING COUNT(*) >= 5;
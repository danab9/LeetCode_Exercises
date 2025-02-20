/*
SQL Schema
Pandas Schema
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.
*/

/*
My soltuion: 
I use a LEFT JOIN to join the Weather table with itself on the condition that the recordDate of the first table is one day before the recordDate of the second table.
Then, I filter the result to only include rows where the temperature of the second table is not NULL and the temperature of the first table is higher than the temperature of the second table.
Finally, I select the id of the first table as the result.

Important Syntax:
- DATE_ADD(date, INTERVAL 1 DAY): Add 1 day to a date.
*/
SELECT w1.id
FROM Weather w1
LEFT JOIN Weather w2
ON w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
WHERE w2.temperature IS NOT NULL
AND w1.temperature > w2.temperature;

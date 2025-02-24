/*
My Solution:
    - I used a LEFT JOIN to join the Signups table with the Confirmations table on the user_id column.
    - I used the COUNT() function to count the total number of actions for each user_id.
    - I used the COUNT() function with a CASE statement to count the number of confirmed actions for each user_id.
    - I used the COALESCE() function to handle the case where the denominator is 0.
    - I used the ROUND() function to round the confirmation rate to two decimal places.
    - I used the GROUP BY clause to group the results by user_id.
    - I used the AS keyword to alias the calculated column as confirmation_rate.
    - I used the NULLIF() function to handle the case where the denominator is 0.
    - I used the 0 as the second argument to the COALESCE() function to return 0 when the denominator is 0.
A Better Solution would be: 
To use AVG() instead of COUNT() and CASE statement to calculate the confirmation rate - becuase Boolean values are treated as 1 and 0 in SQL.

Main Takeaways: 
CASE statement can be used to conditionally count values in SQL.
COALESCE() function can be used to handle NULL values in SQL.
NULLIF() function can be used to handle division by zero in SQL.
*/
SELECT s.user_id, 
    COALESCE(ROUND(COUNT(CASE WHEN c.action = 'confirmed' THEN 1 END) / NULLIF(COUNT(c.action), 0), 2), 0)
    AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id;

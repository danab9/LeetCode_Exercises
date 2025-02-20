/*
My solution: 
I use a LEFT JOIN to join the Visits table with the Transactions table on the visit_id column.
Then, I filter the result to only include rows where the transaction_id is NULL, which means that the user visited without making any transactions.
Finally, I group the result by customer_id and count the number of visits without transactions for each user.
*/
SELECT customer_id, COUNT(v.visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;
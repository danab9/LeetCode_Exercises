
/*
My solution:
I create two CTEs, start_table and end_table, to store the start and end timestamps of each process.
Then, I join the two tables on machine_id and process_id to calculate the processing time for each process.
Finally, I group the result by machine_id and calculate the average processing time for each machine.
*/

WITH start_table AS (
    SELECT machine_id, process_id, timestamp AS start_time
    FROM Activity
    WHERE activity_type = 'start'
),
end_table AS (
    SELECT machine_id, process_id, timestamp AS end_time
    FROM Activity
    WHERE activity_type = 'end'
)
SELECT s.machine_id, 
    ROUND(AVG(e.end_time - s.start_time), 3) AS processing_time
FROM start_table s 
JOIN end_table e
ON s.machine_id = e.machine_id AND s.process_id = e.process_id
GROUP BY s.machine_id;

/*
    This SQL query calculates the average quality of queries and the percentage of poor queries.
    Main takeaways:
     - CASE WHEN statenment allows for conditional logic in aggregate functions like COUNT.
*/
SELECT 
    query_name,
    ROUND(AVG(rating/position),2) AS quality,
    ROUND((COUNT(CASE WHEN rating<3 THEN 1 END) / COUNT(rating) * 100),2) AS poor_query_percentage
FROM 
    Queries
GROUP BY 
    query_name

/*
my solution:
main take away:
Since it is mentioned that each student takes every course from the Subjects table, we can use a cross join to get 
all possible combinations of students and subjects. 
*/

SELECT ss.student_id, ss.student_name, ss.subject_name,
    COUNT(ex.subject_name) AS attended_exams -- Count ex.subject_name because I want to include Null rows and count as 0
FROM (
    SELECT st.student_id, st.student_name, sub.subject_name 
    FROM Students st
    CROSS JOIN Subjects sub
) ss
LEFT JOIN Examinations ex
    ON ss.student_id = ex.student_id AND ss.subject_name = ex.subject_name
GROUP BY ss.student_id, ss.student_name, ss.subject_name
ORDER BY ss.student_id, ss.subject_name;

CREATE SCHEMA IF NOT EXISTS lms;

USE lms;

CREATE TABLE students
(
    student_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name  VARCHAR(255),
    gender     VARCHAR(1)
);

CREATE TABLE instructors
(
    instructor_id INT PRIMARY KEY,
    first_name    VARCHAR(255),
    last_name     VARCHAR(255)
);

CREATE TABLE courses
(
    course_id     INT PRIMARY KEY,
    course_name   VARCHAR(255),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors (instructor_id)
);

CREATE TABLE assignments
(
    assignment_id   INT PRIMARY KEY,
    assignment_name VARCHAR(255),
    course_id       INT,
    due_date        DATE,
    semester        VARCHAR(255),
    FOREIGN KEY (course_id) REFERENCES courses (course_id)
);

CREATE TABLE grades
(
    student_id    INT,
    assignment_id INT,
    grade         DECIMAL(5, 2),
    grade_date    DATE,
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments (assignment_id),
    PRIMARY KEY (student_id, assignment_id)
);

CREATE TABLE enrollments
(
    student_id INT,
    course_id  INT,
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (course_id) REFERENCES courses (course_id),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO students (student_id, first_name, last_name)
VALUES (1, 'John', 'Doe'),
       (2, 'Jane', 'Smith'),
       (3, 'Alice', 'Johnson');

INSERT INTO instructors (instructor_id, first_name, last_name)
VALUES (1, 'Professor', 'Smith'),
       (2, 'Professor', 'Johnson');

INSERT INTO courses (course_id, course_name, instructor_id)
VALUES (1, 'Math 101', 1),
       (2, 'English 101', 2);

INSERT INTO assignments (assignment_id, assignment_name, course_id)
VALUES (1, 'Homework 1', 1),
       (2, 'Essay 1', 2);

INSERT INTO grades (student_id, assignment_id, grade)
VALUES (1, 1, 90),
       (1, 2, 85),
       (2, 1, 95),
       (2, 2, 80),
       (3, 1, 85),
       (3, 2, 90);

INSERT INTO Enrollments (student_id, course_id)
VALUES (1, 1),
       (1, 2),
       (2, 1),
       (2, 2),
       (3, 1),
       (3, 2);

# Queries:
# 1) Retrieve the list of all students who have enrolled in a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
WHERE e.course_id = 1;

# 2) Retrieve the average grade of a specific assignment across all students.
SELECT AVG(grade)
FROM grades
WHERE assignment_id = 1;

# 3) Retrieve the list of all courses taken by a specific student.
SELECT c.course_name
from courses c
         JOIN enrollments e ON c.course_id = e.course_id
         JOIN students s ON e.student_id = s.student_id
WHERE s.first_name = 'John'
  AND s.last_name = 'Doe';

# 4) Retrieve the list of all instructors who teach a specific course.
SELECT i.first_name, i.last_name
FROM instructors i
         JOIN courses c ON i.instructor_id = c.instructor_id
WHERE c.course_name = 'Math 101';

# 5) Retrieve the total number of students enrolled in a specific course.
SELECT COUNT(s.student_id)
FROM students s
         JOIN enrollments e ON s.student_id = e.student_id
WHERE e.course_id = 1;

# 6) Retrieve the list of all assignments for a specific course.
SELECT a.assignment_name
FROM assignments a
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101';

# 7) Retrieve the highest grade received by a specific student in a specific course.
SELECT MAX(grade)
FROM grades
WHERE student_id = 1
  AND assignment_id = 1;

# 8) Retrieve the list of all students who have not completed a specific assignment.
SELECT s.first_name, s.last_name
FROM students s
         LEFT JOIN grades g ON s.student_id = g.student_id
WHERE g.grade IS NULL AND g.assignment_id = 2;

# 9) Retrieve the list of all courses that have more than 50 students enrolled.
SELECT c.course_name
FROM courses c
         JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) > 50;

# 10) Retrieve the list of all students who have an overall grade average of 90% or higher.
SELECT s.student_id, s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id
HAVING AVG(g.grade) >= 90;

# 11) Retrieve the overall average grade for each course.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_name;

# 12) Retrieve the average grade for each assignment in a specific course.
SELECT a.assignment_name, AVG(g.grade) AS average_grade
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY a.assignment_name;

# 13) Retrieve the number of students who have completed each assignment in a specific course.
SELECT a.assignment_name, COUNT(g.student_id) AS num_students_completed
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY a.assignment_name;

# 14) Retrieve the top 5 students with the highest overall grade average.
SELECT s.student_id, AVG(g.grade) AS overall_grade_average
FROM students s
         JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id
ORDER BY overall_grade_average DESC
LIMIT 5;

# 15) Retrieve the instructor with the highest overall average grade for all courses they teach.
SELECT i.instructor_id, AVG(g.grade) AS overall_grade_average
FROM instructors i
         JOIN courses c ON i.instructor_id = c.instructor_id
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY i.instructor_id
ORDER BY overall_grade_average DESC
LIMIT 1;

# 16) Retrieve the list of students who have a grade of A in a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN enrollments e ON s.student_id = e.student_id
         JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Math 101' AND g.grade >= 90;

# 17) Retrieve the list of courses that have no assignments.
SELECT c.course_name
FROM courses c
         LEFT JOIN assignments a ON c.course_id = a.course_id
WHERE a.assignment_id IS NULL;

# 18) Retrieve the list of students who have the highest grade in a specific course.
SELECT s.student_id, MAX(g.grade)
From students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN enrollments e ON g.student_id = e.student_id
         JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id;

# 19) Retrieve the list of assignments that have the lowest average grade in a specific course.
SELECT a.assignment_name, AVG(g.grade) AS average_grade
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY a.assignment_name
ORDER BY average_grade;

# 20) Retrieve the list of students who have not enrolled in any course.
SELECT s.first_name, s.last_name
FROM students s
         LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

# 21) Retrieve the list of instructors who are teaching more than one course.
SELECT i.instructor_id, COUNT(c.course_id) AS num_courses_taught
FROM instructors i
         JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id
HAVING COUNT(c.course_id) > 1;

# 22) Retrieve the list of students who have not submitted an assignment for a specific course.
SELECT s.student_id
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = 0;

# 23) Retrieve the list of courses that have the highest average grade.
SELECT c.course_id, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
ORDER BY average_grade DESC;

# 24) Retrieve the list of assignments that have a grade average higher than the overall grade average.
SELECT a.assignment_id, AVG(g.grade) AS average_grade
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY a.assignment_id
HAVING AVG(g.grade) > (SELECT AVG(grade) FROM grades);

# 25) Retrieve the list of courses that have at least one student with a grade of F.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
WHERE g.grade < 60
GROUP BY c.course_id;

# 26) Retrieve the list of students who have the same grade in all their courses.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id
HAVING COUNT(DISTINCT g.grade) = 1;

# 27) Retrieve the list of courses that have the same number of enrolled students.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING COUNT(DISTINCT g.student_id) = (SELECT COUNT(DISTINCT g.student_id)
                                       FROM grades g
                                                JOIN assignments a ON g.assignment_id = a.assignment_id
                                       WHERE a.course_id = c.course_id);

# 28) Retrieve the list of instructors who have taught all courses.
SELECT i.first_name, i.last_name
FROM instructors i
         JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id
HAVING COUNT(DISTINCT c.course_id) = (SELECT COUNT(DISTINCT c.course_id) FROM courses c);

# 29) Retrieve the list of assignments that have been graded but not returned to the students.
SELECT a.assignment_name
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
WHERE g.grade IS NOT NULL
  AND g.grade_date IS NULL;

# 30) Retrieve the list of courses that have an average grade higher than the overall grade average.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING average_grade > (SELECT AVG(grade) FROM grades);

# 31) Retrieve the list of students who have submitted all assignments for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id);

# 32) Retrieve the list of courses that have at least one assignment that no student has submitted.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         LEFT JOIN grades g ON a.assignment_id = g.assignment_id
WHERE g.student_id IS NULL;

# 33) Retrieve the list of students who have submitted the most assignments.
SELECT s.first_name, s.last_name, COUNT(g.assignment_id) AS num_assignments_submitted
FROM students s
         JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id
ORDER BY num_assignments_submitted DESC
LIMIT 1;

# 34) Retrieve the list of courses that have the highest average grade among students who have submitted all assignments.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING COUNT(DISTINCT g.student_id) = (SELECT COUNT(DISTINCT g.student_id)
                                       FROM grades g
                                                JOIN assignments a ON g.assignment_id = a.assignment_id
                                       WHERE a.course_id = c.course_id);

# 35) Retrieve the list of courses that have the highest average grade among students who have submitted all assignments.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING COUNT(DISTINCT g.student_id) = (SELECT COUNT(DISTINCT g.student_id)
                                       FROM grades g
                                                JOIN assignments a ON g.assignment_id = a.assignment_id
                                       WHERE a.course_id = c.course_id);

# 36) Retrieve the list of courses with the highest number of enrollments.
SELECT c.course_name, COUNT(DISTINCT g.student_id) AS num_students_enrolled
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
ORDER BY num_students_enrolled DESC
LIMIT 1;

# 37) Retrieve the list of assignments that have the lowest submission rate.
SELECT a.assignment_name, COUNT(g.student_id) AS num_submissions
FROM assignments a
         LEFT JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY a.assignment_id
ORDER BY num_submissions
LIMIT 1;

# 38) Retrieve the list of students who have the highest average grade for a specific course.
SELECT s.first_name, s.last_name, AVG(g.grade) AS average_grade
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 1;

# 39) Retrieve the list of courses with the highest percentage of students who have completed all assignments.
SELECT c.course_name, COUNT(DISTINCT g.student_id) / COUNT(DISTINCT s.student_id) AS completion_rate
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
ORDER BY completion_rate DESC
LIMIT 1;

# 40) Retrieve the list of students who have not submitted any assignments for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = 0;

# 41) Retrieve the list of courses with the lowest average grade.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
ORDER BY average_grade
LIMIT 1;

# 42) Retrieve the list of assignments that have the highest average grade.
SELECT a.assignment_name, AVG(g.grade) AS average_grade
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY a.assignment_id
ORDER BY average_grade DESC
LIMIT 1;

# 43) Retrieve the list of students who have the highest overall grade across all courses.
SELECT s.first_name, s.last_name, AVG(g.grade) AS overall_grade_average
FROM students s
         JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id
ORDER BY overall_grade_average DESC
LIMIT 1;

# 44) Retrieve the list of assignments that have not been graded yet.
SELECT a.assignment_name
FROM assignments a
         LEFT JOIN grades g ON a.assignment_id = g.assignment_id
WHERE g.grade IS NULL;

# 45) Retrieve the list of courses that have not been assigned any assignments yet.
SELECT c.course_name
FROM courses c
         LEFT JOIN assignments a ON c.course_id = a.course_id
WHERE a.assignment_id IS NULL;

# 46) Retrieve the list of students who have completed all assignments for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id);

# 47) Retrieve the list of students who have submitted all assignments but have not received a passing grade for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
  AND g.grade < 60
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id);

# 48) Retrieve the list of courses that have the highest percentage of students who have received a passing grade.
SELECT c.course_name, COUNT(DISTINCT s.student_id) / COUNT(DISTINCT g.student_id) AS passing_rate
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
WHERE g.grade >= 60
GROUP BY c.course_id
ORDER BY passing_rate DESC
LIMIT 1;

# 49) Retrieve the list of students who have submitted assignments late for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
  AND g.grade_date > a.due_date;

# 50) Retrieve the list of courses that have the highest percentage of students who have dropped out.
SELECT c.course_name, COUNT(DISTINCT s.student_id) / COUNT(DISTINCT g.student_id) AS dropout_rate
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
WHERE g.grade IS NULL
GROUP BY c.course_id
ORDER BY dropout_rate DESC
LIMIT 1;

# 51) Retrieve the list of students who have not yet submitted any assignments for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         LEFT JOIN grades g ON s.student_id = g.student_id
         LEFT JOIN assignments a ON g.assignment_id = a.assignment_id AND a.course_id = 1
WHERE a.assignment_id IS NULL
GROUP BY s.student_id;

# 52) Retrieve the list of students who have submitted at least one assignment for a specific course but have not completed all assignments.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id AND a.course_id = 1
GROUP BY s.student_id
HAVING COUNT(DISTINCT g.assignment_id) < (SELECT COUNT(*) FROM assignments WHERE course_id = 1);

# 53) Retrieve the list of assignments that have received the highest average grade.
SELECT a.assignment_name, AVG(g.grade) AS average_grade
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY a.assignment_id
ORDER BY average_grade DESC
LIMIT 1;

# 54) Retrieve the list of students who have received the highest average grade across all courses.
SELECT s.first_name, s.last_name, AVG(g.grade) AS overall_grade_average
FROM students s
         JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id
ORDER BY overall_grade_average DESC
LIMIT 1;

# 55) Retrieve the list of courses that have the highest average grade.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
ORDER BY average_grade DESC
LIMIT 1;

# 56) Retrieve the list of courses that have at least one student enrolled but no assignments have been created yet.
SELECT c.course_name
FROM courses c
         JOIN enrollments e ON c.course_id = e.course_id
         LEFT JOIN assignments a ON c.course_id = a.course_id
WHERE a.assignment_id IS NULL
GROUP BY c.course_id
HAVING COUNT(DISTINCT e.student_id) > 0;

# 57) Retrieve the list of courses that have at least one assignment created but no student has enrolled yet.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.student_id IS NULL
GROUP BY c.course_id
HAVING COUNT(DISTINCT a.assignment_id) > 0;

# 58) Retrieve the list of students who have submitted all assignments for a specific course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id AND a.course_id = 1
GROUP BY s.student_id
HAVING COUNT(DISTINCT g.assignment_id) = (SELECT COUNT(*) FROM assignments WHERE course_id = 1);

# 59) Retrieve the list of courses where the overall average grade is higher than the average grade of a specific student.
SELECT c.course_name, AVG(g.grade) AS overall_grade_average
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING overall_grade_average > (SELECT AVG(grade) FROM grades WHERE student_id = 1);

# 60) Retrieve the list of students who have not yet submitted any assignments for any course.
SELECT s.first_name, s.last_name
FROM students s
         LEFT JOIN grades g ON s.student_id = g.student_id
WHERE g.student_id IS NULL;

# 61) Retrieve the list of students who have completed all the courses they have enrolled in.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
         JOIN enrollments e ON s.student_id = e.student_id AND c.course_id = e.course_id
GROUP BY s.student_id
HAVING COUNT(DISTINCT c.course_id) = (SELECT COUNT(DISTINCT course_id)
                                      FROM enrollments
                                      WHERE student_id = s.student_id);

# 62) Retrieve the list of courses where the average grade is lower than a specific threshold.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING average_grade < 70;

# 63) Retrieve the list of courses where the number of students enrolled is less than a specific threshold.
SELECT c.course_name, COUNT(DISTINCT e.student_id) AS num_students_enrolled
FROM courses c
         JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING num_students_enrolled < 50;

# 64) Retrieve the list of students who have not completed a specific course but have submitted all the assignments for that course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id AND a.course_id = 1
         LEFT JOIN enrollments e ON s.student_id = e.student_id AND a.course_id = e.course_id
WHERE e.student_id IS NULL
GROUP BY s.student_id
HAVING COUNT(DISTINCT g.assignment_id) = (SELECT COUNT(*) FROM assignments WHERE course_id = 1);

# 65) Retrieve the list of courses where the average grade is higher than the overall average grade of all courses.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING average_grade > (SELECT AVG(grade) FROM grades);

# 66) Retrieve the list of courses where the average grade is higher than a specific threshold and the number of students enrolled is greater than a specific threshold.
SELECT c.course_name, AVG(g.grade) AS average_grade, COUNT(DISTINCT e.student_id) AS num_students_enrolled
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING average_grade > 80
   AND num_students_enrolled > 50;

# 67) Retrieve the list of students who have enrolled in at least two courses and have not submitted any assignments in the past month.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN enrollments e ON s.student_id = e.student_id
WHERE a.due_date < DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY s.student_id
HAVING COUNT(DISTINCT e.course_id) >= 2;

# 68) Retrieve the list of courses where the percentage of students who have submitted all the assignments is higher than a specific threshold.
SELECT c.course_name,
       COUNT(DISTINCT case when cnt = total_assignments then s.student_id end) * 1.0 / COUNT(DISTINCT e.student_id) AS completion_rate
FROM courses c
JOIN assignments a ON c.course_id = a.course_id
JOIN (
  SELECT s.student_id, e.course_id, COUNT(g.assignment_id) cnt, (SELECT COUNT(*) FROM assignments a2 WHERE a2.course_id = e.course_id) total_assignments
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  LEFT JOIN grades g ON s.student_id = g.student_id AND e.course_id = a.course_id
  GROUP BY s.student_id, e.course_id
) counts ON c.course_id = counts.course_id
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING completion_rate > 0.8;

# 69) Retrieve the list of students who have enrolled in a course but have not submitted any assignments.
SELECT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON s.student_id = g.student_id AND e.course_id = a.course_id
LEFT JOIN assignments a ON e.course_id = a.course_id
WHERE g.assignment_id IS NULL
GROUP BY s.student_id;

# 70) Retrieve the list of courses where the percentage of students who have submitted at least one assignment is lower than a specific threshold.
SELECT c.course_name, 1.0 * COUNT(DISTINCT case when cnt > 0 then s.student_id end) / COUNT(DISTINCT e.student_id) AS submission_rate
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN (
  SELECT s.student_id, e.course_id, COUNT(g.assignment_id) cnt
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  LEFT JOIN grades g ON s.student_id = g.student_id AND e.course_id = a.course_id
  LEFT JOIN assignments a ON g.assignment_id = a.assignment_id
  GROUP BY s.student_id, e.course_id
) counts ON e.course_id = counts.course_id AND e.student_id = counts.student_id
GROUP BY c.course_id
HAVING submission_rate < 0.5;

# 71) Retrieve the list of students who have submitted an assignment after the due date.
SELECT s.first_name, s.last_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN assignments a ON g.assignment_id = a.assignment_id
WHERE g.grade_date > a.due_date;

# 72) Retrieve the list of courses where the average grade of female students is higher than that of male students.
SELECT c.course_name,
       AVG(CASE WHEN s.gender = 'F' THEN g.grade END) AS female_avg_grade,
       AVG(CASE WHEN s.gender = 'M' THEN g.grade END) AS male_avg_grade
FROM courses c
JOIN assignments a ON c.course_id = a.course_id
JOIN grades g ON a.assignment_id = g.assignment_id
JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING female_avg_grade > male_avg_grade;

# 73) Retrieve the list of courses that have at least one female student and no male students.
SELECT c.course_name
FROM courses c
JOIN assignments a ON c.course_id = a.course_id
JOIN grades g ON a.assignment_id = g.assignment_id
JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING SUM(CASE WHEN s.gender = 'F' THEN 1 ELSE 0 END) > 0
   AND SUM(CASE WHEN s.gender = 'M' THEN 1 ELSE 0 END) = 0;

# 74) Retrieve the list of students who have submitted at least one assignment in all the courses they are enrolled in.
SELECT s.first_name, s.last_name
FROM students s
JOIN grades g ON s.student_id = g.student_id
JOIN assignments a ON g.assignment_id = a.assignment_id
GROUP BY s.student_id
HAVING COUNT(DISTINCT a.course_id) = (
  SELECT COUNT(DISTINCT e.course_id)
  FROM enrollments e
  WHERE e.student_id = s.student_id
);

# 75) Retrieve the list of students who have not enrolled in any courses.
SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

# 76) Retrieve the list of courses that have the highest number of enrolled students.
SELECT c.course_name, COUNT(DISTINCT g.student_id) AS num_students_enrolled
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
ORDER BY num_students_enrolled DESC
LIMIT 1;

# 77) Retrieve the list of assignments that have the lowest average grade.
SELECT a.assignment_name, AVG(g.grade) AS average_grade
FROM assignments a
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY a.assignment_id
ORDER BY average_grade
LIMIT 1;

# 78) Retrieve the list of students who have submitted all the assignments in a particular course.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id);

# 79) Retrieve the list of courses where the average grade of all students is above 80.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING AVG(g.grade) > 80;

# 80) Retrieve the list of students who have the highest grade in each course.
SELECT s.first_name, s.last_name, g.grade
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE (s.student_id, c.course_id, g.grade) IN (SELECT s.student_id, c.course_id, MAX(g.grade)
                                               FROM students s
                                                        JOIN grades g ON s.student_id = g.student_id
                                                        JOIN assignments a ON g.assignment_id = a.assignment_id
                                                        JOIN courses c ON a.course_id = c.course_id
                                               GROUP BY c.course_id);

# 81) Retrieve the list of students who have submitted all the assignments on time.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
WHERE g.grade_date <= a.due_date
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id);

# 82) Retrieve the list of students who have submitted late submissions for any assignment.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
WHERE g.grade_date > a.due_date
GROUP BY s.student_id;

# 83) Retrieve the list of courses that have the lowest average grade for a particular semester.
SELECT c.course_name, AVG(g.grade) AS average_grade
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
WHERE a.semester = 'Fall 2021'
GROUP BY c.course_id
ORDER BY average_grade
LIMIT 1;

# 84) Retrieve the list of students who have not submitted any assignment for a particular course.
SELECT s.first_name, s.last_name
FROM students s
         LEFT JOIN grades g ON s.student_id = g.student_id
         LEFT JOIN assignments a ON g.assignment_id = a.assignment_id
WHERE a.course_id = 1
  AND g.student_id IS NULL;

# 85) Retrieve the list of courses where the highest grade is less than 90.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
GROUP BY c.course_id
HAVING MAX(g.grade) < 90;

# 86) Retrieve the list of students who have submitted all the assignments, but their average grade is less than 70.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a)
   AND AVG(g.grade) < 70;

# 87) Retrieve the list of courses that have at least one student with an average grade of 90 or above.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING AVG(g.grade) >= 90;

# 88) Retrieve the list of students who have submitted all the assignments for a particular course but have not received a grade yet.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND g.grade IS NULL;

# 89) Retrieve the list of courses that have at least one student who has not submitted any assignments
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING COUNT(g.assignment_id) = 0;

# 90) Retrieve the list of students who have submitted all the assignments for a particular course but have not received a grade of 90 or above.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND MAX(g.grade) < 90;

# 91) Retrieve the list of courses that have at least one student who has submitted all the assignments but has not received a grade yet.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND g.grade IS NULL;

# 92) Retrieve the list of students who have submitted all the assignments for a particular course but have not received a grade yet.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND g.grade IS NULL;

# 93) Retrieve the list of courses that have at least one student who has submitted all the assignments but has not received a grade of 90 or above.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND MAX(g.grade) < 90;

# 94) Retrieve the list of students who have submitted all the assignments for a particular course but have not received a grade of 90 or above.
SELECT s.first_name, s.last_name
FROM students s
         JOIN grades g ON s.student_id = g.student_id
         JOIN assignments a ON g.assignment_id = a.assignment_id
         JOIN courses c ON a.course_id = c.course_id
WHERE c.course_name = 'Math 101'
GROUP BY s.student_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND MAX(g.grade) < 90;

# 95) Retrieve the list of courses that have at least one student who has submitted all the assignments but has not received a grade of 90 or above.
SELECT c.course_name
FROM courses c
         JOIN assignments a ON c.course_id = a.course_id
         JOIN grades g ON a.assignment_id = g.assignment_id
         JOIN students s ON g.student_id = s.student_id
GROUP BY c.course_id
HAVING COUNT(g.assignment_id) = (SELECT COUNT(a.assignment_id) FROM assignments a WHERE a.course_id = c.course_id)
   AND MAX(g.grade) < 90;

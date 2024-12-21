/* UNIVERSITY COURSE ENROLLMENT ANALYSIS */

CREATE DATABASE COURSE_ENROLLMENT;
USE COURSE_ENROLLMENT;

CREATE TABLE Courses 
(
course_id INT PRIMARY KEY,
course_name VARCHAR(50) NOT NULL,
department VARCHAR(25) NOT NULL,
instructor VARCHAR(50) NOT NULL,
credits INT NOT NULL
);

DESC Courses;

INSERT INTO Courses VALUES 
(101, 'Introduction to Programming', 'CS', 'Prof. Smith', 3),
(102, 'Database Management Systems', 'CS', 'Prof. Jones', 3),
(201, 'Calculus I', 'Math', 'Prof. Lee', 4),
(202, 'Statistics', 'Math', 'Prof. Brown', 3),
(301, 'Shakespeare', 'English', 'Prof. Williams', 3),
(302, 'Art History', 'Art', 'Prof. Miller', 3);

SELECT * FROM Courses;

CREATE TABLE Students 
(
student_id INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
major VARCHAR(25) NOT NULL,
year VARCHAR(10) NOT NULL
);

DESC Students;

INSERT INTO Students VALUES 
(1, 'Alice Smith', 'CS', 'Sophomore'),
(2, 'Bob Jones', 'Math', 'Junior'),
(3, 'Charlie Brown', 'English', 'Freshman'),
(4, 'Diana Garcia', 'Art', 'Senior');

SELECT * FROM Students;

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    student_id INT NOT NULL,
    semester VARCHAR(10) NOT NULL,
    year INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

DESC Enrollments;

INSERT INTO Enrollments VALUES 
(1, 101, 1, 'Fall', 2023),
(2, 102, 1, 'Fall', 2023),
(3, 201, 2, 'Fall', 2023),
(4, 202, 2, 'Fall', 2023),
(5, 301, 3, 'Fall', 2023),
(6, 101, 4, 'Spring', 2024),
(7, 302, 4, 'Spring', 2024);

SELECT * FROM Enrollments;

/* 1.TOTAL ENROLLMENTS BY COURSE:
Query to count how many students are enrolled in each course.
*/

SELECT 
    c.course_id, 
    c.course_name, 
    COUNT(e.enrollment_id) AS total_enrollments
FROM 
    Courses c
JOIN 
    Enrollments e
ON 
    c.course_id = e.course_id
GROUP BY 
    c.course_id, c.course_name
ORDER BY 
    total_enrollments DESC;
    
/*Explanation:
    This query joins the Courses and Enrollments tables using the course_id.
	It groups the data by course_id and course_name to calculate the total number of enrollments for each course.
    The COUNT function counts the enrollment records associated with each course.*/
    
/* 2.AVERAGE ENROLLMENT PER STUDENT:
Query to calculate the average number of courses taken by students.
*/

SELECT 
    AVG(course_count) AS average_courses_per_student
FROM (
    SELECT 
        student_id, 
        COUNT(enrollment_id) AS course_count
    FROM 
        Enrollments
    GROUP BY 
        student_id
) AS student_course_counts;

/*Explanation:
       The inner query counts the number of courses each student is enrolled in by grouping by student_id.
       The outer query calculates the average of these course counts using the AVG function.*/

/* 3.POPULAR COURSES BY MAJOR:
Query to identify the most popular course(s) in each major.
*/

SELECT 
    s.major, 
    c.course_name, 
    COUNT(e.enrollment_id) AS total_enrollments
FROM 
    Students s
JOIN 
    Enrollments e
ON 
    s.student_id = e.student_id
JOIN 
    Courses c
ON 
    e.course_id = c.course_id
GROUP BY 
    s.major, c.course_name
ORDER BY 
    s.major, total_enrollments DESC;
    
/*Explanation:
    This query joins the Students, Enrollments, and Courses tables to connect students with their enrolled courses and corresponding majors.
    It groups by major and course_name to count the number of enrollments in each course for each major.
    The results are ordered by major and popularity within each major.*/
    
/* 4.YEAR-OVER-YEAR ENROLLMENT COMPARISON:
Query to compare enrollments across years.
*/

SELECT 
    e.year, 
    COUNT(e.enrollment_id) AS total_enrollments
FROM 
    Enrollments e
GROUP BY 
    e.year
ORDER BY 
    e.year;
    
/*Explanation:
    The query calculates the total enrollments for each year by grouping data based on the year column from the Enrollments table.
    The results are ordered chronologically by year. */   




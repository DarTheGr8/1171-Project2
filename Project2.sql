--creating tables

create table programs(
program_id int not null primary key,
program_code varchar(50),
program_name text,
degree_id text,
degree text
);

create table courses(
course_id int not null primary key,
course_code char(50),
course_title text,
course_credits int not null
);

create table courses_programs(
co_pro int not null primary key,
program_id int,
foreign key (program_id)
references programs (program_id),
course_id int,
foreign key (course_id)
references courses (course_id)
);

create table feeder(
feeder_id int not null primary key,
school_name varchar (100),
management text,
urban_rural text,
municipality text,
funding varchar(100),
district varchar(100),

);

create table student_information(
student_id int not null primary key,
gender char(1),
city text,
program_start varchar(100),
program_status varchar(100),
programEnd varchar(100),
grad_date varchar(100),
ethnicity text,
feeder_id int,
foreign key (feeder_id)
references feeder (feeder_id)
);

create table grades(
grade_id int not null primary key,
semester varchar(50),
course_grade char(2),
course_points decimal,
student_id int,
foreign key (student_id)
references student_information (student_id),
course_id int,
foreign key (course_id)
references courses (course_id)
);

--personal queries

--which courses does AINT offer
SELECT C.course_code AS courses_offered_AINT
FROM courses as C
WHERE C.course_code LIKE 'CMPS%';

--how many students dropped out of AINT
SELECT COUNT(*) AS students_dropped_AINT
FROM student_information 
WHERE program_status = 'Dropped';

  --average gpa
SELECT courses.course_code, 
AVG(CASE 
      WHEN grades.course_grade = 'A' THEN 4.0
      WHEN grades.course_grade = 'A-' THEN 3.7
      WHEN grades.course_grade = 'B+' THEN 3.3
      WHEN grades.course_grade = 'B' THEN 3.0
      WHEN grades.course_grade = 'B-' THEN 2.7
      WHEN grades.course_grade = 'C+' THEN 2.3
      WHEN grades.course_grade = 'C' THEN 2.0
      WHEN grades.course_grade = 'C-' THEN 1.7
      WHEN grades.course_grade = 'D+' THEN 1.3
      WHEN grades.course_grade = 'D' THEN 1.0
      WHEN grades.course_grade = 'F' THEN 0.0
      ELSE NULL
    END) AS avg_gpa
FROM courses
JOIN grades 
on courses.course_id = grades.course_id
GROUP BY courses.course_code;
  
--how many total people in AINT
SELECT count (S.student_id) AS num_enrolled_AINT
FROM student_information AS S;

--showing amount of previous school attended 
SELECT  F.school_name, 
COUNT (student_id) AS Previous_school
FROM student_information AS S
JOIN feeder AS F 
ON S.student_id = F.feeder_id
GROUP BY school_name
;

--query searches for all the courses containing CMPS that are 3 or more credits
SELECT course_title AS title , course_credits AS credits
FROM courses
WHERE course_credits >= 3 AND course_code like 'CMPS%';

-- students that graduated from a school with a W in it
SELECT f.school_name  AS grads
from feeder AS f
JOIN student_information AS SI
on f.feeder_id=SI.feeder_id
where f.school_name like '%W%' 
AND SI.program_status = 'Graduated';

--courses that AINT offers containing 'cmps'
SELECT C.course_code AS courses_offered_AINT
FROM courses as C
WHERE C.course_code LIKE 'CMPS%';

--how many  males graduated from belize city
SELECT student_id 
AS id, gender, city, program_status
from student_information AS SI
WHERE gender = 'M'
AND city = 'Belize City'
AND program_status = 'Graduated';

--find out which males from belize city have gotten an A in AINT COURSES
SELECT SI.student_id as ID, g.course_grade as letter_grade
from student_information as SI
JOIN grades as g 
on SI.student_id = g.student_id
WHERE SI.gender = 'M' AND SI.city = 'Belize City'  AND g.course_grade LIKE 'A%'
;

--REQUIRED QUERIES--

--Find the total number of students and average course points by feeder institutions.
SELECT f.management, 
COUNT(DISTINCT SI.student_id) AS amount,
AVG(CAST(G.course_points AS float)) AS avg_course_points
FROM feeder AS f
JOIN student_information  AS SI 
on f.feeder_id = SI.feeder_id
JOIN grades AS g 
on SI.student_id = g.student_id
GROUP BY f.management;

--find the total number of stdnt and average course pnt by gender.
SELECT SI.gender AS Student_Gender,
count (SI.student_id) as amount,
AVG(CAST(g.course_points as
float)) as avg_course_points
FROM Student_information AS SI
JOIN Grades AS g
on SI.student_id = g.student_id
GROUP BY SI.gender 
;

--Find the total number of students and average course points by ethnicity.
SELECT si.ethnicity AS ethnicity,
count(si.student_id),
AVG(CAST(g.course_points AS FLOAT)) AS average
FROM student_information AS si
JOIN grades AS g 
on si.student_id = g.student_id
GROUP BY si.ethnicity;

--Find the total number of students and average course points by city.
SELECT si.city,
count(si.student_id) AS students,
AVG(CAST(g.course_points AS FLOAT)) AS average
FROM Student_information AS si
JOIN grades AS g 
ON si.student_id = g.student_id
GROUP BY si.city;

--Find the total number of students and average course points by district.
SELECT si.district AS district,
count(si.student_id) AS students,
AVG(CAST(g.course_points AS FLOAT)) AS average
FROM student_information AS si
JOIN grades AS g 
on si.student_id = g.student_id
GROUP BY si.district;

--total number and percentage of students by prog status
SELECT program_status AS program_stat,
count(student_id) AS students,
(count(student_id)*100.0)/(SELECT count(*) FROM student_information ) AS percentage
FROM student_information 
GROUP BY program_status;

--Find the letter grade breakdown (how many A, A-,B,B+,...)for each of the following
SELECT C.course_title,
COUNT(CASE
      WHEN G.course_grade = 'A' THEN 4.0
      WHEN G.course_grade = 'A-' THEN 3.7
      WHEN G.course_grade = 'B+' THEN 3.3
      WHEN G.course_grade = 'B' THEN 3.0
      WHEN G.course_grade = 'B-' THEN 2.7
      WHEN G.course_grade = 'C+' THEN 2.3
      WHEN G.course_grade = 'C' THEN 2.0
      WHEN G.course_grade = 'C-' THEN 1.7
      WHEN G.course_grade = 'D+' THEN 1.3
      WHEN G.course_grade = 'D' THEN 1.0
      WHEN G.course_grade = 'F' THEN 0.0
      ELSE NULL
END) AS svg_gpa
FROM courses AS C
JOIN grades AS G 
ON C.course_id = G.course_id
WHERE C.course_title IN  ('FUNDAMENTALS OF COMPUTING', 'PRINCIPLES OF PROGRAMMING I',
'ALGEBRA', 'TRIGONOMETRY', 'COLLEGE ENGLISH I')
GROUP BY C.course_title;

--   --average gpa
-- SELECT courses.course_code, 
-- AVG(CASE 
--       WHEN grades.course_grade = 'A' THEN 4.0
--       WHEN grades.course_grade = 'A-' THEN 3.7
--       WHEN grades.course_grade = 'B+' THEN 3.3
--       WHEN grades.course_grade = 'B' THEN 3.0
--       WHEN grades.course_grade = 'B-' THEN 2.7
--       WHEN grades.course_grade = 'C+' THEN 2.3
--       WHEN grades.course_grade = 'C' THEN 2.0
--       WHEN grades.course_grade = 'C-' THEN 1.7
--       WHEN grades.course_grade = 'D+' THEN 1.3
--       WHEN grades.course_grade = 'D' THEN 1.0
--       WHEN grades.course_grade = 'F' THEN 0.0
--       ELSE NULL
--     END) AS avg_gpa
-- FROM courses
-- JOIN grades as
-- on courses.course_id = G.course_id
-- GROUP BY courses.course_code;
  

-- SELECT COUNT(*) AS students_all_graduated
-- FROM students AS S
-- WHERE NOT EXISTS (
--   SELECT *
--   FROM student_information AS SC
--   WHERE SC.student_id = S.student_id
--     AND (S.program_status_id <> 2)
-- );
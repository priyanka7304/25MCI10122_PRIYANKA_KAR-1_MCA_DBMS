CREATE TABLE Students (
    student_id int PRIMARY KEY,
    name VARCHAR(50),
    dept_id int
);
CREATE TABLE Courses (
    course_id int PRIMARY KEY,
    course_name VARCHAR(50)
);
CREATE TABLE Enrollments (
    enroll_id int PRIMARY KEY,
    student_id int,
    course_id int,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
CREATE TABLE Departments (
    dept_id int PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO Departments VALUES (101, 'CSE');
INSERT INTO Departments VALUES (102, 'IT');
INSERT INTO Students VALUES (1, 'Aman', 101);
INSERT INTO Students VALUES (2, 'Priya', 102);
INSERT INTO Students VALUES (3, 'Rohit', 101);
INSERT INTO Students VALUES (4, 'Neha', NULL);
INSERT INTO Courses VALUES (201, 'DBMS');
INSERT INTO Courses VALUES (202, 'OS');
INSERT INTO Courses VALUES (203, 'Java');
INSERT INTO Enrollments VALUES (1, 1, 201);
INSERT INTO Enrollments VALUES (2, 1, 202);
INSERT INTO Enrollments VALUES (3, 2, 203);

--Query 1
select * from students ,enrollments,courses where students.student_id=enrollments.student_id and courses.course_id=enrollments.course_id;

--Query 2
select students.* from students Left join enrollments on students.student_id=enrollments.student_id
Left Join courses on courses.course_id=enrollments.course_id
where courses.course_id is null;

--Query 3
select courses.* from enrollments
Right Join courses on courses.course_id=enrollments.course_id

--Query 4 
select * from students left join departments on students.dept_id=departments.dept_id ;

--Query 5
select * from students,courses ;

select * from students cross join courses;

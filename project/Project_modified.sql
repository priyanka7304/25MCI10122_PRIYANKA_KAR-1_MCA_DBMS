
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    course VARCHAR(50),
    year INT
);

CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    capacity INT,
    occupied INT DEFAULT 0
);

CREATE TABLE allocation (
    allocation_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    room_id INT REFERENCES rooms(room_id),
    allocation_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE complaints (
    complaint_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    issue TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);


-- ============================================================
--  CONSTRAINTS (Original - Unchanged)
-- ============================================================

ALTER TABLE rooms
ADD CONSTRAINT check_capacity CHECK (occupied <= capacity);



CREATE OR REPLACE FUNCTION update_occupancy()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE rooms
    SET occupied = occupied + 1
    WHERE room_id = NEW.room_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER allocate_room_trigger
AFTER INSERT ON allocation
FOR EACH ROW
EXECUTE FUNCTION update_occupancy();


CREATE VIEW available_rooms AS
SELECT * FROM rooms
WHERE occupied < capacity;



CREATE OR REPLACE FUNCTION get_student_room(sid INT)
RETURNS TABLE(room_id INT) AS $$
BEGIN
    RETURN QUERY
    SELECT room_id FROM allocation WHERE student_id = sid;
END;
$$ LANGUAGE plpgsql;



INSERT INTO students (name, course, year)
VALUES
-- Original 6 students
('Aman',     'BBA',    2),
('Riya',     'BCA',    1),
('Karan',    'B.Tech', 4),
('Priyanka', 'MCA',    1),
('Sahil',    'MCA',    2),
('Shubham',  'MSC',    1),

('Harpreet Kaur',  'B.Tech',  1),   -- 7  | CSE first-year
('Navdeep Singh',  'B.Tech',  2),   -- 8  | ECE second-year
('Simran Sharma',  'BCA',     2),   -- 9  | BCA second-year
('Rohit Verma',    'MBA',     1),   -- 10 | MBA first-year
('Manpreet Gill',  'B.Tech',  3),   -- 11 | Mech third-year
('Deepika Negi',   'MCA',     2),   -- 12 | MCA second-year
('Arjun Malhotra', 'B.Com',   1),   -- 13 | B.Com first-year
('Jasleen Kaur',   'MBA',     2),   -- 14 | MBA second-year
('Vishal Thakur',  'B.Tech',  4),   -- 15 | IT final-year
('Pooja Bhatia',   'MSC',     2);   -- 16 | M.Sc second-year



INSERT INTO rooms (capacity, occupied)
VALUES
(2, 0),   -- room_id 1
(3, 0),   -- room_id 2
(4, 0),   -- room_id 3

(2, 0),   -- room_id 4 | Double-sharing
(3, 0),   -- room_id 5 | Triple-sharing
(4, 0),   -- room_id 6 | Quad room
(1, 0),   -- room_id 7 | Single occupancy (for senior/postgrad)
(2, 0),   -- room_id 8 | Double-sharing
(3, 0),   -- room_id 9 | Triple-sharing
(4, 0);   -- room_id 10| Quad room



INSERT INTO allocation (student_id, room_id)
VALUES
(1, 1),   -- Aman      → Room 1
(2, 3),   -- Riya      → Room 3
(3, 2);   -- Karan     → Room 2

INSERT INTO allocation (student_id, room_id)
VALUES
(4,  7),  -- Priyanka  → Room 7 (single; postgrad)
(5,  2),  -- Sahil     → Room 2 (shares with Karan)
(6,  5),  -- Shubham   → Room 5
(7,  3),  -- Harpreet  → Room 3
(8,  6),  -- Navdeep   → Room 6
(9,  5),  -- Simran    → Room 5
(10, 8),  -- Rohit     → Room 8
(11, 6),  -- Manpreet  → Room 6
(12, 9),  -- Deepika   → Room 9
(13, 4);  -- Arjun     → Room 4



INSERT INTO complaints (student_id, issue, status)
VALUES
(1,  'Water supply disrupted in bathroom since 2 days',          'Pending'),
(2,  'Wi-Fi connectivity very slow after 10 PM',                 'Pending'),
(3,  'Room window latch broken, security concern',               'Resolved'),
(5,  'Mess food quality has degraded this week',                 'Pending'),
(7,  'AC in room not functioning, room temperature unbearable',  'In Progress'),
(8,  'Cockroach infestation noticed near washroom',              'Pending'),
(10, 'Laundry machine on 2nd floor out of order',                'Resolved'),
(11, 'Common room TV remote is missing',                         'Pending'),
(13, 'Power socket near study table not working',                'In Progress'),
(6,  'Noisy neighbour disturbing studies late at night',         'Pending');


-- Q1: Students allocated to Room 1
SELECT s.name
FROM students s
JOIN allocation a ON s.student_id = a.student_id
WHERE a.room_id = 1;

-- Q2: Rooms that still have space
SELECT * FROM rooms WHERE occupied < capacity;

-- Q3: All pending complaints
SELECT * FROM complaints WHERE status = 'Pending';



-- Q4: List all students with their course and year (basic projection)
SELECT name, course, year
FROM students
ORDER BY course, year;

-- Q5: Students currently in their final year (B.Tech = 4, MBA/MCA = 2, etc.)
SELECT name, course, year
FROM students
WHERE year >= 3;

-- Q6: All students enrolled in B.Tech program
SELECT student_id, name, year
FROM students
WHERE course = 'B.Tech'
ORDER BY year;

-- Q7: Full allocation details — student name, room, and date
SELECT s.name, a.room_id, a.allocation_date
FROM students s
JOIN allocation a ON s.student_id = a.student_id
ORDER BY a.room_id;

-- Q8: Rooms with their current occupancy and remaining capacity
SELECT room_id,
       capacity,
       occupied,
       (capacity - occupied) AS remaining_seats
FROM rooms
ORDER BY remaining_seats DESC;

-- Q9: Students who have NOT been allocated any room yet
SELECT s.student_id, s.name, s.course
FROM students s
LEFT JOIN allocation a ON s.student_id = a.student_id
WHERE a.student_id IS NULL;

-- Q10: Count of students per course (useful for hostel planning)
SELECT course, COUNT(*) AS total_students
FROM students
GROUP BY course
ORDER BY total_students DESC;

-- Q11: Complaints with student name and current status
SELECT s.name, c.issue, c.status
FROM complaints c
JOIN students s ON c.student_id = s.student_id
ORDER BY c.status;

-- Q12: Rooms that are completely full (no vacancy)
SELECT room_id, capacity, occupied
FROM rooms
WHERE occupied = capacity;

-- Q13: Use the stored function — find which room student_id 7 is in
SELECT * FROM get_student_room(7);

-- Q14: All allocations made today (useful for warden's daily log)
SELECT s.name, a.room_id, a.allocation_date
FROM allocation a
JOIN students s ON a.student_id = s.student_id
WHERE a.allocation_date = CURRENT_DATE;



-- U1: Mark a specific complaint as Resolved (complaint_id = 1)
UPDATE complaints
SET status = 'Resolved'
WHERE complaint_id = 1;

-- U2: Mark all 'In Progress' complaints as 'Resolved' in bulk
UPDATE complaints
SET status = 'Resolved'
WHERE status = 'In Progress';

-- U3: Correct a student's year — Rohit (student_id=10) advances to year 2
UPDATE students
SET year = 2
WHERE student_id = 10;

-- U4: Update a student's course (e.g., course correction at CU)
UPDATE students
SET course = 'M.Tech'
WHERE student_id = 15;  -- Vishal Thakur upgraded from B.Tech to M.Tech

-- U5: Increase capacity of room 6 by 1 (extra bed added by hostel admin)
UPDATE rooms
SET capacity = capacity + 1
WHERE room_id = 6;



-- D1: Remove a specific complaint once fully handled
DELETE FROM complaints
WHERE complaint_id = 2 AND status = 'Resolved';

-- D2: Deallocate a student who has left the hostel (student_id = 13)
--     Must delete allocation before touching students (FK constraint)
DELETE FROM allocation
WHERE student_id = 13;

-- Also reduce room occupancy count manually when bypassing trigger
UPDATE rooms
SET occupied = occupied - 1
WHERE room_id = 4;  -- Arjun was in room 4



-- A1: Average occupancy rate across all rooms (as %)
SELECT ROUND(AVG(occupied::DECIMAL / capacity) * 100, 2) AS avg_occupancy_pct
FROM rooms;

-- A2: Total complaints grouped by status
SELECT status, COUNT(*) AS count
FROM complaints
GROUP BY status;

-- A3: Room-wise student list (multiple students per room shown together)
SELECT r.room_id, r.capacity, r.occupied,
       STRING_AGG(s.name, ', ') AS students_in_room
FROM rooms r
LEFT JOIN allocation a ON r.room_id = a.room_id
LEFT JOIN students s   ON a.student_id = s.student_id	
GROUP BY r.room_id, r.capacity, r.occupied
ORDER BY r.room_id;
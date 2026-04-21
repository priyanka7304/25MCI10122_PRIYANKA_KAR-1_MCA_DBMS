# Hostel Management System – PostgreSQL (DBMS Mini Project)

## Overview

The **Hostel** Management System is a PostgreSQL-based database project that digitizes core hostel operations such as student management, room allocation, and complaint tracking for an educational institution’s hostel. [file:1]  
It focuses on robust relational design, referential integrity, and automation through triggers, stored functions, and views. [file:1]

---

## Features

- Student management: Store basic academic details (name, course, year) for hostel residents. [file:1]
- Room management: Maintain rooms with capacity and dynamically updated occupancy count. [file:1]
- Allocation tracking: Map students to rooms with allocation date and prevent overbooking through constraints. [file:1]
- Complaint management: Record student complaints with status tracking (Pending, In Progress, Resolved). [file:1]
- Automation with triggers: Auto-increment room occupancy on each new allocation. [file:1]
- Stored function: Get room details of a student via PL/pgSQL function `get_student_room(sid INT)`. [file:1]
- Analytical queries: Room-wise student list using `STRING_AGG`, pending complaints, final-year students, available rooms, etc. [file:1]

---

## Tech Stack

- Database: PostgreSQL 14+ [file:1]
- Language: SQL, PL/pgSQL [file:1]
- Tools: pgAdmin 4, VS Code (SQL extension), terminal/psql [file:1]
- OS: Windows 10/11 or Ubuntu 20.04+ [file:1]

---

## Database Design

### Core Tables

1. `students` [file:1]
   - `student_id` (SERIAL, PK)
   - `name` (VARCHAR(100))
   - `course` (VARCHAR(50))
   - `year` (INT)

2. `rooms` [file:1]
   - `room_id` (SERIAL, PK)
   - `capacity` (INT)
   - `occupied` (INT, DEFAULT 0)

3. `allocation` [file:1]
   - `allocation_id` (SERIAL, PK)
   - `student_id` (INT, FK → students.student_id)
   - `room_id` (INT, FK → rooms.room_id)
   - `allocation_date` (DATE, DEFAULT CURRENT_DATE)

4. `complaints` [file:1]
   - `complaint_id` (SERIAL, PK)
   - `student_id` (INT, FK → students.student_id)
   - `issue` (TEXT)
   - `status` (VARCHAR(20), DEFAULT 'Pending')

### Constraints & Logic

- CHECK constraint on `rooms`: `occupied <= capacity` to prevent overbooking. [file:1]
- Trigger function `update_occupancy()` increments `rooms.occupied` after every insert into `allocation`. [file:1]
- Trigger `allocate_room_trigger` fires `AFTER INSERT` on `allocation` per row. [file:1]
- Function `get_student_room(sid INT) RETURNS TABLE(room_id INT)` to fetch room(s) for a given student. [file:1]

---

## Setup Instructions

1. Install PostgreSQL 14+ and pgAdmin 4. [file:1]
2. Create a new database, e.g. `hostel_mgmt`. [file:1]
3. Open a query tool (pgAdmin or psql) connected to this database. [file:1]
4. Run the DDL scripts in this order: [file:1]
   - Create tables: `students`, `rooms`, `allocation`, `complaints`.
   - Add constraints (CHECK on `rooms`).
   - Create trigger function `update_occupancy()` and trigger `allocate_room_trigger`.
   - Create `get_student_room(sid)` function and any view (e.g. available rooms view if defined).
5. Insert sample data for: [file:1]
   - 16 students.
   - 10 rooms (various capacities).
   - 13 allocation records.
   - 10 complaints.

---

## Example SQL Snippets

> Note: adapt schema names or identifiers if you changed them during implementation. [file:1]

### Table Creation

```sql
CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  name       VARCHAR(100),
  course     VARCHAR(50),
  year       INT
);

CREATE TABLE rooms (
  room_id  SERIAL PRIMARY KEY,
  capacity INT,
  occupied INT DEFAULT 0
);

CREATE TABLE allocation (
  allocation_id  SERIAL PRIMARY KEY,
  student_id     INT REFERENCES students(student_id),
  room_id        INT REFERENCES rooms(room_id),
  allocation_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE complaints (
  complaint_id SERIAL PRIMARY KEY,
  student_id   INT REFERENCES students(student_id),
  issue        TEXT,
  status       VARCHAR(20) DEFAULT 'Pending'
);
```

### Constraint, Trigger, Function

```sql
ALTER TABLE rooms
ADD CONSTRAINT check_capacity
CHECK (occupied <= capacity);

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

CREATE OR REPLACE FUNCTION get_student_room(sid INT)
RETURNS TABLE(room_id INT) AS $$
BEGIN
  RETURN QUERY
  SELECT room_id FROM allocation WHERE student_id = sid;
END;
$$ LANGUAGE plpgsql;
```

---

## Sample Queries

- Students in a specific room: [file:1]

```sql
SELECT s.name
FROM students s
JOIN allocation a ON s.student_id = a.student_id
WHERE a.room_id = 1;
```

- Rooms with available capacity: [file:1]

```sql
SELECT *
FROM rooms
WHERE occupied < capacity;
```

- Pending complaints: [file:1]

```sql
SELECT *
FROM complaints
WHERE status = 'Pending';
```

- Final-year B.Tech students (year > 3): [file:1]

```sql
SELECT name, course, year
FROM students
WHERE year > 3 AND course = 'B.Tech';
```

- Room-wise student list using `STRING_AGG`: [file:1]

```sql
SELECT r.room_id,
       r.capacity,
       r.occupied,
       STRING_AGG(s.name, ', ') AS students_in_room
FROM rooms r
LEFT JOIN allocation a ON r.room_id = a.room_id
LEFT JOIN students s ON a.student_id = s.student_id
GROUP BY r.room_id, r.capacity, r.occupied
ORDER BY r.room_id;
```

---

## Future Enhancements

- Add a web or desktop UI (e.g., Django/Flask/React) on top of this database. [file:1]
- Implement role-based access control for admin, warden, and student logins. [file:1]
- Integrate REST APIs, notification system for complaint updates, and advanced reporting dashboards. [file:1]

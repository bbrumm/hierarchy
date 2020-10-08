/* SQL Server, MySQL */
CREATE TABLE emp_h (
id INT,
first_name VARCHAR(100),
role VARCHAR(100),
manager_id INT
);

INSERT INTO emp_h (id, first_name, role, manager_id) VALUES
(1,'Claire','CEO',null),
(2,'Steve','Head of Sales',1),
(3,'Sarah','Head of Support',1),
(4,'John','Head of IT',1),
(5,'Nathan','Salesperson',2),
(6,'Paula','Salesperson',2),
(7,'Anne','Customer Support Officer',3),
(8,'Roger','Customer Support Officer',3),
(9,'Tim','Customer Support Officer',3),
(10,'Peter','Assistant',3),
(11,'Hugo','Team Leader',4),
(12,'Matthew','Developer',11),
(13,'Ruth','Developer',11),
(14,'Simon','QA Engineer',11);

/* Oracle */
CREATE TABLE emp_h (
id NUMBER,
first_name VARCHAR2(100),
role VARCHAR2(100),
manager_id NUMBER
);

INSERT ALL
INTO emp_h (id, first_name, role, manager_id) VALUES (1,'Claire','CEO',null)
INTO emp_h (id, first_name, role, manager_id) VALUES (2,'Steve','Head of Sales',1)
INTO emp_h (id, first_name, role, manager_id) VALUES (3,'Sarah','Head of Support',1)
INTO emp_h (id, first_name, role, manager_id) VALUES (4,'John','Head of IT',1)
INTO emp_h (id, first_name, role, manager_id) VALUES (5,'Nathan','Salesperson',2)
INTO emp_h (id, first_name, role, manager_id) VALUES (6,'Paula','Salesperson',2)
INTO emp_h (id, first_name, role, manager_id) VALUES (7,'Anne','Customer Support Officer',3)
INTO emp_h (id, first_name, role, manager_id) VALUES (8,'Roger','Customer Support Officer',3)
INTO emp_h (id, first_name, role, manager_id) VALUES (9,'Tim','Customer Support Officer',3)
INTO emp_h (id, first_name, role, manager_id) VALUES (10,'Peter','Assistant',3)
INTO emp_h (id, first_name, role, manager_id) VALUES (11,'Hugo','Team Leader',4)
INTO emp_h (id, first_name, role, manager_id) VALUES (12,'Matthew','Developer',11)
INTO emp_h (id, first_name, role, manager_id) VALUES (13,'Ruth','Developer',11)
INTO emp_h (id, first_name, role, manager_id) VALUES (14,'Simon','QA Engineer',11)
SELECT * FROM dual;


/*
SQL Server works. MySQL should work but untested.
*/
WITH empdata AS (
	(SELECT id, first_name, role, manager_id, 1 AS level
	FROM emp_h
	WHERE id = 1)
	UNION ALL
	(SELECT this.id, this.first_name, this.role, this.manager_id, prior.level + 1
	FROM empdata prior
	INNER JOIN emp_h this ON this.manager_id = prior.id)
)
SELECT e.id, e.first_name, e.role, e.manager_id, e.level
FROM empdata e
ORDER BY e.level;

/*
Oracle
*/
SELECT id, first_name, role, manager_id, level
FROM emp_h
START WITH id = 1
CONNECT BY PRIOR id = manager_id
ORDER BY level ASC;





SELECT id, first_name, role, indent_level
FROM employee
WHERE display_order >= (
	SELECT display_order
	FROM employee
	WHERE id = 3)
AND display_order < (
	SELECT display_order
	FROM employee
	WHERE indent_level = (
		SELECT indent_level
		FROM employee
		WHERE id = 3
	)
	AND display_order > (
		SELECT display_order
		FROM employee
		WHERE id = 3
	)
)
ORDER BY display_order;


/*
Create table with left and right Values
*/

CREATE TABLE emp_nested (
id INT,
first_name VARCHAR(100),
role VARCHAR(100),
left_val INT,
right_val INT
);


INSERT INTO emp_nested (id, first_name, role, left_val, right_val) VALUES
(1,'Claire','CEO', 1, 28),
(2,'Steve','Head of Sales', 2, 7),
(3,'Sarah','Head of Support', 8, 17),
(4,'John','Head of IT', 18, 27),
(5,'Nathan','Salesperson', 3, 4),
(6,'Paula','Salesperson', 5, 6),
(7,'Anne','Customer Support Officer', 9, 10),
(8,'Roger','Customer Support Officer', 11, 12),
(9,'Tim','Customer Support Officer', 13, 14),
(10,'Peter','Assistant', 15, 16),
(11,'Hugo','Team Leader', 19, 26),
(12,'Matthew','Developer', 20, 21),
(13,'Ruth','Developer', 22, 23),
(14,'Simon','QA Engineer', 24, 25);


CREATE TABLE emp_flat (
id INT,
first_name VARCHAR(100),
role VARCHAR(100),
display_order INT,
indent_level INT
);

INSERT INTO emp_flat (id, first_name, role, left_val, right_val) VALUES
(1,'Claire','CEO', 1, 0),
(2,'Steve','Head of Sales', 2, 1),
(3,'Sarah','Head of Support', 5, 1),
(4,'John','Head of IT', 10, 1),
(5,'Nathan','Salesperson', 3, 2),
(6,'Paula','Salesperson', 4, 2),
(7,'Anne','Customer Support Officer', 6, 2),
(8,'Roger','Customer Support Officer', 7, 2),
(9,'Tim','Customer Support Officer', 8, 2),
(10,'Peter','Assistant', 9, 2),
(11,'Hugo','Team Leader', 11, 2),
(12,'Matthew','Developer', 12, 3),
(13,'Ruth','Developer', 13, 3),
(14,'Simon','QA Engineer', 14, 3);

/*
Bridging Table method
*/

CREATE TABLE emp_bridge (
id INT,
first_name VARCHAR(100),
role VARCHAR(100)
);

CREATE TABLE employee_path (
ancestor INT,
descendant INT,
num_levels INT
);

INSERT INTO emp_bridge (id, first_name, role) VALUES
(1,'Claire','CEO'),
(2,'Steve','Head of Sales'),
(3,'Sarah','Head of Support'),
(4,'John','Head of IT',),
(5,'Nathan','Salesperson'),
(6,'Paula','Salesperson'),
(7,'Anne','Customer Support Officer'),
(8,'Roger','Customer Support Officer'),
(9,'Tim','Customer Support Officer'),
(10,'Peter','Assistant'),
(11,'Hugo','Team Leader'),
(12,'Matthew','Developer'),
(13,'Ruth','Developer'),
(14,'Simon','QA Engineer');

INSERT INTO employee_path (ancestor, descendant, num_levels) VALUES
(1, 1, 0),
(1, 2, 1),
(1, 3, 1),
(1, 4, 1),
(1, 5, 2),
(1, 6, 2),
(1, 7, 2),
(1, 8, 2),
(1, 9, 2),
(1, 10, 2),
(1, 11, 2),
(1, 12, 3),
(1, 13, 3),
(1, 14, 3),
(2, 2, 0),
(2, 5, 1),
(2, 6, 1),
(5, 5, 0),
(6, 6, 0),
(3, 3, 0),
(3, 7, 1),
(3, 8, 1),
(3, 9, 1),
(3, 10, 1),
(7, 7, 0),
(8, 8, 0),
(9, 9, 0),
(10, 10, 0),
(4, 4, 0),
(4, 11, 1),
(4, 12, 2),
(4, 13, 2),
(4, 14, 2),
(11, 11, 0),
(11, 12, 1),
(11, 13, 1),
(11, 14, 1),
(12, 12, 0),
(13, 13, 0),
(14, 14, 0);

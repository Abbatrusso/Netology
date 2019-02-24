-- Создание и заполнение таблиц
DROP TABLE IF EXISTS Department;

CREATE TABLE Department( 
    id INTEGER PRIMARY KEY,
    name VARCHAR
);

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee(
    id INTEGER PRIMARY KEY,
    department_id INTEGER,
    chief_doc_id INTEGER,
    name VARCHAR,
    num_public INTEGER
);

INSERT INTO Department VALUES
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');

INSERT INTO Employee VALUES
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);

-- A. Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов

SELECT 
    Department.name, 
    COUNT(DISTINCT(Employee.chief_doc_id))
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name;
-- B. Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)

SELECT 
    Department.name,
    Department.id,
    COUNT(DISTINCT(Employee.name))
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name, Department.id
HAVING COUNT(DISTINCT(Employee.name)) >= 3


-- C. Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)

SELECT
    Department.id, 
    Department.name,
    MAX(Employee.num_public) AS max_pub
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name, Department.id
ORDER BY Department.id;

-- D. Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)

-- Берет только одного автора статей с мин.кол-ом, не работает когда авторов > 1 

WITH temp_t AS 
(
  SELECT
    DISTINCT(department_id) AS id_d,
    Department.name AS name_d,
    Employee.name AS name_e,
    MIN(num_public) OVER (PARTITION BY department_id) AS min_pub,
    num_public AS num_pub
  FROM Employee
  JOIN Department ON department_id = Department.id 
  ORDER BY id_d
)

SELECT id_d, name_d, name_e, min_pub
FROM temp_t
WHERE num_pub = min_pub

-- E. Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)
SELECT
    Department.id, 
    Department.name,
    AVG(Employee.num_public) AS avg_pub
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name, Department.id
HAVING COUNT(DISTINCT(Employee.chief_doc_id)) > 1





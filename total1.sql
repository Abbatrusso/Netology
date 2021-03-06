-- Создание таблиц
-- Отделения
DROP TABLE IF EXISTS Department;

CREATE TABLE Department( 
    id INTEGER PRIMARY KEY,
    name VARCHAR
);

-- Главврачи
DROP TABLE IF EXISTS Сhief_doc;

CREATE TABLE Сhief_doc(
    id INTEGER PRIMARY KEY,
    name VARCHAR
);

-- Сотрудники
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee(
    id INTEGER PRIMARY KEY,
    department_id INTEGER REFERENCES Department(id),
    chief_doc_id INTEGER REFERENCES Сhief_doc(id),
    name VARCHAR,
    num_public INTEGER
);

-- Пациенты
DROP TABLE IF EXISTS Patient;

CREATE TABLE Patient(
    id INTEGER PRIMARY KEY,
    emp_id INTEGER REFERENCES Employee(id) 
);


-- Заполнение таблиц данными
INSERT INTO Department VALUES
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');

INSERT INTO Сhief_doc VALUES
('1', 'Ivan'),
('2', 'Igor'),
('3', 'Gergii'),
('4', 'Maya'),
('5', 'Nicolay'),
('6', 'Nadejda'),
('7', 'Lubov'),
('8', 'Zinaida'),
('9', 'Fedor');

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

INSERT INTO Patient VALUES
(1, 20),
(2, 20),
(3, 19),
(4, 19),
(5, 19),
(6, 18),
(7, 16),
(8, 16),
(9, 15),
(10, 14),
(11, 13),
(12, 12),
(13, 12),
(14, 11),
(15, 10),
(16, 9),
(17, 8),
(18, 7),
(19, 6),
(20, 5),
(21, 11),
(22, 3),
(23, 2),
(24, 1),
(25, 17),
(26, 19),
(27, 10),
(28, 19),
(29, 10),
(30, 19),
(31, 10),
(32, 19),
(33, 2),
(34, 8);

-- Запросы
-- 1. Вывести полную информацию из таблиц 
--    (id, отделение, глав.врач, врач, кол-во публикаций врача, кол-во пациентов)

SELECT
  Department.id AS id_dep,
  Department.name AS dep_name,
  Сhief_doc.name AS chief_doc_name,
  Employee.name AS doc_name,
  Employee.num_public AS num_pub,
  COUNT(emp_id) AS count_patient
FROM Patient
RIGHT JOIN Employee ON Patient.emp_id = Employee.id
JOIN Department ON Employee.department_id = Department.id
JOIN Сhief_doc ON Сhief_doc.id = Employee.chief_doc_id
GROUP BY id_dep, dep_name, chief_doc_name, doc_name, num_pub, emp_id
ORDER BY id_dep


-- 2. Вывести список отделений с кол-вом врачей, статей  и пациентов по отделениям 
--    (id, отделение, кол-во врачей, кол-во статей, кол-во пациентов)

WITH temp_t AS
(
SELECT
  Department.id AS id_dep,
  Department.name AS dep_name,
  Employee.name AS doc_name,
  Employee.num_public AS num_pub,
  COUNT(emp_id) AS count_patient
FROM Patient
RIGHT JOIN Employee ON Patient.emp_id = Employee.id
JOIN Department ON Employee.department_id = Department.id
GROUP BY id_dep, dep_name, doc_name, num_pub, emp_id
)

SELECT 
    DISTINCT (id_dep), 
    dep_name,
    COUNT(doc_name) OVER (PARTITION BY id_dep) AS sum_emp,
    SUM(num_pub) OVER (PARTITION BY id_dep) AS sum_pub,
    SUM(count_patient) OVER (PARTITION BY id_dep) AS sum_patient
FROM temp_t
ORDER BY id_dep

-- 3. Вывести список отделений со средним количеством публикаций по отделу и нормированный вклад отдела в общее кол-во публикаций 
--    (id, отделение, среднее кол-во публикаций отделения, кол-во публикаций отделения/общую сумму публикаций) 

WITH temp_t AS
(
SELECT
    DISTINCT (Department.id) AS dep_id, 
    Department.name AS dep_name,
    SUM(Employee.num_public) OVER (PARTITION BY Department.id) AS sum_pub,
    AVG(Employee.num_public) OVER (PARTITION BY Department.id) AS avg_pub
FROM Department
JOIN Employee ON Department.id = Employee.department_id
)

SELECT
    dep_id,
    dep_name,
    avg_pub,
    sum_pub / SUM(sum_pub) OVER () AS per_pub
FROM temp_t
WHERE sum_pub > 0
ORDER BY dep_id

-- 4. Вывести список отделений в которых более одного глав.врача с общим количеством персонала состоящим из врачей и главных врачей 
--    (id, отделение, кол-во глав.врачей, кол-во врачей, кол-во персонала)

SELECT
    Department.id AS dep_id,
    Department.name AS dep_name,
    COUNT(DISTINCT(Employee.chief_doc_id)) AS count_chief_doc,
    COUNT(Employee.id) AS count_doc,               
    COUNT(DISTINCT(Employee.chief_doc_id)) + COUNT(Employee.id) AS count_pers
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY dep_id
HAVING COUNT(DISTINCT(Employee.chief_doc_id)) > 1
ORDER BY dep_id
-- 5. Вывести список отделений с общим количеством персонала состоящим из врачей и главных врачей, 
--    кол-ом пациентов и отношением сколько врачей приходится на одного пациента 
--    (id, отделение, кол-во персонала, кол-во пациентов, среднее кол-во персонала на одного пациента)

WITH temp_t AS
(
SELECT
  Department.id AS dep_id,
  Department.name AS dep_name,
  Employee.name AS doc_name,
  Employee.num_public AS num_pub,
  COUNT(emp_id) AS count_patient
FROM Patient
RIGHT JOIN Employee ON Patient.emp_id = Employee.id
JOIN Department ON Employee.department_id = Department.id
GROUP BY dep_id, doc_name, num_pub, emp_id
)

SELECT 
    DISTINCT (dep_id), 
    dep_name,
    COUNT(doc_name) OVER (PARTITION BY dep_id) + count_chief_doc AS sum_pers,
    SUM(count_patient) OVER (PARTITION BY dep_id) AS sum_patient,
    ((COUNT(doc_name) OVER (PARTITION BY dep_id) + count_chief_doc) / SUM(count_patient) OVER (PARTITION BY dep_id)) AS pers_for_pat
FROM temp_t
JOIN 
  (
    SELECT 
        Department.id AS id_dep,
        COUNT(DISTINCT(Employee.chief_doc_id)) AS count_chief_doc
    FROM Department
    RIGHT JOIN Employee ON Department.id = Employee.department_id
    GROUP BY id_dep
  ) AS temp_tt 
ON dep_id = temp_tt.id_dep                       
ORDER BY dep_id

-- 6. Вывести список департаментов, в которых работают менее 5 сотрудников 
--    (id, отделение, количество сотрудников)

SELECT 
    Department.id AS dep_id,
    Department.name AS dep_name,
    COUNT(DISTINCT(Employee.name)) AS count_emp
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY dep_id
HAVING COUNT(DISTINCT(Employee.name)) < 5


-- 7. Вывести список отделений где работает более одного глав.врача с минимальным количеством публикаций  
--    (id, отделение, количество публикаций)

SELECT
    Department.id AS dep_id, 
    Department.name AS dep_name,
    MIN(Employee.num_public) AS min_pub
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY dep_id
HAVING COUNT(DISTINCT(Employee.chief_doc_id)) > 1
ORDER BY dep_id;


-- 8. Вывести по одному сотруднику с максимальным количеством публикаций в своем отделении 
--     (id, отделение, имя врача, количество публикаций)

SELECT
   DISTINCT(department_id) AS dep_id,
   Department.name AS dep_name,
   FIRST_VALUE(Employee.name) OVER (PARTITION BY department_id ORDER BY num_public DESC) AS name_doc,
   MAX(num_public) OVER (PARTITION BY department_id) AS max_pub
FROM Employee
JOIN Department ON department_id = Department.id
ORDER BY dep_id

-- 9. Вывести список отделений с общим количеством людей состоящим из пациентов, врачей и глав.врачей 
--    (id, отделение, кол-во людей)

WITH temp_t AS
(
SELECT
  Department.id AS dep_id,
  Department.name AS dep_name,
  Employee.name AS doc_name,
  Employee.num_public AS num_pub,
  COUNT(emp_id) AS count_patient
FROM Patient
RIGHT JOIN Employee ON Patient.emp_id = Employee.id
JOIN Department ON Employee.department_id = Department.id
GROUP BY dep_id, doc_name, num_pub, emp_id
)

SELECT 
    DISTINCT (dep_id), 
    dep_name,
    COUNT(doc_name) OVER (PARTITION BY dep_id) 
        + count_chief_doc
        + SUM(count_patient) OVER (PARTITION BY dep_id) AS sum_people
FROM temp_t
JOIN 
  (
    SELECT 
        Department.id AS id_dep,
        COUNT(DISTINCT(Employee.chief_doc_id)) AS count_chief_doc
    FROM Department
    RIGHT JOIN Employee ON Department.id = Employee.department_id
    GROUP BY id_dep
  ) AS temp_tt 
ON dep_id = temp_tt.id_dep                       
ORDER BY dep_id


-- 10. Вывести общее кол-во врачей, статей и пациентов
--       (кол-во врачей, кол-во статей, кол-во поциентов)

SELECT DISTINCT
    COUNT(Employee.name) OVER() AS count_doc,
    SUM(Employee.num_public) OVER() AS sum_pub,
    SUM(COUNT(emp_id)) OVER() AS sum_patient
FROM Patient
RIGHT JOIN Employee ON Patient.emp_id = Employee.id
JOIN Department ON Employee.department_id = Department.id
GROUP BY Employee.name, Employee.num_public, emp_id






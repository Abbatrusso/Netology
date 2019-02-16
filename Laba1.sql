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
-- без решения

-- E. Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)

SELECT
    Department.id, 
    Department.name,
    AVG(Employee.num_public) AS avg_pub
FROM Department
RIGHT JOIN Employee ON Department.id = Employee.department_id
GROUP BY Department.name, Department.id
HAVING COUNT(DISTINCT(Employee.chief_doc_id)) > 1

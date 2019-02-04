SELECT 'ФИО: Григорий Калугин';

-- 1.1 SELECT , LIMIT - выбрать 10 записей из таблицы ratings

SELECT * 
FROM ratings
LIMIT 10 OFFSET 5;

-- 1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42", а поле movieid между 100 и 1000

SELECT * 
FROM links
WHERE
    imdbid LIKE '%42'
    AND movieid BETWEEN 100 AND 1000
LIMIT 10;

-- 2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5

SELECT *
FROM links
INNER JOIN ratings
    ON links.movieid=ratings.movieid
WHERE rating=5
ORDER BY imdbId
LIMIT 10;

-- 3.1 COUNT() Посчитать число фильмов без оценок

SELECT COUNT(*) as count
FROM ratings
WHERE rating IS NULL;

-- 3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5

SELECT userid, AVG(rating) AS avg_rating
FROM ratings
GROUP BY userId
HAVING AVG(rating) > 3.5
ORDER BY avg_rating DESC
LIMIT 10;

-- 4.1 Достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.

SELECT DISTINCT imdbId
FROM links
INNER JOIN ratings ON links.movieid=ratings.movieid
GROUP BY imdbId
HAVING AVG(rating) > 3.5
LIMIT 10;


-- 4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок. 
-- Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.

WITH tmp_user
AS (
    SELECT userid, rating
    FROM ratings
    GROUP BY userid, rating
    HAVING COUNT(rating) > 10
)

SELECT AVG(rating) as avg_rating
FROM tmp_user;

    
	

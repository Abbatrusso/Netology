SELECT 'ФИО: Григорий Калугин';
 
-- 2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5
-- Исправлено после проверки
 
SELECT DISTINCT(imdbId)
FROM links
INNER JOIN ratings
    ON links.movieid=ratings.movieid
WHERE rating=5
ORDER BY imdbId
LIMIT 10;
 
-- 3.1 COUNT() Посчитать число фильмов без оценок
-- Исправил после проверки 

SELECT COUNT(links.movieid)
FROM links
FULL JOIN ratings ON links.movieid=ratings.movieid
WHERE ratings.movieid IS NULL;
 
 
-- 4.1 Достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.
-- Добавил вариант решения, было:

SELECT DISTINCT imdbId
FROM links
INNER JOIN ratings ON links.movieid=ratings.movieid
GROUP BY imdbId
HAVING AVG(rating) > 3.5
LIMIT 10;

-- Новая версия:

SELECT imdbid, movieid
FROM links
WHERE movieid IN (
    SELECT movieid
    FROM ratings 
    
GROUP BY movieid
    
HAVING AVG(rating) > 3.5)
LIMIT 10;

-- 1. КОМАНДА СОЗДАНИЯ ТАБЛИЦЫ
psql -U postgres -c "CREATE TABLE IF NOT EXISTS keywords (id bigint, tags text);"

-- 2. КОМАНДА ЗАЛИВКИ ДАННЫХ В ТАБЛИЦУ
psql -U postgres -c "\\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER as ',' CSV HEADER"

-- 3.1 WITH top_rated as ( ЗАПРОС1 ) ЗАПРОС2;
WITH top_rated AS (
    SELECT movieid, AVG(rating) :: numeric (10,2) as avg_rating
    FROM public.ratings
    GROUP BY movieid
    HAVING COUNT(userid) > 50
    ORDER BY movieid ASC, avg_rating DESC)

SELECT tags
FROM keywords 
JOIN top_rated ON top_rated.movieid = keywords.movieid
LIMIT 150;

-- 3.2 ЗАПРОС3
WITH top_rated AS (
    SELECT movieid, AVG(rating) :: numeric (10,2) as avg_rating
    FROM public.ratings
    GROUP BY movieid
    HAVING COUNT(userid) > 50
    ORDER BY movieid ASC, avg_rating DESC)
SELECT movieId INTO top_rated_tags 
FROM top_rated 


-- 4. КОМАНДА ВЫГРУЗКИ ТАБЛИЦЫ В ФАЙЛ
psql -U postgres -c "\copy (SELECT * FROM top_rated_tags) TO '/usr/local/share/netology/raw_data/top_rated_tags.csv' WITH CSV HEADER DELIMITER as E'\t'"

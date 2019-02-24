-- Вывести список пользователей в формате userId, movieId, normed_rating, avg_rating где
-- userId, movieId - без изменения
-- для каждого пользователя преобразовать рейтинг r в нормированный - normed_rating=(r - r_min)/(r_max - r_min), 
-- где r_min и r_max соответственно минимально и максимальное значение рейтинга у данного пользователя
-- avg_rating - среднее значение рейтинга у данного пользователя
-- Вывести первые 30 таких записей

WITH temp_t AS
(
    SELECT
        userId,
        movieId,
        rating,
        MAX(rating) OVER (PARTITION BY userId) AS max_r,
        MIN(rating) OVER (PARTITION BY userId) AS min_r
    FROM ratings
)

SELECT
    userid,
    movieid,
    (rating - min_r) / (max_r - min_r) AS normed_rating,
    AVG(rating) OVER (PARTITION BY userId) AS avg_rating
FROM temp_t
WHERE max_r <> min_r
ORDER BY userid
LIMIT 30;

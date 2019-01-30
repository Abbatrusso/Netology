--- Создание таблицы films
DROP TABLE IF EXISTS films;

CREATE TABLE
films (
    title TEXT NOT NULL CHECK(title !=''),
    id SERIAL PRIMARY KEY,
    country TEXT NOT NULL CHECK(country !=''),
    box_office INTEGER NOT NULL,
    release_date DATE NOT NULL
);

--- Заполнение данными таблицы films
INSERT INTO films VALUES 
  ('Чужие', 1, 'США', 131060248, '1986-07-14'),
  ('Криминальное чтиво', 2, 'США', 213928762, '1994-05-21'),
  ('Изгой', 3, 'США', 429632142, '2000-12-07'),
  ('28 дней спустя', 4, 'Великобритания', 82719885, '2002-11-01'),
  ('Звездный десант', 5, 'США', 121214377, '1997-11-04');


--- Создание таблицы persons
DROP TABLE IF EXISTS persons;

CREATE TABLE
persons (
    id SERIAL PRIMARY KEY,
    fio TEXT NOT NULL CHECK(fio !='')
);

--- Заполнение данными таблицы persons
INSERT INTO persons VALUES 
  (1, 'Джеймс Кэмерон'),
  (2, 'Квентин Тарантино'),
  (3, 'Роберт Земекис'),
  (4, 'Том Хенкс'),
  (5, 'Дэнни Бойл'),
  (6, 'Алекс Гарленд'),
  (7, 'Пол Верховен');

--- Создание таблицы persons2content
DROP TABLE IF EXISTS persons2content;

CREATE TABLE
persons2content (
    person_id SERIAL REFERENCES persons(id),
    film_id SERIAL REFERENCES films(id),
    person_type TEXT NOT NULL CHECK(person_type !=''),
    PRIMARY KEY(person_id, film_id) 
);

--- Заполнение данными таблицы persons2content
INSERT INTO persons2content VALUES 
  (1, 1, 'режиссер'),
  (2, 2, 'режиссер'),
  (3, 3, 'режиссер'),
  (4, 3, 'актер'),
  (5, 4, 'режиссер'),
  (6, 4, 'сценарист'),
  (7, 5, 'режиссер');

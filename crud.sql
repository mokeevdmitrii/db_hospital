SELECT *
FROM hospital.treatment_history;

INSERT INTO treatment_history
VALUES (0, 1, 1, 6, TIMESTAMP'2020-03-12', TIMESTAMP'2020-03-14', 'OK', FALSE);

/* поменять пневмонию на COVID */
UPDATE treatment_history AS th
SET diacrisis_id = 6
WHERE diacrisis_id = 5;

/* удалить вообще весь ковид */
DELETE FROM treatment_history WHERE diacrisis_id = 6;

/* посмотрим на все лекарства */
SELECT * from drugs;

/* вставим лекарство от спазма */
INSERT INTO drugs VALUES (10, 'Спазмалгон', 6);

/* ввели ограничение 12 лет на спазмалгон */
UPDATE drugs as d SET min_age_dk = 12 WHERE drug_nm = 'Спазмалгон';

/* удалим его лучше */
DELETE FROM drugs WHERE drug_nm = 'Спазмалгон';

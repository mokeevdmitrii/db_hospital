/* 1. Определить уровень смертности от COVID-19. Определяем как количество смертей / количество случаев заболевания */
SELECT (SELECT count(*)
        FROM hospital.treatment_history AS t
                 INNER JOIN hospital.diacrisises AS d ON t.diacrisis_id = d.diacrisis_id
        WHERE d.diacrisis_nm = 'COVID-19'
          and t.current_status_dk = 'D') * 1.0 / (
           SELECT count(*)
           FROM hospital.treatment_history AS t
                    INNER JOIN hospital.diacrisises AS d ON t.diacrisis_id = d.diacrisis_id
           WHERE d.diacrisis_nm = 'COVID-19'
       ) as result;


/* 2. Определить, какие лекарства являются самыми часто применимыми (вывести в порядке убывания)
   Лекарство считается применимым, если пришёл пациент с заболеванием,
   против которого предназначено лекарство. */
SELECT d.drug_nm, count(*) as use_count
FROM hospital.treatment_history AS th
         INNER JOIN hospital.diacrisises_x_preparations AS dxd on th.diacrisis_id = dxd.diacrisis_id
         LEFT JOIN hospital.drugs AS d on dxd.drug_id = d.drug_id
GROUP BY d.drug_nm
ORDER BY use_count DESC;

/*
   3. Простой запрос - вывести записи, когда пациентов нечем было лечить из-за возрастного ограничения,
   чтобы выяснить, как проходило лечение у лечащих врачей
 */
SELECT A.record_id, A.patient_nm, A.employee_nm, A.drug_nm, A.entry_dttm
FROM (SELECT DISTINCT th.record_id,
                      p.patient_nm,
                      d.drug_nm,
                      e.employee_nm,
                      th.entry_dttm,
                      CASE
                          WHEN
                                          (date_part('year', th.entry_dttm::date) - date_part('year', p.birth_dt)) *
                                          12 +
                                          (date_part('month', th.entry_dttm::date) - date_part('month', p.birth_dt)) <
                                          d.min_age_dk * 12 THEN 1
                          ELSE 0 END AS desired_result
      FROM hospital.treatment_history AS th
               INNER JOIN diacrisises_x_preparations dxd on th.diacrisis_id = dxd.diacrisis_id
               INNER JOIN patients p on th.patient_id = p.patient_id
               INNER JOIN drugs d on dxd.drug_id = d.drug_id
               INNER JOIN employees e on th.employee_id = e.employee_id) as A
WHERE A.desired_result = 1;

/*
 4. Ещё простой запрос - вывести всех пациентов известного сотрудника и частоту их посещения.
 */
SELECT patient_nm, count(*) as freq
FROM treatment_history
         INNER JOIN employees e on treatment_history.employee_id = e.employee_id
         INNER JOIN patients p on treatment_history.patient_id = p.patient_id
WHERE employee_nm = 'Купитман Иван Натанович'
GROUP BY patient_nm
order by freq DESC;

/*
  5. Вывести отделения, в которых заняты койко-места, количества койко-мест для 15 июня 2020 года.
*/
SELECT department_nm, count(*), in_patient_bed_cnt
FROM treatment_history
         INNER JOIN diacrisises d on treatment_history.diacrisis_id = d.diacrisis_id
         INNER JOIN departments d2 on d.department_id = d2.department_id
WHERE entry_dttm::date <= DATE'15-06-2020' and treatment_end_dttm::date >= DATE'15-06-2020' and in_patient_flag is TRUE
GROUP BY department_nm, in_patient_bed_cnt;


-- 4.Display a list of students who have enrolled in "Cơ sở dữ liệu" and "Mạng máy tính"
select * from student 
where student_id in
(select student_id from student
inner join enrollment using(student_id)
inner join subject using(subject_id)
where name='Cơ sở dữ liệu' and semester = '20172'
INTERSECT
select student_id from student
inner join enrollment using(student_id)
inner join subject using(subject_id)
where name='Mạng máy tính' and semester = '20172'
);

-- 5.Display a list of students who have enrolled in "Cơ sở dữ liệu" or "Mạng máy tính"
select * from student 
where student_id IN 
(select student_id from student
inner join enrollment using(student_id)
inner join subject using(subject_id)
where name='Cơ sở dữ liệu' or name='Mạng máy tính')
order by student_id;

-- 6.Display subjects that have never been registered by any students
select * from subject
where subject_id NOT IN (select subject_id from enrollment);

-- 7.List of subjects (subject name and credit number corresponding) that student "Nguyễn Nhật 
-- Ánh" have enrolled in the semester '20171'.
select * from student
inner join enrollment using (student_id)
inner join subject using (subject_id)
where trim(concat(last_name, ' ', first_name)) ILIKE 'Nguyễn Nhật Ánh' and semester = '20171';

-- 8.Show the list of students who enrolled in 'Cơ sở dữ liệu' in semesters = '20172'). This list 
-- contains student id, student name, midterm score, final exam score and subject score. Subject 
-- score is calculated by the weighted average of midterm score and final exam score : subject 
-- score = midterm score * (1- percentage_final_exam/100) + final score 
-- *percentage_final_exam/100.
select student_id, first_name, last_name, midterm_score, final_score,
(midterm_score * (1- CAST(percentage_final_exam AS FLOAT)/100) + final_score*CAST(percentage_final_exam AS FLOAT)/100)
AS subject_score 
from enrollment
inner join student using (student_id)
inner join subject using (subject_id)
where name='Cơ sở dữ liệu' and semester = '20172';

-- 9 .Display IDs of students who failed the subject with code 'IT1110' in semester '20171'. Note: a 
-- student failed a subject if his midterm score or his final exam score is below 3 ; or his subject 
-- score is below 4
WITH table_fake as (select student_id, first_name, last_name, midterm_score, final_score,
(midterm_score * (1- CAST(percentage_final_exam AS FLOAT)/100) + final_score*CAST(percentage_final_exam AS FLOAT)/100)
AS subject_score 
from enrollment
inner join student using (student_id)
inner join subject using (subject_id)
where subject_id='IT1110' and semester = '20171')
select * from table_fake
where midterm_score < 3 or final_score < 3 or subject_score < 4;

-- 10. List of all students with their class name, monitor name
select * from clazz
inner join student using (clazz_id)
where student_id = monitor_id;














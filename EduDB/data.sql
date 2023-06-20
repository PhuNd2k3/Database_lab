-- create database
CREATE DATABASE edudb_v2;
\c edudb_v2

-- TABLE DEFINITION
-- student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) 
-- clazz(clazz_id, name, lecturer_id, monitor_id)
-- subject(subject_id, name, credit, percentage_final_exam)
-- enrollment(student_id, subject_id, semester, midterm_score, final_score)

-- lecturer(lecturer_id, first_name, last_name, dob, gender, address, email)
-- teaching(subject_id, lecturer_id)
-- grade(code, from_score, to_score)

-- ================================================================================
-- student(student_id, first_name, last_name, dob, gender, address, note, clazz_id)
CREATE TABLE student (
	student_id CHAR(8) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	dob DATE NOT NULL,
	gender CHAR(1),
	address VARCHAR(30),
	note TEXT,
	clazz_id CHAR(8),
	CONSTRAINT student_pk PRIMARY KEY (student_id),
	CONSTRAINT student_chk_gender CHECK (gender = 'F' OR gender = 'M')
);

-- clazz(clazz_id, name, lecturer_id, monitor_id)
CREATE TABLE clazz (
	clazz_id CHAR(8) NOT NULL,
	name VARCHAR(20),
	lecturer_id CHAR(5),
	monitor_id CHAR(8),
	CONSTRAINT clazz_pk PRIMARY KEY (clazz_id),
	CONSTRAINT clazz_fk_student FOREIGN KEY (monitor_id) REFERENCES student(student_id)
);


-- subject(subject_id, name, credit, percentage_final_exam)
CREATE TABLE subject (
	subject_id CHAR(6) NOT NULL,
	name VARCHAR(30) NOT NULL,
	credit INT NOT NULL,
	percentage_final_exam INT NOT NULL,
	CONSTRAINT subject_pk PRIMARY KEY (subject_id),
	CONSTRAINT subject_chk_credit CHECK (credit >=1 AND credit <=5),
	CONSTRAINT subject_chk_percentage CHECK ( percentage_final_exam BETWEEN 0 AND 100)
);

-- lecturer(lecturer_id, first_name, last_name, dob, gender, address, email)
CREATE TABLE lecturer (
	lecturer_id CHAR(5) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	dob DATE NOT NULL,
	gender CHAR(1),
	address VARCHAR(30),
	email VARCHAR(40),
	CONSTRAINT lecturer_pk PRIMARY KEY (lecturer_id),
	CONSTRAINT lecturer_chk_gender CHECK (gender = 'F' OR gender = 'M')
);

-- teaching(subject_id, lecturer_id)
CREATE TABLE teaching(
	subject_id CHAR(6) NOT NULL,
	lecturer_id CHAR(5) NOT NULL,
	CONSTRAINT teaching_pk PRIMARY KEY (subject_id, lecturer_id)
);

-- grade(code, from_score, to_score)
CREATE TABLE grade(
	code CHAR(1) NOT NULL,
	from_score DECIMAL(3,1) NOT NULL,
	to_score DECIMAL(3,1) NOT NULL,
	CONSTRAINT grade_pk PRIMARY KEY (code),
	CONSTRAINT grade_chk_frmScore CHECK (from_score BETWEEN 0 AND 10),
	CONSTRAINT grade_chk_toScore CHECK ((to_score BETWEEN 0 AND 10) AND to_score > from_score),
	CONSTRAINT grade_chk_code CHECK (code IN ('A', 'B', 'C', 'D', 'F'))
);


-- enrollment(student_id, subject_id, semester, midterm_score, final_score)
CREATE TABLE enrollment (
	student_id CHAR(8) NOT NULL,
	subject_id CHAR(6) NOT NULL,
	semester CHAR(5) NOT NULL,
	midterm_score float,
	final_score float,
	CONSTRAINT enrollment_pk PRIMARY KEY (student_id, subject_id, semester),
	CONSTRAINT enrollment_chk_score CHECK ( cast(midterm_score as numeric) % 0.50 = 0.0 AND cast(final_score as numeric) % 0.50 = 0.0 AND midterm_score >=0 AND midterm_score <= 10 AND final_score >= 0 AND final_score <=10)
);

-- other check conditions
-- SQLServer: ALTER TABLE student ADD CONSTRAINT student_chk_age CHECK(DATEDIFF(YEAR, dob, current_date) BETWEEN 18 AND 35);
-- SQLServer: ALTER TABLE lecturer ADD CONSTRAINT lecturer_chk_age CHECK(DATEDIFF(YEAR, dob, current_date) BETWEEN 22 AND 65);
ALTER TABLE student ADD CONSTRAINT student_chk_age CHECK( (DATE_PART('year', current_date) - DATE_PART('year', dob)) BETWEEN 18 AND 100);
ALTER TABLE lecturer ADD CONSTRAINT lecturer_chk_age CHECK( (DATE_PART('year', current_date) - DATE_PART('year', dob)) BETWEEN 22 AND 100);

-- Foreign key constraints
ALTER TABLE student ADD CONSTRAINT student_fk_class FOREIGN KEY (clazz_id) REFERENCES clazz(clazz_id);
ALTER TABLE teaching ADD CONSTRAINT teaching_fk_subject FOREIGN KEY (subject_id) REFERENCES subject(subject_id);
ALTER TABLE teaching ADD CONSTRAINT teaching_fk_lecturer FOREIGN KEY (lecturer_id) REFERENCES lecturer(lecturer_id);
ALTER TABLE clazz ADD CONSTRAINT clazz_fk_lecturer FOREIGN KEY (lecturer_id) REFERENCES lecturer(lecturer_id);
-- ALTER TABLE clazz ADD CONSTRAINT clazz_fk_student FOREIGN KEY (monitor_id) REFERENCES student(student_id);

ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk_student FOREIGN KEY (student_id) REFERENCES student(student_id);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk_subject FOREIGN KEY (subject_id) REFERENCES subject(subject_id);

-- Data
-- clazz(clazz_id, name, lecturer_id, monitor_id)
INSERT INTO clazz(clazz_id, name) VALUES ('20162101', 'CNTT1.01-K61');
INSERT INTO clazz(clazz_id, name) VALUES ('20162102', 'CNTT1.02-K61');
INSERT INTO clazz(clazz_id, name) VALUES ('20172201', 'CNTT2.01-K62');
INSERT INTO clazz(clazz_id, name) VALUES ('20172202', 'CNTT2.02-K62');

\encoding 'UTF8'
-- student(student_id, first_name, last_name, dob, gender, address, note, clazz_id)
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20160001', 'Ngọc An', 'Bùi', '1987-03-18', 'M', '15 Lương Định Của,Đ. Đa, HN',NULL, '20162101');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20160002', 'Anh', 'Hoàng', '1987-05-20', 'M', '513 B8 KTX BKHN', NULL, '20162101');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20160003', 'Thu Hồng', 'Trần', '1987-06-06', 'F', '15 Trần Đại Nghĩa, HBT, Hà nội',NULL, '20162101');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20160004', 'Minh Anh', 'Nguyễn', '1987-05-20', 'F', '513 TT Phương Mai, Đ. Đa, HN', NULL, '20162101');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20170001', 'Nhật Ánh', 'Nguyễn', '1988-05-15', 'F', '214 B6 KTX BKHN', NULL, '20172201');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20170002', 'Nhật Cường', 'Nguyễn', '1988-10-24', 'M', '214 B5 KTX BKHN', NULL, '20172201');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20170003', 'Nhật Cường', 'Nguyễn', '1988-01-24', 'M', '214 B5 KTX BKHN', NULL, '20172201');
INSERT INTO student(student_id, first_name, last_name, dob, gender, address, note, clazz_id) VALUES ('20170004', 'Minh Đức', 'Bùi', '1988-01-25', 'M', '214 B5 KTX BKHN', NULL, '20172201');

-- Update monitor_id for each class:
UPDATE clazz SET monitor_id = '20160003' WHERE clazz_id = '20162101';
UPDATE clazz SET monitor_id = '20170001' WHERE clazz_id = '20172201';

-- subject(subject_id, name, credit, percentage_final_exam)
INSERT INTO subject(subject_id, name, credit, percentage_final_exam) VALUES ('IT3090', 'Cơ sở dữ liệu', 3, 70);
INSERT INTO subject(subject_id, name, credit, percentage_final_exam) VALUES ('IT1110', 'Tin học đại cương', 4, 60);
INSERT INTO subject(subject_id, name, credit, percentage_final_exam) VALUES ('IT3080', 'Mạng máy tính', 3, 70);
INSERT INTO subject(subject_id, name, credit, percentage_final_exam) VALUES ('IT4866', 'Học máy', 2, 70);
INSERT INTO subject(subject_id, name, credit, percentage_final_exam) VALUES ('IT4857', 'Thị giác máy tính', 3, 50);

-- lecturer(lecturer_id, first_name, last_name, dob, gender, address, email)
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02001', 'Việt Trung', 'Trần', '1984-06-02', 'M', '147 Linh Đàm, HN', 'trungtv@soict.hust.edu.vn');
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02002', 'Tuyết Trinh', 'Vũ', '1975-10-01', 'F', NULL, 'trinhvt@soict.hust.edu.vn');
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02003', 'Linh', 'Trương', '1976-09-08', 'F', 'Hà nội', NULL);
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02004', 'Quang Khoát', 'Thân', '1982-10-08', 'M', 'Hà nội', 'khoattq@soict.hust.edu.vn');
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02005', 'Oanh', 'Nguyễn', '1978-02-18', 'F', 'HBT, HN', 'oanhnt@soict.hust.edu.vn');
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02006', 'Nhật Quang', 'Nguyễn', '1976-04-16', 'M', 'HBT, HN', 'quangnn@gmail.com');
INSERT INTO lecturer(lecturer_id, first_name, last_name, dob, gender, address, email) VALUES('02007', 'Hồng Phương', 'Nguyễn', '1984-03-12', 'M', '17A Tạ Quang Bửu, HBT, HN', 'phuongnh@gmail.com');

-- teaching(subject_id, lecturer_id)
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT3080', '02003');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT3090', '02002');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT3090', '02005');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT3090', '02007');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT1110', '02001');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT1110', '02007');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT4866', '02006');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT4866', '02004');
INSERT INTO teaching(subject_id, lecturer_id) VALUES ('IT4857', '02005');

-- grade(code, from_score, to_score)
INSERT INTO grade(code, from_score, to_score) VALUES ('A', 8.5, 10.0);
INSERT INTO grade(code, from_score, to_score) VALUES ('B', 7.0, 8.4);
INSERT INTO grade(code, from_score, to_score) VALUES ('C', 5.5, 6.9);
INSERT INTO grade(code, from_score, to_score) VALUES ('D', 4.0, 5.4);
INSERT INTO grade(code, from_score, to_score) VALUES ('F', 0.0, 3.9);

-- clazz(clazz_id, name, lecturer_id, monitor_id)
-- Update lecturer_id
UPDATE clazz SET lecturer_id = '02001' WHERE clazz_id = '20162101';
-- UPDATE clazz SET lecturer_id = '02007' WHERE clazz_id = '20162102';
UPDATE clazz SET lecturer_id = '02002' WHERE clazz_id = '20172201';
-- UPDATE clazz SET lecturer_id = '02006' WHERE clazz_id = '20172202';
 
-- enrollment(student_id, subject_id, semester, midterm_score, final_score)
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160001' , 'IT1110', '20171', 9, 8.5);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160001' , 'IT3080', '20172', 8, 8);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160001' , 'IT3090', '20172', 6, 9);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160002' , 'IT1110', '20171', 2, 8);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160002' , 'IT3080', '20172', 9, 8);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160002' , 'IT3090', '20172', 9, 8.5);

INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160003' , 'IT1110', '20171', 7, 6);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160003' , 'IT3080', '20172', 8, 7);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160003' , 'IT3090', '20172', 9.5, 8.5);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160003' , 'IT4857', '20172', 7.5, 9.0);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160003' , 'IT4866', '20172', 7, 9.0);

INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20160004' , 'IT1110', '20171', 6, 5);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170001' , 'IT1110', '20171', 8, 7.5);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170002' , 'IT1110', '20171', 7.5, 7.5);

INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170001' , 'IT3080', '20172', 8, 7.5);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170002' , 'IT3080', '20172', 7.5, 7.5);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170002' , 'IT3090', '20172', 7.5, 7.5);

INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170003' , 'IT1110', '20172', 5, 7);
INSERT INTO enrollment(student_id, subject_id, semester, midterm_score, final_score) VALUES ('20170004' , 'IT1110', '20172', 5, 7);
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170001' , 'IT3080', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170002' , 'IT3080', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170003' , 'IT3080', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170004' , 'IT3080', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170001' , 'IT3090', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170002' , 'IT3090', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170003' , 'IT3090', '20181');
INSERT INTO enrollment(student_id, subject_id, semester) VALUES ('20170004' , 'IT3090', '20181');


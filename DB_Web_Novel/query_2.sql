-- 3 function 2 view 3 trigger

CREATE OR REPLACE VIEW novel_info AS
SELECT novel.novel_id, novel.novel_name, novel.author, users.username AS translator, novel.total_chapters, novel.novel_view, novel.avg_star
FROM novel
JOIN users ON novel.trans_id = users.user_id;

CREATE OR REPLACE VIEW user_info AS
SELECT users.user_id, username, mail, gender, COUNT(trans_id) AS translated_novel, birth_year, genre.genre_name as most_favor_genre
FROM users NATURAL JOIN favorite_genre JOIN genre ON (favorite_genre.favor_genre_id = genre.genre_id) LEFT JOIN novel ON (novel.trans_id = users.user_id)
WHERE ord_genre = 1
GROUP BY users.user_id, genre.genre_id;


CREATE OR REPLACE FUNCTION increase_novel_view(p_novel_id int)
RETURNS VOID AS $$
BEGIN
    UPDATE novel
    SET novel_view = novel_view + 1
    WHERE novel_id = p_novel_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION find_novel_by_composed_year(p_composed_year int)
RETURNS TABLE (novel_id int, novel_name text, composed_year int) AS $$
BEGIN
	RETURN QUERY
	SELECT novel.novel_id, novel.novel_name, novel.composed_year
	FROM novel
	WHERE novel.composed_year = p_composed_year;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION find_novel_by_genre(p_genre_id int)
RETURNS TABLE (novel_id int, novel_name text, genre_id int) AS $$
BEGIN
    RETURN QUERY
    SELECT novel.novel_id, novel.novel_name, with_genre.genre_id
    FROM novel
    INNER JOIN with_genre ON novel.novel_id = with_genre.novel_id
    WHERE with_genre.genre_id = p_genre_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_avg_star()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE novel
    SET avg_star = (
        SELECT (AVG(star)::numeric(2,1))
        FROM read
        WHERE novel_id = NEW.novel_id
    )
    WHERE novel_id = NEW.novel_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER update_avg_star_trigger
AFTER INSERT OR UPDATE ON read
FOR EACH ROW
WHEN (NEW.star is not null)
EXECUTE FUNCTION update_avg_star();

CREATE OR REPLACE FUNCTION update_total_chapters()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE novel
        SET total_chapters = total_chapters + 1
        WHERE novel_id = NEW.novel_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE novel
        SET total_chapters = total_chapters - 1
        WHERE novel_id = OLD.novel_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_total_chapters_trigger
AFTER INSERT OR DELETE ON content
FOR EACH ROW
EXECUTE FUNCTION update_total_chapters();

CREATE OR REPLACE FUNCTION delete_novel()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM content
	WHERE novel_id = OLD.novel_id;
	DELETE FROM with_genre
	WHERE novel_id = OLD.novel_id;
	DELETE FROM read
	WHERE novel_id = OLD.novel_id;

	DELETE FROM novel
	WHERE novel_id = OLD.novel_id;

	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_novel_trigger
INSTEAD OF DELETE ON novel_info
FOR EACH ROW
EXECUTE FUNCTION delete_novel();

-- CREATE OR REPLACE FUNCTION delete_related_chapters()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     DELETE FROM content
--     WHERE novel_id = OLD.novel_id;
    
--     RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;


-- CREATE OR REPLACE TRIGGER delete_related_chapters_trigger
-- BEFORE DELETE ON novel
-- FOR EACH ROW
-- EXECUTE FUNCTION delete_related_chapters();
-- TRIGGER BỊ DÍNH BUG LIÊN QUAN TỚI TRIGGER CẬP NHẬT SỐ CHAP

-- 22 QUERY

-- 1. Kiem tra dang nhap
SELECT * FROM users
WHERE mail= 'your_mail' AND 
password = 'your_pass';

-- 2. Top 5 truyen nhieu luot xem nhat
SELECT * FROM novel_info
ORDER BY novel_view DESC
LIMIT 5;

-- 3. Hien thi ten va so sao trung binh top 5 user co trung binh so sao o tat ca cac truyen da dich cao nhat
SELECT username, AVG(avg_star)::numeric(2,1) as avg_all_star
FROM users join novel on user_id = trans_id
GROUP BY user_id
ORDER BY avg_all_star DESC;

-- 4. Top 5 truyen co nhieu chap nhat
SELECT *
FROM novel_info
ORDER BY total_chapters DESC
LIMIT 5;


-- 5. Truyen va cac chap duoc dang trong thang nay
SELECT novel.novel_id, novel_name, total_chapters, avg_star, chapter, posting_date
FROM novel
INNER JOIN content ON novel.novel_id = content.novel_id
WHERE EXTRACT(MONTH FROM posting_date) = EXTRACT(MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM posting_date) = EXTRACT(YEAR FROM CURRENT_DATE);

-- 6. Thong tin truyen co so sao trung binh > 4.0
SELECT *
FROM novel_info
WHERE avg_star > 4.0;

-- 7. Truyen co luot danh gia 1 sao va feedback tuong ung
SELECT username, novel_name, star, feedback
FROM users NATURAL JOIN read NATURAL JOIN novel
WHERE star = 1;

-- 8. Sap xep nguoi dung theo so luong truyen da doc giam dan
SELECT users.username, COUNT(read.novel_id) AS total_read
FROM users
LEFT JOIN read ON users.user_id = read.user_id
GROUP BY users.username
ORDER BY total_read DESC;

-- 9. TIm truyen theo ten tac gia
SELECT *
FROM novel_info
WHERE author ILIKE '%mot_phan_ten%';

-- 10. Tim truyen theo ten nguoi dich
SELECT *
FROM novel_info
WHERE translator ILIKE '%phu%';

-- 11. Nguoi dung tren 18 tuoi
SELECT *
FROM users
WHERE birth_year <= EXTRACT(YEAR FROM NOW()) - 18;

-- 12. Nguoi dung co cung cap so dien thoai
SELECT *
FROM users
WHERE phone_number IS NOT NULL;

-- 13. Truyen duoc xuat hien trong danh sach ua thich nhieu nhat (ord 1 -> 5 deu duoc)
SELECT genre_name, COUNT(*) as total_top_favor
FROM genre join favorite_genre on genre_id = favor_genre_id
WHERE ord_genre = 1
GROUP BY genre_id
ORDER BY total_top_1_ord DESC;

-- 14. Sap xep cac the loai theo tieu chi duoc xep ua thich thu 1 nhieu nhat (ord =1)
SELECT genre_name, COUNT(*) as total_top_1_ord
FROM genre join favorite_genre on genre_id = favor_genre_id
WHERE ord_genre = 1
GROUP BY genre_id
ORDER BY total_top_1_ord DESC;

-- 15. Nguoi dung chua doc truyen nao
SELECT *
FROM users
WHERE user_id NOT IN (
    SELECT user_id
    FROM read
);

-- 16. The loai va tong so truyen co the loai do sap xep giam dan
SELECT genre_name, COUNT(*) AS total_novels
FROM genre
JOIN with_genre ON genre.genre_id = with_genre.genre_id
GROUP BY genre.genre_id
ORDER BY COUNT(*) DESC;


-- 17. Danh sach tac gia va so truyen da sang tac sap xep giam dan theo so truyen
SELECT author, COUNT(*) AS total_novels
FROM novel
GROUP BY author
ORDER BY total_novels DESC;

-- 18. Nguoi dung chua dich truyen nao
SELECT *
FROM users
WHERE user_id NOT IN (
    SELECT trans_id
    FROM novel
);

-- 19. Ten nguoi dich va cac truyen da dich co so sao > 4.0
SELECT users.username, novel.novel_name, avg_star
FROM users
JOIN novel ON users.user_id = novel.trans_id
WHERE avg_star > 4.0;


-- 20. Truyen co so chuong > 2
SELECT *
FROM novel
WHERE total_chapters > 2;


-- 21. Truyen co the loai Action va so sao > 4.0 truy xuat tu view novel_info
SELECT novel_info.*, genre.genre_name
FROM novel_info
JOIN with_genre ON novel_info.novel_id = with_genre.novel_id
JOIN genre ON with_genre.genre_id = genre.genre_id
WHERE lower(genre.genre_name) = lower('Action') AND novel_info.avg_star > 4.0;

-- 22. Tong so truyen co chap moi duoc dang trong nam nay
SELECT COUNT(*) AS total_novels_this_year
FROM novel
JOIN content ON novel.novel_id = content.novel_id
WHERE EXTRACT(YEAR FROM content.posting_date) = EXTRACT(YEAR FROM NOW());


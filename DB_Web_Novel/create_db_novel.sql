create table genre(
    genre_id serial primary key,
    genre_name varchar(100) not null
);
create table users(
    user_id serial primary key,
    username varchar(50) not null,
    mail varchar(50) not null unique,
    gender varchar(6) check (gender in ('Male','Female','Other')) not null,
    address varchar(60),
    phone_number varchar(20),
    password varchar(60) not null,
    birth_year int not null check (birth_year <= extract(year from now()))
);

CREATE TABLE novel(
    novel_id serial primary key,
    trans_id int not null,
    author varchar(50) not null,
    composed_year int not null check(composed_year > 1900 and composed_year <= extract(year from now())),
    novel_name text not null,
    novel_description text not null,
    novel_view int not null default 0,
    total_chapters int not null default 0,
    avg_star numeric(2,1),
    novel_photo_url varchar(1000),
    foreign key(trans_id) references users(user_id)
);

create table with_genre(
    novel_id int not null,
    genre_id int not null,
    primary key(novel_id, genre_id),
    foreign key(novel_id) references novel(novel_id),
    foreign key(genre_id) references genre(genre_id)
);

create table read(
    user_id int not null,
    novel_id int not null,
    feedback text,
    star int check(star > 0 and star <6), -- it's mean start in 1 2 3 4 5
    primary key(user_id, novel_id),
    foreign key(novel_id) references novel(novel_id),
    foreign key(user_id) references users(user_id)
);


create table favorite_genre(
    user_id int not null,
    favor_genre_id int not null,
    ord_genre int not null,
    primary key (user_id, favor_genre_id),
    foreign key(user_id) references users(user_id),
    foreign key(favor_genre_id) references genre(genre_id)
);

create table content(
    novel_id int not null,
    chapter int not null check (chapter >=0),
    content text not null,
    chapter_name varchar(100),
    posting_date date not null,
    primary key(novel_id, chapter),
    foreign key (novel_id) references novel(novel_id)
);
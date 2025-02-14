create table public.books
(
    id               bigserial
        primary key,
    title            varchar(255) not null,
    author           varchar(255) not null,
    publication_year integer
);

alter table public.books
    owner to postgres;

create table public.users
(
    id       bigserial
        primary key,
    username varchar(100) not null,
    email    varchar(100) not null
);

alter table public.users
    owner to postgres;

create trigger user_update_trigger
    after update
    on public.users
    for each row
    execute procedure public.log_user_action();

create trigger user_delete_trigger
    after delete
    on public.users
    for each row
    execute procedure public.log_user_action();

create table public.reservations
(
    id               bigint default nextval('reservations_books_id_seq'::regclass) not null
        constraint reservations_books_pkey
            primary key,
    book_id          integer
        constraint reservations_books_book_id_fkey
            references public.books,
    username_id      integer
        constraint reservations_books_username_id_fkey
            references public.users
            on delete cascade,
    reservation_date date,
    return_date      date                                                          not null
);

alter table public.reservations
    owner to postgres;

create table public.logs
(
    id          bigserial
        primary key,
    action      varchar(50),
    username_id integer,
    action_time timestamp default CURRENT_TIMESTAMP
);

alter table public.logs
    owner to postgres;

create table public.flyway_schema_history
(
    installed_rank integer                 not null
        constraint flyway_schema_history_pk
            primary key,
    version        varchar(50),
    description    varchar(200)            not null,
    type           varchar(20)             not null,
    script         varchar(1000)           not null,
    checksum       integer,
    installed_by   varchar(100)            not null,
    installed_on   timestamp default now() not null,
    execution_time integer                 not null,
    success        boolean                 not null
);

alter table public.flyway_schema_history
    owner to postgres;

create index flyway_schema_history_s_idx
    on public.flyway_schema_history (success);

create function public.log_user_action() returns trigger
    language plpgsql
as
$$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO logs (action, username_id)
        VALUES ('UPDATE', OLD.id);
RETURN NEW;
ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs (action, username_id)
        VALUES ('DELETE', OLD.id);
RETURN OLD;
END IF;
RETURN NULL;
END;
$$;

alter function public.log_user_action() owner to postgres;

create function public.get_last_registered_user() returns character varying
    language plpgsql
as
$$
DECLARE
last_user VARCHAR;
BEGIN
SELECT username INTO last_user
FROM users
ORDER BY id DESC
    LIMIT 1;

IF last_user IS NULL THEN
        RETURN 'No users registered';
END IF;

RETURN last_user;
END;
$$;

alter function public.get_last_registered_user() owner to postgres;

create function public.get_last_borrowed_book()
    returns TABLE(book_title character varying, publication_year integer, username character varying)
    language plpgsql
as
$$
BEGIN
RETURN QUERY
SELECT b.title, b.publication_year, u.username
FROM reservations rb
         JOIN books b ON rb.book_id = b.id
         JOIN users u ON rb.username_id = u.id
ORDER BY rb.reservation_date DESC
    LIMIT 1;

IF NOT FOUND THEN
        RETURN QUERY SELECT 'No books borrowed'::VARCHAR, NULL, NULL;
END IF;
END;
$$;

alter function public.get_last_borrowed_book() owner to postgres;

create function public.get_all_books()
    returns TABLE(id bigint, title character varying, author character varying, publication_year integer)
    language plpgsql
as
$$
BEGIN
RETURN QUERY
SELECT b.id, b.title, b.author, b.publication_year
FROM books b
ORDER BY b.id;
END;
$$;

alter function public.get_all_books() owner to postgres;

create sequence public.books_id_seq;

alter sequence public.books_id_seq owner to postgres;

alter sequence public.books_id_seq owned by public.books.id;

create sequence public.users_id_seq;

alter sequence public.users_id_seq owner to postgres;

alter sequence public.users_id_seq owned by public.users.id;

create sequence public.reservations_books_id_seq;

alter sequence public.reservations_books_id_seq owner to postgres;

alter sequence public.reservations_books_id_seq owned by public.reservations.id;

create sequence public.logs_id_seq;

alter sequence public.logs_id_seq owner to postgres;

alter sequence public.logs_id_seq owned by public.logs.id;


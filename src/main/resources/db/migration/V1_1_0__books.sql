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
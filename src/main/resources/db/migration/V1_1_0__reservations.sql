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
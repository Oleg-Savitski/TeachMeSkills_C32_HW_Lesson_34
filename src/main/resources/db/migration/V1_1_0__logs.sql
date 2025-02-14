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
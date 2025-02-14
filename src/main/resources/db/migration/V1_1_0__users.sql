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
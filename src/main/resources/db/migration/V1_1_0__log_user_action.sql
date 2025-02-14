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
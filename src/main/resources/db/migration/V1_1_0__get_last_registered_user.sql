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
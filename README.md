Task:

1. Create triggers that will write data to the logs table when users are exposed/deleted from the database.
2. Create a function that will return the login of the last registered user in the database.
3. Create a database schema for a small library management system. Include the following tables:

 - Books (id, title, author, year of publication)

 - Readers (id, name, email)

 - Reservations (id, book id, reader id, booking date, return date)

 - Функция для логирования действий:
CREATE OR REPLACE FUNCTION log_user_action() 
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO logs (action, username_id) 
        VALUES ('UPDATE', OLD.id);  -- Используем OLD.id для идентификатора пользователя
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs (action, username_id) 
        VALUES ('DELETE', OLD.id);  -- Используем OLD.id для идентификатора пользователя
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

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
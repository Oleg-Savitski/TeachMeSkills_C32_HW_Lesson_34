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
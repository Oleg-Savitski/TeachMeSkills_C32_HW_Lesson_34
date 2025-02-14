
--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-02-12 19:39:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 226 (class 1255 OID 16440)
-- Name: get_all_books(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_books() RETURNS TABLE(id bigint, title character varying, author character varying, publication_year integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
        SELECT b.id, b.title, b.author, b.publication_year
        FROM books b
        ORDER BY b.id;
END;
$$;


ALTER FUNCTION public.get_all_books() OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 16439)
-- Name: get_last_borrowed_book(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_last_borrowed_book() RETURNS TABLE(book_title character varying, publication_year integer, username character varying)
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION public.get_last_borrowed_book() OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 16438)
-- Name: get_last_registered_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_last_registered_user() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION public.get_last_registered_user() OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16435)
-- Name: log_user_action(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_user_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION public.log_user_action() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    publication_year integer
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 217
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- TOC entry 224 (class 1259 OID 16423)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id bigint NOT NULL,
    action character varying(50),
    username_id integer,
    action_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16422)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 223
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 222 (class 1259 OID 16406)
-- Name: reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations (
    id bigint NOT NULL,
    book_id integer,
    username_id integer,
    reservation_date date,
    return_date date NOT NULL
);


ALTER TABLE public.reservations OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16405)
-- Name: reservations_books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservations_books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservations_books_id_seq OWNER TO postgres;

--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 221
-- Name: reservations_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservations_books_id_seq OWNED BY public.reservations.id;


--
-- TOC entry 220 (class 1259 OID 16399)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16398)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4660 (class 2604 OID 16393)
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- TOC entry 4663 (class 2604 OID 16426)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 4662 (class 2604 OID 16409)
-- Name: reservations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_books_id_seq'::regclass);


--
-- TOC entry 4661 (class 2604 OID 16402)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4823 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id, title, author, publication_year) FROM stdin;
1	Алые паруса	А. С. Грин	1923
2	XXX - вишенка	А. Грей	2016
3	Правила подстановки	Барбара Л.	2000
4	Игорь и ещё раз, Игорь	Юля Разум.	1980
5	Игорь и ещё раз, Игорь	Юля Разум.	1980
6	Main life	Неизвестный	1933
\.


--
-- TOC entry 4829 (class 0 OID 16423)
-- Dependencies: 224
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, action, username_id, action_time) FROM stdin;
1	UPDATE	4	2025-02-12 15:44:02.371951
2	UPDATE	2	2025-02-12 15:44:28.442141
3	DELETE	4	2025-02-12 15:45:31.678508
\.


--
-- TOC entry 4827 (class 0 OID 16406)
-- Dependencies: 222
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations (id, book_id, username_id, reservation_date, return_date) FROM stdin;
1	1	1	2023-10-01	2023-10-15
2	1	1	2025-02-10	2025-12-13
3	1	1	2024-02-10	2025-12-10
4	1	1	2023-02-10	2024-09-10
5	1	1	2023-02-10	2024-09-10
6	1	1	2023-02-10	2023-02-12
\.


--
-- TOC entry 4825 (class 0 OID 16399)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email) FROM stdin;
1	Андрей Мякинник	andrey@example.com
3	Олег Газманов	oleg@gmail.com
2	Алексей Болт	alexey11@gmail.com
5	Игорь Рязов	igor@mail.ru
6	Владимир Немыслемцев	vovik@mail.ru
\.


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 217
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 6, true);


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 223
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 3, true);


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 221
-- Name: reservations_books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservations_books_id_seq', 6, true);


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- TOC entry 4666 (class 2606 OID 16397)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- TOC entry 4672 (class 2606 OID 16429)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4670 (class 2606 OID 16411)
-- Name: reservations reservations_books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_books_pkey PRIMARY KEY (id);


--
-- TOC entry 4668 (class 2606 OID 16404)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4675 (class 2620 OID 16437)
-- Name: users user_delete_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER user_delete_trigger AFTER DELETE ON public.users FOR EACH ROW EXECUTE FUNCTION public.log_user_action();


--
-- TOC entry 4676 (class 2620 OID 16436)
-- Name: users user_update_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER user_update_trigger AFTER UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.log_user_action();


--
-- TOC entry 4673 (class 2606 OID 16412)
-- Name: reservations reservations_books_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_books_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 4674 (class 2606 OID 16417)
-- Name: reservations reservations_books_username_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_books_username_id_fkey FOREIGN KEY (username_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2025-02-12 19:39:43

--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--

\restrict W0zovpHF9F2iGCzGamABwmySyO5f7GW5vNZ0IBB6Cz1NHfNR3QVEzZgcYaF1Tvb

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-04-23 20:33:15

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
-- TOC entry 271 (class 1255 OID 16582)
-- Name: alumno_prom(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumno_prom(alumn character varying, mater character varying) RETURNS TABLE(nombre character varying, materia character varying, calificaciones numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT alumno.nombre, materia.nombre, AVG(kardex.calif) AS calificaciones
    FROM kardex
    INNER JOIN alumno ON kardex.nocont = alumno.nocont
    INNER JOIN materia ON kardex.cvemat = materia.cvemat
    WHERE alumno.nombre = alumn 
    AND materia.nombre = mater
    GROUP BY alumno.nombre, materia.nombre;
END;
$$;


ALTER FUNCTION public.alumno_prom(alumn character varying, mater character varying) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 16571)
-- Name: alumnos_a(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_a(n integer, calif_min integer) RETURNS TABLE(nombre_alumno character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT alumno.nombre
    FROM kardex
    INNER JOIN alumno 
        ON kardex.nocont = alumno.nocont
    WHERE kardex.calif > calif_min
    GROUP BY alumno.nombre
    HAVING COUNT(kardex.cvemat) > n;
END;
$$;


ALTER FUNCTION public.alumnos_a(n integer, calif_min integer) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 16572)
-- Name: alumnos_apro(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_apro(n integer, calificacion integer) RETURNS TABLE(nombre character varying)
    LANGUAGE plpgsql
    AS $$ 
begin 
return query 
select alumno.nombre 
from alumno 
inner join kardex 
on alumno.nocont = kardex.nocont 
where kardex.calif > calificacion 
group by alumno.nombre 
having count(kardex.cvemat) > n; 
end; 
$$;


ALTER FUNCTION public.alumnos_apro(n integer, calificacion integer) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 16561)
-- Name: alumnos_asistencia_mayor_70(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_asistencia_mayor_70() RETURNS TABLE(nocont character varying, nombre character varying, quejas jsonb, asistencia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        alumno.nocont,
        alumno.nombre,
        tutorias.datos->'reportes',
        (tutorias.datos->>'asistencia')::INT
    FROM alumno
    INNER JOIN tutorias
        ON alumno.nocont = tutorias.nocont
    WHERE (tutorias.datos->>'asistencia')::INT > 70;
END;
$$;


ALTER FUNCTION public.alumnos_asistencia_mayor_70() OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 16562)
-- Name: alumnos_con_matematicas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_con_matematicas() RETURNS TABLE(nocont character varying, nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        alumno.nocont,
        alumno.nombre
    FROM alumno
    INNER JOIN tutorias
        ON alumno.nocont = tutorias.nocont
    WHERE 
        tutorias.datos->'reportes' ? 'matemáticas'
        OR
        tutorias.datos->'reportes' ? 'matematicas';
END;
$$;


ALTER FUNCTION public.alumnos_con_matematicas() OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 16563)
-- Name: alumnos_con_reportes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_con_reportes() RETURNS TABLE(nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT alumno.nombre
    FROM alumno
    INNER JOIN tutorias
        ON alumno.nocont = tutorias.nocont
    WHERE tutorias.datos ? 'reportes';
END;
$$;


ALTER FUNCTION public.alumnos_con_reportes() OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 16577)
-- Name: alumnos_m10a11(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_m10a11(v_mat character varying, v_hor character varying) RETURNS TABLE(nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT alumno.nombre 
	FROM grupo
	INNER JOIN materia ON grupo.cvemat = materia.cvemat
	INNER JOIN integra ON grupo.cvemat = integra.cvemat 
	AND grupo.nogpo = integra.nogpo
	INNER JOIN alumno ON integra.nocont = alumno.nocont
	WHERE materia.nombre LIKE v_mat AND grupo.horario LIKE v_hor;
END;
$$;


ALTER FUNCTION public.alumnos_m10a11(v_mat character varying, v_hor character varying) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 16579)
-- Name: alumnos_nins(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_nins() RETURNS TABLE(nocont character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT alumno.nocont
	FROM alumno
	WHERE  alumno.nocont
	NOT IN (
		SELECT integra.nocont 
		FROM integra 
	);
END;
$$;


ALTER FUNCTION public.alumnos_nins() OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 16578)
-- Name: alumnos_nins(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_nins(v_clave character varying) RETURNS TABLE(nocont character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SELECT alumno.nombre
	FROM alumno
	WHERE  alumno.nocont
	NOT IN (
		SELECT nocont 
		FROM integra 
	);
END;
$$;


ALTER FUNCTION public.alumnos_nins(v_clave character varying) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 16552)
-- Name: alumnos_por_genero(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_por_genero(p_sexo text) RETURNS TABLE(nombre_alumno character varying, especialidad character varying, genero text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT alumno.nombre,
           especialidad.nombre,
           CASE
               WHEN alumno.sexo = 'm' THEN 'Hombre'
               WHEN alumno.sexo = 'f' THEN 'Mujer'
           END
    FROM alumno
    INNER JOIN especialidad
        ON alumno.cveesp = especialidad.cveesp
    WHERE alumno.sexo = p_sexo;
END;
$$;


ALTER FUNCTION public.alumnos_por_genero(p_sexo text) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 16559)
-- Name: alumnos_por_grupo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_por_grupo() RETURNS TABLE(grupo integer, cantidad integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        nogpo,
        COUNT(nocont)::INTEGER
    FROM integra
    GROUP BY nogpo;
END;
$$;


ALTER FUNCTION public.alumnos_por_grupo() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16541)
-- Name: alumnos_por_sexo(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_por_sexo(p_sexo text) RETURNS TABLE(nocont character varying, nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT a.nocont, a.nombre
    FROM alumno a
    WHERE a.sexo = p_sexo;
END;
$$;


ALTER FUNCTION public.alumnos_por_sexo(p_sexo text) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16558)
-- Name: alumnos_quimica_acreditada(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_quimica_acreditada() RETURNS TABLE(alumno character varying, especialidad character varying, descripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        alumno.nombre,
        especialidad.nombre,
        oportunidad.descripcion
    FROM kardex
    INNER JOIN alumno
        ON kardex.nocont = alumno.nocont
    INNER JOIN especialidad
        ON alumno.cveesp = especialidad.cveesp
    INNER JOIN materia
        ON kardex.cvemat = materia.cvemat
    INNER JOIN oportunidad
        ON kardex.opor = oportunidad.opor
    WHERE kardex.calif >= 70
    AND UPPER(materia.nombre) = 'QUIMICA';
END;
$$;


ALTER FUNCTION public.alumnos_quimica_acreditada() OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 16564)
-- Name: alumnos_riesgo_baja_asistencia(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_riesgo_baja_asistencia() RETURNS TABLE(nombre character varying, asistencia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        alumno.nombre,
        (tutorias.datos->>'asistencia')::INT
    FROM alumno
    INNER JOIN tutorias
        ON alumno.nocont = tutorias.nocont
    WHERE alumno.sexo = 'f'
    AND (tutorias.datos->>'riesgo')::boolean = true
    AND (tutorias.datos->>'asistencia')::INT < 70;
END;
$$;


ALTER FUNCTION public.alumnos_riesgo_baja_asistencia() OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 16555)
-- Name: alumnos_sin_especial(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_sin_especial(p_tipo text) RETURNS TABLE(nombre_alumno character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT alumno.nombre
    FROM alumno
    WHERE alumno.nocont NOT IN (
        SELECT kardex.nocont
        FROM kardex
        WHERE kardex.tipo = p_tipo
    );
END;
$$;


ALTER FUNCTION public.alumnos_sin_especial(p_tipo text) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16538)
-- Name: alumnos_sin_oportunidad(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_sin_oportunidad(p_descripcion text) RETURNS TABLE(nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT a.nombre
    FROM alumno a
    WHERE NOT EXISTS (
        SELECT 1
        FROM kardex k
        INNER JOIN oportunidad o ON o.opor = k.opor
        WHERE k.nocont = a.nocont
        AND o.descripcion LIKE p_descripcion
    );
END;
$$;


ALTER FUNCTION public.alumnos_sin_oportunidad(p_descripcion text) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 16560)
-- Name: alumnos_sin_riesgo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alumnos_sin_riesgo() RETURNS TABLE(nocont character varying, nombre character varying, quejas jsonb, asistencia text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        alumno.nocont,
        alumno.nombre,
        tutorias.datos->'reportes',
        tutorias.datos->>'asistencia'
    FROM alumno
    INNER JOIN tutorias
        ON alumno.nocont = tutorias.nocont
    WHERE (tutorias.datos->>'riesgo')::boolean = false;
END;
$$;


ALTER FUNCTION public.alumnos_sin_riesgo() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 16539)
-- Name: ejemplo(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ejemplo(a integer, b integer, OUT suma integer, OUT producto integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
BEGIN
    suma := a + b;
    producto := a * b;
END;
$$;


ALTER FUNCTION public.ejemplo(a integer, b integer, OUT suma integer, OUT producto integer) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 16565)
-- Name: esp_sm(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.esp_sm(nombre_materia text) RETURNS TABLE(nombre_especialidad text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
	SELECT especialidad.nombre::TEXT
    FROM especialidad
    WHERE NOT EXISTS (
        SELECT 1
        FROM reticula
        INNER JOIN materia 
            ON reticula.cvemat = materia.cvemat
        WHERE reticula.cveesp = especialidad.cveesp
        AND materia.nombre LIKE 'b.datos1'
    );
END;
$$;


ALTER FUNCTION public.esp_sm(nombre_materia text) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 16540)
-- Name: incrementar(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.incrementar(INOUT contador integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN 
    contador := contador + 1;
END;
$$;


ALTER FUNCTION public.incrementar(INOUT contador integer) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 16573)
-- Name: maestros_mat(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.maestros_mat(n integer) RETURNS TABLE(nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT maestro.nombre
    FROM maestro
    INNER JOIN grupo
        ON maestro.cvemae = grupo.cvemae
    GROUP BY maestro.nombre
    HAVING COUNT(DISTINCT grupo.cvemat) >= n;
END;
$$;


ALTER FUNCTION public.maestros_mat(n integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 16557)
-- Name: materias_de_alumno(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.materias_de_alumno(p_alumno text) RETURNS TABLE(materia character varying, grupo integer, salon character varying, horario character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT materia.nombre,
           grupo.nogpo,
           grupo.salon,
           grupo.horario
    FROM alumno
    INNER JOIN integra
        ON alumno.nocont = integra.nocont
    INNER JOIN grupo
        ON integra.cvemat = grupo.cvemat
        AND integra.nogpo = grupo.nogpo
    INNER JOIN materia
        ON grupo.cvemat = materia.cvemat
    WHERE alumno.nombre = p_alumno;
END;
$$;


ALTER FUNCTION public.materias_de_alumno(p_alumno text) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 16551)
-- Name: materias_por_especialidad(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.materias_por_especialidad(p_especialidad text) RETURNS TABLE(especialidad character varying, materia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT especialidad.nombre, materia.nombre
    FROM especialidad
    INNER JOIN reticula
        ON especialidad.cveesp = reticula.cveesp
    INNER JOIN materia
        ON materia.cvemat = reticula.cvemat
    WHERE especialidad.nombre = p_especialidad;
END;
$$;


ALTER FUNCTION public.materias_por_especialidad(p_especialidad text) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 16553)
-- Name: materias_por_maestro(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.materias_por_maestro(p_maestro text) RETURNS TABLE(materia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT materia.nombre
    FROM maestro
    INNER JOIN grupo
        ON maestro.cvemae = grupo.cvemae
    INNER JOIN materia
        ON materia.cvemat = grupo.cvemat
    WHERE maestro.nombre = p_maestro;
END;
$$;


ALTER FUNCTION public.materias_por_maestro(p_maestro text) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 16549)
-- Name: obtener_aprobados(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.obtener_aprobados(v_materia text) RETURNS TABLE(alumno character varying, promedio numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT nocont, AVG(calif)
    FROM kardex inner join materia on(kardex.cvemat=materia.cvemat)
    WHERE  materia.nombre = v_materia
    GROUP BY nocont
    HAVING AVG(calif)>= 70;
END;
$$;


ALTER FUNCTION public.obtener_aprobados(v_materia text) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 16542)
-- Name: probar_alumnos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.probar_alumnos() RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
    r RECORD;
BEGIN
    SELECT *
    INTO r
    FROM alumnos_por_sexo('f')
    LIMIT 1;

    RAISE NOTICE 'Nombre: %', r.nombre;
	return r;
END;
$$;


ALTER FUNCTION public.probar_alumnos() OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 16543)
-- Name: procesar_alumnos(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.procesar_alumnos(p_sexo text) RETURNS TABLE(total integer, alertados integer, procesados_correctamente integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    r RECORD;
    v_total INT := 0;
    v_alertados INT := 0;
    v_ok INT := 0;
BEGIN

    FOR r IN
        
		SELECT kardex.nocont, alumno.nombre, avg(kardex.calif) as promedio
    	FROM alumno inner join kardex on(alumno.nocont=kardex.nocont)
        WHERE sexo = p_sexo
		GROUP BY kardex.nocont, alumno.nombre
    LOOP
        
        v_total := v_total + 1;

        BEGIN
            -- Condición
            IF r.promedio <= 70 THEN
                
                INSERT INTO alertas(nocont, mensaje, fecha)
                VALUES (
                    r.nocont,
                    'Alumno en riesgo académico',
                    NOW()
                );

                v_alertados := v_alertados + 1;

            END IF;

            v_ok := v_ok + 1;

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Error procesando alumno %', r.nocont;
        END;

    END LOOP;

    total := v_total;
    alertados := v_alertados;
    procesados_correctamente := v_ok;

    RETURN NEXT;

END;
$$;


ALTER FUNCTION public.procesar_alumnos(p_sexo text) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 16550)
-- Name: promedio_alumno(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.promedio_alumno(v_alumno text) RETURNS numeric
    LANGUAGE plpgsql
    AS $$

DECLARE
	v_promedio numeric;
BEGIN
   
    SELECT AVG(calif) into v_promedio
    FROM kardex inner join alumno on(kardex.nocont=alumno.nocont)
    WHERE  alumno.nombre = v_alumno;

    return v_promedio;
END;
$$;


ALTER FUNCTION public.promedio_alumno(v_alumno text) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 16554)
-- Name: promedio_aprobados(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.promedio_aprobados(p_min_calif numeric) RETURNS TABLE(nombre_alumno character varying, especialidad character varying, promedio numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT alumno.nombre,
           especialidad.nombre,
           AVG(kardex.calif)
    FROM alumno
    INNER JOIN kardex
        ON alumno.nocont = kardex.nocont
    INNER JOIN especialidad
        ON alumno.cveesp = especialidad.cveesp
    WHERE kardex.calif > p_min_calif
    GROUP BY alumno.nombre, especialidad.nombre;
END;
$$;


ALTER FUNCTION public.promedio_aprobados(p_min_calif numeric) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16537)
-- Name: sumar(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sumar(a integer, b integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN 
RETURN a + b;
END;
$$;


ALTER FUNCTION public.sumar(a integer, b integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16544)
-- Name: alertas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertas (
    nocont character varying(15),
    mensaje text,
    fecha date
);


ALTER TABLE public.alertas OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16417)
-- Name: alumno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alumno (
    nocont character varying(5) NOT NULL,
    nombre character varying(25),
    cveesp character varying(5),
    sexo character(1)
);


ALTER TABLE public.alumno OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16399)
-- Name: especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidad (
    cveesp character varying(5) NOT NULL,
    nombre character varying(25)
);


ALTER TABLE public.especialidad OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16456)
-- Name: grupo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grupo (
    cvemat character varying(5) NOT NULL,
    nogpo integer NOT NULL,
    cvemae character varying(5) NOT NULL,
    horario character varying(20),
    salon character varying(10)
);


ALTER TABLE public.grupo OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16476)
-- Name: integra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.integra (
    cvemat character varying(5) NOT NULL,
    nogpo integer NOT NULL,
    nocont character varying(5) NOT NULL
);


ALTER TABLE public.integra OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16499)
-- Name: kardex; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kardex (
    cvemat character varying(5) NOT NULL,
    nocont character varying(5) NOT NULL,
    opor integer NOT NULL,
    calif integer
);


ALTER TABLE public.kardex OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16428)
-- Name: maestro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maestro (
    cvemae character varying(5) NOT NULL,
    nombre character varying(25),
    cveesp character varying(5)
);


ALTER TABLE public.maestro OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16405)
-- Name: materia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materia (
    cvemat character varying(5) NOT NULL,
    nombre character varying(25),
    horteo integer,
    horprac integer,
    creditos integer
);


ALTER TABLE public.materia OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16411)
-- Name: oportunidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oportunidad (
    opor integer NOT NULL,
    descripcion character varying(50)
);


ALTER TABLE public.oportunidad OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16439)
-- Name: reticula; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reticula (
    cveesp character varying(5) NOT NULL,
    cvemat character varying(5) NOT NULL
);


ALTER TABLE public.reticula OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16523)
-- Name: tutorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorias (
    id integer NOT NULL,
    nocont character varying(15),
    datos jsonb
);


ALTER TABLE public.tutorias OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16522)
-- Name: tutorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tutorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tutorias_id_seq OWNER TO postgres;

--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 228
-- Name: tutorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tutorias_id_seq OWNED BY public.tutorias.id;


--
-- TOC entry 4926 (class 2604 OID 16526)
-- Name: tutorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorias ALTER COLUMN id SET DEFAULT nextval('public.tutorias_id_seq'::regclass);


--
-- TOC entry 5120 (class 0 OID 16544)
-- Dependencies: 230
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertas (nocont, mensaje, fecha) FROM stdin;
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
a1	Alumno en riesgo académico	2026-03-01
\.


--
-- TOC entry 5112 (class 0 OID 16417)
-- Dependencies: 222
-- Data for Name: alumno; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alumno (nocont, nombre, cveesp, sexo) FROM stdin;
a1	r.martinez	s	f
a2	j.ramirez	s	m
a3	m.sanchez	s	m
a4	g.plaza	a	f
a5	m.vazquez	a	m
a6	s.ayala	p	f
a7	y.barraza	p	m
\.


--
-- TOC entry 5109 (class 0 OID 16399)
-- Dependencies: 219
-- Data for Name: especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidad (cveesp, nombre) FROM stdin;
a	administracion
e	electronica
p	produccion
s	sistemas
\.


--
-- TOC entry 5115 (class 0 OID 16456)
-- Dependencies: 225
-- Data for Name: grupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grupo (cvemat, nogpo, cvemae, horario, salon) FROM stdin;
m1	1	m2	08-09	10
m2	1	m1	11-12	20
m3	1	m3	17-18	35
m1	2	m4	10-11	10
m2	2	m3	11-12	35
\.


--
-- TOC entry 5116 (class 0 OID 16476)
-- Dependencies: 226
-- Data for Name: integra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.integra (cvemat, nogpo, nocont) FROM stdin;
m1	1	a1
m1	1	a2
m1	1	a3
m2	1	a1
m2	1	a3
m3	1	a1
m3	1	a2
m1	2	a4
m1	1	a5
m3	1	a4
m2	2	a4
\.


--
-- TOC entry 5117 (class 0 OID 16499)
-- Dependencies: 227
-- Data for Name: kardex; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kardex (cvemat, nocont, opor, calif) FROM stdin;
m1	a6	1	90
m2	a5	1	80
m2	a6	1	50
m2	a6	2	60
m3	a3	2	85
m3	a5	1	80
m3	a5	2	90
m4	a6	1	100
m4	a7	1	80
m5	a1	1	70
m5	a2	1	60
m5	a3	2	50
m5	a3	3	75
m5	a4	1	95
m5	a6	1	60
m5	a6	2	80
\.


--
-- TOC entry 5113 (class 0 OID 16428)
-- Dependencies: 223
-- Data for Name: maestro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maestro (cvemae, nombre, cveesp) FROM stdin;
m1	r.rojas	s
m2	j.perez	e
m3	g.garcia	s
m4	r.ramos	p
m5	m.morales	a
\.


--
-- TOC entry 5110 (class 0 OID 16405)
-- Dependencies: 220
-- Data for Name: materia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materia (cvemat, nombre, horteo, horprac, creditos) FROM stdin;
m1	matematicas	4	0	8
m2	s.operativos	4	0	8
m3	b.datos1	4	2	10
m4	quimica	4	2	10
m5	estatica	4	0	8
\.


--
-- TOC entry 5111 (class 0 OID 16411)
-- Dependencies: 221
-- Data for Name: oportunidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oportunidad (opor, descripcion) FROM stdin;
2	repite curso
3	especialidad
1	curso normal
\.


--
-- TOC entry 5114 (class 0 OID 16439)
-- Dependencies: 224
-- Data for Name: reticula; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reticula (cveesp, cvemat) FROM stdin;
s	m1
s	m2
s	m3
e	m1
e	m2
p	m1
p	m4
\.


--
-- TOC entry 5119 (class 0 OID 16523)
-- Dependencies: 229
-- Data for Name: tutorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorias (id, nocont, datos) FROM stdin;
1	a1	{"riesgo": true, "reportes": {"matematicas": "falta mucho", "programacion": "no entrega trabajos y copia de chatGPT"}, "asistencia": 65}
2	a1	{"riesgo": true, "reportes": {"etica": "falta mucho"}, "asistencia": 65}
4	a3	{"riesgo": true, "reportes": {"quimica": "falta puntualidad"}, "asistencia": 10}
5	a4	{"riesgo": true, "reportes": {"fisica": "no entrega tareas"}, "asistencia": 75}
6	a5	{"riesgo": false, "reportes": {"matematicas": "entrega tareas a tiempo"}, "asistencia": 100}
7	a6	{"riesgo": true, "reportes": {"base de datos": "no entrega tareas"}, "asistencia": 30}
8	a7	{"riesgo": true, "reportes": {"quimica": "no trabaja"}, "asistencia": 70}
3	a2	{"riesgo": false, "reportes": {"matemáticas": "trabaja muy bien"}, "asistencia": 100}
\.


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 228
-- Name: tutorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tutorias_id_seq', 8, true);


--
-- TOC entry 4934 (class 2606 OID 16422)
-- Name: alumno alumno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_pkey PRIMARY KEY (nocont);


--
-- TOC entry 4928 (class 2606 OID 16404)
-- Name: especialidad especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_pkey PRIMARY KEY (cveesp);


--
-- TOC entry 4940 (class 2606 OID 16465)
-- Name: grupo grupo_cvemat_nogpo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupo
    ADD CONSTRAINT grupo_cvemat_nogpo_key UNIQUE (cvemat, nogpo);


--
-- TOC entry 4942 (class 2606 OID 16463)
-- Name: grupo grupo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupo
    ADD CONSTRAINT grupo_pkey PRIMARY KEY (cvemat, nogpo, cvemae);


--
-- TOC entry 4944 (class 2606 OID 16483)
-- Name: integra integra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integra
    ADD CONSTRAINT integra_pkey PRIMARY KEY (cvemat, nogpo, nocont);


--
-- TOC entry 4946 (class 2606 OID 16506)
-- Name: kardex kardex_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kardex
    ADD CONSTRAINT kardex_pkey PRIMARY KEY (cvemat, nocont, opor);


--
-- TOC entry 4936 (class 2606 OID 16433)
-- Name: maestro maestro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maestro
    ADD CONSTRAINT maestro_pkey PRIMARY KEY (cvemae);


--
-- TOC entry 4930 (class 2606 OID 16410)
-- Name: materia materia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materia
    ADD CONSTRAINT materia_pkey PRIMARY KEY (cvemat);


--
-- TOC entry 4932 (class 2606 OID 16416)
-- Name: oportunidad oportunidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oportunidad
    ADD CONSTRAINT oportunidad_pkey PRIMARY KEY (opor);


--
-- TOC entry 4938 (class 2606 OID 16445)
-- Name: reticula reticula_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reticula
    ADD CONSTRAINT reticula_pkey PRIMARY KEY (cveesp, cvemat);


--
-- TOC entry 4948 (class 2606 OID 16531)
-- Name: tutorias tutorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorias
    ADD CONSTRAINT tutorias_pkey PRIMARY KEY (id);


--
-- TOC entry 4949 (class 2606 OID 16423)
-- Name: alumno alumno_cveesp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumno
    ADD CONSTRAINT alumno_cveesp_fkey FOREIGN KEY (cveesp) REFERENCES public.especialidad(cveesp);


--
-- TOC entry 4953 (class 2606 OID 16471)
-- Name: grupo grupo_cvemae_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupo
    ADD CONSTRAINT grupo_cvemae_fkey FOREIGN KEY (cvemae) REFERENCES public.maestro(cvemae);


--
-- TOC entry 4954 (class 2606 OID 16466)
-- Name: grupo grupo_cvemat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupo
    ADD CONSTRAINT grupo_cvemat_fkey FOREIGN KEY (cvemat) REFERENCES public.materia(cvemat);


--
-- TOC entry 4955 (class 2606 OID 16484)
-- Name: integra integra_cvemat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integra
    ADD CONSTRAINT integra_cvemat_fkey FOREIGN KEY (cvemat) REFERENCES public.materia(cvemat);


--
-- TOC entry 4956 (class 2606 OID 16494)
-- Name: integra integra_cvemat_nogpo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integra
    ADD CONSTRAINT integra_cvemat_nogpo_fkey FOREIGN KEY (cvemat, nogpo) REFERENCES public.grupo(cvemat, nogpo);


--
-- TOC entry 4957 (class 2606 OID 16489)
-- Name: integra integra_nocont_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integra
    ADD CONSTRAINT integra_nocont_fkey FOREIGN KEY (nocont) REFERENCES public.alumno(nocont);


--
-- TOC entry 4958 (class 2606 OID 16507)
-- Name: kardex kardex_cvemat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kardex
    ADD CONSTRAINT kardex_cvemat_fkey FOREIGN KEY (cvemat) REFERENCES public.materia(cvemat);


--
-- TOC entry 4959 (class 2606 OID 16512)
-- Name: kardex kardex_nocont_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kardex
    ADD CONSTRAINT kardex_nocont_fkey FOREIGN KEY (nocont) REFERENCES public.alumno(nocont);


--
-- TOC entry 4960 (class 2606 OID 16517)
-- Name: kardex kardex_opor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kardex
    ADD CONSTRAINT kardex_opor_fkey FOREIGN KEY (opor) REFERENCES public.oportunidad(opor);


--
-- TOC entry 4950 (class 2606 OID 16434)
-- Name: maestro maestro_cveesp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maestro
    ADD CONSTRAINT maestro_cveesp_fkey FOREIGN KEY (cveesp) REFERENCES public.especialidad(cveesp);


--
-- TOC entry 4951 (class 2606 OID 16446)
-- Name: reticula reticula_cveesp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reticula
    ADD CONSTRAINT reticula_cveesp_fkey FOREIGN KEY (cveesp) REFERENCES public.especialidad(cveesp);


--
-- TOC entry 4952 (class 2606 OID 16451)
-- Name: reticula reticula_cvemat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reticula
    ADD CONSTRAINT reticula_cvemat_fkey FOREIGN KEY (cvemat) REFERENCES public.materia(cvemat);


--
-- TOC entry 4961 (class 2606 OID 16532)
-- Name: tutorias tutorias_nocont_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorias
    ADD CONSTRAINT tutorias_nocont_fkey FOREIGN KEY (nocont) REFERENCES public.alumno(nocont);


-- Completed on 2026-04-23 20:33:16

--
-- PostgreSQL database dump complete
--

\unrestrict W0zovpHF9F2iGCzGamABwmySyO5f7GW5vNZ0IBB6Cz1NHfNR3QVEzZgcYaF1Tvb


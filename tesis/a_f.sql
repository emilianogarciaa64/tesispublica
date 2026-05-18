--
-- PostgreSQL database dump
--

\restrict f2pq10TgGVwgKcw8ppHbXzdZrjExhAVZpIwE89sZzRK5zEQIqtTB05iCl4yxylY

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: administrator
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO administrator;

--
-- Name: clasificacion; Type: SCHEMA; Schema: -; Owner: administrator
--

CREATE SCHEMA clasificacion;


ALTER SCHEMA clasificacion OWNER TO administrator;

--
-- Name: documentos; Type: SCHEMA; Schema: -; Owner: administrator
--

CREATE SCHEMA documentos;


ALTER SCHEMA documentos OWNER TO administrator;

--
-- Name: estadisticas; Type: SCHEMA; Schema: -; Owner: administrator
--

CREATE SCHEMA estadisticas;


ALTER SCHEMA estadisticas OWNER TO administrator;

--
-- Name: expedientes; Type: SCHEMA; Schema: -; Owner: administrator
--

CREATE SCHEMA expedientes;


ALTER SCHEMA expedientes OWNER TO administrator;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: usuarios; Type: TABLE; Schema: auth; Owner: administrator
--

CREATE TABLE auth.usuarios (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    nombre_usuario character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    rol character varying(50) NOT NULL,
    activo integer DEFAULT 1 NOT NULL,
    apellido_paterno character varying(255) NOT NULL,
    apellido_materno character varying(255) NOT NULL
);


ALTER TABLE auth.usuarios OWNER TO administrator;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: auth; Owner: administrator
--

CREATE SEQUENCE auth.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.usuarios_id_seq OWNER TO administrator;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: administrator
--

ALTER SEQUENCE auth.usuarios_id_seq OWNED BY auth.usuarios.id;


--
-- Name: anios; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.anios (
    id integer NOT NULL,
    anio character varying(150)
);


ALTER TABLE clasificacion.anios OWNER TO administrator;

--
-- Name: anios_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.anios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.anios_id_seq OWNER TO administrator;

--
-- Name: anios_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.anios_id_seq OWNED BY clasificacion.anios.id;


--
-- Name: areas_productoras; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.areas_productoras (
    id integer NOT NULL,
    area character varying(150),
    codigo character varying(30)
);


ALTER TABLE clasificacion.areas_productoras OWNER TO administrator;

--
-- Name: areas_productoras_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.areas_productoras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.areas_productoras_id_seq OWNER TO administrator;

--
-- Name: areas_productoras_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.areas_productoras_id_seq OWNED BY clasificacion.areas_productoras.id;


--
-- Name: areas_universitarias; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.areas_universitarias (
    id integer NOT NULL,
    area character varying(150),
    codigo character varying(30)
);


ALTER TABLE clasificacion.areas_universitarias OWNER TO administrator;

--
-- Name: areas_universitarias_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.areas_universitarias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.areas_universitarias_id_seq OWNER TO administrator;

--
-- Name: areas_universitarias_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.areas_universitarias_id_seq OWNED BY clasificacion.areas_universitarias.id;


--
-- Name: ciclos; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.ciclos (
    id integer NOT NULL,
    ciclo character varying(150)
);


ALTER TABLE clasificacion.ciclos OWNER TO administrator;

--
-- Name: ciclos_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.ciclos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.ciclos_id_seq OWNER TO administrator;

--
-- Name: ciclos_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.ciclos_id_seq OWNED BY clasificacion.ciclos.id;


--
-- Name: fondos; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.fondos (
    id integer NOT NULL,
    fondo character varying(150),
    codigo character varying(30)
);


ALTER TABLE clasificacion.fondos OWNER TO administrator;

--
-- Name: fondos_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.fondos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.fondos_id_seq OWNER TO administrator;

--
-- Name: fondos_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.fondos_id_seq OWNED BY clasificacion.fondos.id;


--
-- Name: paises; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.paises (
    id integer NOT NULL,
    pais character varying(150),
    codigo character varying(30)
);


ALTER TABLE clasificacion.paises OWNER TO administrator;

--
-- Name: paises_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.paises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.paises_id_seq OWNER TO administrator;

--
-- Name: paises_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.paises_id_seq OWNED BY clasificacion.paises.id;


--
-- Name: secciones; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.secciones (
    id integer NOT NULL,
    seccion character varying(150),
    codigo character varying(30)
);


ALTER TABLE clasificacion.secciones OWNER TO administrator;

--
-- Name: secciones_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.secciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.secciones_id_seq OWNER TO administrator;

--
-- Name: secciones_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.secciones_id_seq OWNED BY clasificacion.secciones.id;


--
-- Name: series; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.series (
    id integer NOT NULL,
    serie character varying(150),
    codigo character varying(30),
    seccion_id integer
);


ALTER TABLE clasificacion.series OWNER TO administrator;

--
-- Name: series_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.series_id_seq OWNER TO administrator;

--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.series_id_seq OWNED BY clasificacion.series.id;


--
-- Name: subseries; Type: TABLE; Schema: clasificacion; Owner: administrator
--

CREATE TABLE clasificacion.subseries (
    id integer NOT NULL,
    subserie character varying(150),
    codigo character varying(30),
    serie_id integer
);


ALTER TABLE clasificacion.subseries OWNER TO administrator;

--
-- Name: subseries_id_seq; Type: SEQUENCE; Schema: clasificacion; Owner: administrator
--

CREATE SEQUENCE clasificacion.subseries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE clasificacion.subseries_id_seq OWNER TO administrator;

--
-- Name: subseries_id_seq; Type: SEQUENCE OWNED BY; Schema: clasificacion; Owner: administrator
--

ALTER SEQUENCE clasificacion.subseries_id_seq OWNED BY clasificacion.subseries.id;


--
-- Name: actas; Type: TABLE; Schema: documentos; Owner: administrator
--

CREATE TABLE documentos.actas (
    ui character varying(50) NOT NULL,
    nombre_documento character varying(255) NOT NULL,
    ruta_documento text NOT NULL,
    id_usuario integer NOT NULL,
    fecha timestamp without time zone DEFAULT now(),
    expediente_anios_id integer,
    expediente_ciclos_id integer
);


ALTER TABLE documentos.actas OWNER TO administrator;

--
-- Name: descripcion_actas; Type: TABLE; Schema: documentos; Owner: administrator
--

CREATE TABLE documentos.descripcion_actas (
    id integer NOT NULL,
    acta character varying(50),
    fecha character varying(50),
    tipo character varying(50),
    permanente character varying(50),
    ui_documento character varying(50)
);


ALTER TABLE documentos.descripcion_actas OWNER TO administrator;

--
-- Name: descripcion_actas_id_seq; Type: SEQUENCE; Schema: documentos; Owner: administrator
--

CREATE SEQUENCE documentos.descripcion_actas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE documentos.descripcion_actas_id_seq OWNER TO administrator;

--
-- Name: descripcion_actas_id_seq; Type: SEQUENCE OWNED BY; Schema: documentos; Owner: administrator
--

ALTER SEQUENCE documentos.descripcion_actas_id_seq OWNED BY documentos.descripcion_actas.id;


--
-- Name: documentos_anexos; Type: TABLE; Schema: documentos; Owner: administrator
--

CREATE TABLE documentos.documentos_anexos (
    ui character varying(50) NOT NULL,
    nombre_documento character varying(255) NOT NULL,
    ruta_documento text NOT NULL,
    id_usuario integer NOT NULL,
    ui_principal character varying(50) NOT NULL,
    fecha timestamp without time zone DEFAULT now(),
    descripcion character varying(255) NOT NULL,
    fecha_del_documento character varying(50) NOT NULL
);


ALTER TABLE documentos.documentos_anexos OWNER TO administrator;

--
-- Name: instancias; Type: TABLE; Schema: documentos; Owner: administrator
--

CREATE TABLE documentos.instancias (
    id_instancia integer NOT NULL,
    instancia character varying(500) NOT NULL,
    periodo character varying(100) NOT NULL
);


ALTER TABLE documentos.instancias OWNER TO administrator;

--
-- Name: instancias_id_instancia_seq; Type: SEQUENCE; Schema: documentos; Owner: administrator
--

CREATE SEQUENCE documentos.instancias_id_instancia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE documentos.instancias_id_instancia_seq OWNER TO administrator;

--
-- Name: instancias_id_instancia_seq; Type: SEQUENCE OWNED BY; Schema: documentos; Owner: administrator
--

ALTER SEQUENCE documentos.instancias_id_instancia_seq OWNED BY documentos.instancias.id_instancia;


--
-- Name: catalogo_acciones; Type: TABLE; Schema: estadisticas; Owner: administrator
--

CREATE TABLE estadisticas.catalogo_acciones (
    id_accion integer NOT NULL,
    accion character varying(100) NOT NULL,
    tabla_destino character varying(50) NOT NULL
);


ALTER TABLE estadisticas.catalogo_acciones OWNER TO administrator;

--
-- Name: catalogo_acciones_id_accion_seq; Type: SEQUENCE; Schema: estadisticas; Owner: administrator
--

CREATE SEQUENCE estadisticas.catalogo_acciones_id_accion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE estadisticas.catalogo_acciones_id_accion_seq OWNER TO administrator;

--
-- Name: catalogo_acciones_id_accion_seq; Type: SEQUENCE OWNED BY; Schema: estadisticas; Owner: administrator
--

ALTER SEQUENCE estadisticas.catalogo_acciones_id_accion_seq OWNED BY estadisticas.catalogo_acciones.id_accion;


--
-- Name: catalogo_endpoints; Type: TABLE; Schema: estadisticas; Owner: administrator
--

CREATE TABLE estadisticas.catalogo_endpoints (
    id_endpoint integer NOT NULL,
    endpoint character varying(200) NOT NULL
);


ALTER TABLE estadisticas.catalogo_endpoints OWNER TO administrator;

--
-- Name: catalogo_endpoints_id_endpoint_seq; Type: SEQUENCE; Schema: estadisticas; Owner: administrator
--

CREATE SEQUENCE estadisticas.catalogo_endpoints_id_endpoint_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE estadisticas.catalogo_endpoints_id_endpoint_seq OWNER TO administrator;

--
-- Name: catalogo_endpoints_id_endpoint_seq; Type: SEQUENCE OWNED BY; Schema: estadisticas; Owner: administrator
--

ALTER SEQUENCE estadisticas.catalogo_endpoints_id_endpoint_seq OWNED BY estadisticas.catalogo_endpoints.id_endpoint;


--
-- Name: rendimiento_busqueda; Type: TABLE; Schema: estadisticas; Owner: administrator
--

CREATE TABLE estadisticas.rendimiento_busqueda (
    id bigint NOT NULL,
    id_accion integer NOT NULL,
    id_endpoint integer NOT NULL,
    duracion_ms numeric(12,3),
    exito boolean,
    status_http integer,
    instante_cliente_iso timestamp with time zone,
    timestamp_cliente_ms bigint,
    usuario_id bigint,
    instancia_id bigint,
    ui_principal character varying(120),
    query_texto text,
    total_resultados integer,
    total_anexos integer,
    detalle_error text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE estadisticas.rendimiento_busqueda OWNER TO administrator;

--
-- Name: rendimiento_busqueda_id_seq; Type: SEQUENCE; Schema: estadisticas; Owner: administrator
--

CREATE SEQUENCE estadisticas.rendimiento_busqueda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE estadisticas.rendimiento_busqueda_id_seq OWNER TO administrator;

--
-- Name: rendimiento_busqueda_id_seq; Type: SEQUENCE OWNED BY; Schema: estadisticas; Owner: administrator
--

ALTER SEQUENCE estadisticas.rendimiento_busqueda_id_seq OWNED BY estadisticas.rendimiento_busqueda.id;


--
-- Name: rendimiento_indexacion_y_registro; Type: TABLE; Schema: estadisticas; Owner: administrator
--

CREATE TABLE estadisticas.rendimiento_indexacion_y_registro (
    id bigint NOT NULL,
    id_accion integer NOT NULL,
    id_endpoint integer NOT NULL,
    duracion_ms numeric(12,3),
    exito boolean,
    status_http integer,
    instante_cliente_iso timestamp with time zone,
    timestamp_cliente_ms bigint,
    usuario_id bigint,
    instancia_id bigint,
    ui_principal character varying(120),
    ui_anexo character varying(120),
    tamanio_archivo_bytes bigint,
    detalle_error text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    tamanio_salida_bytes bigint
);


ALTER TABLE estadisticas.rendimiento_indexacion_y_registro OWNER TO administrator;

--
-- Name: rendimiento_indexacion_y_registro_id_seq; Type: SEQUENCE; Schema: estadisticas; Owner: administrator
--

CREATE SEQUENCE estadisticas.rendimiento_indexacion_y_registro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE estadisticas.rendimiento_indexacion_y_registro_id_seq OWNER TO administrator;

--
-- Name: rendimiento_indexacion_y_registro_id_seq; Type: SEQUENCE OWNED BY; Schema: estadisticas; Owner: administrator
--

ALTER SEQUENCE estadisticas.rendimiento_indexacion_y_registro_id_seq OWNED BY estadisticas.rendimiento_indexacion_y_registro.id;


--
-- Name: rendimiento_visualizacion_pdf; Type: TABLE; Schema: estadisticas; Owner: administrator
--

CREATE TABLE estadisticas.rendimiento_visualizacion_pdf (
    id bigint NOT NULL,
    id_accion integer NOT NULL,
    id_endpoint integer NOT NULL,
    duracion_ms numeric(12,3),
    exito boolean,
    status_http integer,
    instante_cliente_iso timestamp with time zone,
    timestamp_cliente_ms bigint,
    usuario_id bigint,
    doc_id character varying(120),
    ui_anexo character varying(120),
    detalle_error text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE estadisticas.rendimiento_visualizacion_pdf OWNER TO administrator;

--
-- Name: rendimiento_visualizacion_pdf_id_seq; Type: SEQUENCE; Schema: estadisticas; Owner: administrator
--

CREATE SEQUENCE estadisticas.rendimiento_visualizacion_pdf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE estadisticas.rendimiento_visualizacion_pdf_id_seq OWNER TO administrator;

--
-- Name: rendimiento_visualizacion_pdf_id_seq; Type: SEQUENCE OWNED BY; Schema: estadisticas; Owner: administrator
--

ALTER SEQUENCE estadisticas.rendimiento_visualizacion_pdf_id_seq OWNED BY estadisticas.rendimiento_visualizacion_pdf.id;


--
-- Name: poranios; Type: TABLE; Schema: expedientes; Owner: administrator
--

CREATE TABLE expedientes.poranios (
    id integer NOT NULL,
    anio_id integer NOT NULL,
    pais_id integer DEFAULT 1 NOT NULL,
    fondo_id integer DEFAULT 1 NOT NULL,
    seccion_id integer NOT NULL,
    serie_id integer NOT NULL,
    subserie_id integer NOT NULL,
    aruni_id integer DEFAULT 1 NOT NULL,
    arprod_id integer NOT NULL,
    instancia_id integer NOT NULL
);


ALTER TABLE expedientes.poranios OWNER TO administrator;

--
-- Name: poranios_id_seq; Type: SEQUENCE; Schema: expedientes; Owner: administrator
--

CREATE SEQUENCE expedientes.poranios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE expedientes.poranios_id_seq OWNER TO administrator;

--
-- Name: poranios_id_seq; Type: SEQUENCE OWNED BY; Schema: expedientes; Owner: administrator
--

ALTER SEQUENCE expedientes.poranios_id_seq OWNED BY expedientes.poranios.id;


--
-- Name: porciclos; Type: TABLE; Schema: expedientes; Owner: administrator
--

CREATE TABLE expedientes.porciclos (
    id integer NOT NULL,
    ciclo_id integer NOT NULL,
    pais_id integer DEFAULT 1 NOT NULL,
    fondo_id integer DEFAULT 1 NOT NULL,
    seccion_id integer NOT NULL,
    serie_id integer NOT NULL,
    subserie_id integer NOT NULL,
    aruni_id integer DEFAULT 1 NOT NULL,
    arprod_id integer NOT NULL,
    instancia_id integer NOT NULL
);


ALTER TABLE expedientes.porciclos OWNER TO administrator;

--
-- Name: porciclos_id_seq; Type: SEQUENCE; Schema: expedientes; Owner: administrator
--

CREATE SEQUENCE expedientes.porciclos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE expedientes.porciclos_id_seq OWNER TO administrator;

--
-- Name: porciclos_id_seq; Type: SEQUENCE OWNED BY; Schema: expedientes; Owner: administrator
--

ALTER SEQUENCE expedientes.porciclos_id_seq OWNED BY expedientes.porciclos.id;


--
-- Name: usuarios id; Type: DEFAULT; Schema: auth; Owner: administrator
--

ALTER TABLE ONLY auth.usuarios ALTER COLUMN id SET DEFAULT nextval('auth.usuarios_id_seq'::regclass);


--
-- Name: anios id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.anios ALTER COLUMN id SET DEFAULT nextval('clasificacion.anios_id_seq'::regclass);


--
-- Name: areas_productoras id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.areas_productoras ALTER COLUMN id SET DEFAULT nextval('clasificacion.areas_productoras_id_seq'::regclass);


--
-- Name: areas_universitarias id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.areas_universitarias ALTER COLUMN id SET DEFAULT nextval('clasificacion.areas_universitarias_id_seq'::regclass);


--
-- Name: ciclos id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.ciclos ALTER COLUMN id SET DEFAULT nextval('clasificacion.ciclos_id_seq'::regclass);


--
-- Name: fondos id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.fondos ALTER COLUMN id SET DEFAULT nextval('clasificacion.fondos_id_seq'::regclass);


--
-- Name: paises id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.paises ALTER COLUMN id SET DEFAULT nextval('clasificacion.paises_id_seq'::regclass);


--
-- Name: secciones id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.secciones ALTER COLUMN id SET DEFAULT nextval('clasificacion.secciones_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.series ALTER COLUMN id SET DEFAULT nextval('clasificacion.series_id_seq'::regclass);


--
-- Name: subseries id; Type: DEFAULT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.subseries ALTER COLUMN id SET DEFAULT nextval('clasificacion.subseries_id_seq'::regclass);


--
-- Name: descripcion_actas id; Type: DEFAULT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.descripcion_actas ALTER COLUMN id SET DEFAULT nextval('documentos.descripcion_actas_id_seq'::regclass);


--
-- Name: instancias id_instancia; Type: DEFAULT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.instancias ALTER COLUMN id_instancia SET DEFAULT nextval('documentos.instancias_id_instancia_seq'::regclass);


--
-- Name: catalogo_acciones id_accion; Type: DEFAULT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.catalogo_acciones ALTER COLUMN id_accion SET DEFAULT nextval('estadisticas.catalogo_acciones_id_accion_seq'::regclass);


--
-- Name: catalogo_endpoints id_endpoint; Type: DEFAULT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.catalogo_endpoints ALTER COLUMN id_endpoint SET DEFAULT nextval('estadisticas.catalogo_endpoints_id_endpoint_seq'::regclass);


--
-- Name: rendimiento_busqueda id; Type: DEFAULT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_busqueda ALTER COLUMN id SET DEFAULT nextval('estadisticas.rendimiento_busqueda_id_seq'::regclass);


--
-- Name: rendimiento_indexacion_y_registro id; Type: DEFAULT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_indexacion_y_registro ALTER COLUMN id SET DEFAULT nextval('estadisticas.rendimiento_indexacion_y_registro_id_seq'::regclass);


--
-- Name: rendimiento_visualizacion_pdf id; Type: DEFAULT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_visualizacion_pdf ALTER COLUMN id SET DEFAULT nextval('estadisticas.rendimiento_visualizacion_pdf_id_seq'::regclass);


--
-- Name: poranios id; Type: DEFAULT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios ALTER COLUMN id SET DEFAULT nextval('expedientes.poranios_id_seq'::regclass);


--
-- Name: porciclos id; Type: DEFAULT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos ALTER COLUMN id SET DEFAULT nextval('expedientes.porciclos_id_seq'::regclass);


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: auth; Owner: administrator
--

COPY auth.usuarios (id, nombre, nombre_usuario, password, rol, activo, apellido_paterno, apellido_materno) FROM stdin;
1	benjamin	ben	$2a$12$cbtaUzR1HF07aTFXcRmbl.m9NY3q3I1Ravd/mXD1nuXwTbPPkF40y	admin	1	Lopez	Perez
2	emiliano	em	$2a$12$Ml66GnA/9TUCTnwFyuvvpObKAPLFoGaKsS5V9mR3guPtxUwfKR9zy	buscador	1	Medina	Garcia
\.


--
-- Data for Name: anios; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.anios (id, anio) FROM stdin;
1	2014
2	2015
3	2017
\.


--
-- Data for Name: areas_productoras; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.areas_productoras (id, area, codigo) FROM stdin;
1	Secretaría Académica	100
\.


--
-- Data for Name: areas_universitarias; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.areas_universitarias (id, area, codigo) FROM stdin;
1	Facultad de Ingeniería Eléctrica	203
\.


--
-- Data for Name: ciclos; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.ciclos (id, ciclo) FROM stdin;
1	2014-2015
2	2014-2014
\.


--
-- Data for Name: fondos; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.fondos (id, fondo, codigo) FROM stdin;
1	Universidad Michoacana de San Nicolás de Hidalgo	UMSNH
\.


--
-- Data for Name: paises; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.paises (id, pais, codigo) FROM stdin;
1	Estados Unidos Mexicanos	MX
\.


--
-- Data for Name: secciones; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.secciones (id, seccion, codigo) FROM stdin;
1	Legislación	1C
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.series (id, serie, codigo, seccion_id) FROM stdin;
1	Actas y Acuerdos	1C.5	1
\.


--
-- Data for Name: subseries; Type: TABLE DATA; Schema: clasificacion; Owner: administrator
--

COPY clasificacion.subseries (id, subserie, codigo, serie_id) FROM stdin;
1	Actas	1C.5.1	1
\.


--
-- Data for Name: actas; Type: TABLE DATA; Schema: documentos; Owner: administrator
--

COPY documentos.actas (ui, nombre_documento, ruta_documento, id_usuario, fecha, expediente_anios_id, expediente_ciclos_id) FROM stdin;
742e6097-3ee2-4e1f-b6a7-2152c40e1303	953a6f7a-e4e9-48e6-be69-68147e8a5f9a.pdf	/home/benja/a_f/2004/d9924375-4492-4eb7-b30a-6cbf98d79e85	1	2025-12-02 19:05:07.113813	\N	\N
a10ecd53-b31f-4114-9490-c7b8f0f16f71	0ec3c4fe-2431-4d8b-a0b1-63fbab9fee8c.pdf	/home/benja/a_f/2014/ba8ae8aa-222d-4e5a-981d-fac6acdb778d	1	2025-12-02 18:42:39.074312	1	\N
7e5c2037-30ed-4ec2-b6d0-ffc1fffdadf1	bab8c0d3-1e9a-4694-a370-451e44ecdc40.pdf	/home/benja/a_f/2014/626ed29d-700a-4b0d-957f-e243afe2d464	1	2025-12-02 18:58:23.805347	1	\N
2104fcfa-1ed9-403b-9fdf-2e530386536c	b96a0aa0-d44a-4b8f-a762-0b871038530e.pdf	/home/benja/a_f/2014/f483bad8-8578-4813-b6e9-45b95d797bf1	1	2025-12-02 19:01:38.403335	1	\N
10469fc1-63d5-4764-9316-6d49088f8250	ad9d8109-4fdb-4980-82c0-ff48432e13b7.pdf	/home/benja/a_f/2014/af32df11-e35b-4edc-a8e5-6e0d93801d99	1	2025-12-02 19:03:08.761854	1	\N
0771aff0-8236-40d8-bcb5-d2cdfed0becf	165cf83d-8c45-40da-ba94-c3304cfb17c9.pdf	/home/benja/a_f/2014/4630a08f-a9c4-4bfd-bc77-7626ce84c3a9	1	2025-12-02 23:16:54.45546	1	\N
af671869-a693-4749-9421-e6725b802fcd	73e661ff-14b9-4be3-a7c9-5e402591a408.pdf	/home/benja/a_f/2014/090676e7-2481-4bc6-a36d-52922852da42	1	2026-01-27 13:00:35.049733	1	\N
481f4a78-6f75-4f87-92f1-f1bee8e43b8a	f0c5c903-f23a-4cd4-817c-2bde2338b1cf.pdf	/home/benja/a_f/2015/46ddad37-6234-449f-ab28-e699ec56238a	1	2026-02-06 00:48:31.934663	\N	1
0166a709-734a-44fb-8e4d-24c2a991a89d	8ed80460-8ea4-4fbc-ad58-c2a18a927e39.pdf	/home/benja/a_f/2014/d23fc18c-63b9-4b39-a816-0f0445f53ca9	1	2026-02-11 20:38:44.818772	1	\N
410a24ce-c172-4b7f-afb8-2f7215c76f47	c740b292-d21d-4e01-88d4-625ef0a0d080.pdf	/home/benja/a_f/2014/b894753c-f6b2-4e69-9bfc-853ec7a7bb65	1	2026-02-11 20:43:38.811428	1	\N
cbc72a92-7430-4296-bada-a85fb0ca9a29	8e6d065b-c270-4c3c-a34d-e4514171017b.pdf	/home/benja/a_f/2014/f9dc1bfa-76e1-471b-838b-921ddff92621	1	2026-02-11 20:56:06.092757	1	\N
e8e6a06e-acb6-47a1-a25a-79b48417b22e	5e1cf952-1973-4cba-ab30-66b6d4b522de.pdf	/home/benja/a_f/2014/3f5ae495-7044-4c68-b386-3637c43259e3	1	2026-02-11 21:00:52.849614	1	\N
2082fbd0-376b-4efd-a268-6279fa249c9f	e942bb49-75c0-46ad-b78b-4bba02a0bcc4.pdf	/home/benja/a_f/2014/74370df8-4967-4efc-bbe0-5724509cb098	1	2026-02-11 21:01:56.626537	1	\N
1f9631c4-b232-43d4-836d-146088118d72	d1eee98c-1069-4b48-b74e-b1b69da2b400.pdf	/home/benja/a_f/2014/fa1a5847-94d6-46c0-a6e8-b95ca03b5669	1	2026-02-16 19:21:12.119231	1	\N
142cfcc1-c32d-4279-8ea0-07c2bd1ff657	36a57ad1-65b0-4e12-b563-1f68b730d19f.pdf	/home/benja/a_f/2014/95f404a0-395c-4af8-98e7-bbb32c25d37d	1	2026-02-16 22:12:21.469716	1	\N
4150bf80-e456-4123-8bb0-62a1446f2549	f6f23a58-b919-4be7-ad74-19201cd3791a.pdf	/home/benja/a_f/2014/6e430a3e-ad6b-4672-b7ce-b51dd594cf45	1	2026-04-08 19:22:25.060434	1	\N
6baa1cc7-6345-4cf0-ba0a-b783008651d1	1bae84bd-c41f-4f26-b10d-fe6f2d54b8a1.pdf	/home/benja/a_f/2014/6e06007e-2dd6-41a0-862c-113d28278869	1	2026-04-08 20:00:11.271039	1	\N
d23f13fb-17ce-4d2c-b4c1-61d0a7ce15c6	818ddfb0-9a85-4a22-8c3a-1a483f166c7a.pdf	/home/benja/a_f/2014/e8bfaa07-d9e1-4087-9ea8-204025691be4	1	2026-04-08 20:02:26.606088	1	\N
dbd1a666-4196-45c6-9b68-6b2e76d66023	1f167e90-a496-411f-b595-4df61c216972.pdf	/home/benja/a_f/2014/4cf5de65-79ef-4479-b110-75bfd80232ba	1	2026-04-08 20:07:52.853957	1	\N
43844d85-a15a-4f1f-bbdb-b4a84ae5247e	189a2210-166e-43e7-8392-d5721f01048a.pdf	/home/benja/a_f/2014/8baf092f-96d2-4a93-bf02-c4643a338da0	1	2026-04-08 20:10:03.152587	1	\N
5b0c3a68-2185-41fa-af9d-ebc08cabb4dc	b310372e-b111-454b-a9a9-6813f958f788.pdf	/home/benja/a_f/2014/15fe062a-fcfd-45ee-80b7-23ee552e0273	1	2026-04-08 20:12:26.700623	1	\N
6a3d79d3-83a3-46a5-8eac-3d12312060d1	4eda82bf-5de3-40d0-9325-e6e99146a173.pdf	/home/benja/a_f/2014/52cc3f4d-a3ea-4f73-9e3a-af58d87534da	1	2026-04-12 20:38:19.484929	1	\N
e3f7e031-c413-4186-8eae-ba09c4d8884b	fd9be894-2506-4197-8f45-7fea66c200a5.pdf	/home/benja/a_f/2014/b4d7c444-850f-4c39-841f-fab8d16b4ebf	1	2026-04-13 21:27:58.335967	1	\N
5621b734-6a2a-4536-8961-be434809f3db	97b520f6-f7e4-44d5-ad27-a8645347dc8a.pdf	/home/benja/a_f/2014/cefe0743-1735-4c5f-ad35-447a77b339fd	1	2026-04-14 00:15:44.531965	1	\N
27ad4c18-2f5a-4a86-b531-e2254aac27fb	1897af74-b420-46f6-9064-0d1186c88e6f.pdf	/home/benja/a_f/2014/0823e035-20b8-4fef-bf2b-44953065f3ea	1	2026-04-14 00:20:18.301826	1	\N
5d7ddeba-3694-49c7-bb60-61e6e8d34beb	7f166389-b3e4-47ea-969b-246ad4ad0422.pdf	/home/benja/a_f/2014/6d02ee7a-b02a-4e74-813e-1730925df67e	1	2026-04-14 00:22:54.084475	1	\N
51aa833e-bd64-4743-82be-19c73928012a	48734d21-e9e3-4b1e-8aae-61ffe7a0fa67.pdf	/home/benja/a_f/2014/9b7cba87-c82a-4a64-b37e-76534b75e09e	1	2026-04-14 00:23:29.803187	1	\N
a617f7ce-1e38-4976-a1be-9d75ebc32fcb	aa85ffc0-9ca0-451b-90ab-dd23b8c99163.pdf	/home/benja/a_f/2014/31fb9b5c-2058-403a-99e3-718efd5bd51a	1	2026-04-14 00:30:12.654488	1	\N
81dc8735-389c-4565-a2f7-1f2ce0cab83a	b5d0aa8f-b1ae-4073-93a9-e34913c4f393.pdf	/home/benja/a_f/2014/4d1ba857-6dce-4f43-96e6-71e89a6e27a8	1	2026-04-14 00:56:52.659269	1	\N
e1eb2a97-d2d2-4545-b145-1294d401238b	85cd49a0-98a6-4afe-8bbc-0567f5d29ec2.pdf	/home/benja/a_f/2014/c16e25ac-cf67-4263-88ef-fd1ff3bdf042	1	2026-04-14 00:59:18.740706	1	\N
83fe139b-4cba-4efd-b1c6-1e19732c9d57	afdb079f-3725-4f78-8647-f1d6be461ae8.pdf	/home/benja/a_f/2014/dcc47df7-c911-4177-acd5-f1a68e216d0b	1	2026-04-14 01:00:58.297264	1	\N
6f98a785-9ae8-4de6-b17a-442c9aa56728	d6f56988-2f42-4dbf-85ba-28e96ff37f87.pdf	/home/benja/a_f/2014/6a6840fb-2649-422a-948a-d6776ffd112b	1	2026-04-14 01:04:45.600975	1	\N
e842d15f-5d07-4728-9e3e-3e9c8ece74e6	3b54c8b1-6ca2-44d7-84b1-125b5a768792.pdf	/home/benja/a_f/2014/3785668c-7519-4c52-8e17-b916602c6c88	1	2026-04-14 01:06:30.748083	1	\N
a66d4ba1-4203-496f-a79f-b1480f6e4d49	ee3013ba-9b03-4ae4-9af7-3a4be7e25a06.pdf	/home/benja/a_f/2014/3338890d-b547-4429-96a6-b813aee3cb82	1	2026-04-14 01:09:23.652153	1	\N
4ba172c4-bde2-4f98-a759-01547d487e56	f30e4ee9-2ff7-4455-9fc8-40e98b8b649a.pdf	/home/benja/a_f/2014/0b3bca9c-350e-40cd-8321-d0c5c0c75d93	1	2026-04-14 01:10:30.39105	1	\N
38258774-2f2a-4586-97d7-dd15df225e82	ac403932-9f32-4655-94af-b4b4d2f12be8.pdf	/home/benja/a_f/2014/cd640171-4df6-4396-a07b-303cc12b6755	1	2026-04-14 01:33:05.391947	1	\N
ea049eb3-8bc0-4b6e-903a-3d79effe004b	4ffcce3f-900a-4445-ba6d-519443cb2b2e.pdf	/home/benja/a_f/2014/97f93f0b-363c-4d78-9839-88434a5f45b6	1	2026-04-14 20:36:30.194439	1	\N
730e8e00-78c7-4fe4-963c-5fcbf46b417a	d6a0c8ec-3096-4bbe-b73e-b06be00b7801.pdf	/home/benja/a_f/2014/e2c07478-f0b8-4d5b-9eb2-38de9df4e4e8	1	2026-04-15 01:00:07.289849	1	\N
02014998-16ee-4ceb-9565-41140a814842	ebcc22cf-dce6-4530-acc7-75d97027ac13.pdf	/home/benja/a_f/2017/2a6ea68d-7824-4140-ae2f-307570fc2f02	1	2026-04-15 23:17:41.795094	6	\N
4f804719-e09a-423a-bbf6-b77644beef6a	77ca8468-0981-4cda-9c56-4b0962d359a9.pdf	/home/benja/a_f/2014/32771989-194a-49a5-8d0f-b2e908b957b5	1	2026-04-15 23:46:19.250624	1	\N
b560c07c-3da0-472e-9fd6-57a89837bd2c	cd5fd552-d697-4b30-ae60-baafb475d40f.pdf	/home/benja/a_f/2014/1faa47f2-4483-4839-8efe-d055699b45be	1	2026-04-15 23:47:58.64213	1	\N
ee674f2f-013e-4f54-ab12-df4cd1d29311	842ebc6c-8b4e-444b-94e0-9070b3655e2e.pdf	/home/benja/a_f/2017/7a37bdaf-a9b4-4ea0-9619-fa4612fba7e5	1	2026-04-16 00:05:55.223837	6	\N
\.


--
-- Data for Name: descripcion_actas; Type: TABLE DATA; Schema: documentos; Owner: administrator
--

COPY documentos.descripcion_actas (id, acta, fecha, tipo, permanente, ui_documento) FROM stdin;
1	1/2014-2014	12-Febrero-2014	Ordinaria	No	a10ecd53-b31f-4114-9490-c7b8f0f16f71
2	2/2014-2014	18-Febrero-2014	Ordinaria	Si	7e5c2037-30ed-4ec2-b6d0-ffc1fffdadf1
3	3/2014-2014	25-Febrero-2014	Extraordinaria	No	2104fcfa-1ed9-403b-9fdf-2e530386536c
4	4/2014-2014	26-Febrero-2014	Ordinaria	No	10469fc1-63d5-4764-9316-6d49088f8250
5	1/2004-2004	26-Febrero-2004	Ordinaria	No	742e6097-3ee2-4e1f-b6a7-2152c40e1303
6	5/2014-2014	7-Marzo-2014	Ordinaria	Si	0771aff0-8236-40d8-bcb5-d2cdfed0becf
7	9/2014	2-Mayo-2014	Ordinaria	Si	af671869-a693-4749-9421-e6725b802fcd
8	9/2014-2015	30-Septiembre-2015	Ordinaria	Si	481f4a78-6f75-4f87-92f1-f1bee8e43b8a
9	10/2014-2014	28-Febrero-2014	Ordinaria	No	0166a709-734a-44fb-8e4d-24c2a991a89d
10	11/2014-2014	11-Febrero-2014	Ordinaria	No	410a24ce-c172-4b7f-afb8-2f7215c76f47
11	12/2014-2014	26-Febrero-2014	Ordinaria	No	cbc72a92-7430-4296-bada-a85fb0ca9a29
12	13/2014-2014	25-Febrero-2014	Ordinaria	No	e8e6a06e-acb6-47a1-a25a-79b48417b22e
13	14/2014-2014	26-Febrero-2014	Ordinaria	No	2082fbd0-376b-4efd-a268-6279fa249c9f
14	300/2014-2014	28-Febrero-2014	Ordinaria	Si	1f9631c4-b232-43d4-836d-146088118d72
15	400/2014-2014	28-Febrero-2014	Ordinaria	Si	142cfcc1-c32d-4279-8ea0-07c2bd1ff657
16	7/2014	10-Abril-2014	Ordinaria	No	4150bf80-e456-4123-8bb0-62a1446f2549
17	8/2014	4-Abril-2014	Ordinaria	No	6baa1cc7-6345-4cf0-ba0a-b783008651d1
18	9/2014	4-Junio-2014	Ordinaria	No	d23f13fb-17ce-4d2c-b4c1-61d0a7ce15c6
19	10/2014	4-Junio-2014	Ordinaria	No	dbd1a666-4196-45c6-9b68-6b2e76d66023
20	11/2014-2014	4-Agosto-2014	Ordinaria	No	43844d85-a15a-4f1f-bbdb-b4a84ae5247e
21	12/2014-2014	4-Marzo-2014	Ordinaria	No	5b0c3a68-2185-41fa-af9d-ebc08cabb4dc
22	17/2014	22-Mayo-2014	Ordinaria	No	6a3d79d3-83a3-46a5-8eac-3d12312060d1
23	17/2014	26-Febrero-2014	Ordinaria	No	e3f7e031-c413-4186-8eae-ba09c4d8884b
24	17/2014	29-Abril-2014	Ordinaria	No	5621b734-6a2a-4536-8961-be434809f3db
25	317/2014	2-Abril-2014	Ordinaria	No	27ad4c18-2f5a-4a86-b531-e2254aac27fb
26	319/2014	4-Abril-2014	Ordinaria	No	5d7ddeba-3694-49c7-bb60-61e6e8d34beb
27	319/2014	5-Abril-2014	Ordinaria	No	51aa833e-bd64-4743-82be-19c73928012a
28	320/2014	6-Abril-2014	Ordinaria	No	a617f7ce-1e38-4976-a1be-9d75ebc32fcb
29	321/2014	13-Agosto-2014	Ordinaria	No	81dc8735-389c-4565-a2f7-1f2ce0cab83a
30	322/2014	27-Agosto-2014	Ordinaria	No	e1eb2a97-d2d2-4545-b145-1294d401238b
31	323/2014	17-Agosto-2014	Ordinaria	No	83fe139b-4cba-4efd-b1c6-1e19732c9d57
32	323/2014	18-Agosto-2014	Ordinaria	No	6f98a785-9ae8-4de6-b17a-442c9aa56728
33	323/2014	18-Agosto-2014	Ordinaria	No	e842d15f-5d07-4728-9e3e-3e9c8ece74e6
34	324/2014	19-Agosto-2014	Ordinaria	No	a66d4ba1-4203-496f-a79f-b1480f6e4d49
35	326/2014	20-Agosto-2014	Ordinaria	No	4ba172c4-bde2-4f98-a759-01547d487e56
36	328/2014	27-Febrero-2014	Ordinaria	No	38258774-2f2a-4586-97d7-dd15df225e82
37	329/2014	29-Abril-2014	Ordinaria	No	ea049eb3-8bc0-4b6e-903a-3d79effe004b
38	329/2014	29-Abril-2014	Ordinaria	No	730e8e00-78c7-4fe4-963c-5fcbf46b417a
39	1/2017	23-Enero-2017	Ordinaria	No	02014998-16ee-4ceb-9565-41140a814842
40	1001/2014	30-Abril-2014	Ordinaria	No	4f804719-e09a-423a-bbf6-b77644beef6a
41	1002/2014	30-Abril-2014	Ordinaria	No	b560c07c-3da0-472e-9fd6-57a89837bd2c
42	1005/2017	30-Abril-2017	Ordinaria	No	ee674f2f-013e-4f54-ab12-df4cd1d29311
\.


--
-- Data for Name: documentos_anexos; Type: TABLE DATA; Schema: documentos; Owner: administrator
--

COPY documentos.documentos_anexos (ui, nombre_documento, ruta_documento, id_usuario, ui_principal, fecha, descripcion, fecha_del_documento) FROM stdin;
0d1132ce-345e-42c5-a5c2-67ece01fc9e9	1bae994f-2e35-4ae8-91f4-34994b98e6cc.pdf	/home/benja/a_f/2014/ba8ae8aa-222d-4e5a-981d-fac6acdb778d/anexos	1	a10ecd53-b31f-4114-9490-c7b8f0f16f71	2025-12-02 18:44:51.713869	este es un anexo ejemplo	15-Febrero-2014
69bbbf8b-4c6b-4108-b601-505e1516021f	7f5cf4ae-fe27-4aee-8050-d07736730ca7.pdf	/home/benja/a_f/2014/4630a08f-a9c4-4bfd-bc77-7626ce84c3a9/anexos	1	0771aff0-8236-40d8-bcb5-d2cdfed0becf	2025-12-02 23:17:58.423215	anexo solr	8-Marzo-2014
eb8f14b0-5e8a-4008-a061-ab04281846d3	c2ec74a5-2b3d-4bc7-a77d-f7563017e276.pdf	/home/benja/a_f/2014/090676e7-2481-4bc6-a36d-52922852da42/anexos	1	af671869-a693-4749-9421-e6725b802fcd	2026-01-27 13:01:44.895052	anexo	3-Mayo-2014
39e2d876-d9ef-440a-a996-729d28c3a9bd	1db4d1c8-baa5-418d-ac67-9742ff7d7f69.pdf	/home/benja/a_f/2015/46ddad37-6234-449f-ab28-e699ec56238a/anexos	1	481f4a78-6f75-4f87-92f1-f1bee8e43b8a	2026-02-06 00:49:06.259727	anexo	30-Septiembre-2015
87b4e3e2-d0aa-4092-b64d-82ec81fdbb53	8f92dc39-0b68-4362-8406-e54feb022695.pdf	/home/benja/a_f/2014/af32df11-e35b-4edc-a8e5-6e0d93801d99/anexos	2	10469fc1-63d5-4764-9316-6d49088f8250	2026-02-11 17:58:26.767293	este es un anexo ejemplo obvio	19-Febrero-2014
62431aae-ee93-4e07-8a89-93cb82e1b367	2514a434-e348-4483-ba72-84a7476401f3.pdf	/home/benja/a_f/2014/d23fc18c-63b9-4b39-a816-0f0445f53ca9/anexos	1	0166a709-734a-44fb-8e4d-24c2a991a89d	2026-02-11 20:39:33.893811	el anexo del anexo	28-Febrero-2014
2543a528-563c-4763-a0c2-51170af8c08a	476af67c-adaa-4698-b6c3-da04de1af3f5.pdf	/home/benja/a_f/2014/fa1a5847-94d6-46c0-a6e8-b95ca03b5669/anexos	1	1f9631c4-b232-43d4-836d-146088118d72	2026-04-07 22:03:08.336656	hola	28-Febrero-2014
664b3ebd-7d9a-4db1-a2e7-b5213cc6ba7b	d372872e-447e-41e9-bf2a-fd80c39367a2.pdf	/home/benja/a_f/2014/fa1a5847-94d6-46c0-a6e8-b95ca03b5669/anexos	1	1f9631c4-b232-43d4-836d-146088118d72	2026-04-08 12:13:47.100857	hola2	28-Febrero-2014
fd0f1595-93b2-4893-b962-bf3ed6da4426	7b50c2ab-3ebb-4e96-9239-fd99086adf90.pdf	/home/benja/a_f/2014/fa1a5847-94d6-46c0-a6e8-b95ca03b5669/anexos	1	1f9631c4-b232-43d4-836d-146088118d72	2026-04-08 14:15:12.774578	hola3	20-Febrero-2014
e7955765-5176-4932-b16c-3ea20934a93e	6bb42d3d-c421-4bcd-bcfb-21ac7eabd2a6.pdf	/home/benja/a_f/2014/6e430a3e-ad6b-4672-b7ce-b51dd594cf45/anexos	1	4150bf80-e456-4123-8bb0-62a1446f2549	2026-04-08 19:23:22.686225	anexo	4-Abril-2014
2264c9b4-16ae-48df-b970-199c9e2af07c	00a489a8-e0df-44be-9766-5d63674e5963.pdf	/home/benja/a_f/2014/e8bfaa07-d9e1-4087-9ea8-204025691be4/anexos	1	d23f13fb-17ce-4d2c-b4c1-61d0a7ce15c6	2026-04-08 20:04:17.241406		4-Mayo-2014
84786742-87ac-4842-9e5f-495e68bde75f	ffb542fb-05b0-442b-9beb-40426ead5959.pdf	/home/benja/a_f/2014/8baf092f-96d2-4a93-bf02-c4643a338da0/anexos	1	43844d85-a15a-4f1f-bbdb-b4a84ae5247e	2026-04-08 20:10:49.359128	hola	28-Abril-2014
de2afc48-f2e2-4460-839e-64a15f773b51	1f5c87a2-d1c7-4bb5-96a4-f6a8996bcdf2.pdf	/home/benja/a_f/2014/cd640171-4df6-4396-a07b-303cc12b6755/anexos	1	38258774-2f2a-4586-97d7-dd15df225e82	2026-04-14 01:33:26.569388	efweffew	11-Abril-2026
3c3fa7a5-8f50-4890-9995-c79b077abbf1	438c851c-9344-46a8-a24b-2e07253a33ec.pdf	/home/benja/a_f/2014/d23fc18c-63b9-4b39-a816-0f0445f53ca9/anexos	1	0166a709-734a-44fb-8e4d-24c2a991a89d	2026-04-14 01:40:47.932124	jbfjfjvsj csa	15-Abril-2026
\.


--
-- Data for Name: instancias; Type: TABLE DATA; Schema: documentos; Owner: administrator
--

COPY documentos.instancias (id_instancia, instancia, periodo) FROM stdin;
1	http://localhost:8983/solr/quinta_decada	2014-2023
2	http://localhost:8985/solr/cuarta_decada	2004-2013
\.


--
-- Data for Name: catalogo_acciones; Type: TABLE DATA; Schema: estadisticas; Owner: administrator
--

COPY estadisticas.catalogo_acciones (id_accion, accion, tabla_destino) FROM stdin;
1	BUSCAR	BUSQUEDA
2	CARGAR_ANEXOS	BUSQUEDA
3	LISTAR_ACTAS_PARA_REGISTRAR_ANEXO	BUSQUEDA
4	INDEXAR	INDEXACION_Y_REGISTRO
5	REGISTRAR_ANEXO	INDEXACION_Y_REGISTRO
6	REGISTRAR_ANEXO_DESDE_LISTADO_DE_ACTAS	INDEXACION_Y_REGISTRO
7	MOSTRAR_PDF_ACTA	VISUALIZACION_PDF
8	MOSTRAR_PDF_ANEXO	VISUALIZACION_PDF
9	VALIDAR_OCR	INDEXACION_Y_REGISTRO_OCR
\.


--
-- Data for Name: catalogo_endpoints; Type: TABLE DATA; Schema: estadisticas; Owner: administrator
--

COPY estadisticas.catalogo_endpoints (id_endpoint, endpoint) FROM stdin;
1	/api/solrSearch
2	/api/anexosByPrincipal
3	/api/documentosListado
4	/api/documentos/Listado
5	/api/indexarActa
6	/api/registerAnexo
7	/api/pdf
8	/api/anexoPdf
9	/api/ocrDocumento
\.


--
-- Data for Name: rendimiento_busqueda; Type: TABLE DATA; Schema: estadisticas; Owner: administrator
--

COPY estadisticas.rendimiento_busqueda (id, id_accion, id_endpoint, duracion_ms, exito, status_http, instante_cliente_iso, timestamp_cliente_ms, usuario_id, instancia_id, ui_principal, query_texto, total_resultados, total_anexos, detalle_error, created_at) FROM stdin;
1	1	1	1288.400	t	200	2026-04-15 01:24:14.158-06	1776237854158	1	1	\N	luis	37	\N	\N	2026-04-15 01:24:16.059475-06
2	1	1	759.400	t	200	2026-04-15 23:22:59.066-06	1776316979066	1	1	\N	2017	1	\N	\N	2026-04-15 23:22:59.531889-06
3	1	1	1549.300	t	200	2026-04-15 23:35:17.54-06	1776317717540	1	1	\N	acta:9/2014	2	\N	\N	2026-04-15 23:35:19.107073-06
4	1	1	1454.800	t	200	2026-04-15 23:45:13.879-06	1776318313879	1	1	\N	acta:1000/2014	0	\N	\N	2026-04-15 23:45:16.839936-06
5	1	1	217.500	t	200	2026-04-15 23:46:40.198-06	1776318400198	1	1	\N	acta:1001/2014	1	\N	\N	2026-04-15 23:46:41.312739-06
6	1	1	94.800	t	200	2026-04-15 23:48:21.539-06	1776318501539	1	1	\N	acta:1002/2014	1	\N	\N	2026-04-15 23:48:23.510799-06
7	1	1	488.200	t	200	2026-04-15 23:48:42.937-06	1776318522937	1	1	\N	2017	2	\N	\N	2026-04-15 23:48:43.280779-06
8	1	1	218.700	t	200	2026-04-15 23:49:06.59-06	1776318546590	1	1	\N	acta:1002/2014	1	\N	\N	2026-04-15 23:49:07.962127-06
9	1	1	352.100	t	200	2026-04-15 23:49:13.109-06	1776318553109	1	1	\N	acta:1000/2014	0	\N	\N	2026-04-15 23:49:14.173803-06
10	1	1	125.100	t	200	2026-04-15 23:49:21.652-06	1776318561652	1	1	\N	acta:1001/2014	1	\N	\N	2026-04-15 23:49:21.631618-06
11	1	1	48.900	t	200	2026-04-16 00:04:59.425-06	1776319499425	1	1	\N	acta:1003/2017	0	\N	\N	2026-04-16 00:04:59.800929-06
12	1	1	386.600	t	200	2026-04-16 00:06:14.67-06	1776319574670	1	1	\N	acta:1005/2017	1	\N	\N	2026-04-16 00:06:15.248942-06
\.


--
-- Data for Name: rendimiento_indexacion_y_registro; Type: TABLE DATA; Schema: estadisticas; Owner: administrator
--

COPY estadisticas.rendimiento_indexacion_y_registro (id, id_accion, id_endpoint, duracion_ms, exito, status_http, instante_cliente_iso, timestamp_cliente_ms, usuario_id, instancia_id, ui_principal, ui_anexo, tamanio_archivo_bytes, detalle_error, created_at, tamanio_salida_bytes) FROM stdin;
1	4	5	3356.700	t	200	2026-04-15 01:00:07.159-06	1776236407159	1	1	\N	\N	\N	\N	2026-04-15 01:00:10.733545-06	\N
2	9	9	33688.500	t	200	2026-04-15 23:17:06.5-06	1776316626500	1	1	\N	\N	1334855	\N	2026-04-15 23:17:41.351507-06	3985904
3	4	5	12261.600	t	200	2026-04-15 23:17:40.301-06	1776316660301	1	1	\N	\N	1334855	\N	2026-04-15 23:17:52.636649-06	\N
4	4	5	\N	f	\N	\N	\N	1	1	\N	\N	7721835	\N	2026-04-15 23:30:19.401898-06	\N
5	4	5	\N	f	\N	\N	\N	1	1	\N	\N	7721835	\N	2026-04-15 23:41:09.875608-06	\N
6	9	9	5852.300	t	200	2026-04-15 23:46:12.975-06	1776318372975	1	1	\N	\N	7721835	\N	2026-04-15 23:46:18.809521-06	7721835
7	4	5	6295.500	t	200	2026-04-15 23:46:19.233-06	1776318379233	1	1	\N	\N	7721835	\N	2026-04-15 23:46:27.252335-06	\N
8	9	9	29687.800	t	200	2026-04-15 23:47:26.812-06	1776318446812	1	1	\N	\N	1334855	\N	2026-04-15 23:47:58.249107-06	3985899
9	4	5	2296.200	t	200	2026-04-15 23:47:57.116-06	1776318477116	1	1	\N	\N	1334855	\N	2026-04-15 23:48:00.88861-06	\N
10	9	9	26777.100	t	200	2026-04-16 00:04:09.095-06	1776319449095	1	1	\N	\N	1334855	\N	2026-04-16 00:04:35.927419-06	3985902
11	4	5	564.400	f	400	2026-04-16 00:04:35.978-06	1776319475978	1	1	\N	\N	1334855	\N	2026-04-16 00:04:36.621978-06	\N
12	9	9	25510.800	t	200	2026-04-16 00:05:28.885-06	1776319528885	1	1	\N	\N	1334855	\N	2026-04-16 00:05:54.753159-06	3985902
13	4	5	3003.600	t	200	2026-04-16 00:05:54.781-06	1776319554781	1	1	\N	\N	1334855	\N	2026-04-16 00:05:57.804097-06	\N
\.


--
-- Data for Name: rendimiento_visualizacion_pdf; Type: TABLE DATA; Schema: estadisticas; Owner: administrator
--

COPY estadisticas.rendimiento_visualizacion_pdf (id, id_accion, id_endpoint, duracion_ms, exito, status_http, instante_cliente_iso, timestamp_cliente_ms, usuario_id, doc_id, ui_anexo, detalle_error, created_at) FROM stdin;
1	7	7	2258.400	t	200	\N	\N	1	0771aff0-8236-40d8-bcb5-d2cdfed0becf	\N	\N	2026-04-15 01:24:21.635807-06
2	7	7	2252.200	t	200	\N	\N	1	02014998-16ee-4ceb-9565-41140a814842	\N	\N	2026-04-15 23:23:05.677918-06
3	7	7	2223.700	t	200	\N	\N	1	b560c07c-3da0-472e-9fd6-57a89837bd2c	\N	\N	2026-04-15 23:48:31.435997-06
\.


--
-- Data for Name: poranios; Type: TABLE DATA; Schema: expedientes; Owner: administrator
--

COPY expedientes.poranios (id, anio_id, pais_id, fondo_id, seccion_id, serie_id, subserie_id, aruni_id, arprod_id, instancia_id) FROM stdin;
1	1	1	1	1	1	1	1	1	1
5	2	1	1	1	1	1	1	1	1
6	3	1	1	1	1	1	1	1	1
\.


--
-- Data for Name: porciclos; Type: TABLE DATA; Schema: expedientes; Owner: administrator
--

COPY expedientes.porciclos (id, ciclo_id, pais_id, fondo_id, seccion_id, serie_id, subserie_id, aruni_id, arprod_id, instancia_id) FROM stdin;
1	1	1	1	1	1	1	1	1	1
\.


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: administrator
--

SELECT pg_catalog.setval('auth.usuarios_id_seq', 2, true);


--
-- Name: anios_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.anios_id_seq', 3, true);


--
-- Name: areas_productoras_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.areas_productoras_id_seq', 1, true);


--
-- Name: areas_universitarias_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.areas_universitarias_id_seq', 1, true);


--
-- Name: ciclos_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.ciclos_id_seq', 2, true);


--
-- Name: fondos_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.fondos_id_seq', 1, true);


--
-- Name: paises_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.paises_id_seq', 1, true);


--
-- Name: secciones_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.secciones_id_seq', 1, true);


--
-- Name: series_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.series_id_seq', 1, true);


--
-- Name: subseries_id_seq; Type: SEQUENCE SET; Schema: clasificacion; Owner: administrator
--

SELECT pg_catalog.setval('clasificacion.subseries_id_seq', 1, true);


--
-- Name: descripcion_actas_id_seq; Type: SEQUENCE SET; Schema: documentos; Owner: administrator
--

SELECT pg_catalog.setval('documentos.descripcion_actas_id_seq', 42, true);


--
-- Name: instancias_id_instancia_seq; Type: SEQUENCE SET; Schema: documentos; Owner: administrator
--

SELECT pg_catalog.setval('documentos.instancias_id_instancia_seq', 2, true);


--
-- Name: catalogo_acciones_id_accion_seq; Type: SEQUENCE SET; Schema: estadisticas; Owner: administrator
--

SELECT pg_catalog.setval('estadisticas.catalogo_acciones_id_accion_seq', 9, true);


--
-- Name: catalogo_endpoints_id_endpoint_seq; Type: SEQUENCE SET; Schema: estadisticas; Owner: administrator
--

SELECT pg_catalog.setval('estadisticas.catalogo_endpoints_id_endpoint_seq', 9, true);


--
-- Name: rendimiento_busqueda_id_seq; Type: SEQUENCE SET; Schema: estadisticas; Owner: administrator
--

SELECT pg_catalog.setval('estadisticas.rendimiento_busqueda_id_seq', 12, true);


--
-- Name: rendimiento_indexacion_y_registro_id_seq; Type: SEQUENCE SET; Schema: estadisticas; Owner: administrator
--

SELECT pg_catalog.setval('estadisticas.rendimiento_indexacion_y_registro_id_seq', 13, true);


--
-- Name: rendimiento_visualizacion_pdf_id_seq; Type: SEQUENCE SET; Schema: estadisticas; Owner: administrator
--

SELECT pg_catalog.setval('estadisticas.rendimiento_visualizacion_pdf_id_seq', 3, true);


--
-- Name: poranios_id_seq; Type: SEQUENCE SET; Schema: expedientes; Owner: administrator
--

SELECT pg_catalog.setval('expedientes.poranios_id_seq', 6, true);


--
-- Name: porciclos_id_seq; Type: SEQUENCE SET; Schema: expedientes; Owner: administrator
--

SELECT pg_catalog.setval('expedientes.porciclos_id_seq', 1, true);


--
-- Name: usuarios usuarios_nombre_usuario_key; Type: CONSTRAINT; Schema: auth; Owner: administrator
--

ALTER TABLE ONLY auth.usuarios
    ADD CONSTRAINT usuarios_nombre_usuario_key UNIQUE (nombre_usuario);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: auth; Owner: administrator
--

ALTER TABLE ONLY auth.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: anios anios_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.anios
    ADD CONSTRAINT anios_pkey PRIMARY KEY (id);


--
-- Name: areas_productoras areas_productoras_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.areas_productoras
    ADD CONSTRAINT areas_productoras_codigo_key UNIQUE (codigo);


--
-- Name: areas_productoras areas_productoras_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.areas_productoras
    ADD CONSTRAINT areas_productoras_pkey PRIMARY KEY (id);


--
-- Name: areas_universitarias areas_universitarias_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.areas_universitarias
    ADD CONSTRAINT areas_universitarias_codigo_key UNIQUE (codigo);


--
-- Name: areas_universitarias areas_universitarias_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.areas_universitarias
    ADD CONSTRAINT areas_universitarias_pkey PRIMARY KEY (id);


--
-- Name: ciclos ciclos_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.ciclos
    ADD CONSTRAINT ciclos_pkey PRIMARY KEY (id);


--
-- Name: fondos fondos_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.fondos
    ADD CONSTRAINT fondos_codigo_key UNIQUE (codigo);


--
-- Name: fondos fondos_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.fondos
    ADD CONSTRAINT fondos_pkey PRIMARY KEY (id);


--
-- Name: paises paises_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.paises
    ADD CONSTRAINT paises_codigo_key UNIQUE (codigo);


--
-- Name: paises paises_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (id);


--
-- Name: secciones secciones_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.secciones
    ADD CONSTRAINT secciones_codigo_key UNIQUE (codigo);


--
-- Name: secciones secciones_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.secciones
    ADD CONSTRAINT secciones_pkey PRIMARY KEY (id);


--
-- Name: series series_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.series
    ADD CONSTRAINT series_codigo_key UNIQUE (codigo);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: subseries subseries_codigo_key; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.subseries
    ADD CONSTRAINT subseries_codigo_key UNIQUE (codigo);


--
-- Name: subseries subseries_pkey; Type: CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.subseries
    ADD CONSTRAINT subseries_pkey PRIMARY KEY (id);


--
-- Name: actas actas_pkey; Type: CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.actas
    ADD CONSTRAINT actas_pkey PRIMARY KEY (ui);


--
-- Name: descripcion_actas descripcion_actas_pkey; Type: CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.descripcion_actas
    ADD CONSTRAINT descripcion_actas_pkey PRIMARY KEY (id);


--
-- Name: documentos_anexos documentos_anexos_pkey; Type: CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.documentos_anexos
    ADD CONSTRAINT documentos_anexos_pkey PRIMARY KEY (ui);


--
-- Name: instancias instancias_pkey; Type: CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.instancias
    ADD CONSTRAINT instancias_pkey PRIMARY KEY (id_instancia);


--
-- Name: catalogo_acciones catalogo_acciones_accion_key; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.catalogo_acciones
    ADD CONSTRAINT catalogo_acciones_accion_key UNIQUE (accion);


--
-- Name: catalogo_acciones catalogo_acciones_pkey; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.catalogo_acciones
    ADD CONSTRAINT catalogo_acciones_pkey PRIMARY KEY (id_accion);


--
-- Name: catalogo_endpoints catalogo_endpoints_endpoint_key; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.catalogo_endpoints
    ADD CONSTRAINT catalogo_endpoints_endpoint_key UNIQUE (endpoint);


--
-- Name: catalogo_endpoints catalogo_endpoints_pkey; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.catalogo_endpoints
    ADD CONSTRAINT catalogo_endpoints_pkey PRIMARY KEY (id_endpoint);


--
-- Name: rendimiento_busqueda rendimiento_busqueda_pkey; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_busqueda
    ADD CONSTRAINT rendimiento_busqueda_pkey PRIMARY KEY (id);


--
-- Name: rendimiento_indexacion_y_registro rendimiento_indexacion_y_registro_pkey; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_indexacion_y_registro
    ADD CONSTRAINT rendimiento_indexacion_y_registro_pkey PRIMARY KEY (id);


--
-- Name: rendimiento_visualizacion_pdf rendimiento_visualizacion_pdf_pkey; Type: CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_visualizacion_pdf
    ADD CONSTRAINT rendimiento_visualizacion_pdf_pkey PRIMARY KEY (id);


--
-- Name: poranios poranios_pkey; Type: CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT poranios_pkey PRIMARY KEY (id);


--
-- Name: porciclos porciclos_pkey; Type: CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT porciclos_pkey PRIMARY KEY (id);


--
-- Name: poranios uq_expedientes_poranios_anio_instancia; Type: CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT uq_expedientes_poranios_anio_instancia UNIQUE (pais_id, fondo_id, seccion_id, serie_id, subserie_id, aruni_id, arprod_id, instancia_id, anio_id);


--
-- Name: porciclos uq_expedientes_porciclos_ciclo_instancia; Type: CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT uq_expedientes_porciclos_ciclo_instancia UNIQUE (pais_id, fondo_id, seccion_id, serie_id, subserie_id, aruni_id, arprod_id, instancia_id, ciclo_id);


--
-- Name: instancias_periodo_idx; Type: INDEX; Schema: documentos; Owner: administrator
--

CREATE INDEX instancias_periodo_idx ON documentos.instancias USING btree (periodo);


--
-- Name: series fk_series_secciones; Type: FK CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.series
    ADD CONSTRAINT fk_series_secciones FOREIGN KEY (seccion_id) REFERENCES clasificacion.secciones(id) ON DELETE RESTRICT;


--
-- Name: subseries fk_subseries_series; Type: FK CONSTRAINT; Schema: clasificacion; Owner: administrator
--

ALTER TABLE ONLY clasificacion.subseries
    ADD CONSTRAINT fk_subseries_series FOREIGN KEY (serie_id) REFERENCES clasificacion.series(id) ON DELETE RESTRICT;


--
-- Name: actas actas_id_usuario_fkey; Type: FK CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.actas
    ADD CONSTRAINT actas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES auth.usuarios(id);


--
-- Name: descripcion_actas descripcion_actas_ui_documento_fkey; Type: FK CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.descripcion_actas
    ADD CONSTRAINT descripcion_actas_ui_documento_fkey FOREIGN KEY (ui_documento) REFERENCES documentos.actas(ui) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: documentos_anexos documentos_anexos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.documentos_anexos
    ADD CONSTRAINT documentos_anexos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES auth.usuarios(id);


--
-- Name: documentos_anexos documentos_anexos_ui_principal_fkey; Type: FK CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.documentos_anexos
    ADD CONSTRAINT documentos_anexos_ui_principal_fkey FOREIGN KEY (ui_principal) REFERENCES documentos.actas(ui);


--
-- Name: actas fk_actas_expediente_anios; Type: FK CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.actas
    ADD CONSTRAINT fk_actas_expediente_anios FOREIGN KEY (expediente_anios_id) REFERENCES expedientes.poranios(id) ON DELETE RESTRICT;


--
-- Name: actas fk_actas_expediente_ciclos; Type: FK CONSTRAINT; Schema: documentos; Owner: administrator
--

ALTER TABLE ONLY documentos.actas
    ADD CONSTRAINT fk_actas_expediente_ciclos FOREIGN KEY (expediente_ciclos_id) REFERENCES expedientes.porciclos(id) ON DELETE RESTRICT;


--
-- Name: rendimiento_busqueda rendimiento_busqueda_id_accion_fkey; Type: FK CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_busqueda
    ADD CONSTRAINT rendimiento_busqueda_id_accion_fkey FOREIGN KEY (id_accion) REFERENCES estadisticas.catalogo_acciones(id_accion);


--
-- Name: rendimiento_busqueda rendimiento_busqueda_id_endpoint_fkey; Type: FK CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_busqueda
    ADD CONSTRAINT rendimiento_busqueda_id_endpoint_fkey FOREIGN KEY (id_endpoint) REFERENCES estadisticas.catalogo_endpoints(id_endpoint);


--
-- Name: rendimiento_indexacion_y_registro rendimiento_indexacion_y_registro_id_accion_fkey; Type: FK CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_indexacion_y_registro
    ADD CONSTRAINT rendimiento_indexacion_y_registro_id_accion_fkey FOREIGN KEY (id_accion) REFERENCES estadisticas.catalogo_acciones(id_accion);


--
-- Name: rendimiento_indexacion_y_registro rendimiento_indexacion_y_registro_id_endpoint_fkey; Type: FK CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_indexacion_y_registro
    ADD CONSTRAINT rendimiento_indexacion_y_registro_id_endpoint_fkey FOREIGN KEY (id_endpoint) REFERENCES estadisticas.catalogo_endpoints(id_endpoint);


--
-- Name: rendimiento_visualizacion_pdf rendimiento_visualizacion_pdf_id_accion_fkey; Type: FK CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_visualizacion_pdf
    ADD CONSTRAINT rendimiento_visualizacion_pdf_id_accion_fkey FOREIGN KEY (id_accion) REFERENCES estadisticas.catalogo_acciones(id_accion);


--
-- Name: rendimiento_visualizacion_pdf rendimiento_visualizacion_pdf_id_endpoint_fkey; Type: FK CONSTRAINT; Schema: estadisticas; Owner: administrator
--

ALTER TABLE ONLY estadisticas.rendimiento_visualizacion_pdf
    ADD CONSTRAINT rendimiento_visualizacion_pdf_id_endpoint_fkey FOREIGN KEY (id_endpoint) REFERENCES estadisticas.catalogo_endpoints(id_endpoint);


--
-- Name: poranios fk_poranios_anios; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_anios FOREIGN KEY (anio_id) REFERENCES clasificacion.anios(id) ON DELETE RESTRICT;


--
-- Name: poranios fk_poranios_areas_productoras; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_areas_productoras FOREIGN KEY (arprod_id) REFERENCES clasificacion.areas_productoras(id);


--
-- Name: poranios fk_poranios_areas_universitarias; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_areas_universitarias FOREIGN KEY (aruni_id) REFERENCES clasificacion.areas_universitarias(id);


--
-- Name: poranios fk_poranios_fondos; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_fondos FOREIGN KEY (fondo_id) REFERENCES clasificacion.fondos(id);


--
-- Name: poranios fk_poranios_instancias; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_instancias FOREIGN KEY (instancia_id) REFERENCES documentos.instancias(id_instancia) ON DELETE RESTRICT;


--
-- Name: poranios fk_poranios_paises; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_paises FOREIGN KEY (pais_id) REFERENCES clasificacion.paises(id);


--
-- Name: poranios fk_poranios_secciones; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_secciones FOREIGN KEY (seccion_id) REFERENCES clasificacion.secciones(id);


--
-- Name: poranios fk_poranios_series; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_series FOREIGN KEY (serie_id) REFERENCES clasificacion.series(id);


--
-- Name: poranios fk_poranios_subseries; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios
    ADD CONSTRAINT fk_poranios_subseries FOREIGN KEY (subserie_id) REFERENCES clasificacion.subseries(id);


--
-- Name: porciclos fk_porciclos_areas_productoras; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_areas_productoras FOREIGN KEY (arprod_id) REFERENCES clasificacion.areas_productoras(id);


--
-- Name: porciclos fk_porciclos_areas_universitarias; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_areas_universitarias FOREIGN KEY (aruni_id) REFERENCES clasificacion.areas_universitarias(id);


--
-- Name: porciclos fk_porciclos_ciclos; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_ciclos FOREIGN KEY (ciclo_id) REFERENCES clasificacion.ciclos(id) ON DELETE RESTRICT;


--
-- Name: porciclos fk_porciclos_fondos; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_fondos FOREIGN KEY (fondo_id) REFERENCES clasificacion.fondos(id);


--
-- Name: porciclos fk_porciclos_instancias; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_instancias FOREIGN KEY (instancia_id) REFERENCES documentos.instancias(id_instancia) ON DELETE RESTRICT;


--
-- Name: porciclos fk_porciclos_paises; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_paises FOREIGN KEY (pais_id) REFERENCES clasificacion.paises(id);


--
-- Name: porciclos fk_porciclos_secciones; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_secciones FOREIGN KEY (seccion_id) REFERENCES clasificacion.secciones(id);


--
-- Name: porciclos fk_porciclos_series; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_series FOREIGN KEY (serie_id) REFERENCES clasificacion.series(id);


--
-- Name: porciclos fk_porciclos_subseries; Type: FK CONSTRAINT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos
    ADD CONSTRAINT fk_porciclos_subseries FOREIGN KEY (subserie_id) REFERENCES clasificacion.subseries(id);


--
-- PostgreSQL database dump complete
--

\unrestrict f2pq10TgGVwgKcw8ppHbXzdZrjExhAVZpIwE89sZzRK5zEQIqtTB05iCl4yxylY


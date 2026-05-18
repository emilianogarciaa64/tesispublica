--
-- PostgreSQL database dump
--

\restrict 9b6nIrJptNXWB0hTxdIONgGbuyLoMQ9reOIk4V5Q5KaynQV0EdBvn9g8OkbTs2u

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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
    activo integer DEFAULT 1 NOT NULL
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
-- Name: poranios id; Type: DEFAULT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.poranios ALTER COLUMN id SET DEFAULT nextval('expedientes.poranios_id_seq'::regclass);


--
-- Name: porciclos id; Type: DEFAULT; Schema: expedientes; Owner: administrator
--

ALTER TABLE ONLY expedientes.porciclos ALTER COLUMN id SET DEFAULT nextval('expedientes.porciclos_id_seq'::regclass);


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

\unrestrict 9b6nIrJptNXWB0hTxdIONgGbuyLoMQ9reOIk4V5Q5KaynQV0EdBvn9g8OkbTs2u


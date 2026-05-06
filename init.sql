--
-- PostgreSQL database dump
--

\restrict 1cxeISrGEpG1X1glKMjatliVCbwIfg6k8snpxDtcAheONtsS7YuNqul9wID71Yj

-- Dumped from database version 15.13
-- Dumped by pg_dump version 15.15

-- Started on 2026-04-23 09:03:27 UTC

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
-- TOC entry 2 (class 3079 OID 17947)
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- TOC entry 4197 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- TOC entry 1398 (class 1247 OID 27178)
-- Name: machine_status_type; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.machine_status_type AS ENUM (
    'OK',
    'WARNING',
    'FAULT',
    'STOPPED'
);


ALTER TYPE public.machine_status_type OWNER TO admin;

--
-- TOC entry 1392 (class 1247 OID 27135)
-- Name: sensor_status_type; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.sensor_status_type AS ENUM (
    'available',
    'maintenance',
    'active'
);


ALTER TYPE public.sensor_status_type OWNER TO admin;

--
-- TOC entry 1416 (class 1247 OID 27309)
-- Name: severity_type; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.severity_type AS ENUM (
    'INFO',
    'WARNING',
    'CRITICAL'
);


ALTER TYPE public.severity_type OWNER TO admin;

--
-- TOC entry 1386 (class 1247 OID 18889)
-- Name: user_role; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'operator',
    'user'
);


ALTER TYPE public.user_role OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 297 (class 1259 OID 27289)
-- Name: analysis_results; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.analysis_results (
    id_analysis integer NOT NULL,
    id_model integer NOT NULL,
    prediction_type text NOT NULL,
    prediction_value double precision,
    confidence double precision,
    "timestamp" timestamp with time zone DEFAULT now(),
    id_measurement integer NOT NULL,
    prediction_label text
);


ALTER TABLE public.analysis_results OWNER TO admin;

--
-- TOC entry 296 (class 1259 OID 27288)
-- Name: analysis_results_id_analysis_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.analysis_results_id_analysis_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analysis_results_id_analysis_seq OWNER TO admin;

--
-- TOC entry 4198 (class 0 OID 0)
-- Dependencies: 296
-- Name: analysis_results_id_analysis_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.analysis_results_id_analysis_seq OWNED BY public.analysis_results.id_analysis;


--
-- TOC entry 293 (class 1259 OID 27246)
-- Name: feature_data; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.feature_data (
    id_featureset integer NOT NULL,
    id_measurement integer,
    id_machine integer,
    "time" timestamp with time zone DEFAULT now(),
    iso_10816 double precision,
    peak_raw double precision,
    peak_hf double precision,
    rms_raw double precision,
    dif_kt_raw double precision,
    rms_acl_env double precision,
    frq_bnd_1 double precision,
    frq_bnd_2 double precision,
    kurtosis_raw double precision,
    crest_factor double precision,
    max_val double precision,
    min_val double precision,
    id_sensor integer NOT NULL
);


ALTER TABLE public.feature_data OWNER TO admin;

--
-- TOC entry 292 (class 1259 OID 27245)
-- Name: feature_data_id_featureset_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.feature_data_id_featureset_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feature_data_id_featureset_seq OWNER TO admin;

--
-- TOC entry 4199 (class 0 OID 0)
-- Dependencies: 292
-- Name: feature_data_id_featureset_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.feature_data_id_featureset_seq OWNED BY public.feature_data.id_featureset;


--
-- TOC entry 289 (class 1259 OID 27188)
-- Name: machines; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.machines (
    id_machine integer NOT NULL,
    name text NOT NULL,
    type text,
    location text NOT NULL,
    installation_date date DEFAULT now() NOT NULL,
    status public.machine_status_type DEFAULT 'STOPPED'::public.machine_status_type,
    description text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.machines OWNER TO admin;

--
-- TOC entry 288 (class 1259 OID 27187)
-- Name: machines_id_machine_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.machines_id_machine_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.machines_id_machine_seq OWNER TO admin;

--
-- TOC entry 4200 (class 0 OID 0)
-- Dependencies: 288
-- Name: machines_id_machine_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.machines_id_machine_seq OWNED BY public.machines.id_machine;


--
-- TOC entry 291 (class 1259 OID 27199)
-- Name: measurements; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.measurements (
    id_measurement integer NOT NULL,
    id_sensor integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now(),
    raw_data_path text,
    notes text
);


ALTER TABLE public.measurements OWNER TO admin;

--
-- TOC entry 290 (class 1259 OID 27198)
-- Name: measurements_id_measurement_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.measurements_id_measurement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.measurements_id_measurement_seq OWNER TO admin;

--
-- TOC entry 4201 (class 0 OID 0)
-- Dependencies: 290
-- Name: measurements_id_measurement_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.measurements_id_measurement_seq OWNED BY public.measurements.id_measurement;


--
-- TOC entry 295 (class 1259 OID 27279)
-- Name: ml_models; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ml_models (
    id_model integer NOT NULL,
    name text NOT NULL,
    version text,
    type text,
    path_to_model text NOT NULL,
    accuracy double precision,
    training_date timestamp with time zone DEFAULT now(),
    description text,
    is_active boolean DEFAULT true,
    training_status text DEFAULT 'ready'::text NOT NULL
);


ALTER TABLE public.ml_models OWNER TO admin;

--
-- TOC entry 294 (class 1259 OID 27278)
-- Name: ml_models_id_model_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.ml_models_id_model_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ml_models_id_model_seq OWNER TO admin;

--
-- TOC entry 4202 (class 0 OID 0)
-- Dependencies: 294
-- Name: ml_models_id_model_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.ml_models_id_model_seq OWNED BY public.ml_models.id_model;


--
-- TOC entry 287 (class 1259 OID 27142)
-- Name: sensors; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.sensors (
    id_sensor integer NOT NULL,
    serial_number text NOT NULL,
    description text NOT NULL,
    status public.sensor_status_type DEFAULT 'available'::public.sensor_status_type,
    id_machine integer,
    "position" text,
    sampling_rate double precision,
    calibration_date date,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sensors OWNER TO admin;

--
-- TOC entry 286 (class 1259 OID 27141)
-- Name: sensors_id_sensor_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.sensors_id_sensor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensors_id_sensor_seq OWNER TO admin;

--
-- TOC entry 4203 (class 0 OID 0)
-- Dependencies: 286
-- Name: sensors_id_sensor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.sensors_id_sensor_seq OWNED BY public.sensors.id_sensor;


--
-- TOC entry 299 (class 1259 OID 27316)
-- Name: service_notes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.service_notes (
    id_note integer NOT NULL,
    id_machine integer NOT NULL,
    id_analysis integer,
    id_user integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now(),
    content text NOT NULL,
    severity public.severity_type DEFAULT 'INFO'::public.severity_type
);


ALTER TABLE public.service_notes OWNER TO admin;

--
-- TOC entry 298 (class 1259 OID 27315)
-- Name: service_notes_id_note_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.service_notes_id_note_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_notes_id_note_seq OWNER TO admin;

--
-- TOC entry 4204 (class 0 OID 0)
-- Dependencies: 298
-- Name: service_notes_id_note_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.service_notes_id_note_seq OWNED BY public.service_notes.id_note;


--
-- TOC entry 285 (class 1259 OID 18896)
-- Name: users; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    hashed_password text NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    creation_time timestamp with time zone DEFAULT now() NOT NULL,
    last_login timestamp with time zone
);


ALTER TABLE public.users OWNER TO admin;

--
-- TOC entry 284 (class 1259 OID 18895)
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_user_seq OWNER TO admin;

--
-- TOC entry 4205 (class 0 OID 0)
-- Dependencies: 284
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;


--
-- TOC entry 3898 (class 2604 OID 27292)
-- Name: analysis_results id_analysis; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis_results ALTER COLUMN id_analysis SET DEFAULT nextval('public.analysis_results_id_analysis_seq'::regclass);


--
-- TOC entry 3892 (class 2604 OID 27249)
-- Name: feature_data id_featureset; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.feature_data ALTER COLUMN id_featureset SET DEFAULT nextval('public.feature_data_id_featureset_seq'::regclass);


--
-- TOC entry 3886 (class 2604 OID 27191)
-- Name: machines id_machine; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.machines ALTER COLUMN id_machine SET DEFAULT nextval('public.machines_id_machine_seq'::regclass);


--
-- TOC entry 3890 (class 2604 OID 27202)
-- Name: measurements id_measurement; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.measurements ALTER COLUMN id_measurement SET DEFAULT nextval('public.measurements_id_measurement_seq'::regclass);


--
-- TOC entry 3894 (class 2604 OID 27282)
-- Name: ml_models id_model; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ml_models ALTER COLUMN id_model SET DEFAULT nextval('public.ml_models_id_model_seq'::regclass);


--
-- TOC entry 3883 (class 2604 OID 27145)
-- Name: sensors id_sensor; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sensors ALTER COLUMN id_sensor SET DEFAULT nextval('public.sensors_id_sensor_seq'::regclass);


--
-- TOC entry 3900 (class 2604 OID 27319)
-- Name: service_notes id_note; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service_notes ALTER COLUMN id_note SET DEFAULT nextval('public.service_notes_id_note_seq'::regclass);


--
-- TOC entry 3880 (class 2604 OID 18899)
-- Name: users id_user; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);


--
-- TOC entry 3831 (class 0 OID 17974)
-- Dependencies: 230
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.hypertable (id, schema_name, table_name, associated_schema_name, associated_table_prefix, num_dimensions, chunk_sizing_func_schema, chunk_sizing_func_name, chunk_target_size, compression_state, compressed_hypertable_id, status) FROM stdin;
\.


--
-- TOC entry 3837 (class 0 OID 18044)
-- Dependencies: 238
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.chunk (id, hypertable_id, schema_name, table_name, compressed_chunk_id, dropped, status, osm_chunk, creation_time) FROM stdin;
\.


--
-- TOC entry 3841 (class 0 OID 18087)
-- Dependencies: 242
-- Data for Name: chunk_column_stats; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.chunk_column_stats (id, hypertable_id, chunk_id, column_name, range_start, range_end, valid) FROM stdin;
\.


--
-- TOC entry 3833 (class 0 OID 18010)
-- Dependencies: 234
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.dimension (id, hypertable_id, column_name, column_type, aligned, num_slices, partitioning_func_schema, partitioning_func, interval_length, compress_interval_length, integer_now_func_schema, integer_now_func) FROM stdin;
\.


--
-- TOC entry 3835 (class 0 OID 18029)
-- Dependencies: 236
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.dimension_slice (id, dimension_id, range_start, range_end) FROM stdin;
\.


--
-- TOC entry 3839 (class 0 OID 18069)
-- Dependencies: 239
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.chunk_constraint (chunk_id, dimension_slice_id, constraint_name, hypertable_constraint_name) FROM stdin;
\.


--
-- TOC entry 3854 (class 0 OID 18275)
-- Dependencies: 260
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.compression_chunk_size (chunk_id, compressed_chunk_id, uncompressed_heap_size, uncompressed_toast_size, uncompressed_index_size, compressed_heap_size, compressed_toast_size, compressed_index_size, numrows_pre_compression, numrows_post_compression, numrows_frozen_immediately) FROM stdin;
\.


--
-- TOC entry 3853 (class 0 OID 18264)
-- Dependencies: 259
-- Data for Name: compression_settings; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.compression_settings (relid, compress_relid, segmentby, orderby, orderby_desc, orderby_nullsfirst, index) FROM stdin;
\.


--
-- TOC entry 3846 (class 0 OID 18175)
-- Dependencies: 251
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_agg (mat_hypertable_id, raw_hypertable_id, parent_mat_hypertable_id, user_view_schema, user_view_name, partial_view_schema, partial_view_name, direct_view_schema, direct_view_name, materialized_only, finalized) FROM stdin;
\.


--
-- TOC entry 3855 (class 0 OID 18291)
-- Dependencies: 261
-- Data for Name: continuous_agg_migrate_plan; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_agg_migrate_plan (mat_hypertable_id, start_ts, end_ts, user_view_definition) FROM stdin;
\.


--
-- TOC entry 3856 (class 0 OID 18300)
-- Dependencies: 263
-- Data for Name: continuous_agg_migrate_plan_step; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_agg_migrate_plan_step (mat_hypertable_id, step_id, status, start_ts, end_ts, type, config) FROM stdin;
\.


--
-- TOC entry 3847 (class 0 OID 18202)
-- Dependencies: 252
-- Data for Name: continuous_aggs_bucket_function; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_aggs_bucket_function (mat_hypertable_id, bucket_func, bucket_width, bucket_origin, bucket_offset, bucket_timezone, bucket_fixed_width) FROM stdin;
\.


--
-- TOC entry 3850 (class 0 OID 18235)
-- Dependencies: 255
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_aggs_hypertable_invalidation_log (hypertable_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3848 (class 0 OID 18215)
-- Dependencies: 253
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_aggs_invalidation_threshold (hypertable_id, watermark) FROM stdin;
\.


--
-- TOC entry 3851 (class 0 OID 18239)
-- Dependencies: 256
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_aggs_materialization_invalidation_log (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3852 (class 0 OID 18248)
-- Dependencies: 257
-- Data for Name: continuous_aggs_materialization_ranges; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_aggs_materialization_ranges (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3849 (class 0 OID 18225)
-- Dependencies: 254
-- Data for Name: continuous_aggs_watermark; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.continuous_aggs_watermark (mat_hypertable_id, watermark) FROM stdin;
\.


--
-- TOC entry 3845 (class 0 OID 18162)
-- Dependencies: 249
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.metadata (key, value, include_in_telemetry) FROM stdin;
install_timestamp	2025-12-28 16:42:02.658776+00	t
timescaledb_version	2.24.0	f
exported_uuid	b57fde9a-3e30-4c58-bd26-cd48754744aa	t
\.


--
-- TOC entry 3832 (class 0 OID 17996)
-- Dependencies: 232
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: admin
--

COPY _timescaledb_catalog.tablespace (id, hypertable_id, tablespace_name) FROM stdin;
\.


--
-- TOC entry 3844 (class 0 OID 18107)
-- Dependencies: 244
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: admin
--

COPY _timescaledb_config.bgw_job (id, application_name, schedule_interval, max_runtime, max_retries, retry_period, proc_schema, proc_name, owner, scheduled, fixed_schedule, initial_start, hypertable_id, config, check_schema, check_name, timezone) FROM stdin;
\.


--
-- TOC entry 4189 (class 0 OID 27289)
-- Dependencies: 297
-- Data for Name: analysis_results; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.analysis_results (id_analysis, id_model, prediction_type, prediction_value, confidence, "timestamp", id_measurement, prediction_label) FROM stdin;
1	1	Anomaly Score	1.0260289708773296	1	2026-04-09 06:28:18.701514+00	2243	Zjištěna anomálie
3	2	Fault Classification	\N	0.9993821382522583	2026-04-09 07:16:56.738807+00	2243	Porucha vnějšího kroužku (Outer Race) - OR_007
4	1	Anomaly Score	1.0836833665768306	1	2026-04-09 07:36:03.902965+00	2735	Zjištěna anomálie
5	2	Fault Classification	\N	0.7472366094589233	2026-04-09 07:36:09.421326+00	2735	Zdravé ložisko (Normal)
6	2	Fault Classification	\N	0.7472366094589233	2026-04-09 07:36:25.766679+00	2735	Zdravé ložisko (Normal)
7	1	Anomaly Score	1.0836833665768306	1	2026-04-09 07:38:18.823413+00	2735	Zjištěna anomálie
8	2	Fault Classification	\N	0.7472366094589233	2026-04-09 07:38:23.711193+00	2735	Zdravé ložisko (Normal)
9	3	RUL Prediction	18.1	\N	2026-04-09 09:06:11.47469+00	2489	18.1 dní
10	4	RUL Prediction	18.1	\N	2026-04-23 08:19:49.68122+00	2489	18.1 dní
11	6	Anomaly Score	1.1341449469327927	1	2026-04-23 08:20:02.444411+00	2489	Zjištěna anomálie
12	2	Fault Classification	\N	0.7472366094589233	2026-04-23 08:20:08.371241+00	2489	Zdravé ložisko (Normal)
13	2	Fault Classification	\N	0.7472366094589233	2026-04-23 08:21:13.95164+00	2489	Zdravé ložisko (Normal)
14	2	Fault Classification	\N	0.7472366094589233	2026-04-23 08:21:20.789248+00	2489	Zdravé ložisko (Normal)
15	6	Anomaly Score	1.1341449469327927	1	2026-04-23 08:21:32.504805+00	2735	Zjištěna anomálie
16	2	Fault Classification	\N	0.7472366094589233	2026-04-23 08:21:36.666233+00	2735	Zdravé ložisko (Normal)
17	4	RUL Prediction	16.8	\N	2026-04-23 08:21:41.105027+00	2736	16.8 dní
\.


--
-- TOC entry 4185 (class 0 OID 27246)
-- Dependencies: 293
-- Data for Name: feature_data; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.feature_data (id_featureset, id_measurement, id_machine, "time", iso_10816, peak_raw, peak_hf, rms_raw, dif_kt_raw, rms_acl_env, frq_bnd_1, frq_bnd_2, kurtosis_raw, crest_factor, max_val, min_val, id_sensor) FROM stdin;
1502	1923	5	2026-04-08 12:43:42.745397+00	\N	4.3210625648498535	\N	0.6196967427493564	\N	\N	\N	\N	0.9322489405724004	6.9728663502069725	3.902006149291992	-4.3210625648498535	9
1503	1924	5	2026-04-08 13:13:55.182273+00	\N	3.429257869720459	\N	0.6198391982235759	\N	\N	\N	\N	0.2656478036962606	5.532495975647423	3.005456924438477	-3.429257869720459	10
1504	1925	5	2026-04-08 13:14:59.177461+00	\N	4.5407891273498535	\N	0.6111942311237565	\N	\N	\N	\N	1.093940705670514	7.429371705621385	3.4758925437927246	-4.5407891273498535	9
1507	1926	5	2026-04-08 13:19:01.472694+00	\N	2.852308750152588	\N	0.6042225793759484	\N	\N	\N	\N	0.06695356198191948	4.720625887729158	2.6365041732788086	-2.852308750152588	10
1505	1927	5	2026-04-08 13:17:42.921042+00	\N	4.48986291885376	\N	0.6250779376386767	\N	\N	\N	\N	1.162604457334747	7.182884962817394	4.093050956726074	-4.48986291885376	9
1508	1928	5	2026-04-08 13:19:03.552113+00	\N	3.380429744720459	\N	0.6347941094055759	\N	\N	\N	\N	0.23283638320461808	5.3252380490516975	3.380429744720459	-2.6494503021240234	10
1510	1929	5	2026-04-08 13:19:07.687863+00	\N	3.948354721069336	\N	0.6014108466259074	\N	\N	\N	\N	1.005726488066597	6.565153826574251	3.948354721069336	-3.710484504699707	9
1509	1930	5	2026-04-08 13:19:05.631334+00	\N	2.934563159942627	\N	0.596958720693903	\N	\N	\N	\N	0.20123230799127256	4.915856085545579	2.87477970123291	-2.934563159942627	10
1512	1931	5	2026-04-08 13:19:11.808232+00	\N	3.944087028503418	\N	0.5938887150644261	\N	\N	\N	\N	0.8744068469924149	6.64112135566603	3.7089109420776367	-3.944087028503418	9
1511	1932	5	2026-04-08 13:19:09.758008+00	\N	2.544808387756348	\N	0.5849928761735868	\N	\N	\N	\N	0.17948602309593298	4.35015278203357	2.544808387756348	-2.505946159362793	10
1506	1932	5	2026-04-08 13:18:48.078465+00	\N	2.544808387756348	\N	0.5849928761735868	\N	\N	\N	\N	0.17948602309593298	4.35015278203357	2.544808387756348	-2.505946159362793	10
1514	1933	5	2026-04-08 13:19:15.94213+00	\N	3.3491015434265137	\N	0.5840111427586488	\N	\N	\N	\N	0.7426608062260116	5.73465349925794	3.307366371154785	-3.3491015434265137	9
1513	1934	5	2026-04-08 13:19:13.871025+00	\N	2.561831474304199	\N	0.5781964719161489	\N	\N	\N	\N	0.17031517063578194	4.430728305577971	2.561831474304199	-2.405226230621338	10
1516	1935	5	2026-04-08 13:19:20.104795+00	\N	4.497480392456055	\N	0.6112114369131065	\N	\N	\N	\N	0.765449775877693	7.358305360204579	4.497480392456055	-3.3536911010742188	9
1515	1936	5	2026-04-08 13:19:18.015671+00	\N	3.10525894165039	\N	0.6049710384150045	\N	\N	\N	\N	0.12807362664799626	5.132905121848513	2.5600314140319824	-3.10525894165039	10
1517	1937	5	2026-04-08 13:19:22.164951+00	\N	3.872203826904297	\N	0.6040683703289161	\N	\N	\N	\N	0.496706105981791	6.410207878945683	3.872203826904297	-2.8184056282043457	9
1518	1938	5	2026-04-08 13:19:24.221803+00	\N	3.466212749481201	\N	0.5913082582490663	\N	\N	\N	\N	0.3394908873501339	5.861938677712818	3.466212749481201	-2.8940439224243164	10
1520	1939	5	2026-04-08 13:19:28.384521+00	\N	3.73920202255249	\N	0.6085789970387427	\N	\N	\N	\N	0.6329044101298837	6.144152264121676	3.73920202255249	-3.478395938873291	9
1519	1940	5	2026-04-08 13:19:26.313103+00	\N	2.7272582054138184	\N	0.591815590394177	\N	\N	\N	\N	0.2061204511296051	4.608290571725791	2.7272582054138184	-2.534961700439453	10
1522	1941	5	2026-04-08 13:19:32.522464+00	\N	3.3764243125915527	\N	0.5972959626002717	\N	\N	\N	\N	0.4946374122856869	5.6528497160647255	2.932214736938477	-3.3764243125915527	9
1521	1942	5	2026-04-08 13:19:30.442188+00	\N	2.994966506958008	\N	0.604863896203408	\N	\N	\N	\N	0.17375629108304746	4.9514717703548285	2.994966506958008	-2.442002296447754	10
1523	1943	5	2026-04-08 13:19:34.57525+00	\N	3.526461124420166	\N	0.6014806504391093	\N	\N	\N	\N	0.6626686599526876	5.862966866591108	3.213536739349365	-3.526461124420166	9
1524	1944	5	2026-04-08 13:19:36.645854+00	\N	2.707350254058838	\N	0.5850199602146932	\N	\N	\N	\N	0.28228969003590576	4.627791251883582	2.707350254058838	-2.6533007621765137	10
1526	1945	5	2026-04-08 13:19:40.76442+00	\N	3.213667869567871	\N	0.5984866448798347	\N	\N	\N	\N	0.5718911890546674	5.369656778578772	3.1162261962890625	-3.213667869567871	9
1525	1946	5	2026-04-08 13:19:38.69929+00	\N	2.8964877128601074	\N	0.6059533778773053	\N	\N	\N	\N	0.23671431503017182	4.78005044382572	2.8964877128601074	-2.5923609733581543	10
1528	2491	4	2026-04-09 07:36:57.3686+00	\N	2.52988338470459	\N	0.5638898794564087	\N	\N	\N	\N	0.07135220765689265	4.486484820659317	2.3543357849121094	-2.52988338470459	6
1531	2495	4	2026-04-09 07:37:03.729208+00	\N	3.3217787742614746	\N	0.5895362028089083	\N	\N	\N	\N	0.24625938461898356	5.634562828261444	3.3217787742614746	-3.195667266845703	6
1536	2499	4	2026-04-09 07:37:14.315762+00	\N	4.136919975280762	\N	0.6046452147525899	\N	\N	\N	\N	0.3939179891327429	6.841896494580737	4.136919975280762	-3.5265684127807617	6
1540	2503	4	2026-04-09 07:37:22.758872+00	\N	4.874801635742188	\N	0.6390831355517214	\N	\N	\N	\N	0.8219141035223956	7.627805154854799	3.711307048797608	-4.874801635742188	6
1543	2507	4	2026-04-09 07:37:29.130021+00	\N	3.98709774017334	\N	0.6354192444445607	\N	\N	\N	\N	0.5170792527889203	6.274751315816038	3.649294376373291	-3.98709774017334	6
1529	2494	4	2026-04-09 07:36:59.485344+00	\N	2.812349796295166	\N	0.5668608267366446	\N	\N	\N	\N	-0.035780409124404944	4.961270321827589	2.812349796295166	-2.358376979827881	7
1534	2498	4	2026-04-09 07:37:10.069278+00	\N	2.6929378509521484	\N	0.5687879546130624	\N	\N	\N	\N	-0.07639275258209866	4.73451983135633	1.9980669021606443	-2.6929378509521484	7
1538	2502	4	2026-04-09 07:37:18.559472+00	\N	2.587246894836426	\N	0.6020977251748424	\N	\N	\N	\N	0.003375735259136814	4.297054758154282	2.474129199981689	-2.587246894836426	7
1541	2506	4	2026-04-09 07:37:24.867503+00	\N	2.805781364440918	\N	0.5944758635059112	\N	\N	\N	\N	0.06910129397000908	4.719756573284356	2.504146099090576	-2.805781364440918	7
1545	2510	4	2026-04-09 07:37:33.355886+00	\N	4.586362838745117	\N	0.5911269143120327	\N	\N	\N	\N	0.24975307735220076	7.758677075434526	2.950751781463623	-4.586362838745117	7
1530	2493	4	2026-04-09 07:37:01.603151+00	\N	3.623104095458984	\N	0.5890775374817	\N	\N	\N	\N	0.13794155897761096	6.150470634048811	3.195643424987793	-3.623104095458984	6
1533	2497	4	2026-04-09 07:37:07.964889+00	\N	2.872622013092041	\N	0.597274133176941	\N	\N	\N	\N	0.24819047905949887	4.80955369323023	2.872622013092041	-2.539539337158203	6
1537	2501	4	2026-04-09 07:37:16.446301+00	\N	4.627382755279541	\N	0.6276674304337782	\N	\N	\N	\N	0.550157014615225	7.372348047566492	3.986501693725586	-4.627382755279541	6
1542	2505	4	2026-04-09 07:37:26.979479+00	\N	4.286158084869385	\N	0.6285348242875125	\N	\N	\N	\N	0.5761798052153027	6.819284977133988	2.9686808586120605	-4.286158084869385	6
1546	2509	4	2026-04-09 07:37:35.490932+00	\N	6.721889972686768	\N	0.6541204761524503	\N	\N	\N	\N	1.7992674993386206	10.276226196472336	6.721889972686768	-5.931985378265381	6
1527	2492	4	2026-04-09 07:36:55.241113+00	\N	2.469348907470703	\N	0.5604705115751822	\N	\N	\N	\N	-0.02466551115223581	4.405849828799533	2.193140983581543	-2.469348907470703	7
1532	2496	4	2026-04-09 07:37:05.834366+00	\N	2.327442169189453	\N	0.5688734167333562	\N	\N	\N	\N	-0.03503009262130563	4.091318210216839	2.1926164627075195	-2.327442169189453	7
1535	2500	4	2026-04-09 07:37:12.183998+00	\N	2.655816078186035	\N	0.5829561082763537	\N	\N	\N	\N	0.03562625436105549	4.555773651705233	2.655816078186035	-2.5069355964660645	7
1539	2504	4	2026-04-09 07:37:20.660643+00	\N	2.739846706390381	\N	0.59392805990366	\N	\N	\N	\N	0.04076141341113093	4.613095240583188	2.501881122589112	-2.739846706390381	7
1544	2508	4	2026-04-09 07:37:31.256296+00	\N	3.554868698120117	\N	0.5890357333713359	\N	\N	\N	\N	0.10230241654756655	6.0350645923871	3.554868698120117	-2.682805061340332	7
\.


--
-- TOC entry 4181 (class 0 OID 27188)
-- Dependencies: 289
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.machines (id_machine, name, type, location, installation_date, status, description, created_at) FROM stdin;
1	Odstředivé čerpadlo CP-101	Čerpadlo s asynchronním motorem	Hala A - Sekce 1	2024-03-15	OK	Hlavní oběhové čerpadlo chladicího okruhu. Kritický uzel pro chlazení lisu.	2026-01-21 13:34:55.004583+00
2	Vstřikovací lis IM-202	Hydraulický vstřikovací lis	Hala B - Lisovna	2023-11-20	OK	Lis pro výrobu plastových komponentů. Pohon čerpadla vykazuje občasné rázy.	2026-01-21 13:34:55.004583+00
5	XJTU_Bearing_1_2	Ložisko typu LDK UER204	Hala 2	2026-01-30	OK	Otáčky 2100rpm (35 Hz), radiální zatížení 12kN	2026-01-30 09:25:35.016454+00
4	XJTU_Bearing_1_1	Ložisko typu LDK UER204	Hala 2	2026-01-29	OK	Otáčky 2100rpm (35 Hz), radiální zatížení 12kN	2026-01-29 09:10:37.379569+00
\.


--
-- TOC entry 4183 (class 0 OID 27199)
-- Dependencies: 291
-- Data for Name: measurements; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.measurements (id_measurement, id_sensor, "timestamp", raw_data_path, notes) FROM stdin;
1923	9	2026-04-08 12:00:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\1_h.csv	Batch import: 1.csv (H)
1924	10	2026-04-08 12:00:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\1_v.csv	Batch import: 1.csv (V)
1925	9	2026-04-08 12:01:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\2_h.csv	Batch import: 2.csv (H)
1926	10	2026-04-08 12:01:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\2_v.csv	Batch import: 2.csv (V)
1927	9	2026-04-08 12:02:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\3_h.csv	Batch import: 3.csv (H)
1928	10	2026-04-08 12:02:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\3_v.csv	Batch import: 3.csv (V)
1929	9	2026-04-08 12:03:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\4_h.csv	Batch import: 4.csv (H)
1930	10	2026-04-08 12:03:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\4_v.csv	Batch import: 4.csv (V)
1931	9	2026-04-08 12:04:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\5_h.csv	Batch import: 5.csv (H)
1932	10	2026-04-08 12:04:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\5_v.csv	Batch import: 5.csv (V)
1933	9	2026-04-08 12:05:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\6_h.csv	Batch import: 6.csv (H)
1934	10	2026-04-08 12:05:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\6_v.csv	Batch import: 6.csv (V)
1935	9	2026-04-08 12:06:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\7_h.csv	Batch import: 7.csv (H)
1936	10	2026-04-08 12:06:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\7_v.csv	Batch import: 7.csv (V)
1937	9	2026-04-08 12:07:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\8_h.csv	Batch import: 8.csv (H)
1938	10	2026-04-08 12:07:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\8_v.csv	Batch import: 8.csv (V)
1939	9	2026-04-08 12:08:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\9_h.csv	Batch import: 9.csv (H)
1940	10	2026-04-08 12:08:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\9_v.csv	Batch import: 9.csv (V)
1941	9	2026-04-08 12:09:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\10_h.csv	Batch import: 10.csv (H)
1942	10	2026-04-08 12:09:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\10_v.csv	Batch import: 10.csv (V)
1943	9	2026-04-08 12:10:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\11_h.csv	Batch import: 11.csv (H)
1944	10	2026-04-08 12:10:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\11_v.csv	Batch import: 11.csv (V)
1945	9	2026-04-08 12:11:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\12_h.csv	Batch import: 12.csv (H)
1946	10	2026-04-08 12:11:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\12_v.csv	Batch import: 12.csv (V)
1947	9	2026-04-08 12:12:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\13_h.csv	Batch import: 13.csv (H)
1948	10	2026-04-08 12:12:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\13_v.csv	Batch import: 13.csv (V)
1949	9	2026-04-08 12:13:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\14_h.csv	Batch import: 14.csv (H)
1950	10	2026-04-08 12:13:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\14_v.csv	Batch import: 14.csv (V)
1951	9	2026-04-08 12:14:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\15_h.csv	Batch import: 15.csv (H)
1952	10	2026-04-08 12:14:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\15_v.csv	Batch import: 15.csv (V)
1953	9	2026-04-08 12:15:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\16_h.csv	Batch import: 16.csv (H)
1954	10	2026-04-08 12:15:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\16_v.csv	Batch import: 16.csv (V)
1955	9	2026-04-08 12:16:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\17_h.csv	Batch import: 17.csv (H)
1956	10	2026-04-08 12:16:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\17_v.csv	Batch import: 17.csv (V)
1957	9	2026-04-08 12:17:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\18_h.csv	Batch import: 18.csv (H)
1958	10	2026-04-08 12:17:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\18_v.csv	Batch import: 18.csv (V)
1959	9	2026-04-08 12:18:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\19_h.csv	Batch import: 19.csv (H)
1960	10	2026-04-08 12:18:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\19_v.csv	Batch import: 19.csv (V)
1961	9	2026-04-08 12:19:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\20_h.csv	Batch import: 20.csv (H)
1962	10	2026-04-08 12:19:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\20_v.csv	Batch import: 20.csv (V)
1963	9	2026-04-08 12:20:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\21_h.csv	Batch import: 21.csv (H)
1964	10	2026-04-08 12:20:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\21_v.csv	Batch import: 21.csv (V)
1965	9	2026-04-08 12:21:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\22_h.csv	Batch import: 22.csv (H)
1966	10	2026-04-08 12:21:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\22_v.csv	Batch import: 22.csv (V)
1967	9	2026-04-08 12:22:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\23_h.csv	Batch import: 23.csv (H)
1968	10	2026-04-08 12:22:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\23_v.csv	Batch import: 23.csv (V)
1969	9	2026-04-08 12:23:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\24_h.csv	Batch import: 24.csv (H)
1973	9	2026-04-08 12:25:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\26_h.csv	Batch import: 26.csv (H)
1977	9	2026-04-08 12:27:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\28_h.csv	Batch import: 28.csv (H)
1981	9	2026-04-08 12:29:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\30_h.csv	Batch import: 30.csv (H)
1985	9	2026-04-08 12:31:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\32_h.csv	Batch import: 32.csv (H)
1989	9	2026-04-08 12:33:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\34_h.csv	Batch import: 34.csv (H)
1993	9	2026-04-08 12:35:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\36_h.csv	Batch import: 36.csv (H)
1970	10	2026-04-08 12:23:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\24_v.csv	Batch import: 24.csv (V)
1974	10	2026-04-08 12:25:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\26_v.csv	Batch import: 26.csv (V)
1978	10	2026-04-08 12:27:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\28_v.csv	Batch import: 28.csv (V)
1982	10	2026-04-08 12:29:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\30_v.csv	Batch import: 30.csv (V)
1986	10	2026-04-08 12:31:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\32_v.csv	Batch import: 32.csv (V)
1990	10	2026-04-08 12:33:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\34_v.csv	Batch import: 34.csv (V)
1994	10	2026-04-08 12:35:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\36_v.csv	Batch import: 36.csv (V)
1971	9	2026-04-08 12:24:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\25_h.csv	Batch import: 25.csv (H)
1975	9	2026-04-08 12:26:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\27_h.csv	Batch import: 27.csv (H)
1979	9	2026-04-08 12:28:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\29_h.csv	Batch import: 29.csv (H)
1983	9	2026-04-08 12:30:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\31_h.csv	Batch import: 31.csv (H)
1987	9	2026-04-08 12:32:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\33_h.csv	Batch import: 33.csv (H)
1991	9	2026-04-08 12:34:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\35_h.csv	Batch import: 35.csv (H)
1972	10	2026-04-08 12:24:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\25_v.csv	Batch import: 25.csv (V)
1976	10	2026-04-08 12:26:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\27_v.csv	Batch import: 27.csv (V)
1980	10	2026-04-08 12:28:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\29_v.csv	Batch import: 29.csv (V)
1984	10	2026-04-08 12:30:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\31_v.csv	Batch import: 31.csv (V)
1988	10	2026-04-08 12:32:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\33_v.csv	Batch import: 33.csv (V)
1992	10	2026-04-08 12:34:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\35_v.csv	Batch import: 35.csv (V)
1995	9	2026-04-08 12:36:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\37_h.csv	Batch import: 37.csv (H)
1996	10	2026-04-08 12:36:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\37_v.csv	Batch import: 37.csv (V)
1997	9	2026-04-08 12:37:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\38_h.csv	Batch import: 38.csv (H)
1998	10	2026-04-08 12:37:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\38_v.csv	Batch import: 38.csv (V)
1999	9	2026-04-08 12:38:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\39_h.csv	Batch import: 39.csv (H)
2000	10	2026-04-08 12:38:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\39_v.csv	Batch import: 39.csv (V)
2001	9	2026-04-08 12:39:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\40_h.csv	Batch import: 40.csv (H)
2002	10	2026-04-08 12:39:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\40_v.csv	Batch import: 40.csv (V)
2003	9	2026-04-08 12:40:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\41_h.csv	Batch import: 41.csv (H)
2004	10	2026-04-08 12:40:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\41_v.csv	Batch import: 41.csv (V)
2005	9	2026-04-08 12:41:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\42_h.csv	Batch import: 42.csv (H)
2006	10	2026-04-08 12:41:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\42_v.csv	Batch import: 42.csv (V)
2007	9	2026-04-08 12:42:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\43_h.csv	Batch import: 43.csv (H)
2008	10	2026-04-08 12:42:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\43_v.csv	Batch import: 43.csv (V)
2009	9	2026-04-08 12:43:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\44_h.csv	Batch import: 44.csv (H)
2010	10	2026-04-08 12:43:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\44_v.csv	Batch import: 44.csv (V)
2011	9	2026-04-08 12:44:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\45_h.csv	Batch import: 45.csv (H)
2012	10	2026-04-08 12:44:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\45_v.csv	Batch import: 45.csv (V)
2013	9	2026-04-08 12:45:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\46_h.csv	Batch import: 46.csv (H)
2014	10	2026-04-08 12:45:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\46_v.csv	Batch import: 46.csv (V)
2015	9	2026-04-08 12:46:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\47_h.csv	Batch import: 47.csv (H)
2016	10	2026-04-08 12:46:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\47_v.csv	Batch import: 47.csv (V)
2017	9	2026-04-08 12:47:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\48_h.csv	Batch import: 48.csv (H)
2018	10	2026-04-08 12:47:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\48_v.csv	Batch import: 48.csv (V)
2019	9	2026-04-08 12:48:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\49_h.csv	Batch import: 49.csv (H)
2020	10	2026-04-08 12:48:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\49_v.csv	Batch import: 49.csv (V)
2021	9	2026-04-08 12:49:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\50_h.csv	Batch import: 50.csv (H)
2022	10	2026-04-08 12:49:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\50_v.csv	Batch import: 50.csv (V)
2023	9	2026-04-08 12:50:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\51_h.csv	Batch import: 51.csv (H)
2024	10	2026-04-08 12:50:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\51_v.csv	Batch import: 51.csv (V)
2025	9	2026-04-08 12:51:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\52_h.csv	Batch import: 52.csv (H)
2026	10	2026-04-08 12:51:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\52_v.csv	Batch import: 52.csv (V)
2027	9	2026-04-08 12:52:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\53_h.csv	Batch import: 53.csv (H)
2028	10	2026-04-08 12:52:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\53_v.csv	Batch import: 53.csv (V)
2029	9	2026-04-08 12:53:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\54_h.csv	Batch import: 54.csv (H)
2030	10	2026-04-08 12:53:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\54_v.csv	Batch import: 54.csv (V)
2031	9	2026-04-08 12:54:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\55_h.csv	Batch import: 55.csv (H)
2032	10	2026-04-08 12:54:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\55_v.csv	Batch import: 55.csv (V)
2033	9	2026-04-08 12:55:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\56_h.csv	Batch import: 56.csv (H)
2034	10	2026-04-08 12:55:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\56_v.csv	Batch import: 56.csv (V)
2038	10	2026-04-08 12:57:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\58_v.csv	Batch import: 58.csv (V)
2042	10	2026-04-08 12:59:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\60_v.csv	Batch import: 60.csv (V)
2046	10	2026-04-08 13:01:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\62_v.csv	Batch import: 62.csv (V)
2050	10	2026-04-08 13:03:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\64_v.csv	Batch import: 64.csv (V)
2054	10	2026-04-08 13:05:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\66_v.csv	Batch import: 66.csv (V)
2058	10	2026-04-08 13:07:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\68_v.csv	Batch import: 68.csv (V)
2062	10	2026-04-08 13:09:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\70_v.csv	Batch import: 70.csv (V)
2066	10	2026-04-08 13:11:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\72_v.csv	Batch import: 72.csv (V)
2070	10	2026-04-08 13:13:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\74_v.csv	Batch import: 74.csv (V)
2074	10	2026-04-08 13:15:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\76_v.csv	Batch import: 76.csv (V)
2078	10	2026-04-08 13:17:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\78_v.csv	Batch import: 78.csv (V)
2082	10	2026-04-08 13:19:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\80_v.csv	Batch import: 80.csv (V)
2086	10	2026-04-08 13:21:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\82_v.csv	Batch import: 82.csv (V)
2090	10	2026-04-08 13:23:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\84_v.csv	Batch import: 84.csv (V)
2094	10	2026-04-08 13:25:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\86_v.csv	Batch import: 86.csv (V)
2098	10	2026-04-08 13:27:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\88_v.csv	Batch import: 88.csv (V)
2102	10	2026-04-08 13:29:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\90_v.csv	Batch import: 90.csv (V)
2106	10	2026-04-08 13:31:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\92_v.csv	Batch import: 92.csv (V)
2110	10	2026-04-08 13:33:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\94_v.csv	Batch import: 94.csv (V)
2114	10	2026-04-08 13:35:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\96_v.csv	Batch import: 96.csv (V)
2035	9	2026-04-08 12:56:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\57_h.csv	Batch import: 57.csv (H)
2039	9	2026-04-08 12:58:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\59_h.csv	Batch import: 59.csv (H)
2043	9	2026-04-08 13:00:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\61_h.csv	Batch import: 61.csv (H)
2047	9	2026-04-08 13:02:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\63_h.csv	Batch import: 63.csv (H)
2051	9	2026-04-08 13:04:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\65_h.csv	Batch import: 65.csv (H)
2055	9	2026-04-08 13:06:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\67_h.csv	Batch import: 67.csv (H)
2059	9	2026-04-08 13:08:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\69_h.csv	Batch import: 69.csv (H)
2063	9	2026-04-08 13:10:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\71_h.csv	Batch import: 71.csv (H)
2067	9	2026-04-08 13:12:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\73_h.csv	Batch import: 73.csv (H)
2071	9	2026-04-08 13:14:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\75_h.csv	Batch import: 75.csv (H)
2075	9	2026-04-08 13:16:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\77_h.csv	Batch import: 77.csv (H)
2079	9	2026-04-08 13:18:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\79_h.csv	Batch import: 79.csv (H)
2083	9	2026-04-08 13:20:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\81_h.csv	Batch import: 81.csv (H)
2087	9	2026-04-08 13:22:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\83_h.csv	Batch import: 83.csv (H)
2091	9	2026-04-08 13:24:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\85_h.csv	Batch import: 85.csv (H)
2095	9	2026-04-08 13:26:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\87_h.csv	Batch import: 87.csv (H)
2099	9	2026-04-08 13:28:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\89_h.csv	Batch import: 89.csv (H)
2103	9	2026-04-08 13:30:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\91_h.csv	Batch import: 91.csv (H)
2107	9	2026-04-08 13:32:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\93_h.csv	Batch import: 93.csv (H)
2111	9	2026-04-08 13:34:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\95_h.csv	Batch import: 95.csv (H)
2115	9	2026-04-08 13:36:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\97_h.csv	Batch import: 97.csv (H)
2036	10	2026-04-08 12:56:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\57_v.csv	Batch import: 57.csv (V)
2040	10	2026-04-08 12:58:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\59_v.csv	Batch import: 59.csv (V)
2044	10	2026-04-08 13:00:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\61_v.csv	Batch import: 61.csv (V)
2048	10	2026-04-08 13:02:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\63_v.csv	Batch import: 63.csv (V)
2052	10	2026-04-08 13:04:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\65_v.csv	Batch import: 65.csv (V)
2056	10	2026-04-08 13:06:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\67_v.csv	Batch import: 67.csv (V)
2060	10	2026-04-08 13:08:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\69_v.csv	Batch import: 69.csv (V)
2064	10	2026-04-08 13:10:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\71_v.csv	Batch import: 71.csv (V)
2068	10	2026-04-08 13:12:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\73_v.csv	Batch import: 73.csv (V)
2072	10	2026-04-08 13:14:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\75_v.csv	Batch import: 75.csv (V)
2076	10	2026-04-08 13:16:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\77_v.csv	Batch import: 77.csv (V)
2080	10	2026-04-08 13:18:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\79_v.csv	Batch import: 79.csv (V)
2084	10	2026-04-08 13:20:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\81_v.csv	Batch import: 81.csv (V)
2088	10	2026-04-08 13:22:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\83_v.csv	Batch import: 83.csv (V)
2092	10	2026-04-08 13:24:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\85_v.csv	Batch import: 85.csv (V)
2096	10	2026-04-08 13:26:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\87_v.csv	Batch import: 87.csv (V)
2100	10	2026-04-08 13:28:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\89_v.csv	Batch import: 89.csv (V)
2104	10	2026-04-08 13:30:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\91_v.csv	Batch import: 91.csv (V)
2108	10	2026-04-08 13:32:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\93_v.csv	Batch import: 93.csv (V)
2112	10	2026-04-08 13:34:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\95_v.csv	Batch import: 95.csv (V)
2116	10	2026-04-08 13:36:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\97_v.csv	Batch import: 97.csv (V)
2037	9	2026-04-08 12:57:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\58_h.csv	Batch import: 58.csv (H)
2041	9	2026-04-08 12:59:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\60_h.csv	Batch import: 60.csv (H)
2045	9	2026-04-08 13:01:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\62_h.csv	Batch import: 62.csv (H)
2049	9	2026-04-08 13:03:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\64_h.csv	Batch import: 64.csv (H)
2053	9	2026-04-08 13:05:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\66_h.csv	Batch import: 66.csv (H)
2057	9	2026-04-08 13:07:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\68_h.csv	Batch import: 68.csv (H)
2061	9	2026-04-08 13:09:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\70_h.csv	Batch import: 70.csv (H)
2065	9	2026-04-08 13:11:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\72_h.csv	Batch import: 72.csv (H)
2069	9	2026-04-08 13:13:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\74_h.csv	Batch import: 74.csv (H)
2073	9	2026-04-08 13:15:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\76_h.csv	Batch import: 76.csv (H)
2077	9	2026-04-08 13:17:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\78_h.csv	Batch import: 78.csv (H)
2081	9	2026-04-08 13:19:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\80_h.csv	Batch import: 80.csv (H)
2085	9	2026-04-08 13:21:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\82_h.csv	Batch import: 82.csv (H)
2089	9	2026-04-08 13:23:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\84_h.csv	Batch import: 84.csv (H)
2093	9	2026-04-08 13:25:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\86_h.csv	Batch import: 86.csv (H)
2097	9	2026-04-08 13:27:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\88_h.csv	Batch import: 88.csv (H)
2101	9	2026-04-08 13:29:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\90_h.csv	Batch import: 90.csv (H)
2105	9	2026-04-08 13:31:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\92_h.csv	Batch import: 92.csv (H)
2109	9	2026-04-08 13:33:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\94_h.csv	Batch import: 94.csv (H)
2113	9	2026-04-08 13:35:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\96_h.csv	Batch import: 96.csv (H)
2117	9	2026-04-08 13:37:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\98_h.csv	Batch import: 98.csv (H)
2118	10	2026-04-08 13:37:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\98_v.csv	Batch import: 98.csv (V)
2119	9	2026-04-08 13:38:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\99_h.csv	Batch import: 99.csv (H)
2120	10	2026-04-08 13:38:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\99_v.csv	Batch import: 99.csv (V)
2121	9	2026-04-08 13:39:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\100_h.csv	Batch import: 100.csv (H)
2122	10	2026-04-08 13:39:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\100_v.csv	Batch import: 100.csv (V)
2123	9	2026-04-08 13:40:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\101_h.csv	Batch import: 101.csv (H)
2124	10	2026-04-08 13:40:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\101_v.csv	Batch import: 101.csv (V)
2125	9	2026-04-08 13:41:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\102_h.csv	Batch import: 102.csv (H)
2126	10	2026-04-08 13:41:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\102_v.csv	Batch import: 102.csv (V)
2127	9	2026-04-08 13:42:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\103_h.csv	Batch import: 103.csv (H)
2128	10	2026-04-08 13:42:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\103_v.csv	Batch import: 103.csv (V)
2129	9	2026-04-08 13:43:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\104_h.csv	Batch import: 104.csv (H)
2130	10	2026-04-08 13:43:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\104_v.csv	Batch import: 104.csv (V)
2131	9	2026-04-08 13:44:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\105_h.csv	Batch import: 105.csv (H)
2132	10	2026-04-08 13:44:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\105_v.csv	Batch import: 105.csv (V)
2133	9	2026-04-08 13:45:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\106_h.csv	Batch import: 106.csv (H)
2134	10	2026-04-08 13:45:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\106_v.csv	Batch import: 106.csv (V)
2135	9	2026-04-08 13:46:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\107_h.csv	Batch import: 107.csv (H)
2136	10	2026-04-08 13:46:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\107_v.csv	Batch import: 107.csv (V)
2137	9	2026-04-08 13:47:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\108_h.csv	Batch import: 108.csv (H)
2138	10	2026-04-08 13:47:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\108_v.csv	Batch import: 108.csv (V)
2139	9	2026-04-08 13:48:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\109_h.csv	Batch import: 109.csv (H)
2140	10	2026-04-08 13:48:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\109_v.csv	Batch import: 109.csv (V)
2141	9	2026-04-08 13:49:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\110_h.csv	Batch import: 110.csv (H)
2142	10	2026-04-08 13:49:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\110_v.csv	Batch import: 110.csv (V)
2146	10	2026-04-08 13:51:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\112_v.csv	Batch import: 112.csv (V)
2150	10	2026-04-08 13:53:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\114_v.csv	Batch import: 114.csv (V)
2154	10	2026-04-08 13:55:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\116_v.csv	Batch import: 116.csv (V)
2158	10	2026-04-08 13:57:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\118_v.csv	Batch import: 118.csv (V)
2162	10	2026-04-08 13:59:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\120_v.csv	Batch import: 120.csv (V)
2166	10	2026-04-08 14:01:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\122_v.csv	Batch import: 122.csv (V)
2170	10	2026-04-08 14:03:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\124_v.csv	Batch import: 124.csv (V)
2174	10	2026-04-08 14:05:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\126_v.csv	Batch import: 126.csv (V)
2178	10	2026-04-08 14:07:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\128_v.csv	Batch import: 128.csv (V)
2182	10	2026-04-08 14:09:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\130_v.csv	Batch import: 130.csv (V)
2186	10	2026-04-08 14:11:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\132_v.csv	Batch import: 132.csv (V)
2190	10	2026-04-08 14:13:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\134_v.csv	Batch import: 134.csv (V)
2194	10	2026-04-08 14:15:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\136_v.csv	Batch import: 136.csv (V)
2198	10	2026-04-08 14:17:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\138_v.csv	Batch import: 138.csv (V)
2202	10	2026-04-08 14:19:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\140_v.csv	Batch import: 140.csv (V)
2206	10	2026-04-08 14:21:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\142_v.csv	Batch import: 142.csv (V)
2210	10	2026-04-08 14:23:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\144_v.csv	Batch import: 144.csv (V)
2214	10	2026-04-08 14:25:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\146_v.csv	Batch import: 146.csv (V)
2218	10	2026-04-08 14:27:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\148_v.csv	Batch import: 148.csv (V)
2222	10	2026-04-08 14:29:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\150_v.csv	Batch import: 150.csv (V)
2226	10	2026-04-08 14:31:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\152_v.csv	Batch import: 152.csv (V)
2230	10	2026-04-08 14:33:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\154_v.csv	Batch import: 154.csv (V)
2234	10	2026-04-08 14:35:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\156_v.csv	Batch import: 156.csv (V)
2238	10	2026-04-08 14:37:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\158_v.csv	Batch import: 158.csv (V)
2143	9	2026-04-08 13:50:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\111_h.csv	Batch import: 111.csv (H)
2147	9	2026-04-08 13:52:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\113_h.csv	Batch import: 113.csv (H)
2151	9	2026-04-08 13:54:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\115_h.csv	Batch import: 115.csv (H)
2155	9	2026-04-08 13:56:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\117_h.csv	Batch import: 117.csv (H)
2159	9	2026-04-08 13:58:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\119_h.csv	Batch import: 119.csv (H)
2163	9	2026-04-08 14:00:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\121_h.csv	Batch import: 121.csv (H)
2167	9	2026-04-08 14:02:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\123_h.csv	Batch import: 123.csv (H)
2171	9	2026-04-08 14:04:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\125_h.csv	Batch import: 125.csv (H)
2175	9	2026-04-08 14:06:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\127_h.csv	Batch import: 127.csv (H)
2179	9	2026-04-08 14:08:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\129_h.csv	Batch import: 129.csv (H)
2183	9	2026-04-08 14:10:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\131_h.csv	Batch import: 131.csv (H)
2187	9	2026-04-08 14:12:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\133_h.csv	Batch import: 133.csv (H)
2191	9	2026-04-08 14:14:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\135_h.csv	Batch import: 135.csv (H)
2195	9	2026-04-08 14:16:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\137_h.csv	Batch import: 137.csv (H)
2199	9	2026-04-08 14:18:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\139_h.csv	Batch import: 139.csv (H)
2203	9	2026-04-08 14:20:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\141_h.csv	Batch import: 141.csv (H)
2207	9	2026-04-08 14:22:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\143_h.csv	Batch import: 143.csv (H)
2211	9	2026-04-08 14:24:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\145_h.csv	Batch import: 145.csv (H)
2215	9	2026-04-08 14:26:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\147_h.csv	Batch import: 147.csv (H)
2219	9	2026-04-08 14:28:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\149_h.csv	Batch import: 149.csv (H)
2223	9	2026-04-08 14:30:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\151_h.csv	Batch import: 151.csv (H)
2227	9	2026-04-08 14:32:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\153_h.csv	Batch import: 153.csv (H)
2231	9	2026-04-08 14:34:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\155_h.csv	Batch import: 155.csv (H)
2235	9	2026-04-08 14:36:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\157_h.csv	Batch import: 157.csv (H)
2144	10	2026-04-08 13:50:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\111_v.csv	Batch import: 111.csv (V)
2148	10	2026-04-08 13:52:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\113_v.csv	Batch import: 113.csv (V)
2152	10	2026-04-08 13:54:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\115_v.csv	Batch import: 115.csv (V)
2156	10	2026-04-08 13:56:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\117_v.csv	Batch import: 117.csv (V)
2160	10	2026-04-08 13:58:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\119_v.csv	Batch import: 119.csv (V)
2164	10	2026-04-08 14:00:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\121_v.csv	Batch import: 121.csv (V)
2168	10	2026-04-08 14:02:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\123_v.csv	Batch import: 123.csv (V)
2172	10	2026-04-08 14:04:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\125_v.csv	Batch import: 125.csv (V)
2176	10	2026-04-08 14:06:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\127_v.csv	Batch import: 127.csv (V)
2180	10	2026-04-08 14:08:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\129_v.csv	Batch import: 129.csv (V)
2184	10	2026-04-08 14:10:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\131_v.csv	Batch import: 131.csv (V)
2188	10	2026-04-08 14:12:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\133_v.csv	Batch import: 133.csv (V)
2192	10	2026-04-08 14:14:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\135_v.csv	Batch import: 135.csv (V)
2196	10	2026-04-08 14:16:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\137_v.csv	Batch import: 137.csv (V)
2200	10	2026-04-08 14:18:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\139_v.csv	Batch import: 139.csv (V)
2204	10	2026-04-08 14:20:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\141_v.csv	Batch import: 141.csv (V)
2208	10	2026-04-08 14:22:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\143_v.csv	Batch import: 143.csv (V)
2212	10	2026-04-08 14:24:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\145_v.csv	Batch import: 145.csv (V)
2216	10	2026-04-08 14:26:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\147_v.csv	Batch import: 147.csv (V)
2220	10	2026-04-08 14:28:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\149_v.csv	Batch import: 149.csv (V)
2224	10	2026-04-08 14:30:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\151_v.csv	Batch import: 151.csv (V)
2228	10	2026-04-08 14:32:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\153_v.csv	Batch import: 153.csv (V)
2232	10	2026-04-08 14:34:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\155_v.csv	Batch import: 155.csv (V)
2236	10	2026-04-08 14:36:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\157_v.csv	Batch import: 157.csv (V)
2145	9	2026-04-08 13:51:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\112_h.csv	Batch import: 112.csv (H)
2149	9	2026-04-08 13:53:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\114_h.csv	Batch import: 114.csv (H)
2153	9	2026-04-08 13:55:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\116_h.csv	Batch import: 116.csv (H)
2157	9	2026-04-08 13:57:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\118_h.csv	Batch import: 118.csv (H)
2161	9	2026-04-08 13:59:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\120_h.csv	Batch import: 120.csv (H)
2165	9	2026-04-08 14:01:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\122_h.csv	Batch import: 122.csv (H)
2169	9	2026-04-08 14:03:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\124_h.csv	Batch import: 124.csv (H)
2173	9	2026-04-08 14:05:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\126_h.csv	Batch import: 126.csv (H)
2177	9	2026-04-08 14:07:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\128_h.csv	Batch import: 128.csv (H)
2181	9	2026-04-08 14:09:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\130_h.csv	Batch import: 130.csv (H)
2185	9	2026-04-08 14:11:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\132_h.csv	Batch import: 132.csv (H)
2189	9	2026-04-08 14:13:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\134_h.csv	Batch import: 134.csv (H)
2193	9	2026-04-08 14:15:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\136_h.csv	Batch import: 136.csv (H)
2197	9	2026-04-08 14:17:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\138_h.csv	Batch import: 138.csv (H)
2201	9	2026-04-08 14:19:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\140_h.csv	Batch import: 140.csv (H)
2205	9	2026-04-08 14:21:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\142_h.csv	Batch import: 142.csv (H)
2209	9	2026-04-08 14:23:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\144_h.csv	Batch import: 144.csv (H)
2213	9	2026-04-08 14:25:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\146_h.csv	Batch import: 146.csv (H)
2217	9	2026-04-08 14:27:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\148_h.csv	Batch import: 148.csv (H)
2221	9	2026-04-08 14:29:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\150_h.csv	Batch import: 150.csv (H)
2225	9	2026-04-08 14:31:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\152_h.csv	Batch import: 152.csv (H)
2229	9	2026-04-08 14:33:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\154_h.csv	Batch import: 154.csv (H)
2233	9	2026-04-08 14:35:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\156_h.csv	Batch import: 156.csv (H)
2237	9	2026-04-08 14:37:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\158_h.csv	Batch import: 158.csv (H)
2239	9	2026-04-08 14:38:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\159_h.csv	Batch import: 159.csv (H)
2240	10	2026-04-08 14:38:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\159_v.csv	Batch import: 159.csv (V)
2241	9	2026-04-08 14:39:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\160_h.csv	Batch import: 160.csv (H)
2242	10	2026-04-08 14:39:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\160_v.csv	Batch import: 160.csv (V)
2243	9	2026-04-08 14:40:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\161_h.csv	Batch import: 161.csv (H)
2244	10	2026-04-08 14:40:08.4363+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_2\\161_v.csv	Batch import: 161.csv (V)
2245	9	2026-04-09 07:30:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\1_h.csv	Batch import: 1.csv (H)
2246	10	2026-04-09 07:30:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\1_v.csv	Batch import: 1.csv (V)
2247	9	2026-04-09 07:31:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\2_h.csv	Batch import: 2.csv (H)
2248	10	2026-04-09 07:31:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\2_v.csv	Batch import: 2.csv (V)
2249	9	2026-04-09 07:32:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\3_h.csv	Batch import: 3.csv (H)
2250	10	2026-04-09 07:32:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\3_v.csv	Batch import: 3.csv (V)
2251	9	2026-04-09 07:33:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\4_h.csv	Batch import: 4.csv (H)
2252	10	2026-04-09 07:33:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\4_v.csv	Batch import: 4.csv (V)
2253	9	2026-04-09 07:34:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\5_h.csv	Batch import: 5.csv (H)
2254	10	2026-04-09 07:34:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\5_v.csv	Batch import: 5.csv (V)
2255	9	2026-04-09 07:35:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\6_h.csv	Batch import: 6.csv (H)
2256	10	2026-04-09 07:35:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\6_v.csv	Batch import: 6.csv (V)
2257	9	2026-04-09 07:36:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\7_h.csv	Batch import: 7.csv (H)
2258	10	2026-04-09 07:36:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\7_v.csv	Batch import: 7.csv (V)
2259	9	2026-04-09 07:37:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\8_h.csv	Batch import: 8.csv (H)
2260	10	2026-04-09 07:37:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\8_v.csv	Batch import: 8.csv (V)
2261	9	2026-04-09 07:38:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\9_h.csv	Batch import: 9.csv (H)
2262	10	2026-04-09 07:38:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\9_v.csv	Batch import: 9.csv (V)
2263	9	2026-04-09 07:39:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\10_h.csv	Batch import: 10.csv (H)
2264	10	2026-04-09 07:39:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\10_v.csv	Batch import: 10.csv (V)
2265	9	2026-04-09 07:40:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\11_h.csv	Batch import: 11.csv (H)
2266	10	2026-04-09 07:40:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\11_v.csv	Batch import: 11.csv (V)
2267	9	2026-04-09 07:41:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\12_h.csv	Batch import: 12.csv (H)
2268	10	2026-04-09 07:41:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\12_v.csv	Batch import: 12.csv (V)
2269	9	2026-04-09 07:42:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\13_h.csv	Batch import: 13.csv (H)
2270	10	2026-04-09 07:42:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\13_v.csv	Batch import: 13.csv (V)
2271	9	2026-04-09 07:43:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\14_h.csv	Batch import: 14.csv (H)
2272	10	2026-04-09 07:43:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\14_v.csv	Batch import: 14.csv (V)
2273	9	2026-04-09 07:44:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\15_h.csv	Batch import: 15.csv (H)
2274	10	2026-04-09 07:44:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\15_v.csv	Batch import: 15.csv (V)
2275	9	2026-04-09 07:45:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\16_h.csv	Batch import: 16.csv (H)
2276	10	2026-04-09 07:45:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\16_v.csv	Batch import: 16.csv (V)
2277	9	2026-04-09 07:46:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\17_h.csv	Batch import: 17.csv (H)
2278	10	2026-04-09 07:46:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\17_v.csv	Batch import: 17.csv (V)
2279	9	2026-04-09 07:47:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\18_h.csv	Batch import: 18.csv (H)
2280	10	2026-04-09 07:47:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\18_v.csv	Batch import: 18.csv (V)
2281	9	2026-04-09 07:48:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\19_h.csv	Batch import: 19.csv (H)
2282	10	2026-04-09 07:48:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\19_v.csv	Batch import: 19.csv (V)
2283	9	2026-04-09 07:49:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\20_h.csv	Batch import: 20.csv (H)
2284	10	2026-04-09 07:49:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\20_v.csv	Batch import: 20.csv (V)
2285	9	2026-04-09 07:50:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\21_h.csv	Batch import: 21.csv (H)
2286	10	2026-04-09 07:50:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\21_v.csv	Batch import: 21.csv (V)
2287	9	2026-04-09 07:51:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\22_h.csv	Batch import: 22.csv (H)
2288	10	2026-04-09 07:51:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\22_v.csv	Batch import: 22.csv (V)
2289	9	2026-04-09 07:52:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\23_h.csv	Batch import: 23.csv (H)
2290	10	2026-04-09 07:52:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\23_v.csv	Batch import: 23.csv (V)
2291	9	2026-04-09 07:53:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\24_h.csv	Batch import: 24.csv (H)
2292	10	2026-04-09 07:53:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\24_v.csv	Batch import: 24.csv (V)
2293	9	2026-04-09 07:54:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\25_h.csv	Batch import: 25.csv (H)
2294	10	2026-04-09 07:54:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\25_v.csv	Batch import: 25.csv (V)
2295	9	2026-04-09 07:55:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\26_h.csv	Batch import: 26.csv (H)
2296	10	2026-04-09 07:55:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\26_v.csv	Batch import: 26.csv (V)
2297	9	2026-04-09 07:56:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\27_h.csv	Batch import: 27.csv (H)
2298	10	2026-04-09 07:56:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\27_v.csv	Batch import: 27.csv (V)
2299	9	2026-04-09 07:57:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\28_h.csv	Batch import: 28.csv (H)
2300	10	2026-04-09 07:57:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\28_v.csv	Batch import: 28.csv (V)
2301	9	2026-04-09 07:58:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\29_h.csv	Batch import: 29.csv (H)
2302	10	2026-04-09 07:58:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\29_v.csv	Batch import: 29.csv (V)
2303	9	2026-04-09 07:59:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\30_h.csv	Batch import: 30.csv (H)
2304	10	2026-04-09 07:59:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\30_v.csv	Batch import: 30.csv (V)
2305	9	2026-04-09 08:00:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\31_h.csv	Batch import: 31.csv (H)
2306	10	2026-04-09 08:00:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\31_v.csv	Batch import: 31.csv (V)
2307	9	2026-04-09 08:01:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\32_h.csv	Batch import: 32.csv (H)
2308	10	2026-04-09 08:01:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\32_v.csv	Batch import: 32.csv (V)
2309	9	2026-04-09 08:02:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\33_h.csv	Batch import: 33.csv (H)
2310	10	2026-04-09 08:02:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\33_v.csv	Batch import: 33.csv (V)
2311	9	2026-04-09 08:03:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\34_h.csv	Batch import: 34.csv (H)
2312	10	2026-04-09 08:03:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\34_v.csv	Batch import: 34.csv (V)
2313	9	2026-04-09 08:04:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\35_h.csv	Batch import: 35.csv (H)
2314	10	2026-04-09 08:04:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\35_v.csv	Batch import: 35.csv (V)
2315	9	2026-04-09 08:05:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\36_h.csv	Batch import: 36.csv (H)
2316	10	2026-04-09 08:05:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\36_v.csv	Batch import: 36.csv (V)
2317	9	2026-04-09 08:06:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\37_h.csv	Batch import: 37.csv (H)
2318	10	2026-04-09 08:06:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\37_v.csv	Batch import: 37.csv (V)
2319	9	2026-04-09 08:07:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\38_h.csv	Batch import: 38.csv (H)
2320	10	2026-04-09 08:07:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\38_v.csv	Batch import: 38.csv (V)
2321	9	2026-04-09 08:08:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\39_h.csv	Batch import: 39.csv (H)
2322	10	2026-04-09 08:08:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\39_v.csv	Batch import: 39.csv (V)
2323	9	2026-04-09 08:09:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\40_h.csv	Batch import: 40.csv (H)
2324	10	2026-04-09 08:09:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\40_v.csv	Batch import: 40.csv (V)
2325	9	2026-04-09 08:10:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\41_h.csv	Batch import: 41.csv (H)
2326	10	2026-04-09 08:10:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\41_v.csv	Batch import: 41.csv (V)
2327	9	2026-04-09 08:11:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\42_h.csv	Batch import: 42.csv (H)
2328	10	2026-04-09 08:11:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\42_v.csv	Batch import: 42.csv (V)
2329	9	2026-04-09 08:12:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\43_h.csv	Batch import: 43.csv (H)
2330	10	2026-04-09 08:12:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\43_v.csv	Batch import: 43.csv (V)
2331	9	2026-04-09 08:13:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\44_h.csv	Batch import: 44.csv (H)
2332	10	2026-04-09 08:13:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\44_v.csv	Batch import: 44.csv (V)
2333	9	2026-04-09 08:14:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\45_h.csv	Batch import: 45.csv (H)
2334	10	2026-04-09 08:14:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\45_v.csv	Batch import: 45.csv (V)
2335	9	2026-04-09 08:15:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\46_h.csv	Batch import: 46.csv (H)
2336	10	2026-04-09 08:15:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\46_v.csv	Batch import: 46.csv (V)
2337	9	2026-04-09 08:16:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\47_h.csv	Batch import: 47.csv (H)
2338	10	2026-04-09 08:16:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\47_v.csv	Batch import: 47.csv (V)
2339	9	2026-04-09 08:17:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\48_h.csv	Batch import: 48.csv (H)
2340	10	2026-04-09 08:17:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\48_v.csv	Batch import: 48.csv (V)
2341	9	2026-04-09 08:18:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\49_h.csv	Batch import: 49.csv (H)
2342	10	2026-04-09 08:18:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\49_v.csv	Batch import: 49.csv (V)
2343	9	2026-04-09 08:19:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\50_h.csv	Batch import: 50.csv (H)
2344	10	2026-04-09 08:19:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\50_v.csv	Batch import: 50.csv (V)
2345	9	2026-04-09 08:20:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\51_h.csv	Batch import: 51.csv (H)
2346	10	2026-04-09 08:20:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\51_v.csv	Batch import: 51.csv (V)
2347	9	2026-04-09 08:21:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\52_h.csv	Batch import: 52.csv (H)
2348	10	2026-04-09 08:21:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\52_v.csv	Batch import: 52.csv (V)
2349	9	2026-04-09 08:22:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\53_h.csv	Batch import: 53.csv (H)
2350	10	2026-04-09 08:22:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\53_v.csv	Batch import: 53.csv (V)
2351	9	2026-04-09 08:23:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\54_h.csv	Batch import: 54.csv (H)
2352	10	2026-04-09 08:23:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\54_v.csv	Batch import: 54.csv (V)
2353	9	2026-04-09 08:24:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\55_h.csv	Batch import: 55.csv (H)
2354	10	2026-04-09 08:24:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\55_v.csv	Batch import: 55.csv (V)
2355	9	2026-04-09 08:25:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\56_h.csv	Batch import: 56.csv (H)
2356	10	2026-04-09 08:25:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\56_v.csv	Batch import: 56.csv (V)
2357	9	2026-04-09 08:26:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\57_h.csv	Batch import: 57.csv (H)
2358	10	2026-04-09 08:26:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\57_v.csv	Batch import: 57.csv (V)
2359	9	2026-04-09 08:27:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\58_h.csv	Batch import: 58.csv (H)
2360	10	2026-04-09 08:27:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\58_v.csv	Batch import: 58.csv (V)
2361	9	2026-04-09 08:28:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\59_h.csv	Batch import: 59.csv (H)
2362	10	2026-04-09 08:28:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\59_v.csv	Batch import: 59.csv (V)
2363	9	2026-04-09 08:29:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\60_h.csv	Batch import: 60.csv (H)
2364	10	2026-04-09 08:29:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\60_v.csv	Batch import: 60.csv (V)
2365	9	2026-04-09 08:30:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\61_h.csv	Batch import: 61.csv (H)
2366	10	2026-04-09 08:30:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\61_v.csv	Batch import: 61.csv (V)
2367	9	2026-04-09 08:31:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\62_h.csv	Batch import: 62.csv (H)
2368	10	2026-04-09 08:31:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\62_v.csv	Batch import: 62.csv (V)
2369	9	2026-04-09 08:32:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\63_h.csv	Batch import: 63.csv (H)
2370	10	2026-04-09 08:32:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\63_v.csv	Batch import: 63.csv (V)
2371	9	2026-04-09 08:33:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\64_h.csv	Batch import: 64.csv (H)
2372	10	2026-04-09 08:33:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\64_v.csv	Batch import: 64.csv (V)
2373	9	2026-04-09 08:34:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\65_h.csv	Batch import: 65.csv (H)
2374	10	2026-04-09 08:34:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\65_v.csv	Batch import: 65.csv (V)
2375	9	2026-04-09 08:35:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\66_h.csv	Batch import: 66.csv (H)
2376	10	2026-04-09 08:35:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\66_v.csv	Batch import: 66.csv (V)
2377	9	2026-04-09 08:36:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\67_h.csv	Batch import: 67.csv (H)
2378	10	2026-04-09 08:36:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\67_v.csv	Batch import: 67.csv (V)
2379	9	2026-04-09 08:37:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\68_h.csv	Batch import: 68.csv (H)
2380	10	2026-04-09 08:37:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\68_v.csv	Batch import: 68.csv (V)
2381	9	2026-04-09 08:38:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\69_h.csv	Batch import: 69.csv (H)
2382	10	2026-04-09 08:38:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\69_v.csv	Batch import: 69.csv (V)
2383	9	2026-04-09 08:39:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\70_h.csv	Batch import: 70.csv (H)
2384	10	2026-04-09 08:39:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\70_v.csv	Batch import: 70.csv (V)
2385	9	2026-04-09 08:40:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\71_h.csv	Batch import: 71.csv (H)
2386	10	2026-04-09 08:40:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\71_v.csv	Batch import: 71.csv (V)
2387	9	2026-04-09 08:41:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\72_h.csv	Batch import: 72.csv (H)
2388	10	2026-04-09 08:41:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\72_v.csv	Batch import: 72.csv (V)
2389	9	2026-04-09 08:42:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\73_h.csv	Batch import: 73.csv (H)
2390	10	2026-04-09 08:42:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\73_v.csv	Batch import: 73.csv (V)
2391	9	2026-04-09 08:43:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\74_h.csv	Batch import: 74.csv (H)
2392	10	2026-04-09 08:43:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\74_v.csv	Batch import: 74.csv (V)
2393	9	2026-04-09 08:44:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\75_h.csv	Batch import: 75.csv (H)
2394	10	2026-04-09 08:44:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\75_v.csv	Batch import: 75.csv (V)
2395	9	2026-04-09 08:45:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\76_h.csv	Batch import: 76.csv (H)
2396	10	2026-04-09 08:45:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\76_v.csv	Batch import: 76.csv (V)
2400	10	2026-04-09 08:47:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\78_v.csv	Batch import: 78.csv (V)
2404	10	2026-04-09 08:49:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\80_v.csv	Batch import: 80.csv (V)
2408	10	2026-04-09 08:51:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\82_v.csv	Batch import: 82.csv (V)
2412	10	2026-04-09 08:53:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\84_v.csv	Batch import: 84.csv (V)
2416	10	2026-04-09 08:55:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\86_v.csv	Batch import: 86.csv (V)
2420	10	2026-04-09 08:57:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\88_v.csv	Batch import: 88.csv (V)
2397	9	2026-04-09 08:46:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\77_h.csv	Batch import: 77.csv (H)
2401	9	2026-04-09 08:48:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\79_h.csv	Batch import: 79.csv (H)
2405	9	2026-04-09 08:50:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\81_h.csv	Batch import: 81.csv (H)
2409	9	2026-04-09 08:52:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\83_h.csv	Batch import: 83.csv (H)
2413	9	2026-04-09 08:54:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\85_h.csv	Batch import: 85.csv (H)
2417	9	2026-04-09 08:56:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\87_h.csv	Batch import: 87.csv (H)
2398	10	2026-04-09 08:46:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\77_v.csv	Batch import: 77.csv (V)
2402	10	2026-04-09 08:48:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\79_v.csv	Batch import: 79.csv (V)
2406	10	2026-04-09 08:50:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\81_v.csv	Batch import: 81.csv (V)
2410	10	2026-04-09 08:52:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\83_v.csv	Batch import: 83.csv (V)
2414	10	2026-04-09 08:54:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\85_v.csv	Batch import: 85.csv (V)
2418	10	2026-04-09 08:56:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\87_v.csv	Batch import: 87.csv (V)
2399	9	2026-04-09 08:47:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\78_h.csv	Batch import: 78.csv (H)
2403	9	2026-04-09 08:49:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\80_h.csv	Batch import: 80.csv (H)
2407	9	2026-04-09 08:51:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\82_h.csv	Batch import: 82.csv (H)
2411	9	2026-04-09 08:53:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\84_h.csv	Batch import: 84.csv (H)
2415	9	2026-04-09 08:55:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\86_h.csv	Batch import: 86.csv (H)
2419	9	2026-04-09 08:57:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\88_h.csv	Batch import: 88.csv (H)
2421	9	2026-04-09 08:58:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\89_h.csv	Batch import: 89.csv (H)
2422	10	2026-04-09 08:58:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\89_v.csv	Batch import: 89.csv (V)
2423	9	2026-04-09 08:59:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\90_h.csv	Batch import: 90.csv (H)
2424	10	2026-04-09 08:59:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\90_v.csv	Batch import: 90.csv (V)
2425	9	2026-04-09 09:00:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\91_h.csv	Batch import: 91.csv (H)
2426	10	2026-04-09 09:00:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\91_v.csv	Batch import: 91.csv (V)
2427	9	2026-04-09 09:01:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\92_h.csv	Batch import: 92.csv (H)
2428	10	2026-04-09 09:01:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\92_v.csv	Batch import: 92.csv (V)
2429	9	2026-04-09 09:02:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\93_h.csv	Batch import: 93.csv (H)
2430	10	2026-04-09 09:02:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\93_v.csv	Batch import: 93.csv (V)
2431	9	2026-04-09 09:03:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\94_h.csv	Batch import: 94.csv (H)
2432	10	2026-04-09 09:03:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\94_v.csv	Batch import: 94.csv (V)
2433	9	2026-04-09 09:04:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\95_h.csv	Batch import: 95.csv (H)
2434	10	2026-04-09 09:04:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\95_v.csv	Batch import: 95.csv (V)
2435	9	2026-04-09 09:05:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\96_h.csv	Batch import: 96.csv (H)
2436	10	2026-04-09 09:05:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\96_v.csv	Batch import: 96.csv (V)
2437	9	2026-04-09 09:06:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\97_h.csv	Batch import: 97.csv (H)
2438	10	2026-04-09 09:06:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\97_v.csv	Batch import: 97.csv (V)
2439	9	2026-04-09 09:07:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\98_h.csv	Batch import: 98.csv (H)
2440	10	2026-04-09 09:07:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\98_v.csv	Batch import: 98.csv (V)
2441	9	2026-04-09 09:08:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\99_h.csv	Batch import: 99.csv (H)
2442	10	2026-04-09 09:08:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\99_v.csv	Batch import: 99.csv (V)
2443	9	2026-04-09 09:09:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\100_h.csv	Batch import: 100.csv (H)
2444	10	2026-04-09 09:09:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\100_v.csv	Batch import: 100.csv (V)
2445	9	2026-04-09 09:10:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\101_h.csv	Batch import: 101.csv (H)
2446	10	2026-04-09 09:10:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\101_v.csv	Batch import: 101.csv (V)
2447	9	2026-04-09 09:11:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\102_h.csv	Batch import: 102.csv (H)
2448	10	2026-04-09 09:11:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\102_v.csv	Batch import: 102.csv (V)
2449	9	2026-04-09 09:12:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\103_h.csv	Batch import: 103.csv (H)
2450	10	2026-04-09 09:12:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\103_v.csv	Batch import: 103.csv (V)
2451	9	2026-04-09 09:13:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\104_h.csv	Batch import: 104.csv (H)
2452	10	2026-04-09 09:13:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\104_v.csv	Batch import: 104.csv (V)
2453	9	2026-04-09 09:14:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\105_h.csv	Batch import: 105.csv (H)
2454	10	2026-04-09 09:14:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\105_v.csv	Batch import: 105.csv (V)
2455	9	2026-04-09 09:15:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\106_h.csv	Batch import: 106.csv (H)
2456	10	2026-04-09 09:15:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\106_v.csv	Batch import: 106.csv (V)
2457	9	2026-04-09 09:16:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\107_h.csv	Batch import: 107.csv (H)
2458	10	2026-04-09 09:16:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\107_v.csv	Batch import: 107.csv (V)
2459	9	2026-04-09 09:17:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\108_h.csv	Batch import: 108.csv (H)
2460	10	2026-04-09 09:17:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\108_v.csv	Batch import: 108.csv (V)
2464	10	2026-04-09 09:19:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\110_v.csv	Batch import: 110.csv (V)
2468	10	2026-04-09 09:21:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\112_v.csv	Batch import: 112.csv (V)
2472	10	2026-04-09 09:23:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\114_v.csv	Batch import: 114.csv (V)
2476	10	2026-04-09 09:25:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\116_v.csv	Batch import: 116.csv (V)
2480	10	2026-04-09 09:27:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\118_v.csv	Batch import: 118.csv (V)
2484	10	2026-04-09 09:29:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\120_v.csv	Batch import: 120.csv (V)
2488	10	2026-04-09 09:31:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\122_v.csv	Batch import: 122.csv (V)
2491	6	2026-04-09 07:32:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\1_h.csv	Batch import: 1.csv (H)
2495	6	2026-04-09 07:34:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\3_h.csv	Batch import: 3.csv (H)
2499	6	2026-04-09 07:36:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\5_h.csv	Batch import: 5.csv (H)
2503	6	2026-04-09 07:38:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\7_h.csv	Batch import: 7.csv (H)
2507	6	2026-04-09 07:40:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\9_h.csv	Batch import: 9.csv (H)
2511	6	2026-04-09 07:42:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\11_h.csv	Batch import: 11.csv (H)
2515	6	2026-04-09 07:44:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\13_h.csv	Batch import: 13.csv (H)
2519	6	2026-04-09 07:46:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\15_h.csv	Batch import: 15.csv (H)
2523	6	2026-04-09 07:48:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\17_h.csv	Batch import: 17.csv (H)
2527	6	2026-04-09 07:50:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\19_h.csv	Batch import: 19.csv (H)
2531	6	2026-04-09 07:52:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\21_h.csv	Batch import: 21.csv (H)
2535	6	2026-04-09 07:54:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\23_h.csv	Batch import: 23.csv (H)
2539	6	2026-04-09 07:56:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\25_h.csv	Batch import: 25.csv (H)
2543	6	2026-04-09 07:58:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\27_h.csv	Batch import: 27.csv (H)
2547	6	2026-04-09 08:00:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\29_h.csv	Batch import: 29.csv (H)
2551	6	2026-04-09 08:02:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\31_h.csv	Batch import: 31.csv (H)
2555	6	2026-04-09 08:04:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\33_h.csv	Batch import: 33.csv (H)
2559	6	2026-04-09 08:06:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\35_h.csv	Batch import: 35.csv (H)
2563	6	2026-04-09 08:08:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\37_h.csv	Batch import: 37.csv (H)
2567	6	2026-04-09 08:10:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\39_h.csv	Batch import: 39.csv (H)
2571	6	2026-04-09 08:12:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\41_h.csv	Batch import: 41.csv (H)
2575	6	2026-04-09 08:14:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\43_h.csv	Batch import: 43.csv (H)
2579	6	2026-04-09 08:16:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\45_h.csv	Batch import: 45.csv (H)
2583	6	2026-04-09 08:18:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\47_h.csv	Batch import: 47.csv (H)
2587	6	2026-04-09 08:20:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\49_h.csv	Batch import: 49.csv (H)
2591	6	2026-04-09 08:22:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\51_h.csv	Batch import: 51.csv (H)
2595	6	2026-04-09 08:24:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\53_h.csv	Batch import: 53.csv (H)
2599	6	2026-04-09 08:26:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\55_h.csv	Batch import: 55.csv (H)
2603	6	2026-04-09 08:28:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\57_h.csv	Batch import: 57.csv (H)
2607	6	2026-04-09 08:30:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\59_h.csv	Batch import: 59.csv (H)
2611	6	2026-04-09 08:32:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\61_h.csv	Batch import: 61.csv (H)
2615	6	2026-04-09 08:34:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\63_h.csv	Batch import: 63.csv (H)
2619	6	2026-04-09 08:36:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\65_h.csv	Batch import: 65.csv (H)
2623	6	2026-04-09 08:38:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\67_h.csv	Batch import: 67.csv (H)
2627	6	2026-04-09 08:40:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\69_h.csv	Batch import: 69.csv (H)
2631	6	2026-04-09 08:42:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\71_h.csv	Batch import: 71.csv (H)
2635	6	2026-04-09 08:44:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\73_h.csv	Batch import: 73.csv (H)
2461	9	2026-04-09 09:18:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\109_h.csv	Batch import: 109.csv (H)
2465	9	2026-04-09 09:20:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\111_h.csv	Batch import: 111.csv (H)
2469	9	2026-04-09 09:22:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\113_h.csv	Batch import: 113.csv (H)
2473	9	2026-04-09 09:24:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\115_h.csv	Batch import: 115.csv (H)
2477	9	2026-04-09 09:26:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\117_h.csv	Batch import: 117.csv (H)
2481	9	2026-04-09 09:28:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\119_h.csv	Batch import: 119.csv (H)
2485	9	2026-04-09 09:30:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\121_h.csv	Batch import: 121.csv (H)
2489	9	2026-04-09 09:32:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\123_h.csv	Batch import: 123.csv (H)
2494	7	2026-04-09 07:33:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\2_v.csv	Batch import: 2.csv (V)
2498	7	2026-04-09 07:35:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\4_v.csv	Batch import: 4.csv (V)
2502	7	2026-04-09 07:37:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\6_v.csv	Batch import: 6.csv (V)
2506	7	2026-04-09 07:39:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\8_v.csv	Batch import: 8.csv (V)
2510	7	2026-04-09 07:41:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\10_v.csv	Batch import: 10.csv (V)
2514	7	2026-04-09 07:43:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\12_v.csv	Batch import: 12.csv (V)
2518	7	2026-04-09 07:45:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\14_v.csv	Batch import: 14.csv (V)
2522	7	2026-04-09 07:47:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\16_v.csv	Batch import: 16.csv (V)
2526	7	2026-04-09 07:49:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\18_v.csv	Batch import: 18.csv (V)
2530	7	2026-04-09 07:51:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\20_v.csv	Batch import: 20.csv (V)
2534	7	2026-04-09 07:53:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\22_v.csv	Batch import: 22.csv (V)
2538	7	2026-04-09 07:55:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\24_v.csv	Batch import: 24.csv (V)
2542	7	2026-04-09 07:57:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\26_v.csv	Batch import: 26.csv (V)
2546	7	2026-04-09 07:59:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\28_v.csv	Batch import: 28.csv (V)
2550	7	2026-04-09 08:01:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\30_v.csv	Batch import: 30.csv (V)
2554	7	2026-04-09 08:03:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\32_v.csv	Batch import: 32.csv (V)
2558	7	2026-04-09 08:05:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\34_v.csv	Batch import: 34.csv (V)
2562	7	2026-04-09 08:07:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\36_v.csv	Batch import: 36.csv (V)
2566	7	2026-04-09 08:09:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\38_v.csv	Batch import: 38.csv (V)
2570	7	2026-04-09 08:11:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\40_v.csv	Batch import: 40.csv (V)
2574	7	2026-04-09 08:13:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\42_v.csv	Batch import: 42.csv (V)
2578	7	2026-04-09 08:15:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\44_v.csv	Batch import: 44.csv (V)
2582	7	2026-04-09 08:17:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\46_v.csv	Batch import: 46.csv (V)
2586	7	2026-04-09 08:19:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\48_v.csv	Batch import: 48.csv (V)
2590	7	2026-04-09 08:21:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\50_v.csv	Batch import: 50.csv (V)
2594	7	2026-04-09 08:23:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\52_v.csv	Batch import: 52.csv (V)
2598	7	2026-04-09 08:25:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\54_v.csv	Batch import: 54.csv (V)
2602	7	2026-04-09 08:27:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\56_v.csv	Batch import: 56.csv (V)
2606	7	2026-04-09 08:29:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\58_v.csv	Batch import: 58.csv (V)
2610	7	2026-04-09 08:31:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\60_v.csv	Batch import: 60.csv (V)
2614	7	2026-04-09 08:33:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\62_v.csv	Batch import: 62.csv (V)
2618	7	2026-04-09 08:35:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\64_v.csv	Batch import: 64.csv (V)
2622	7	2026-04-09 08:37:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\66_v.csv	Batch import: 66.csv (V)
2626	7	2026-04-09 08:39:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\68_v.csv	Batch import: 68.csv (V)
2630	7	2026-04-09 08:41:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\70_v.csv	Batch import: 70.csv (V)
2634	7	2026-04-09 08:43:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\72_v.csv	Batch import: 72.csv (V)
2638	7	2026-04-09 08:45:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\74_v.csv	Batch import: 74.csv (V)
2462	10	2026-04-09 09:18:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\109_v.csv	Batch import: 109.csv (V)
2466	10	2026-04-09 09:20:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\111_v.csv	Batch import: 111.csv (V)
2470	10	2026-04-09 09:22:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\113_v.csv	Batch import: 113.csv (V)
2474	10	2026-04-09 09:24:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\115_v.csv	Batch import: 115.csv (V)
2478	10	2026-04-09 09:26:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\117_v.csv	Batch import: 117.csv (V)
2482	10	2026-04-09 09:28:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\119_v.csv	Batch import: 119.csv (V)
2486	10	2026-04-09 09:30:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\121_v.csv	Batch import: 121.csv (V)
2490	10	2026-04-09 09:32:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\123_v.csv	Batch import: 123.csv (V)
2493	6	2026-04-09 07:33:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\2_h.csv	Batch import: 2.csv (H)
2497	6	2026-04-09 07:35:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\4_h.csv	Batch import: 4.csv (H)
2501	6	2026-04-09 07:37:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\6_h.csv	Batch import: 6.csv (H)
2505	6	2026-04-09 07:39:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\8_h.csv	Batch import: 8.csv (H)
2509	6	2026-04-09 07:41:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\10_h.csv	Batch import: 10.csv (H)
2513	6	2026-04-09 07:43:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\12_h.csv	Batch import: 12.csv (H)
2517	6	2026-04-09 07:45:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\14_h.csv	Batch import: 14.csv (H)
2521	6	2026-04-09 07:47:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\16_h.csv	Batch import: 16.csv (H)
2525	6	2026-04-09 07:49:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\18_h.csv	Batch import: 18.csv (H)
2529	6	2026-04-09 07:51:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\20_h.csv	Batch import: 20.csv (H)
2533	6	2026-04-09 07:53:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\22_h.csv	Batch import: 22.csv (H)
2537	6	2026-04-09 07:55:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\24_h.csv	Batch import: 24.csv (H)
2541	6	2026-04-09 07:57:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\26_h.csv	Batch import: 26.csv (H)
2545	6	2026-04-09 07:59:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\28_h.csv	Batch import: 28.csv (H)
2549	6	2026-04-09 08:01:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\30_h.csv	Batch import: 30.csv (H)
2553	6	2026-04-09 08:03:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\32_h.csv	Batch import: 32.csv (H)
2557	6	2026-04-09 08:05:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\34_h.csv	Batch import: 34.csv (H)
2561	6	2026-04-09 08:07:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\36_h.csv	Batch import: 36.csv (H)
2565	6	2026-04-09 08:09:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\38_h.csv	Batch import: 38.csv (H)
2569	6	2026-04-09 08:11:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\40_h.csv	Batch import: 40.csv (H)
2573	6	2026-04-09 08:13:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\42_h.csv	Batch import: 42.csv (H)
2577	6	2026-04-09 08:15:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\44_h.csv	Batch import: 44.csv (H)
2581	6	2026-04-09 08:17:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\46_h.csv	Batch import: 46.csv (H)
2585	6	2026-04-09 08:19:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\48_h.csv	Batch import: 48.csv (H)
2589	6	2026-04-09 08:21:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\50_h.csv	Batch import: 50.csv (H)
2593	6	2026-04-09 08:23:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\52_h.csv	Batch import: 52.csv (H)
2597	6	2026-04-09 08:25:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\54_h.csv	Batch import: 54.csv (H)
2601	6	2026-04-09 08:27:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\56_h.csv	Batch import: 56.csv (H)
2605	6	2026-04-09 08:29:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\58_h.csv	Batch import: 58.csv (H)
2609	6	2026-04-09 08:31:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\60_h.csv	Batch import: 60.csv (H)
2613	6	2026-04-09 08:33:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\62_h.csv	Batch import: 62.csv (H)
2617	6	2026-04-09 08:35:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\64_h.csv	Batch import: 64.csv (H)
2621	6	2026-04-09 08:37:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\66_h.csv	Batch import: 66.csv (H)
2625	6	2026-04-09 08:39:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\68_h.csv	Batch import: 68.csv (H)
2629	6	2026-04-09 08:41:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\70_h.csv	Batch import: 70.csv (H)
2633	6	2026-04-09 08:43:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\72_h.csv	Batch import: 72.csv (H)
2637	6	2026-04-09 08:45:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\74_h.csv	Batch import: 74.csv (H)
2463	9	2026-04-09 09:19:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\110_h.csv	Batch import: 110.csv (H)
2467	9	2026-04-09 09:21:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\112_h.csv	Batch import: 112.csv (H)
2471	9	2026-04-09 09:23:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\114_h.csv	Batch import: 114.csv (H)
2475	9	2026-04-09 09:25:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\116_h.csv	Batch import: 116.csv (H)
2479	9	2026-04-09 09:27:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\118_h.csv	Batch import: 118.csv (H)
2483	9	2026-04-09 09:29:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\120_h.csv	Batch import: 120.csv (H)
2487	9	2026-04-09 09:31:52.826201+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\122_h.csv	Batch import: 122.csv (H)
2492	7	2026-04-09 07:32:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\1_v.csv	Batch import: 1.csv (V)
2496	7	2026-04-09 07:34:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\3_v.csv	Batch import: 3.csv (V)
2500	7	2026-04-09 07:36:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\5_v.csv	Batch import: 5.csv (V)
2504	7	2026-04-09 07:38:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\7_v.csv	Batch import: 7.csv (V)
2508	7	2026-04-09 07:40:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\9_v.csv	Batch import: 9.csv (V)
2512	7	2026-04-09 07:42:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\11_v.csv	Batch import: 11.csv (V)
2516	7	2026-04-09 07:44:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\13_v.csv	Batch import: 13.csv (V)
2520	7	2026-04-09 07:46:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\15_v.csv	Batch import: 15.csv (V)
2524	7	2026-04-09 07:48:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\17_v.csv	Batch import: 17.csv (V)
2528	7	2026-04-09 07:50:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\19_v.csv	Batch import: 19.csv (V)
2532	7	2026-04-09 07:52:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\21_v.csv	Batch import: 21.csv (V)
2536	7	2026-04-09 07:54:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\23_v.csv	Batch import: 23.csv (V)
2540	7	2026-04-09 07:56:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\25_v.csv	Batch import: 25.csv (V)
2544	7	2026-04-09 07:58:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\27_v.csv	Batch import: 27.csv (V)
2548	7	2026-04-09 08:00:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\29_v.csv	Batch import: 29.csv (V)
2552	7	2026-04-09 08:02:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\31_v.csv	Batch import: 31.csv (V)
2556	7	2026-04-09 08:04:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\33_v.csv	Batch import: 33.csv (V)
2560	7	2026-04-09 08:06:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\35_v.csv	Batch import: 35.csv (V)
2564	7	2026-04-09 08:08:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\37_v.csv	Batch import: 37.csv (V)
2568	7	2026-04-09 08:10:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\39_v.csv	Batch import: 39.csv (V)
2572	7	2026-04-09 08:12:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\41_v.csv	Batch import: 41.csv (V)
2576	7	2026-04-09 08:14:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\43_v.csv	Batch import: 43.csv (V)
2580	7	2026-04-09 08:16:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\45_v.csv	Batch import: 45.csv (V)
2584	7	2026-04-09 08:18:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\47_v.csv	Batch import: 47.csv (V)
2588	7	2026-04-09 08:20:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\49_v.csv	Batch import: 49.csv (V)
2592	7	2026-04-09 08:22:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\51_v.csv	Batch import: 51.csv (V)
2596	7	2026-04-09 08:24:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\53_v.csv	Batch import: 53.csv (V)
2600	7	2026-04-09 08:26:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\55_v.csv	Batch import: 55.csv (V)
2604	7	2026-04-09 08:28:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\57_v.csv	Batch import: 57.csv (V)
2608	7	2026-04-09 08:30:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\59_v.csv	Batch import: 59.csv (V)
2612	7	2026-04-09 08:32:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\61_v.csv	Batch import: 61.csv (V)
2616	7	2026-04-09 08:34:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\63_v.csv	Batch import: 63.csv (V)
2620	7	2026-04-09 08:36:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\65_v.csv	Batch import: 65.csv (V)
2624	7	2026-04-09 08:38:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\67_v.csv	Batch import: 67.csv (V)
2628	7	2026-04-09 08:40:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\69_v.csv	Batch import: 69.csv (V)
2632	7	2026-04-09 08:42:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\71_v.csv	Batch import: 71.csv (V)
2636	7	2026-04-09 08:44:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\73_v.csv	Batch import: 73.csv (V)
2640	7	2026-04-09 08:46:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\75_v.csv	Batch import: 75.csv (V)
2639	6	2026-04-09 08:46:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\75_h.csv	Batch import: 75.csv (H)
2643	6	2026-04-09 08:48:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\77_h.csv	Batch import: 77.csv (H)
2647	6	2026-04-09 08:50:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\79_h.csv	Batch import: 79.csv (H)
2651	6	2026-04-09 08:52:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\81_h.csv	Batch import: 81.csv (H)
2655	6	2026-04-09 08:54:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\83_h.csv	Batch import: 83.csv (H)
2659	6	2026-04-09 08:56:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\85_h.csv	Batch import: 85.csv (H)
2663	6	2026-04-09 08:58:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\87_h.csv	Batch import: 87.csv (H)
2667	6	2026-04-09 09:00:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\89_h.csv	Batch import: 89.csv (H)
2671	6	2026-04-09 09:02:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\91_h.csv	Batch import: 91.csv (H)
2675	6	2026-04-09 09:04:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\93_h.csv	Batch import: 93.csv (H)
2679	6	2026-04-09 09:06:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\95_h.csv	Batch import: 95.csv (H)
2683	6	2026-04-09 09:08:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\97_h.csv	Batch import: 97.csv (H)
2687	6	2026-04-09 09:10:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\99_h.csv	Batch import: 99.csv (H)
2691	6	2026-04-09 09:12:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\101_h.csv	Batch import: 101.csv (H)
2695	6	2026-04-09 09:14:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\103_h.csv	Batch import: 103.csv (H)
2699	6	2026-04-09 09:16:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\105_h.csv	Batch import: 105.csv (H)
2703	6	2026-04-09 09:18:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\107_h.csv	Batch import: 107.csv (H)
2707	6	2026-04-09 09:20:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\109_h.csv	Batch import: 109.csv (H)
2711	6	2026-04-09 09:22:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\111_h.csv	Batch import: 111.csv (H)
2715	6	2026-04-09 09:24:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\113_h.csv	Batch import: 113.csv (H)
2719	6	2026-04-09 09:26:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\115_h.csv	Batch import: 115.csv (H)
2723	6	2026-04-09 09:28:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\117_h.csv	Batch import: 117.csv (H)
2727	6	2026-04-09 09:30:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\119_h.csv	Batch import: 119.csv (H)
2731	6	2026-04-09 09:32:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\121_h.csv	Batch import: 121.csv (H)
2735	6	2026-04-09 09:34:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\123_h.csv	Batch import: 123.csv (H)
2641	6	2026-04-09 08:47:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\76_h.csv	Batch import: 76.csv (H)
2645	6	2026-04-09 08:49:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\78_h.csv	Batch import: 78.csv (H)
2649	6	2026-04-09 08:51:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\80_h.csv	Batch import: 80.csv (H)
2653	6	2026-04-09 08:53:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\82_h.csv	Batch import: 82.csv (H)
2657	6	2026-04-09 08:55:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\84_h.csv	Batch import: 84.csv (H)
2661	6	2026-04-09 08:57:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\86_h.csv	Batch import: 86.csv (H)
2665	6	2026-04-09 08:59:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\88_h.csv	Batch import: 88.csv (H)
2669	6	2026-04-09 09:01:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\90_h.csv	Batch import: 90.csv (H)
2673	6	2026-04-09 09:03:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\92_h.csv	Batch import: 92.csv (H)
2677	6	2026-04-09 09:05:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\94_h.csv	Batch import: 94.csv (H)
2681	6	2026-04-09 09:07:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\96_h.csv	Batch import: 96.csv (H)
2685	6	2026-04-09 09:09:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\98_h.csv	Batch import: 98.csv (H)
2689	6	2026-04-09 09:11:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\100_h.csv	Batch import: 100.csv (H)
2693	6	2026-04-09 09:13:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\102_h.csv	Batch import: 102.csv (H)
2697	6	2026-04-09 09:15:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\104_h.csv	Batch import: 104.csv (H)
2701	6	2026-04-09 09:17:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\106_h.csv	Batch import: 106.csv (H)
2705	6	2026-04-09 09:19:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\108_h.csv	Batch import: 108.csv (H)
2709	6	2026-04-09 09:21:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\110_h.csv	Batch import: 110.csv (H)
2713	6	2026-04-09 09:23:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\112_h.csv	Batch import: 112.csv (H)
2717	6	2026-04-09 09:25:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\114_h.csv	Batch import: 114.csv (H)
2721	6	2026-04-09 09:27:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\116_h.csv	Batch import: 116.csv (H)
2725	6	2026-04-09 09:29:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\118_h.csv	Batch import: 118.csv (H)
2729	6	2026-04-09 09:31:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\120_h.csv	Batch import: 120.csv (H)
2733	6	2026-04-09 09:33:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\122_h.csv	Batch import: 122.csv (H)
2642	7	2026-04-09 08:47:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\76_v.csv	Batch import: 76.csv (V)
2646	7	2026-04-09 08:49:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\78_v.csv	Batch import: 78.csv (V)
2650	7	2026-04-09 08:51:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\80_v.csv	Batch import: 80.csv (V)
2654	7	2026-04-09 08:53:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\82_v.csv	Batch import: 82.csv (V)
2658	7	2026-04-09 08:55:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\84_v.csv	Batch import: 84.csv (V)
2662	7	2026-04-09 08:57:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\86_v.csv	Batch import: 86.csv (V)
2666	7	2026-04-09 08:59:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\88_v.csv	Batch import: 88.csv (V)
2670	7	2026-04-09 09:01:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\90_v.csv	Batch import: 90.csv (V)
2674	7	2026-04-09 09:03:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\92_v.csv	Batch import: 92.csv (V)
2678	7	2026-04-09 09:05:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\94_v.csv	Batch import: 94.csv (V)
2682	7	2026-04-09 09:07:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\96_v.csv	Batch import: 96.csv (V)
2686	7	2026-04-09 09:09:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\98_v.csv	Batch import: 98.csv (V)
2690	7	2026-04-09 09:11:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\100_v.csv	Batch import: 100.csv (V)
2694	7	2026-04-09 09:13:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\102_v.csv	Batch import: 102.csv (V)
2698	7	2026-04-09 09:15:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\104_v.csv	Batch import: 104.csv (V)
2702	7	2026-04-09 09:17:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\106_v.csv	Batch import: 106.csv (V)
2706	7	2026-04-09 09:19:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\108_v.csv	Batch import: 108.csv (V)
2710	7	2026-04-09 09:21:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\110_v.csv	Batch import: 110.csv (V)
2714	7	2026-04-09 09:23:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\112_v.csv	Batch import: 112.csv (V)
2718	7	2026-04-09 09:25:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\114_v.csv	Batch import: 114.csv (V)
2722	7	2026-04-09 09:27:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\116_v.csv	Batch import: 116.csv (V)
2726	7	2026-04-09 09:29:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\118_v.csv	Batch import: 118.csv (V)
2730	7	2026-04-09 09:31:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\120_v.csv	Batch import: 120.csv (V)
2734	7	2026-04-09 09:33:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\122_v.csv	Batch import: 122.csv (V)
2644	7	2026-04-09 08:48:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\77_v.csv	Batch import: 77.csv (V)
2648	7	2026-04-09 08:50:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\79_v.csv	Batch import: 79.csv (V)
2652	7	2026-04-09 08:52:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\81_v.csv	Batch import: 81.csv (V)
2656	7	2026-04-09 08:54:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\83_v.csv	Batch import: 83.csv (V)
2660	7	2026-04-09 08:56:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\85_v.csv	Batch import: 85.csv (V)
2664	7	2026-04-09 08:58:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\87_v.csv	Batch import: 87.csv (V)
2668	7	2026-04-09 09:00:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\89_v.csv	Batch import: 89.csv (V)
2672	7	2026-04-09 09:02:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\91_v.csv	Batch import: 91.csv (V)
2676	7	2026-04-09 09:04:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\93_v.csv	Batch import: 93.csv (V)
2680	7	2026-04-09 09:06:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\95_v.csv	Batch import: 95.csv (V)
2684	7	2026-04-09 09:08:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\97_v.csv	Batch import: 97.csv (V)
2688	7	2026-04-09 09:10:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\99_v.csv	Batch import: 99.csv (V)
2692	7	2026-04-09 09:12:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\101_v.csv	Batch import: 101.csv (V)
2696	7	2026-04-09 09:14:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\103_v.csv	Batch import: 103.csv (V)
2700	7	2026-04-09 09:16:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\105_v.csv	Batch import: 105.csv (V)
2704	7	2026-04-09 09:18:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\107_v.csv	Batch import: 107.csv (V)
2708	7	2026-04-09 09:20:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\109_v.csv	Batch import: 109.csv (V)
2712	7	2026-04-09 09:22:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\111_v.csv	Batch import: 111.csv (V)
2716	7	2026-04-09 09:24:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\113_v.csv	Batch import: 113.csv (V)
2720	7	2026-04-09 09:26:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\115_v.csv	Batch import: 115.csv (V)
2724	7	2026-04-09 09:28:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\117_v.csv	Batch import: 117.csv (V)
2728	7	2026-04-09 09:30:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\119_v.csv	Batch import: 119.csv (V)
2732	7	2026-04-09 09:32:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\121_v.csv	Batch import: 121.csv (V)
2736	7	2026-04-09 09:34:51.202949+00	C:\\Code\\Vibro-diag-system\\ml_service\\data\\XJTU-SY\\XJTU-SY_Bearing_Datasets\\35Hz12kN\\Bearing1_1\\123_v.csv	Batch import: 123.csv (V)
\.


--
-- TOC entry 4187 (class 0 OID 27279)
-- Dependencies: 295
-- Data for Name: ml_models; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ml_models (id_model, name, version, type, path_to_model, accuracy, training_date, description, is_active, training_status) FROM stdin;
1	AE_ANOWGAN	1.0.0	Anomaly Detection	models/AE_ANOWGAN/v1	0.95	2026-04-08 13:45:43.190446+00	Detekce poruch (Zdravé / Porucha) pomocí Autoencoder GAN. Vstupem jsou CWT skalogramy.	f	ready
2	1D_CNNwWGN	1.0.0	Classification	models/1DCNN/v1/bearing_fault_model.pth	0.98	2026-04-08 13:45:43.190446+00	Klasifikace typu poruchy z 1D vibračních signálů a frekvenčního spektra (FFT).	t	ready
6	AE_ANOWGAN	2.0.0	Anomaly Detection	models/AE_ANOWGAN/v2	\N	2026-04-23 07:23:55.818974+00	Detekce poruch (Zdravé / Porucha) pomocí Autoencoder GAN. Vstupem jsou CWT skalogramy. (Fine-tuned z v1.0.0)	t	ready
4	Bi-LSTM_Inner_Race	1.0.0	RUL Prediction	models/Bi-LSTM/v1	0.91	2026-04-08 13:45:43.190446+00	Predikce zbývající užitečné životnosti (RUL) optimalizovaná pro poruchy vnitřního kroužku ložiska.	t	ready
5	Bi-LSTM_Other	1.0.0	RUL Prediction	models/Bi-LSTM/v1	0.88	2026-04-08 13:45:43.190446+00	Obecný model pro predikci zbývající užitečné životnosti (RUL) u ostatních nebo kombinovaných poruch.	t	ready
3	Bi-LSTM_Outer_Race	1.0.0	RUL Prediction	models/Bi-LSTM/v1	0.92	2026-04-08 13:45:43.190446+00	Predikce zbývající užitečné životnosti (RUL) optimalizovaná pro poruchy vnějšího kroužku ložiska.	t	ready
\.


--
-- TOC entry 4179 (class 0 OID 27142)
-- Dependencies: 287
-- Data for Name: sensors; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.sensors (id_sensor, serial_number, description, status, id_machine, "position", sampling_rate, calibration_date, created_at) FROM stdin;
5	WIL-786-A	Wilcoxon Research 786A High Speed 50	maintenance	\N	\N	50000	2023-01-21	2026-01-20 10:00:31.472252+00
1	BR-ACC-01-A	B&R Industrial Accelerometer (100mV/g)	active	1	Ložisko 2	25600	2025-10-15	2026-01-20 10:00:31.472252+00
2	BR-ACC-02-B	B&R Industrial Accelerometer (100mV/g)	active	1	Ložisko 2 - Radiálně	25600	2025-10-15	2026-01-20 10:00:31.472252+00
3	BR-TMP-05-X	Pt100 Temperature Sensor (RTD)	active	2	Ložisko 3	10	2025-11-20	2026-01-20 10:00:31.472252+00
4	IFM-VSA-001	ifm electronic - Vibration Sensor	active	1	Radial	12000	2024-05-10	2026-01-20 10:00:31.472252+00
6	PCB_352C33_H	Na ložisku v horizontálním směru	active	4	Horizontal	25600	2026-01-29	2026-01-29 09:14:08.555659+00
7	PCB_352C33_V	Na ložisku ve vertikálním směru	active	4	Vertical	25600	2026-01-29	2026-01-29 09:14:50.822228+00
9	PCB2_352C33_H	Na ložisku v horizontálním směru	active	5	Horizontal	25600	2026-01-30	2026-01-30 09:28:39.495317+00
10	PCB2_352C33_V	Na ložisku ve vertikálním směru	active	5	Vertical	25600	2026-01-30	2026-01-30 09:29:06.398244+00
\.


--
-- TOC entry 4191 (class 0 OID 27316)
-- Dependencies: 299
-- Data for Name: service_notes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.service_notes (id_note, id_machine, id_analysis, id_user, "timestamp", content, severity) FROM stdin;
13	4	\N	1	2026-01-29 09:12:09.619815+00	Testovací stroj - Nahrávání datasetu XJTU-SY do aplikace	INFO
14	5	\N	1	2026-01-30 09:25:56.569393+00	Test - nahrání dat a zpracování	WARNING
\.


--
-- TOC entry 4177 (class 0 OID 18896)
-- Dependencies: 285
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.users (id_user, username, email, hashed_password, role, creation_time, last_login) FROM stdin;
2	Pavel Novák	pavel.novak@test.cz	$2b$12$6kBkc0dtvNlL2kz0Z9jSAu5oTpsCeBEwvoDEVfGxp8S0y/6XhMTGi	operator	2026-01-20 07:49:54.675441+00	2026-01-20 09:16:57.142863+00
1	admin	admin@vut.cz	$2b$12$hMxV0Sbjwmt3n9b1/PX5XOPIL83ULMtNT2PfFbib1UWeThxBwizQm	admin	2026-01-07 09:50:50.519587+00	2026-04-23 06:46:51.150605+00
3	Josef Paklíč	josef.paklic@test.cz	$2b$12$oS1LrWNR6XokwFnzBsZFyejySCznUNeoKvyeqj3oFpE3sIOMtDfDm	user	2026-01-20 07:50:56.575029+00	2026-01-22 09:35:13.06682+00
\.


--
-- TOC entry 4206 (class 0 OID 0)
-- Dependencies: 241
-- Name: chunk_column_stats_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_column_stats_id_seq', 1, false);


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 240
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 237
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, true);


--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 262
-- Name: continuous_agg_migrate_plan_step_step_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.continuous_agg_migrate_plan_step_step_id_seq', 1, false);


--
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 233
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 2, true);


--
-- TOC entry 4211 (class 0 OID 0)
-- Dependencies: 235
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, true);


--
-- TOC entry 4212 (class 0 OID 0)
-- Dependencies: 229
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 2, true);


--
-- TOC entry 4213 (class 0 OID 0)
-- Dependencies: 243
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: admin
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);


--
-- TOC entry 4214 (class 0 OID 0)
-- Dependencies: 296
-- Name: analysis_results_id_analysis_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.analysis_results_id_analysis_seq', 17, true);


--
-- TOC entry 4215 (class 0 OID 0)
-- Dependencies: 292
-- Name: feature_data_id_featureset_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.feature_data_id_featureset_seq', 1546, true);


--
-- TOC entry 4216 (class 0 OID 0)
-- Dependencies: 288
-- Name: machines_id_machine_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.machines_id_machine_seq', 5, true);


--
-- TOC entry 4217 (class 0 OID 0)
-- Dependencies: 290
-- Name: measurements_id_measurement_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.measurements_id_measurement_seq', 2736, true);


--
-- TOC entry 4218 (class 0 OID 0)
-- Dependencies: 294
-- Name: ml_models_id_model_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.ml_models_id_model_seq', 6, true);


--
-- TOC entry 4219 (class 0 OID 0)
-- Dependencies: 286
-- Name: sensors_id_sensor_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.sensors_id_sensor_seq', 10, true);


--
-- TOC entry 4220 (class 0 OID 0)
-- Dependencies: 298
-- Name: service_notes_id_note_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.service_notes_id_note_seq', 14, true);


--
-- TOC entry 4221 (class 0 OID 0)
-- Dependencies: 284
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.users_id_user_seq', 3, true);


--
-- TOC entry 4006 (class 2606 OID 27297)
-- Name: analysis_results analysis_results_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT analysis_results_pkey PRIMARY KEY (id_analysis);


--
-- TOC entry 4002 (class 2606 OID 27252)
-- Name: feature_data feature_data_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.feature_data
    ADD CONSTRAINT feature_data_pkey PRIMARY KEY (id_featureset);


--
-- TOC entry 3998 (class 2606 OID 27197)
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (id_machine);


--
-- TOC entry 4000 (class 2606 OID 27207)
-- Name: measurements measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (id_measurement);


--
-- TOC entry 4004 (class 2606 OID 27287)
-- Name: ml_models ml_models_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ml_models
    ADD CONSTRAINT ml_models_pkey PRIMARY KEY (id_model);


--
-- TOC entry 3994 (class 2606 OID 27151)
-- Name: sensors sensors_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sensors
    ADD CONSTRAINT sensors_pkey PRIMARY KEY (id_sensor);


--
-- TOC entry 3996 (class 2606 OID 27153)
-- Name: sensors sensors_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sensors
    ADD CONSTRAINT sensors_serial_number_key UNIQUE (serial_number);


--
-- TOC entry 4008 (class 2606 OID 27325)
-- Name: service_notes service_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service_notes
    ADD CONSTRAINT service_notes_pkey PRIMARY KEY (id_note);


--
-- TOC entry 3988 (class 2606 OID 18909)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3990 (class 2606 OID 18905)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 3992 (class 2606 OID 18907)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4013 (class 2606 OID 27303)
-- Name: analysis_results analysis_results_id_model_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT analysis_results_id_model_fkey FOREIGN KEY (id_model) REFERENCES public.ml_models(id_model) ON DELETE CASCADE;


--
-- TOC entry 4010 (class 2606 OID 27258)
-- Name: feature_data feature_data_id_machine_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.feature_data
    ADD CONSTRAINT feature_data_id_machine_fkey FOREIGN KEY (id_machine) REFERENCES public.machines(id_machine) ON DELETE CASCADE;


--
-- TOC entry 4011 (class 2606 OID 27253)
-- Name: feature_data feature_data_id_measurement_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.feature_data
    ADD CONSTRAINT feature_data_id_measurement_fkey FOREIGN KEY (id_measurement) REFERENCES public.measurements(id_measurement) ON DELETE CASCADE;


--
-- TOC entry 4014 (class 2606 OID 43859)
-- Name: analysis_results fk_analysis_measurement; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis_results
    ADD CONSTRAINT fk_analysis_measurement FOREIGN KEY (id_measurement) REFERENCES public.measurements(id_measurement) ON DELETE CASCADE;


--
-- TOC entry 4012 (class 2606 OID 68437)
-- Name: feature_data fk_feature_sensor; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.feature_data
    ADD CONSTRAINT fk_feature_sensor FOREIGN KEY (id_sensor) REFERENCES public.sensors(id_sensor) ON DELETE CASCADE;


--
-- TOC entry 4009 (class 2606 OID 27208)
-- Name: measurements measurements_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.measurements
    ADD CONSTRAINT measurements_id_sensor_fkey FOREIGN KEY (id_sensor) REFERENCES public.sensors(id_sensor) ON DELETE CASCADE;


--
-- TOC entry 4015 (class 2606 OID 27331)
-- Name: service_notes service_notes_id_analysis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service_notes
    ADD CONSTRAINT service_notes_id_analysis_fkey FOREIGN KEY (id_analysis) REFERENCES public.analysis_results(id_analysis) ON DELETE SET NULL;


--
-- TOC entry 4016 (class 2606 OID 27326)
-- Name: service_notes service_notes_id_machine_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service_notes
    ADD CONSTRAINT service_notes_id_machine_fkey FOREIGN KEY (id_machine) REFERENCES public.machines(id_machine) ON DELETE CASCADE;


--
-- TOC entry 4017 (class 2606 OID 27336)
-- Name: service_notes service_notes_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service_notes
    ADD CONSTRAINT service_notes_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user);


-- Completed on 2026-04-23 09:03:27 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict 1cxeISrGEpG1X1glKMjatliVCbwIfg6k8snpxDtcAheONtsS7YuNqul9wID71Yj


CREATE TABLE public."Experiments" (
  uuid uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  params jsonb NOT NULL CHECK (is_valid_params(params)),
  name text NOT NULL,
  status smallint,
  user_id uuid NOT NULL,
  timestamp timestamp with time zone NOT NULL DEFAULT now(),
  info jsonb,
  sensors TEXT[] NOT NULL CHECK (array_length(sensors, 1) >= 1),
  CONSTRAINT Experiments_pkey PRIMARY KEY (id),
  UNIQUE (user_id, name)
);
ALTER TABLE public."Experiments" ENABLE ROW LEVEL SECURITY;


CREATE TABLE public."Potentiostat_Data" (
  exp_sens_id integer NOT NULL,
  current real NOT NULL,
  voltage real NOT NULL,
  time_ms bigint NOT NULL,
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  CONSTRAINT Potentiostat_Data_pkey PRIMARY KEY (id)
);
ALTER TABLE public."Potentiostat_Data" ENABLE ROW LEVEL SECURITY;


CREATE TABLE public."Sensors" (
  name character varying NOT NULL,
  material character varying NOT NULL,
  area_cm2 real NOT NULL,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  CONSTRAINT Sensors_pkey PRIMARY KEY (id)
);
ALTER TABLE public."Sensors" ENABLE ROW LEVEL SECURITY;


CREATE TABLE public."Sweep_Stats" (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  exp_sens_id integer NOT NULL,
  time_ms_start bigint NOT NULL,
  time_ms_end bigint NOT NULL,
  time_ms bigint NOT NULL,
  open_v real NOT NULL,
  cd_mag real NOT NULL,
  CONSTRAINT Sweep_Stats_pkey PRIMARY KEY (id)
);
ALTER TABLE public."Sweep_Stats" ENABLE ROW LEVEL SECURITY;


-- Entities --

CREATE TABLE public."Entities" (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name character varying NOT NULL,
  info jsonb,
  email text,
  contact text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT Entities_pkey PRIMARY KEY (id)
);
ALTER TABLE public."Entities" ENABLE ROW LEVEL SECURITY;

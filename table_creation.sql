-- Table: public.cdc_data

-- DROP TABLE public.cdc_data;

CREATE TABLE public.cdc_data
(
    submission_date character varying COLLATE pg_catalog."default",
    state character varying COLLATE pg_catalog."default" NOT NULL,
    tot_cases integer,
    conf_cases bigint,
    prob_cases bigint,
    new_case integer,
    pnew_case bigint,
    tot_death integer,
    conf_death bigint,
    prob_death bigint,
    new_death integer,
    pnew_death bigint,
    CONSTRAINT cdc_data_pkey PRIMARY KEY (state)
)

TABLESPACE pg_default;

ALTER TABLE public.cdc_data
    OWNER to postgres;

--============================================================================

-- Table: public.state_lookup

-- DROP TABLE public.state_lookup;

CREATE TABLE public.state_lookup
(
    "State" character varying COLLATE pg_catalog."default",
    "Code" character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE public.state_lookup
    OWNER to postgres;

--============================================================================

-- Table: public.vaccine_data

-- DROP TABLE public.vaccine_data;

CREATE TABLE public.vaccine_data
(
    date character varying COLLATE pg_catalog."default",
    location character varying COLLATE pg_catalog."default" NOT NULL,
    total_vaccinations bigint,
    total_distributed bigint,
    people_vaccinated bigint,
    people_fully_vaccinated bigint,
    CONSTRAINT vaccine_data_pkey PRIMARY KEY (location)
)

TABLESPACE pg_default;

ALTER TABLE public.vaccine_data
    OWNER to postgres;
##ETL Project Readme

#Members: Saibal, Benjamin

#########################
#Database table creation#
#########################
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


########################################
##Code from Jupyter notebook -- pandas##
########################################

#Importing Dependencies
import pandas as pd
import json
import datetime
import numpy as np
from sqlalchemy import create_engine

############################################################
#Reading data in from csv files and loading into dataframes#
############################################################

#Reading state_vaccine csv file
state_vaccine_csv_file = "Source 1/us_state_vaccinations.csv"
state_vaccine_data_df = pd.read_csv(state_vaccine_csv_file)
state_vaccine_data_df.head()


#Reading cdc_data csv file
cdc_data_df_csv_file = "Source 2/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv"
cdc_data_df = pd.read_csv(cdc_data_df_csv_file)
cdc_data_df.head()


#Reading state_lookup csv file
lookup_data_df_csv_file = "Source 1/state_province_lookup.csv"
lookup_data_df = pd.read_csv(lookup_data_df_csv_file)
lookup_data_df.head()


################
#Verifying data#
################

#counting rows for data set
state_vaccine_data_df.count()


#counting rows for data set
cdc_data_df.count()

cdc_data_df.head()

##########################################
#Transformed cdc_dataGB_df dataframe data#
##########################################

#filtering based on most current date from file
cdc_dataGB_df = cdc_data_df[cdc_data_df["submission_date"] == "04/26/2021"]
cdc_dataGB_df.head(2)

#dropping unnecessary columns
cdc_dataGB_df.drop(columns = ["created_at","consent_cases","consent_deaths"], axis = 1, inplace = True)
cdc_dataGB_df.head()

#converting NaN and null values to 0
cdc_dataGB_df.fillna(value = 0, inplace = True)
cdc_dataGB_df.head()

##################################################
#Transformed state_vaccine_data_df dataframe data#
##################################################

#filtering based on most current date from file
state_vaccine_data_df = state_vaccine_data_df[state_vaccine_data_df["date"] == "2021-04-26"]
state_vaccine_data_df.head()

#dropping unnecessary columns
state_vaccine_data_df.drop(columns = ["share_doses_used","daily_vaccinations_per_million","daily_vaccinations","daily_vaccinations_raw","distributed_per_hundred","people_vaccinated_per_hundred","total_vaccinations_per_hundred","people_fully_vaccinated_per_hundred"], axis = 1, inplace = True)
state_vaccine_data_df.head()


#################################
#Establish database connectivity#
#################################
rds_connection_string = "postgres:Qwerty1234@localhost:5432/ETL_project_db"
engine = create_engine(f'postgresql://{rds_connection_string}')

engine.table_names()


#############################################
#Loading dataframe data into database tables#
#############################################

state_vaccine_data_df.to_sql(name='vaccine_data', con=engine, if_exists='append', index=False)

cdc_dataGB_df.to_sql(name='cdc_data', con=engine, if_exists='append', index=False)

lookup_data_df.to_sql(name='state_lookup', con=engine, if_exists='append', index=False)

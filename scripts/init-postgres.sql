-- Crée la base dataplatform (la base airflow existe déjà via POSTGRES_DB)
CREATE DATABASE dataplatform
    WITH OWNER = admin
    ENCODING = 'UTF8';

-- Schemas dans dataplatform
\c dataplatform

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS marts;

GRANT ALL ON SCHEMA raw     TO admin;
GRANT ALL ON SCHEMA staging TO admin;
GRANT ALL ON SCHEMA marts   TO admin;

-- psql -h 0.0.0.0 -U postgres -W < create-role-and-db.sql

-- Create the role.

CREATE ROLE api_demo_role
  WITH LOGIN ENCRYPTED PASSWORD 
  'password';

GRANT 
  SELECT, INSERT, UPDATE, DELETE 
  ON ALL TABLES 
  IN SCHEMA public 
  TO api_demo_role;

CREATE DATABASE api_demo_db
  OWNER api_demo_role;

-- Creating the schema

\c api_demo_db

SET ROLE api_demo_role;

CREATE TABLE IF NOT EXISTS partners (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    summary TEXT,
    description TEXT,
    created_at TIMESTAMP,
    contact_email VARCHAR
);

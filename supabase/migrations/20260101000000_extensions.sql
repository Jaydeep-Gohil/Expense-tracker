-- Migration: 20260101000000_extensions.sql
-- Purpose: Required Postgres extensions and the shared set_updated_at trigger function.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Touches NEW.updated_at on every UPDATE.
CREATE OR REPLACE FUNCTION public.set_updated_at () RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

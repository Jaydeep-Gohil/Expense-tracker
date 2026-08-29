-- Migration: 20260101000200_domain_tables.sql
-- Purpose: Per-business domain tables: accounts, categories, projects, parties.
-- =========================================================================
-- accounts
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses (id) ON DELETE CASCADE,
  name text NOT NULL,
  kind text NOT NULL CHECK (
    kind IN ('cash', 'bank', 'card', 'wallet', 'other')
  ),
  opening_balance numeric(18, 2) NOT NULL DEFAULT 0 CHECK (opening_balance >= 0),
  is_archived boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  UNIQUE (business_id, name)
);

CREATE INDEX IF NOT EXISTS idx_accounts_business_id ON public.accounts (business_id);

CREATE INDEX IF NOT EXISTS idx_accounts_business_active ON public.accounts (business_id)
WHERE
  deleted_at IS NULL;

DROP TRIGGER IF EXISTS trg_accounts_set_updated_at ON public.accounts;

CREATE TRIGGER trg_accounts_set_updated_at
BEFORE UPDATE ON public.accounts FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- =========================================================================
-- categories
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses (id) ON DELETE CASCADE,
  name text NOT NULL,
  kind text NOT NULL CHECK (kind IN ('income', 'expense', 'both')),
  color text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  UNIQUE (business_id, name)
);

CREATE INDEX IF NOT EXISTS idx_categories_business_id ON public.categories (business_id);

CREATE INDEX IF NOT EXISTS idx_categories_business_active ON public.categories (business_id)
WHERE
  deleted_at IS NULL;

DROP TRIGGER IF EXISTS trg_categories_set_updated_at ON public.categories;

CREATE TRIGGER trg_categories_set_updated_at
BEFORE UPDATE ON public.categories FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- =========================================================================
-- projects
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses (id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'archived', 'closed')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  UNIQUE (business_id, name)
);

CREATE INDEX IF NOT EXISTS idx_projects_business_id ON public.projects (business_id);

CREATE INDEX IF NOT EXISTS idx_projects_business_active ON public.projects (business_id)
WHERE
  deleted_at IS NULL;

DROP TRIGGER IF EXISTS trg_projects_set_updated_at ON public.projects;

CREATE TRIGGER trg_projects_set_updated_at
BEFORE UPDATE ON public.projects FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- =========================================================================
-- parties (people + companies)
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses (id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('person', 'company')),
  name text NOT NULL,
  email text,
  phone text,
  address text,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_parties_business_id ON public.parties (business_id);

CREATE INDEX IF NOT EXISTS idx_parties_business_type ON public.parties (business_id, type);

CREATE INDEX IF NOT EXISTS idx_parties_business_active ON public.parties (business_id)
WHERE
  deleted_at IS NULL;

DROP TRIGGER IF EXISTS trg_parties_set_updated_at ON public.parties;

CREATE TRIGGER trg_parties_set_updated_at
BEFORE UPDATE ON public.parties FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

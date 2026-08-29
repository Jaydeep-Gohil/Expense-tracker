-- Migration: 20260101000100_profiles_businesses_members.sql
-- Purpose: Auth-adjacent tables: profiles, businesses, business_members.
-- Auto-inserts the creator into business_members as 'owner' on business create.
-- =========================================================================
-- profiles: 1:1 with auth.users;
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

DROP TRIGGER IF EXISTS trg_profiles_set_updated_at ON public.profiles;

CREATE TRIGGER trg_profiles_set_updated_at
BEFORE UPDATE ON public.profiles FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- Convenience: when a new auth user is created, insert a profile row.
CREATE OR REPLACE FUNCTION public.handle_new_user () RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER
SET
  search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id)
  VALUES (NEW.id)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_on_auth_user_created ON auth.users;

CREATE TRIGGER trg_on_auth_user_created
AFTER INSERT ON auth.users FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user ();

-- =========================================================================
-- businesses
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.businesses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  currency_code char(3) NOT NULL DEFAULT 'INR',
  owner_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE RESTRICT,
  created_by uuid NOT NULL REFERENCES public.profiles (id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_businesses_owner_id ON public.businesses (owner_id);

CREATE INDEX IF NOT EXISTS idx_businesses_deleted_at ON public.businesses (deleted_at);

DROP TRIGGER IF EXISTS trg_businesses_set_updated_at ON public.businesses;

CREATE TRIGGER trg_businesses_set_updated_at
BEFORE UPDATE ON public.businesses FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- =========================================================================
-- business_members
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.business_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  role text NOT NULL CHECK (role IN ('owner', 'admin', 'member', 'viewer')),
  invited_by uuid REFERENCES public.profiles (id) ON DELETE SET NULL,
  joined_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (business_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_business_members_user_id ON public.business_members (user_id);

CREATE INDEX IF NOT EXISTS idx_business_members_business_id ON public.business_members (business_id);

DROP TRIGGER IF EXISTS trg_business_members_set_updated_at ON public.business_members;

CREATE TRIGGER trg_business_members_set_updated_at
BEFORE UPDATE ON public.business_members FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- =========================================================================
-- Auto-insert the owner into business_members when a business is created.
-- =========================================================================
CREATE OR REPLACE FUNCTION public.handle_new_business () RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER
SET
  search_path = public AS $$
BEGIN
  INSERT INTO public.business_members (business_id, user_id, role, invited_by)
  VALUES (NEW.id, NEW.owner_id, 'owner', NEW.created_by)
  ON CONFLICT (business_id, user_id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_on_business_created ON public.businesses;

CREATE TRIGGER trg_on_business_created
AFTER INSERT ON public.businesses FOR EACH ROW
EXECUTE FUNCTION public.handle_new_business ();

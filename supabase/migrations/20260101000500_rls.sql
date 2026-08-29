-- Migration: 20260101000500_rls.sql
-- Purpose: Enable RLS on every table and define policies.
-- Roles: 'owner' > 'admin' > 'member' > 'viewer'.
-- Write allowed for owner/admin/member; delete allowed for owner/admin.

-- =========================================================================
-- Helper: a single policy template via DO blocks to keep file readable.
-- =========================================================================

-- profiles -----------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS profiles_read_own   ON public.profiles;
DROP POLICY IF EXISTS profiles_update_own ON public.profiles;
DROP POLICY IF EXISTS profiles_insert_self ON public.profiles;

CREATE POLICY profiles_read_own ON public.profiles
FOR SELECT USING (id = auth.uid());

CREATE POLICY profiles_update_own ON public.profiles
FOR UPDATE USING (id = auth.uid()) WITH CHECK (id = auth.uid());

-- Inserts are done by the SECURITY DEFINER trigger handle_new_user(), so no
-- client-facing insert policy is needed.

-- businesses ---------------------------------------------------------------
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS businesses_read   ON public.businesses;
DROP POLICY IF EXISTS businesses_insert  ON public.businesses;
DROP POLICY IF EXISTS businesses_update ON public.businesses;
DROP POLICY IF EXISTS businesses_delete ON public.businesses;

CREATE POLICY businesses_read ON public.businesses
FOR SELECT USING (
  deleted_at IS NULL
  AND public.is_business_member(id, auth.uid())
);

CREATE POLICY businesses_insert ON public.businesses
FOR INSERT WITH CHECK (
  created_by = auth.uid()
  AND owner_id = auth.uid()
);

CREATE POLICY businesses_update ON public.businesses
FOR UPDATE USING (
  public.has_business_role(id, auth.uid(), ARRAY['owner','admin'])
) WITH CHECK (
  public.has_business_role(id, auth.uid(), ARRAY['owner','admin'])
);

CREATE POLICY businesses_delete ON public.businesses
FOR DELETE USING (
  public.has_business_role(id, auth.uid(), ARRAY['owner'])
);

-- business_members ---------------------------------------------------------
ALTER TABLE public.business_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS bm_read   ON public.business_members;
DROP POLICY IF EXISTS bm_insert ON public.business_members;
DROP POLICY IF EXISTS bm_update ON public.business_members;
DROP POLICY IF EXISTS bm_delete ON public.business_members;

CREATE POLICY bm_read ON public.business_members
FOR SELECT USING (
  public.is_business_member(business_id, auth.uid())
);

-- Owner self-insert is handled by handle_new_business() trigger (SECURITY DEFINER).
-- Additional inserts (invites) require owner/admin.
CREATE POLICY bm_insert ON public.business_members
FOR INSERT WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

CREATE POLICY bm_update ON public.business_members
FOR UPDATE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
) WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

CREATE POLICY bm_delete ON public.business_members
FOR DELETE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

-- accounts -----------------------------------------------------------------
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS accounts_read   ON public.accounts;
DROP POLICY IF EXISTS accounts_write  ON public.accounts;
DROP POLICY IF EXISTS accounts_update ON public.accounts;
DROP POLICY IF EXISTS accounts_delete ON public.accounts;

CREATE POLICY accounts_read ON public.accounts
FOR SELECT USING (
  deleted_at IS NULL
  AND public.is_business_member(business_id, auth.uid())
);

CREATE POLICY accounts_write ON public.accounts
FOR INSERT WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY accounts_update ON public.accounts
FOR UPDATE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
) WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY accounts_delete ON public.accounts
FOR DELETE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

-- categories ---------------------------------------------------------------
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS categories_read   ON public.categories;
DROP POLICY IF EXISTS categories_write  ON public.categories;
DROP POLICY IF EXISTS categories_update ON public.categories;
DROP POLICY IF EXISTS categories_delete ON public.categories;

CREATE POLICY categories_read ON public.categories
FOR SELECT USING (
  deleted_at IS NULL
  AND public.is_business_member(business_id, auth.uid())
);

CREATE POLICY categories_write ON public.categories
FOR INSERT WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY categories_update ON public.categories
FOR UPDATE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
) WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY categories_delete ON public.categories
FOR DELETE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

-- projects -----------------------------------------------------------------
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS projects_read   ON public.projects;
DROP POLICY IF EXISTS projects_write  ON public.projects;
DROP POLICY IF EXISTS projects_update ON public.projects;
DROP POLICY IF EXISTS projects_delete ON public.projects;

CREATE POLICY projects_read ON public.projects
FOR SELECT USING (
  deleted_at IS NULL
  AND public.is_business_member(business_id, auth.uid())
);

CREATE POLICY projects_write ON public.projects
FOR INSERT WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY projects_update ON public.projects
FOR UPDATE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
) WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY projects_delete ON public.projects
FOR DELETE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

-- parties ------------------------------------------------------------------
ALTER TABLE public.parties ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS parties_read   ON public.parties;
DROP POLICY IF EXISTS parties_write  ON public.parties;
DROP POLICY IF EXISTS parties_update ON public.parties;
DROP POLICY IF EXISTS parties_delete ON public.parties;

CREATE POLICY parties_read ON public.parties
FOR SELECT USING (
  deleted_at IS NULL
  AND public.is_business_member(business_id, auth.uid())
);

CREATE POLICY parties_write ON public.parties
FOR INSERT WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY parties_update ON public.parties
FOR UPDATE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
) WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY parties_delete ON public.parties
FOR DELETE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

-- transactions -------------------------------------------------------------
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS transactions_read   ON public.transactions;
DROP POLICY IF EXISTS transactions_write  ON public.transactions;
DROP POLICY IF EXISTS transactions_update ON public.transactions;
DROP POLICY IF EXISTS transactions_delete ON public.transactions;

CREATE POLICY transactions_read ON public.transactions
FOR SELECT USING (
  deleted_at IS NULL
  AND public.is_business_member(business_id, auth.uid())
);

CREATE POLICY transactions_write ON public.transactions
FOR INSERT WITH CHECK (
  created_by = auth.uid()
  AND public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY transactions_update ON public.transactions
FOR UPDATE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
) WITH CHECK (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin','member'])
);

CREATE POLICY transactions_delete ON public.transactions
FOR DELETE USING (
  public.has_business_role(business_id, auth.uid(), ARRAY['owner','admin'])
);

-- =========================================================================
-- Grants: authenticated role can call helper functions.
-- =========================================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION public.account_balance(uuid, uuid)  TO authenticated;
GRANT EXECUTE ON FUNCTION public.business_totals(uuid, date, date) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_business_member(uuid, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.has_business_role(uuid, uuid, text[]) TO authenticated;

-- Default table privileges for authenticated.
GRANT SELECT, INSERT, UPDATE, DELETE ON
  public.profiles,
  public.businesses,
  public.business_members,
  public.accounts,
  public.categories,
  public.projects,
  public.parties,
  public.transactions
TO authenticated;

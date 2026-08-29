-- Migration: 20260101000400_helper_functions.sql
-- Purpose: Read-side helpers (account balance, business totals).

-- =========================================================================
-- account_balance: opening_balance + sum(credits) - sum(debits) for an account.
-- SECURITY INVOKER so RLS on transactions applies.
-- =========================================================================
CREATE OR REPLACE FUNCTION public.account_balance(
  p_business uuid,
  p_account  uuid
)
RETURNS numeric(18,2)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    COALESCE((SELECT opening_balance FROM public.accounts WHERE id = p_account), 0)
    + COALESCE((
        SELECT
          SUM(CASE
                WHEN type = 'credit' AND received_in_account_id = p_account THEN amount
                WHEN type = 'debit'  AND paid_from_account_id   = p_account THEN -amount
                ELSE 0
              END)
        FROM public.transactions
        WHERE business_id = p_business
          AND deleted_at IS NULL
          AND (received_in_account_id = p_account OR paid_from_account_id = p_account)
      ), 0);
$$;

-- =========================================================================
-- business_totals: income/expense/net for a date range (inclusive).
-- Returns a single row.
-- =========================================================================
CREATE OR REPLACE FUNCTION public.business_totals(
  p_business uuid,
  p_from     date DEFAULT NULL,
  p_to       date DEFAULT NULL
)
RETURNS TABLE (
  total_income  numeric(18,2),
  total_expense numeric(18,2),
  net           numeric(18,2)
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    COALESCE(SUM(CASE WHEN type = 'credit' THEN amount ELSE 0 END), 0) AS total_income,
    COALESCE(SUM(CASE WHEN type = 'debit'  THEN amount ELSE 0 END), 0) AS total_expense,
    COALESCE(SUM(CASE WHEN type = 'credit' THEN amount
                      WHEN type = 'debit'  THEN -amount
                      ELSE 0 END), 0) AS net
  FROM public.transactions
  WHERE business_id = p_business
    AND deleted_at IS NULL
    AND (p_from IS NULL OR occurred_on >= p_from)
    AND (p_to   IS NULL OR occurred_on <= p_to);
$$;

-- =========================================================================
-- is_business_member: convenience for clients/policies.
-- =========================================================================
CREATE OR REPLACE FUNCTION public.is_business_member(
  p_business uuid,
  p_user     uuid
)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.business_members
    WHERE business_id = p_business AND user_id = p_user
  );
$$;

CREATE OR REPLACE FUNCTION public.has_business_role(
  p_business uuid,
  p_user     uuid,
  p_roles    text[]
)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.business_members
    WHERE business_id = p_business
      AND user_id    = p_user
      AND role = ANY (p_roles)
  );
$$;

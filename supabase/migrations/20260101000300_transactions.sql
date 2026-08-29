-- Migration: 20260101000300_transactions.sql
-- Purpose: Core transactions table + cross-business FK safety trigger.
CREATE TABLE IF NOT EXISTS public.transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES public.businesses (id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('debit', 'credit')),
  amount numeric(18, 2) NOT NULL CHECK (amount >= 0),
  occurred_on date NOT NULL DEFAULT current_date,
  description text,
  created_by uuid NOT NULL REFERENCES public.profiles (id) ON DELETE RESTRICT,
  -- Exactly one of these two is set, dictated by `type`.
  paid_from_account_id uuid REFERENCES public.accounts (id) ON DELETE RESTRICT,
  received_in_account_id uuid REFERENCES public.accounts (id) ON DELETE RESTRICT,
  -- Optional links.
  category_id uuid REFERENCES public.categories (id) ON DELETE SET NULL,
  project_id uuid REFERENCES public.projects (id) ON DELETE SET NULL,
  from_party_id uuid REFERENCES public.parties (id) ON DELETE SET NULL,
  to_party_id uuid REFERENCES public.parties (id) ON DELETE SET NULL,
  attachment_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  CONSTRAINT chk_txn_account_side CHECK (
    (
      type = 'debit'
      AND paid_from_account_id IS NOT NULL
      AND received_in_account_id IS NULL
    )
    OR (
      type = 'credit'
      AND received_in_account_id IS NOT NULL
      AND paid_from_account_id IS NULL
    )
  )
);

CREATE INDEX IF NOT EXISTS idx_txn_business_occurred ON public.transactions (business_id, occurred_on DESC);

CREATE INDEX IF NOT EXISTS idx_txn_business_created ON public.transactions (business_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_txn_business_category ON public.transactions (business_id, category_id);

CREATE INDEX IF NOT EXISTS idx_txn_business_project ON public.transactions (business_id, project_id);

CREATE INDEX IF NOT EXISTS idx_txn_business_paid_from ON public.transactions (business_id, paid_from_account_id);

CREATE INDEX IF NOT EXISTS idx_txn_business_received_in ON public.transactions (business_id, received_in_account_id);

CREATE INDEX IF NOT EXISTS idx_txn_business_active ON public.transactions (business_id)
WHERE
  deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_txn_created_by ON public.transactions (created_by);

DROP TRIGGER IF EXISTS trg_transactions_set_updated_at ON public.transactions;

CREATE TRIGGER trg_transactions_set_updated_at
BEFORE UPDATE ON public.transactions FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at ();

-- =========================================================================
-- Cross-business FK safety: every non-null FK must point to a row in the
-- same business as the transaction.
-- =========================================================================
CREATE OR REPLACE FUNCTION public.enforce_transaction_fk_business () RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_fk_business uuid;
BEGIN
  IF NEW.paid_from_account_id IS NOT NULL THEN
    SELECT business_id INTO v_fk_business FROM public.accounts WHERE id = NEW.paid_from_account_id;
    IF v_fk_business IS DISTINCT FROM NEW.business_id THEN
      RAISE EXCEPTION 'paid_from_account_id (%) belongs to a different business', NEW.paid_from_account_id;
    END IF;
  END IF;

  IF NEW.received_in_account_id IS NOT NULL THEN
    SELECT business_id INTO v_fk_business FROM public.accounts WHERE id = NEW.received_in_account_id;
    IF v_fk_business IS DISTINCT FROM NEW.business_id THEN
      RAISE EXCEPTION 'received_in_account_id (%) belongs to a different business', NEW.received_in_account_id;
    END IF;
  END IF;

  IF NEW.category_id IS NOT NULL THEN
    SELECT business_id INTO v_fk_business FROM public.categories WHERE id = NEW.category_id;
    IF v_fk_business IS DISTINCT FROM NEW.business_id THEN
      RAISE EXCEPTION 'category_id (%) belongs to a different business', NEW.category_id;
    END IF;
  END IF;

  IF NEW.project_id IS NOT NULL THEN
    SELECT business_id INTO v_fk_business FROM public.projects WHERE id = NEW.project_id;
    IF v_fk_business IS DISTINCT FROM NEW.business_id THEN
      RAISE EXCEPTION 'project_id (%) belongs to a different business', NEW.project_id;
    END IF;
  END IF;

  IF NEW.from_party_id IS NOT NULL THEN
    SELECT business_id INTO v_fk_business FROM public.parties WHERE id = NEW.from_party_id;
    IF v_fk_business IS DISTINCT FROM NEW.business_id THEN
      RAISE EXCEPTION 'from_party_id (%) belongs to a different business', NEW.from_party_id;
    END IF;
  END IF;

  IF NEW.to_party_id IS NOT NULL THEN
    SELECT business_id INTO v_fk_business FROM public.parties WHERE id = NEW.to_party_id;
    IF v_fk_business IS DISTINCT FROM NEW.business_id THEN
      RAISE EXCEPTION 'to_party_id (%) belongs to a different business', NEW.to_party_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_txn_fk_business ON public.transactions;

CREATE TRIGGER trg_txn_fk_business
BEFORE INSERT OR UPDATE ON public.transactions FOR EACH ROW
EXECUTE FUNCTION public.enforce_transaction_fk_business ();

-- Seed: local dev only.
-- Creates a demo business + starter categories + sample accounts. No auth
-- users are inserted here (auth.users is owned by Supabase Auth); run
-- this AFTER you have signed up at least one user via the dashboard or API
-- and replaced the UUIDs below.
-- Replace these UUIDs with real values from your local auth.users.
-- Example:
--   SELECT id FROM auth.users WHERE email = 'demo@example.com';
DO $$
DECLARE
  v_user  uuid := '00000000-0000-0000-0000-000000000001'; -- <-- replace me
  v_biz   uuid;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = v_user) THEN
    RAISE NOTICE 'Seed skipped: auth user % does not exist. Sign up first, then update the UUID.', v_user;
    RETURN;
  END IF;

  INSERT INTO public.businesses (id, name, currency_code, owner_id, created_by)
  VALUES (gen_random_uuid(), 'Demo Business', 'INR', v_user, v_user)
  RETURNING id INTO v_biz;

  INSERT INTO public.accounts (business_id, name, kind, opening_balance) VALUES
    (v_biz, 'Cash',          'cash',  0),
    (v_biz, 'HDFC Current',  'bank',  0),
    (v_biz, 'Credit Card',   'card',  0);

  INSERT INTO public.categories (business_id, name, kind) VALUES
    (v_biz, 'Salary',     'income'),
    (v_biz, 'Freelance',  'income'),
    (v_biz, 'Food',       'expense'),
    (v_biz, 'Rent',       'expense'),
    (v_biz, 'Travel',     'expense'),
    (v_biz, 'Utilities',  'expense'),
    (v_biz, 'Other',      'both');

  INSERT INTO public.projects (business_id, name, status) VALUES
    (v_biz, 'Personal',     'active'),
    (v_biz, 'Side Project', 'active');

  RAISE NOTICE 'Seed complete for business %', v_biz;
END $$;

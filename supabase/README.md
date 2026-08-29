# Supabase — Expense Tracker

Postgres schema, RLS policies, and helper functions for the expense tracker.

## Layout

```
supabase/
  config.toml                # Supabase CLI project config (local dev)
  migrations/                # Timestamped SQL migrations
    20260101000000_extensions.sql
    20260101000100_profiles_businesses_members.sql
    20260101000200_domain_tables.sql
    20260101000300_transactions.sql
    20260101000400_helper_functions.sql
    20260101000500_rls.sql
  seed/
    seed.sql                 # Local dev only — create a demo business
```

## Local development

Prereqs: [Supabase CLI](https://supabase.com/docs/guides/cli), Docker.

```bash
# Start the local stack
supabase start

# Apply all migrations
supabase db reset

# (Optional) seed a demo business
# Edit supabase/seed/seed.sql and replace the user UUID first
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" \
  -f supabase/seed/seed.sql
```

## Apply to a hosted project

```bash
supabase link --project-ref <ref>
supabase db push
```

## Schema summary

- `profiles` — 1:1 with `auth.users`.
- `businesses` — one per workspace; has `owner_id` and `currency_code`.
- `business_members` — `user_id × business_id` × `role` (owner/admin/member/viewer).
  Auto-populated with the creator as `owner` on business insert.
- `accounts`, `categories`, `projects`, `parties` — per-business domain tables, soft-deleted.
- `transactions` — `type ∈ {debit, credit}` with positive `numeric(18,2)` amount. Exactly one of
  `paid_from_account_id` / `received_in_account_id` is set, dictated by `type`. Optional
  `category_id`, `project_id`, `from_party_id`, `to_party_id`. A trigger enforces that every
  non-null FK belongs to the same `business_id`.

## Read-side helpers

- `public.account_balance(business_id, account_id) → numeric(18,2)`
- `public.business_totals(business_id, from date, to date) → (total_income, total_expense, net)`
- `public.is_business_member(business_id, user_id) → boolean`
- `public.has_business_role(business_id, user_id, roles[]) → boolean`

All `SECURITY INVOKER` and `STABLE`, so RLS on `transactions` is respected.

## RLS

Every table has RLS enabled. Policy summary:

| Table | Read | Write | Update | Delete |
|-------|------|-------|--------|--------|
| `profiles` | self | (trigger) | self | — |
| `businesses` | members | owner-self | owner/admin | owner |
| `business_members` | members | owner/admin | owner/admin | owner/admin |
| `accounts`, `categories`, `projects`, `parties` | members | owner/admin/member | owner/admin/member | owner/admin |
| `transactions` | members | owner/admin/member | owner/admin/member | owner/admin |

`viewer` role can only `SELECT`.

## Future / out of scope (v1)

- Transfers between accounts (will be modeled as two linked transactions).
- Recurring transactions, budgets, multi-currency, attachments storage.
- React client schema code-gen — `supabase gen types typescript` when needed.

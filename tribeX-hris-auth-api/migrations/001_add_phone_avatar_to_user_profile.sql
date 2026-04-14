-- Migration 001: Add missing columns to user_profile
-- Run this in your Supabase SQL editor BEFORE deploying the updated backend.
--
-- These columns are required by the employee profile page:
--   • phone_number  — stored from applicant onboarding and editable by the employee
--   • avatar_url    — stores the employee's profile photo (base64 or storage URL)

ALTER TABLE public.user_profile
  ADD COLUMN IF NOT EXISTS phone_number character varying,
  ADD COLUMN IF NOT EXISTS avatar_url text;

-- Backfill phone_number from applicant_profile for employees who were
-- converted from applicants (where applicant_id is set on user_profile).
UPDATE public.user_profile up
SET phone_number = ap.phone_number
FROM public.applicant_profile ap
WHERE up.applicant_id = ap.applicant_id
  AND up.phone_number IS NULL
  AND ap.phone_number IS NOT NULL;

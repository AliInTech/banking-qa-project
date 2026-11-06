# Regression Testing Checklist — SecureBank Web Application

**Purpose:** Run this checklist after any code change/release to quickly verify core,
high-risk banking flows still work — without re-running all 62 test cases every time.

**How to use:** Tick each box after manually verifying it. If anything fails, log it in
`bug_reports/bug_reports.xlsx` using the Bug Life Cycle states from
`docs/05_bug_life_cycle.md`, then re-run this checklist after the fix.

## Priority 1 — Smoke / Critical Path (always run, every release)
- [ ] User can log in with valid credentials
- [ ] User can view their accounts and balances
- [ ] User can transfer funds between their own accounts successfully
- [ ] Balance updates correctly (debit source, credit destination) after a transfer
- [ ] Transaction appears correctly in Transaction History after a transfer
- [ ] User can log out successfully

## Priority 2 — Money-Safety Regression (the highest-risk category in banking)
- [ ] Zero-amount transfer is rejected
- [ ] Negative-amount transfer is rejected
- [ ] Transfer exceeding balance is rejected with a clear error
- [ ] Transfer of the EXACT full balance succeeds (boundary check)
- [ ] Double-click / rapid resubmit does NOT create a duplicate transaction
- [ ] Browser back + resubmit does NOT silently duplicate a completed transfer
- [ ] Transaction history amount exactly matches the real balance change (no rounding drift)

## Priority 3 — Authorization & Session Regression
- [ ] A user cannot view or act on another user's account (direct URL / ID manipulation)
- [ ] A user cannot view another user's transaction history
- [ ] Back button after logout does not expose cached account data
- [ ] Direct URL access to a protected page while logged out redirects to Login
- [ ] Session expires after the defined inactivity period (if supported by the AUT)

## Priority 4 — Beneficiary & Account Management Regression
- [ ] Adding a valid beneficiary succeeds
- [ ] Duplicate beneficiary (same name + account number) is detected/blocked
- [ ] Invalid/malformed beneficiary account number is rejected
- [ ] Deleting a beneficiary removes it from the Transfer Funds selection list
- [ ] Update Contact Info validates email/phone format correctly
- [ ] Opening a new account completes and reflects the correct starting balance

## Priority 5 — API & Data Layer (if backend changed)
- [ ] GET accounts/transactions endpoints return 200 with correct data
- [ ] POST login/transfer endpoints correctly validate and reject bad input
- [ ] PUT (update) endpoints correctly modify only the intended record
- [ ] DELETE (beneficiary) endpoint correctly removes the record and nothing else
- [ ] SQL validation queries in `sql/db_validation_queries.sql` return expected results

---

### Regression Entry/Exit Notes
- **Always run Priority 1 + Priority 2** before any release — money-safety bugs are the
  highest-cost category in a banking application.
- **Run Priority 3** whenever authentication, session, or routing code changes.
- **Run Priority 4/5** when the specific module or API layer was touched.

### Execution Log (fill in as you actually run this)
| Date | Run By | Priorities Checked | Pass | Fail | Notes |
|------|--------|---------------------|------|------|-------|
| _(fill in)_ | _(fill in)_ | _(e.g., P1 + P2)_ | _(count)_ | _(count)_ | _(any new bugs found)_ |

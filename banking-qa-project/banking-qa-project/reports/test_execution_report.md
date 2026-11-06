# Test Execution Report — SecureBank Web Application

> **⚠️ SAMPLE DATA DISCLAIMER:** The numbers below are **illustrative sample data** showing the
> correct format of a QA execution report — they do not represent an actually-executed test
> cycle. Replace every number with your real counts once you execute test cases against
> ParaBank yourself, per `docs/03_test_plan.md`, Section 11.

**Report Date:** _(fill in your execution date)_
**Application Under Test:** ParaBank demo build, as of test date
**Prepared By:** Laraib Ali
**Test Cycle:** Cycle 1 (Sample)

---

## 1. Execution Summary (Sample)

| Metric | Count |
|---|---|
| Total Test Cases Planned | 62 |
| Test Cases Executed (sample subset) | 22 |
| Passed | 15 |
| Failed | 5 |
| Not Executable — AUT Limitation (OTP/session-timeout not in ParaBank) | 2 |
| Not Executed | 40 |
| **Pass Rate (of executable, executed cases)** | **75%** |

## 2. Module-wise Execution Status (Sample)

| Module | Planned | Executed | Passed | Failed | Not Executable | Not Executed |
|---|---|---|---|---|---|---|
| Authentication | 9 | 5 | 3 | 1 | 1 | 3 |
| Account Management | 5 | 0 | 0 | 0 | 0 | 5 |
| Account Balance | 3 | 0 | 0 | 0 | 0 | 3 |
| Beneficiary Management | 7 | 4 | 3 | 1 | 0 | 3 |
| Fund Transfer | 14 | 9 | 6 | 3 | 0 | 5 |
| Transaction History | 7 | 4 | 3 | 0 | 0 | 3 |
| Logout & Session Mgmt | 6 | 0 | 0 | 0 | 1 | 5 |
| **Total** | **62(approx.)** | **22** | **15** | **5** | **2** | **40(approx.)** |

*(Sample numbers only — see disclaimer above. Totals are approximate across the 62-row set.)*

## 3. Defect Summary (linked to `bug_reports/bug_reports.xlsx`)

| Severity | Count (sample) |
|---|---|
| Critical | 2 |
| High | 6 |
| Medium | 8 |
| Low | 5 |
| **Total** | **21** |

## 4. Key Observations (Sample — illustrative of what a real report should capture)

- **Fund Transfer carries the highest risk** in this cycle: two **Critical** defects
  (BUG-003 double-submit creating duplicate transfers, and BUG-005 negative amounts bypassing
  server-side validation) directly threaten money-safety and must block release.
- **BUG-001** (exact-full-balance transfer incorrectly rejected) is a textbook off-by-one logic
  bug exactly at the boundary tested by BVA — this is why boundary testing matters in a money
  context, not just as an exercise.
- **Authorization checks** (user cannot access another user's account/history) passed in this
  sample cycle — these are exactly the checks that must never regress, so they stay in
  Priority 3 of the Regression Checklist permanently.
- Two scenarios (OTP, hard session timeout) could not be executed against ParaBank and are
  marked "Not Executable — AUT Limitation" rather than guessed at — this is the correct,
  honest way to report a gap in environment coverage.

## 5. Recommendation (Sample)

Based on the sample execution above, **release is NOT recommended** until the two Critical
Fund Transfer defects (BUG-003, BUG-005) are fixed and retested, along with the exact-balance
boundary bug (BUG-001). This kind of risk-based go/no-go call — money-safety bugs block
release even if the overall pass rate looks acceptable — is exactly the judgment a banking QA
engineer is expected to make.

## 6. Sign-off

| Role | Name | Status |
|---|---|---|
| QA Engineer | Laraib Ali | Sample report — pending real execution |
| Test Lead / Reviewer | _(fill in if applicable)_ | — |

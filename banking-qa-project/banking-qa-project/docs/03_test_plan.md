# Test Plan — SecureBank Web Application

**Document Version:** 1.0 | **Author:** Laraib Ali | **Status:** For Portfolio/Demonstration Use

---

### 1. Introduction
This Test Plan defines scope, approach, risk, and schedule for testing SecureBank, tested
against the ParaBank public demo banking application, covering UI, API, and database layers.

### 2. Objectives
- Verify all 7 core banking modules function per `02_functional_requirements.md`.
- Apply formal test design techniques (Boundary Value Analysis, Equivalence Partitioning) —
  not just ad-hoc test ideas — because financial input validation bugs are disproportionately
  costly.
- Document defects with full Bug Life Cycle tracking, as a real banking QA team would.
- Demonstrate layered testing: UI (manual) + API (Postman, all 4 verbs) + DB (SQL).

### 3. Scope

**In Scope:** Authentication, Account Management, Account Balance, Beneficiary Management,
Fund Transfer, Transaction History, Logout & Session Management.

**Out of Scope:** Security penetration testing, load/performance testing, multi-currency
conversion, native mobile apps. (See Functional Requirements doc, "Out of Scope".)

### 4. Test Strategy

| Level | Description | Owner (real team) |
|---|---|---|
| Unit Testing | Individual function correctness | Developers |
| Integration Testing | Module-to-module (e.g., Transfer → Balance → History) | Dev/QA |
| **System Testing** | **End-to-end functional — primary focus of this project** | **QA (this project)** |
| Regression Testing | Re-verify after a change | QA (this project) |
| UAT | Business sign-off | Product/Client |

### 5. Why These Scenarios Matter (the reasoning, not just the list)

The person commissioning this project specifically called out 12 scenarios. Here's the
underlying QA reasoning for each — this is what you should be able to *explain*, not just
recite, in an interview:

| Scenario | Why it's a must-test (the risk it catches) |
|---|---|
| **Invalid login attempts** | First line of defense against unauthorized access; also tests that errors don't leak whether the *username* or *password* was wrong (a common real-world security flaw) |
| **Incorrect OTP** | OTP is the second factor — if it's not actually validated, 2FA is theater, not security |
| **Insufficient account balance** | The single most common real banking bug class: letting a transfer proceed when funds aren't there, overdrawing an account |
| **Zero amount transfer** | A boundary case — ₹0 is technically "not negative," so naive validation (`amount < 0`) can let it through; it should still be rejected as meaningless |
| **Negative amount transfer** | Without server-side validation, a negative "transfer" could function as a hidden credit — a direct fraud vector, not just a UI glitch |
| **Transfer exceeding account balance** | Distinct from "insufficient balance" — tests the exact boundary (balance + 0.01) to catch off-by-one logic errors |
| **Duplicate beneficiary** | Prevents a cluttered/confusing payee list and can mask a social-engineering attempt (same name, different account number) |
| **Invalid beneficiary details** | Malformed account numbers must be caught before money is routed to a non-existent or wrong account |
| **Transaction history verification** | If history doesn't match actual balance changes, the user (and auditors) can't trust the statement — a core trust requirement for any bank |
| **Session timeout** | Shared/public computers are common banking access points; a session that never expires is a direct account-takeover risk |
| **Unauthorized transaction access** | Tests the authorization boundary — can User A see or act on User B's account by guessing/editing a URL or ID? This is one of the most common real-world banking app vulnerabilities (IDOR — Insecure Direct Object Reference) |
| **Duplicate transaction prevention** | Double-clicking Submit, or a network retry, must not create two transfers — this is a classic "idempotency" bug that has caused real financial incidents |

### 6. Test Design Techniques Applied
See `docs/04_test_design_techniques.md` for a full walkthrough of **Boundary Value Analysis**
and **Equivalence Partitioning** as applied to the Fund Transfer amount field — these two
techniques are explicitly called out in the test case set (tagged in the "Technique" column).

### 7. Entry & Exit Criteria

**Entry:** Functional Requirements and Test Scenarios finalized; ParaBank demo accessible;
test data (dummy user, dummy accounts) prepared.

**Exit:** 100% of planned test cases executed (or documented as blocked/skipped with reason);
no open Critical/High defect without a documented workaround; Execution Report and RTM signed
off.

### 8. Test Environment

| Item | Detail |
|---|---|
| Application URL | https://parabank.parasoft.com/parabank/index.htm |
| Browsers | Chrome (primary), Firefox, Edge |
| Test Data | Dummy ParaBank test account (self-registered), fictional amounts only |
| Bug Tracking | Excel, Jira-style columns — `bug_reports/bug_reports.xlsx` |
| API Tool | Postman, against ParaBank's own REST demo API where available, or a generic banking-style practice API |
| DB Tool | Any SQL client against the local sample schema in `sql/db_validation_queries.sql` |

### 9. Risk & Mitigation

| Risk | Mitigation |
|---|---|
| Demo site data/session resets periodically | Re-verify preconditions before each session; register a fresh dummy account if needed |
| OTP/session-timeout not implemented in ParaBank | Those test cases are documented as industry-standard templates; note explicitly when a case couldn't be executed against ParaBank and why |
| No access to real backend/DB | SQL deliverable uses a documented illustrative sample schema you can build locally |
| Limited time as a solo tester | Prioritize Fund Transfer and Authentication first — highest risk modules (see Section 5) |

### 10. Deliverables
Functional Requirements, Test Plan, Test Design Techniques doc, 60+ Test Cases, 20+ Bug
Reports, Bug Life Cycle doc, Test Execution Report, RTM, Regression Checklist, Postman
Collection (GET/POST/PUT/DELETE), SQL Validation Scripts, README.

---

## 11. How to Execute This Project Yourself (step-by-step)

1. **Register a dummy account on ParaBank.** Go to
   `https://parabank.parasoft.com/parabank/register.htm` and self-register with a fake name/
   fake address (never real personal data). This gives you a real username/password and a
   starter checking account with fake funds.
2. **Pick 15–20 test cases** from `test_cases/test_cases.xlsx`, prioritizing Authentication
   and Fund Transfer (highest risk, per Section 5).
3. **Execute each step literally**, using the Test Data given (adapt account numbers to the
   ones ParaBank actually assigned you).
4. **Record the real Actual Result and Status** — don't assume Pass.
5. **For scenarios ParaBank can't support** (OTP, hard session-timeout), mark Status as
   "Not Executable — AUT Limitation" and note it, rather than faking a result. This is itself
   a correct, professional QA judgment call.
6. **Log every real mismatch** as a bug in `bug_reports/bug_reports.xlsx`, and walk it through
   the Bug Life Cycle stages described in `docs/05_bug_life_cycle.md`.
7. **Run the Regression Checklist** once, end-to-end.
8. **Try the Postman collection** — ParaBank exposes `/parabank/services/bank/...` REST
   endpoints you can call directly (no auth needed for several GETs); the collection is also
   written to work against a generic banking-style practice API as a fallback.
9. **Run the SQL scripts** against a local schema (MySQL/PostgreSQL/SQLite) — the file includes
   the `CREATE TABLE` statements.
10. **Fill in `reports/test_execution_report.md`** with your real results.

Doing 1–10 with even 15–20 test cases gives you genuine, interview-ready experience testing a
financial application — including knowing *when a scenario can't be tested against your
environment and saying so*, which is itself a real QA skill.

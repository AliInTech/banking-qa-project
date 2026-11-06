# Project Overview — SecureBank Web Application Testing Project

## 1. Why this project exists

This is a **portfolio project for learning and demonstration purposes**. There is no real bank
behind it. To make the test cases actually reproducible, the project is designed against a
well-known **public banking demo application built specifically for QA practice**:

**Application Under Test (AUT):** [ParaBank](https://parabank.parasoft.com/parabank/index.htm)
— a free, open demo online banking application (by Parasoft) used worldwide by QA learners.
It uses fake money and fake accounts only — nothing here touches a real bank.

> ⚠️ **Critical safety note, stated once and followed throughout this entire project:**
> **Never use real bank account numbers, real card numbers, real OTPs, real CVVs, or real
> personal financial data anywhere in this project** — not in test data, screenshots, or bug
> reports. All data below (account numbers, names, amounts) is fictional/dummy data generated
> for testing purposes only, the same way `4111 1111 1111 1111` is a universally recognized
> dummy Visa test number, never a real card.

> **Honesty note for interviews:** Everything here falls into one of two buckets, and both are
> labeled throughout: (a) **planning/design artifacts you authored** — Functional
> Requirements, Test Plan, Test Cases, RTM, Regression Checklist — and (b) **sample/illustrative
> data** — Bug Reports and the Execution Report — which show the correct *format and reasoning*
> and are clearly marked as not-yet-executed until you run them yourself.

## 2. Application Modules in Scope

| # | Module | What it covers |
|---|--------|-----------------|
| 1 | User Authentication | Login, invalid login handling, OTP (where applicable), account lockout |
| 2 | Account Management | View account details, open new account, update contact info |
| 3 | Account Balance | View current/available balance per account |
| 4 | Beneficiary Management | Add/edit/delete a payee (beneficiary), duplicate/invalid payee handling |
| 5 | Fund Transfer | Transfer between own accounts and to a beneficiary, validations |
| 6 | Transaction History | View, filter, and verify past transactions |
| 7 | Logout & Session Management | Logout, session timeout, unauthorized access after logout |

> **Mapping note:** ParaBank's closest equivalents are: **Login** → Authentication,
> **Accounts Overview** → Account Balance, **Open New Account** → Account Management,
> **Transfer Funds** → Fund Transfer, **Pay Bills** → closest working equivalent to
> Beneficiary Management (adding a new payee), **Find Transactions** → Transaction History,
> **Log Out** → Session Management. ParaBank does **not** implement OTP or true session-timeout
> enforcement, so those specific test cases (clearly marked below) are written as
> **industry-standard templates** — correct and interview-ready, but to be executed against a
> real banking **staging/sandbox environment** if you get access to one (e.g., during an
> internship), rather than against ParaBank.

## 3. Project Goal

Demonstrate the full QA lifecycle for a security- and money-sensitive application: Functional
Requirements → Test Planning → Test Design (with formal techniques: BVA, Equivalence
Partitioning) → Test Execution (sample) → Defect Reporting → Bug Life Cycle → Traceability →
Regression → API Testing (all 4 HTTP verbs) → DB Validation.

## 4. Why Banking Apps Need Extra Rigor (the reasoning, not just the checklist)

Banking is a **high-risk domain**: a single bug can mean a user loses money, sees someone
else's data, or transfers funds twice. This project is written to specifically exercise the
failure modes that matter most in banking QA:

- **Money-safety bugs**: negative amounts, zero amounts, amounts exceeding balance, floating-
  point rounding errors, duplicate submission (double-click) causing a double transfer.
- **Identity/authorization bugs**: one user accessing another user's account data/transactions,
  session not expiring, acting after logout.
- **Data-integrity bugs**: a transfer debiting one account without crediting the other,
  mismatched transaction history vs. actual balance.

This project is deliberately structured so every "Important Test Scenario" the user listed
maps to one of these three risk categories — see `docs/03_test_plan.md` Section 5 for why each
one matters.

## 5. Repository Structure

```
banking-qa-project/
│
├── README.md
│
├── docs/
│   ├── 01_project_overview.md
│   ├── 02_functional_requirements.md
│   ├── 03_test_plan.md
│   ├── 04_test_design_techniques.md      # BVA + Equivalence Partitioning, explained
│   └── 05_bug_life_cycle.md
│
├── test_cases/
│   └── test_cases.xlsx                    # 60+ test cases (functional + BVA + EP tagged)
│
├── bug_reports/
│   └── bug_reports.xlsx                   # 20+ sample bug reports with lifecycle status
│
├── reports/
│   └── test_execution_report.md
│
├── rtm/
│   └── requirement_traceability_matrix.xlsx
│
├── regression/
│   └── regression_checklist.md
│
├── api_testing/
│   ├── api_test_scenarios.md
│   └── Banking_API_Collection.postman_collection.json   # GET, POST, PUT, DELETE
│
├── sql/
│   └── db_validation_queries.sql
│
└── screenshots/
```

## 6. How to Use This Repository
See `docs/03_test_plan.md` Section 7 ("How to Execute This Project Yourself") for the full
step-by-step guide to actually running this against ParaBank, Postman, and a local SQL
database.

# SecureBank — Banking Web Application: Functional, Manual & API Testing Portfolio Project

A complete, end-to-end **manual QA testing project** for a banking application, built to
demonstrate practical software testing skills for a QA Testing Intern / Fresher role:
functional requirements, formal test design techniques (BVA, Equivalence Partitioning), test
case design, Jira-style defect reporting with full Bug Life Cycle tracking, requirement
traceability, regression testing, API testing (GET/POST/PUT/DELETE), and database validation.

> 📌 **Honest framing for recruiters/interviewers:** This is a self-driven practice project
> built against [ParaBank](https://parabank.parasoft.com/parabank/index.htm) — a free, public
> demo banking application created specifically for QA practice, using fake accounts and fake
> money only. It is **not** a real bank, and no real banking credentials or financial data
> appear anywhere in this project. The planning documents (Functional Requirements, Test Plan,
> Test Design Techniques, Test Cases, RTM, Regression Checklist, Bug Life Cycle) are original
> work. The Bug Reports and Test Execution Report contain **sample/illustrative data**, clearly
> labeled, showing correct format and reasoning until replaced with real results from your own
> execution.

## 📁 Repository Structure

```
banking-qa-project/
├── README.md
├── docs/
│   ├── 01_project_overview.md         # App modules + AUT mapping + repo guide
│   ├── 02_functional_requirements.md  # 34+ functional requirements across 7 modules
│   ├── 03_test_plan.md                # Test plan + "why these scenarios matter" + execution guide
│   ├── 04_test_design_techniques.md   # BVA & Equivalence Partitioning, taught with worked examples
│   └── 05_bug_life_cycle.md           # Bug Life Cycle states + Severity vs Priority
├── test_cases/
│   └── test_cases.xlsx                # 62 test cases (functional, BVA, EP tagged)
├── bug_reports/
│   └── bug_reports.xlsx               # 21 sample Jira-style bug reports with life-cycle status
├── reports/
│   └── test_execution_report.md       # Sample execution summary & release recommendation
├── rtm/
│   └── requirement_traceability_matrix.xlsx
├── regression/
│   └── regression_checklist.md        # Priority-tiered, money-safety-first checklist
├── api_testing/
│   ├── api_test_scenarios.md
│   └── Banking_API_Collection.postman_collection.json   # GET, POST, PUT, DELETE
├── sql/
│   └── db_validation_queries.sql      # Schema + 15 runnable DB validation queries
└── screenshots/                       # Add your own real screenshots here when you execute
```

## 🎯 What This Project Covers

| Deliverable | What it proves you can do |
|---|---|
| Functional Requirements | Translate a high-risk (financial) domain into testable requirements |
| Test Plan | Plan scope, risk, environment, and explain *why* each scenario matters |
| Test Design Techniques | Apply formal BVA & Equivalence Partitioning, not just ad-hoc test ideas |
| 62 Test Cases | Write clear, reproducible, positive + negative + boundary test steps |
| 21 Bug Reports | Report defects the way a real team expects — severity vs priority, life-cycle status |
| Bug Life Cycle | Understand and explain how a bug moves from New → Verified/Closed |
| RTM | Prove every requirement has test coverage |
| Regression Checklist | Prioritize money-safety and authorization checks first, not a flat re-test-everything list |
| Test Execution Report | Summarize results and make a risk-based release go/no-go call |
| Postman Collection | Test all 4 core HTTP verbs — GET, POST, PUT, DELETE — against a real banking API |
| SQL Validation Queries | Verify money-safety and data integrity at the database layer |

## 🚀 Quick Start — How to Actually Use This Project

1. **Read first:** `docs/01_project_overview.md` → `02_functional_requirements.md` →
   `03_test_plan.md` → `04_test_design_techniques.md`
2. **Register a dummy account** on https://parabank.parasoft.com/parabank/register.htm using
   fake details (never real personal data)
3. **Open** `test_cases/test_cases.xlsx` and execute 15–20 cases manually, prioritizing
   Authentication and Fund Transfer (see Test Plan Section 5 for why these are highest-risk)
4. **Log real bugs** you find in `bug_reports/bug_reports.xlsx`, walking each through the
   Bug Life Cycle states described in `docs/05_bug_life_cycle.md`
5. **Run** `regression/regression_checklist.md` end to end
6. **Import** `api_testing/Banking_API_Collection.postman_collection.json` into Postman and
   run it against ParaBank's real REST endpoints
7. **Run** the queries in `sql/db_validation_queries.sql` against a local sample DB (schema
   included — works on MySQL, PostgreSQL, SQLite, or db-fiddle.com)
8. **Update** `reports/test_execution_report.md` with your real pass/fail numbers

## 🛠️ Tools & Tech Used
Manual Testing · Excel (test case & bug repository) · Jira-style defect fields with full Bug
Life Cycle · Postman (GET/POST/PUT/DELETE API testing) · SQL (MySQL/PostgreSQL syntax) ·
Boundary Value Analysis · Equivalence Partitioning · Markdown documentation

## 🗣️ How to Talk About This Project in an Interview

- *"I built a full QA documentation set for a banking application — functional requirements,
  a risk-based test plan, 62 test cases using formal BVA and Equivalence Partitioning, and an
  RTM — then executed a subset manually against a live demo banking app."*
- *"I specifically tested money-safety edge cases: zero and negative transfer amounts,
  transferring the exact account balance (a classic off-by-one boundary), and double-submit
  duplicate-transaction prevention — because in banking, these are the highest-cost bug
  categories."*
- *"I tracked bugs through a full life cycle, not just 'open/closed' — and I set Severity and
  Priority independently, for example rating a decline-handling bug Critical severity because
  it breaks core money-moving logic."*
- *"I tested beyond the UI — API tests covering all 4 HTTP verbs in Postman, plus SQL queries
  that check things like 'does the sum of all balances stay the same after an internal
  transfer' — because UI-only testing misses backend data-integrity bugs."*
- *"When a scenario like OTP or hard session-timeout wasn't supported by the demo app I had
  access to, I documented it as 'Not Executable — AUT Limitation' rather than guessing — I
  know the difference between a failed test and an untestable environment."*

## ⚠️ Safety Note
No real banking credentials, card numbers, OTPs, or personal financial data are used anywhere
in this project. All account numbers, names, and amounts are fictional test data.

## 📄 License / Use
Free to use and adapt for your own learning/portfolio. Replace the sample execution and bug
data with your own real results before presenting this as "executed" work.

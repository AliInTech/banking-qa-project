# Bug Life Cycle Documentation

A bug doesn't just go from "found" to "fixed" — it moves through a defined set of states, and
knowing this flow (and being able to draw/explain it) is one of the most commonly asked
interview topics for a QA fresher. This document explains the standard life cycle and how it's
applied to the bugs in `bug_reports/bug_reports.xlsx`.

## 1. Standard Bug Life Cycle States

```
   New
    │
    ▼
 Assigned ──────────────┐
    │                    │
    ▼                    ▼
 In Progress          Rejected (not a valid bug / cannot reproduce)
    │                    │
    ▼                    ▼
   Fixed              Closed
    │
    ▼
 Ready for Retest
    │
    ▼
 Retest ──────┬─────────────┐
    │          │             │
    ▼          ▼             ▼
 Verified   Reopened      Reopened
 (Pass)     (Fail —       (Fail —
    │        same root     found
    │        cause)        elsewhere)
    ▼
 Closed
```

## 2. State Definitions

| State | Meaning |
|---|---|
| **New** | Tester has just logged the defect; no one has reviewed it yet |
| **Assigned** | A lead/triage has reviewed it and assigned it to a specific developer |
| **In Progress** | Developer is actively working on a fix |
| **Fixed** | Developer believes the issue is resolved and has deployed/merged the fix |
| **Ready for Retest** | Fix has reached the test environment; QA is notified to retest |
| **Retest** | QA is re-executing the original failing steps against the fix |
| **Verified / Closed** | QA confirms the fix works as expected; bug is closed |
| **Reopened** | QA retested and the bug still occurs (same cause) or a related issue surfaced — goes back to "Assigned" |
| **Rejected** | Developer/lead determines this isn't a real bug (e.g., working as designed, duplicate, or not reproducible) |
| **Deferred** | Valid bug, but postponed to a future release (common for Low-severity, non-blocking issues) |

## 3. Severity vs. Priority — the distinction interviewers love to probe

These are **two different axes**, and conflating them is the #1 mistake fresher candidates
make:

- **Severity** = how badly the bug damages the application (technical impact)
- **Priority** = how soon it needs to be fixed (business urgency)

| Example | Severity | Priority | Why |
|---|---|---|---|
| Payment confirms "success" but money isn't actually deducted correctly | Critical | Critical | Breaks core function AND must be fixed before any release |
| Company logo is misaligned by 2px on the login page | Low | Low | Minor cosmetic issue, no functional impact |
| A typo in a legal disclaimer text ("Your funds is secure") | Low | High | Doesn't break functionality (Low severity) but is urgent for compliance/brand reasons (High priority) — this is the classic example showing severity ≠ priority |
| A rarely-used admin report page crashes | High | Low | Technically breaks a whole page (High severity) but almost no one uses it, so it can wait (Low priority) |

## 4. How This Is Applied in `bug_reports/bug_reports.xlsx`

Every bug in the sheet has both a **Severity** and **Priority** column, set independently using
the reasoning above (not just copied from each other), plus a **Status** column reflecting a
life-cycle state from Section 1 — all currently set to **"New"** since these are sample/
illustrative bugs not yet triaged by a real team. When you log real bugs you find while
executing, walk them through actual states as you (simulating a dev/retest cycle, or genuinely
retesting after a day) move them along — this is what demonstrates you understand the life
cycle isn't just a diagram, it's a workflow.

## 5. Practicing This Yourself
When you find a real bug while executing this project:
1. Log it with Status = **New**.
2. Pretend-triage it: decide Severity and Priority independently using the table in Section 3.
3. After a day (simulating a fix cycle), re-test the same steps.
4. If it's still broken, log that as a **Reopened** note; if ParaBank happens to have changed
   (unlikely for a demo), mark **Verified / Closed**.
5. Be ready to say in an interview: *"I track severity and priority independently — for
   example, I found X, which I rated severity Y because Z, and priority W because..."*

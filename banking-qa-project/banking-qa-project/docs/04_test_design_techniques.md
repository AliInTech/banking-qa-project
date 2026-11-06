# Test Design Techniques — Boundary Value Analysis & Equivalence Partitioning

These are two formal, interview-favorite test design techniques. This document teaches you
*how to derive* test cases with them (not just shows you the output), using the **Fund
Transfer amount field** as the worked example, then shows where else in this project they're
applied.

---

## 1. Equivalence Partitioning (EP)

**The idea:** You can never test every possible input. EP groups all possible inputs into
"partitions" (buckets) where, logically, every value in a bucket should behave the same way.
You then test **one representative value per bucket** instead of every value — this gets you
strong coverage with far fewer test cases.

### Worked example: Fund Transfer "Amount" field
Rule: amount must be a positive number, greater than 0, and not exceeding the available
balance (say the account has $1,000 available).

| Partition | Range / Description | Example Test Value | Expected Result |
|---|---|---|---|
| P1 — Invalid (negative) | amount < 0 | -50 | Rejected |
| P2 — Invalid (zero) | amount = 0 | 0 | Rejected |
| P3 — Valid | 0 < amount ≤ 1000 | 500 | Accepted |
| P4 — Invalid (exceeds balance) | amount > 1000 | 1500 | Rejected |
| P5 — Invalid (non-numeric) | letters/symbols | "abc", "$100" | Rejected / field validation error |
| P6 — Invalid (empty) | blank field | "" | Rejected / required-field error |

**Reasoning:** Instead of testing 1, 2, 3, 4... 999, 1000, 1001 one by one, EP says: pick ONE
value from P1, ONE from P3, etc. If the system handles -50 correctly, it's reasonable to infer
it handles -1, -999, etc. the same way, *because they're in the same logical partition*.

This is why the test case set has far fewer cases than "every possible number," but still
catches every category of bug.

---

## 2. Boundary Value Analysis (BVA)

**The idea:** Most real bugs happen **at the edges** of a valid range, not in the middle — an
`if (amount <= 1000)` typo where it should be `<` is invisible if you only test 500, but
instantly visible if you test exactly 1000 and 1001. BVA says: **always test the boundary
value itself, one value just below it, and one value just above it.**

### Worked example: same Fund Transfer field, balance = $1,000

| Boundary | Test Value | Why this exact value | Expected Result |
|---|---|---|---|
| Just below minimum | -1 | One unit into "invalid negative" territory | Rejected |
| Minimum boundary | 0 | The exact "zero" edge case | Rejected |
| Just above minimum | 0.01 | Smallest possible valid transfer | Accepted |
| Just below maximum | 999.99 | One cent under the full balance | Accepted |
| Maximum boundary | 1000.00 | Transferring the EXACT full balance | Accepted (this is the trickiest one — many systems wrongly reject it due to `<` vs `<=` bugs) |
| Just above maximum | 1000.01 | One cent over balance | Rejected — "Insufficient balance" |

**Reasoning:** The pair **1000.00 (should pass) vs 1000.01 (should fail)** is the single most
valuable test pair in this whole module. It's where off-by-one logic errors in the code
(`amount <= balance` vs `amount < balance`) actually surface. This is exactly the difference
between "Transfer exceeding account balance" (clearly over) and "Insufficient balance" as two
distinct scenarios in the requirements — BVA is what makes that distinction testable, not just
theoretical.

---

## 3. Where EP and BVA Are Applied in This Project

Open `test_cases/test_cases.xlsx` and check the **"Technique"** column — every test case
derived using one of these methods is explicitly tagged `EP` or `BVA`, applied to:
- Fund Transfer amount field (as worked above)
- Login password field (length boundaries)
- Beneficiary account number field (valid length range)
- OTP field (valid numeric length, e.g., exactly 6 digits)

### Quick reference: how to apply this to ANY input field yourself
1. **List the valid range/rule** for the field (e.g., "password must be 8–20 characters").
2. **For EP:** identify every logically distinct bucket (too short, valid, too long, contains
   invalid characters, empty) and pick one representative value from each.
3. **For BVA:** take every numeric boundary in the rule (8 and 20, in this example) and test:
   one below, exactly on, and one above each boundary (7, 8, 9, 19, 20, 21).
4. Write one test case per value you picked. That's it — this is the entire method.

This is a reusable skill: apply the same 4 steps to any field in any application (age field,
discount percentage, quantity selector) and you'll have systematically strong coverage instead
of guessing.

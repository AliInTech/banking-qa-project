-- =====================================================================
-- SecureBank — Database Validation Queries (QA Portfolio Project)
-- =====================================================================
-- Written against a SIMPLIFIED SAMPLE SCHEMA representing what a typical
-- banking backend would expose. Run SECTION 0 first (on MySQL, PostgreSQL,
-- or SQLite / db-fiddle.com) to build the schema and sample data, then run
-- each query below individually to practice real DB-level validation.
--
-- NOTE: All account numbers, names, and amounts below are entirely
-- fictional dummy data. Never substitute real banking details here.
-- =====================================================================

-- ---------------------------------------------------------------------
-- SECTION 0: Sample Schema (run this first to try the queries yourself)
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS payees;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id    INT PRIMARY KEY,
    first_name     VARCHAR(60),
    last_name      VARCHAR(60),
    username       VARCHAR(60) UNIQUE NOT NULL,
    password_hash  VARCHAR(255) NOT NULL,
    email          VARCHAR(100),
    created_at     DATETIME
);

CREATE TABLE accounts (
    account_id     INT PRIMARY KEY,
    customer_id    INT NOT NULL,
    account_type   VARCHAR(30) NOT NULL,     -- Checking, Savings
    balance        DECIMAL(12,2) NOT NULL DEFAULT 0,
    opened_at      DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE payees (
    payee_id       INT PRIMARY KEY,
    customer_id    INT NOT NULL,
    payee_name     VARCHAR(100) NOT NULL,
    payee_account  VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
    transaction_id   INT PRIMARY KEY,
    from_account_id  INT NULL,
    to_account_id    INT NULL,
    amount           DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,   -- Transfer, Deposit, Withdrawal
    status           VARCHAR(20) NOT NULL,   -- Completed, Failed, Pending
    created_at       DATETIME,
    FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(account_id)
);

-- Sample data
INSERT INTO customers VALUES
 (1,'Riya','Sharma','testuser_qa1','$2y$hash1','riya.sharma+test1@mailinator.com','2026-10-01 10:00:00'),
 (2,'Arjun','Mehta','arjun_mehta_qa','$2y$hash2','arjun.mehta@mailinator.com','2026-10-02 11:30:00');

INSERT INTO accounts VALUES
 (13344,1,'Checking',1000.00,'2026-10-01 10:05:00'),
 (13455,1,'Savings',500.00,'2026-10-01 10:06:00'),
 (13566,2,'Checking',250.00,'2026-10-02 11:35:00');

INSERT INTO payees VALUES
 (1,1,'Arjun Mehta','13566');

INSERT INTO transactions VALUES
 (9001,13344,13455,200.00,'Transfer','Completed','2026-11-01 09:00:00'),
 (9002,13344,13566,150.00,'Transfer','Completed','2026-11-02 14:20:00'),
 (9003,13455,13344,0.00,'Transfer','Completed','2026-11-02 14:25:00');  -- intentionally flawed sample row: $0 transfer that should never have been allowed, used by Q6 below

-- =====================================================================
-- SECTION 1: Account / Balance validation
-- =====================================================================

-- Q1: Verify an account's current balance (cross-check vs what the UI shows)
SELECT account_id, account_type, balance
FROM accounts
WHERE account_id = 13344;

-- Q2: Verify balance never goes negative (a negative balance should never
--     exist in a correctly-functioning system — feeds BUG-005 root-cause check)
SELECT account_id, balance
FROM accounts
WHERE balance < 0;
-- Expected: 0 rows returned

-- Q3: Verify a transfer correctly debited the source and credited the
--     destination by the SAME amount (REQ-TXN-08 atomicity check)
SELECT t.transaction_id, t.from_account_id, t.to_account_id, t.amount,
       a_from.balance AS from_account_current_balance,
       a_to.balance AS to_account_current_balance
FROM transactions t
JOIN accounts a_from ON a_from.account_id = t.from_account_id
JOIN accounts a_to ON a_to.account_id = t.to_account_id
WHERE t.transaction_id = 9001;
-- Manually verify: from_account balance reflects a decrease of 200.00,
-- to_account balance reflects an increase of 200.00, relative to their
-- balances immediately before this transaction.

-- =====================================================================
-- SECTION 2: Transaction / money-safety validation (highest risk area)
-- =====================================================================

-- Q4: Find any transaction with a negative amount — should NEVER exist
--     (feeds BUG-005: negative transfer validation bypass)
SELECT * FROM transactions WHERE amount < 0;
-- Expected: 0 rows returned. Any row here is a Critical data-integrity bug.

-- Q5: Find any completed transaction with amount = 0 — should not be
--     allowed to complete (feeds BUG-002: zero-amount transfer)
SELECT * FROM transactions WHERE amount = 0 AND status = 'Completed';
-- Expected: 0 rows returned (the sample row 9003 above intentionally
-- demonstrates what this looks like when the bug IS present)

-- Q6: Detect potential duplicate transactions — same accounts, same
--     amount, within a very short time window (feeds BUG-003: double-click
--     duplicate submission)
SELECT t1.transaction_id AS txn_1, t2.transaction_id AS txn_2,
       t1.from_account_id, t1.to_account_id, t1.amount,
       t1.created_at AS time_1, t2.created_at AS time_2
FROM transactions t1
JOIN transactions t2
  ON t1.from_account_id = t2.from_account_id
 AND t1.to_account_id   = t2.to_account_id
 AND t1.amount          = t2.amount
 AND t1.transaction_id  < t2.transaction_id
WHERE ABS(TIMESTAMPDIFF(SECOND, t1.created_at, t2.created_at)) <= 5;  -- MySQL syntax; adapt for other engines
-- Expected: 0 rows returned in a healthy system. Any pair found here is a
-- likely duplicate-transaction bug worth investigating manually.

-- Q7: Verify total money in the system is conserved for internal transfers
--     (sum of all balances should only change due to external
--     deposits/withdrawals, never due to a transfer between two accounts)
SELECT SUM(balance) AS total_system_balance FROM accounts;
-- Run before and after a transfer between two accounts in the system —
-- the total must remain IDENTICAL for an internal transfer (money moved,
-- not created or destroyed).

-- =====================================================================
-- SECTION 3: Beneficiary / Payee validation
-- =====================================================================

-- Q8: Detect duplicate beneficiaries for the same customer (same name +
--     account number saved more than once) — feeds BUG-006
SELECT customer_id, payee_name, payee_account, COUNT(*) AS cnt
FROM payees
GROUP BY customer_id, payee_name, payee_account
HAVING COUNT(*) > 1;
-- Expected: 0 rows returned

-- Q9: Find payees with a non-numeric or malformed account number —
--     feeds BUG-007
SELECT payee_id, payee_name, payee_account
FROM payees
WHERE payee_account NOT REGEXP '^[0-9]+$';  -- MySQL syntax; use ~ '^[0-9]+$' in PostgreSQL
-- Expected: 0 rows returned

-- =====================================================================
-- SECTION 4: Authorization / data-isolation validation
-- =====================================================================

-- Q10: Verify an account truly belongs to the customer it's displayed
--      under (cross-check feeding REQ-ACC-05 authorization boundary test)
SELECT a.account_id, a.customer_id, c.username
FROM accounts a
JOIN customers c ON c.customer_id = a.customer_id
WHERE a.account_id = 13344;
-- Confirm this matches exactly the logged-in user shown in the UI test —
-- any mismatch would mean account ownership data itself is wrong, a
-- severe data-integrity issue distinct from a UI-layer authorization bug.

-- Q11: Verify no transaction references an account outside its owning
--      customer's own accounts without a valid payee/transfer relationship
--      (basic sanity check — transfers should only touch accounts the
--      transaction's initiating customer is authorized to use)
SELECT t.transaction_id, t.from_account_id, a.customer_id AS from_owner
FROM transactions t
JOIN accounts a ON a.account_id = t.from_account_id;
-- Manually cross-check from_owner against the customer who actually
-- initiated each transaction in your test session.

-- =====================================================================
-- SECTION 5: Referential integrity & NFR checks
-- =====================================================================

-- Q12: Verify no orphaned transactions (every transaction must reference
--      real, existing accounts)
SELECT t.*
FROM transactions t
LEFT JOIN accounts a1 ON a1.account_id = t.from_account_id
LEFT JOIN accounts a2 ON a2.account_id = t.to_account_id
WHERE (t.from_account_id IS NOT NULL AND a1.account_id IS NULL)
   OR (t.to_account_id IS NOT NULL AND a2.account_id IS NULL);
-- Expected: 0 rows returned

-- Q13: Verify no duplicate usernames exist (REQ-AUTH basic integrity)
SELECT username, COUNT(*) AS cnt
FROM customers
GROUP BY username
HAVING COUNT(*) > 1;
-- Expected: 0 rows returned

-- Q14: Verify passwords are never stored in plain text (NFR-01) — sanity
--      check that password_hash values look hashed, not plain
SELECT customer_id, username, password_hash
FROM customers
WHERE LENGTH(password_hash) < 20;   -- a real bcrypt/argon2 hash is much longer
-- Expected: 0 rows returned (any row here is a serious NFR-01 violation)

-- Q15: Verify a customer's full transaction history only includes their
--      own accounts (feeds REQ-HIST-05 — user sees only own transactions)
SELECT t.transaction_id, t.amount, t.created_at
FROM transactions t
WHERE t.from_account_id IN (SELECT account_id FROM accounts WHERE customer_id = 1)
   OR t.to_account_id   IN (SELECT account_id FROM accounts WHERE customer_id = 1)
ORDER BY t.created_at DESC;
-- Cross-check this result set against exactly what the Transaction History
-- UI page shows when logged in as customer_id = 1 — no more, no fewer rows.

-- =====================================================================
-- How to run this yourself:
-- 1. Use a free DB (MySQL, PostgreSQL, SQLite) or an online sandbox like
--    https://www.db-fiddle.com (choose MySQL dialect for exact syntax match).
-- 2. Run SECTION 0 to create the schema and sample data.
-- 3. Run each SELECT individually and compare the result against what you'd
--    expect the corresponding UI screen (or API response) to show.
-- 4. When a query reveals a mismatch, log it as a bug using the same format
--    as bug_reports/bug_reports.xlsx and walk it through the Bug Life Cycle.
-- =====================================================================

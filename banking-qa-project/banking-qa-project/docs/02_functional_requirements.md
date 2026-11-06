# Functional Requirements — SecureBank Web Application

**Reference Application:** ParaBank demo (https://parabank.parasoft.com) — see
`01_project_overview.md` for module mapping and scope notes.

---

## Module 1: User Authentication

| Req ID | Requirement |
|---|---|
| REQ-AUTH-01 | User shall log in using a valid Username and Password |
| REQ-AUTH-02 | System shall reject login with incorrect password and show a generic error (not revealing whether username or password was wrong) |
| REQ-AUTH-03 | System shall reject login with a non-existent username |
| REQ-AUTH-04 | System shall lock or throttle the account after N consecutive failed login attempts (industry-standard control; template requirement — see module mapping note) |
| REQ-AUTH-05 | Where OTP/2FA is implemented, system shall validate OTP correctness and expiry before granting access (template requirement) |
| REQ-AUTH-06 | System shall not expose the password in plaintext anywhere in the UI, URL, or client-side storage |

## Module 2: Account Management

| Req ID | Requirement |
|---|---|
| REQ-ACC-01 | Logged-in user shall be able to view a list of their own accounts only |
| REQ-ACC-02 | User shall be able to open a new account of a valid type (e.g., Checking, Savings) |
| REQ-ACC-03 | User shall be able to update contact information (address, phone, email) |
| REQ-ACC-04 | System shall validate contact info fields (valid email format, phone format) |
| REQ-ACC-05 | A user shall NOT be able to view or act on another user's account data (authorization boundary) |

## Module 3: Account Balance

| Req ID | Requirement |
|---|---|
| REQ-BAL-01 | System shall display the current balance for each of the user's accounts accurately |
| REQ-BAL-02 | Balance shall update immediately and correctly after a completed transaction |
| REQ-BAL-03 | Balance shall be displayed with correct currency formatting and 2 decimal precision |
| REQ-BAL-04 | System shall distinguish "available balance" from "total balance" where holds/pending transactions exist (template requirement) |

## Module 4: Beneficiary Management

| Req ID | Requirement |
|---|---|
| REQ-BEN-01 | User shall be able to add a new beneficiary/payee with valid details (name, account number) |
| REQ-BEN-02 | System shall reject a beneficiary with invalid/malformed account number |
| REQ-BEN-03 | System shall detect and prevent/warn on a duplicate beneficiary (same name + account number already saved) |
| REQ-BEN-04 | User shall be able to edit an existing beneficiary's details |
| REQ-BEN-05 | User shall be able to delete a beneficiary |
| REQ-BEN-06 | System shall validate all mandatory beneficiary fields are filled before saving |

## Module 5: Fund Transfer

| Req ID | Requirement |
|---|---|
| REQ-TXN-01 | User shall be able to transfer funds between their own accounts |
| REQ-TXN-02 | User shall be able to transfer funds to a saved beneficiary |
| REQ-TXN-03 | System shall reject a transfer of ₹0 / $0 (zero amount) |
| REQ-TXN-04 | System shall reject a negative transfer amount |
| REQ-TXN-05 | System shall reject a transfer amount exceeding the available account balance |
| REQ-TXN-06 | System shall reject a transfer with insufficient balance and show a clear, specific error |
| REQ-TXN-07 | System shall prevent duplicate transaction submission (e.g., double-click on Submit creating two transfers) |
| REQ-TXN-08 | System shall correctly debit the source account and credit the destination account atomically (both happen, or neither) |
| REQ-TXN-09 | System shall show a confirmation with a unique transaction reference ID after a successful transfer |
| REQ-TXN-10 | System shall validate the transfer amount field accepts only valid numeric input (no letters/special characters) |

## Module 6: Transaction History

| Req ID | Requirement |
|---|---|
| REQ-HIST-01 | User shall be able to view a list of past transactions for a selected account |
| REQ-HIST-02 | User shall be able to search/filter transactions (by date, amount, or ID) |
| REQ-HIST-03 | Every completed transfer shall appear in transaction history within an acceptable time (near real-time) |
| REQ-HIST-04 | Transaction history entries shall match the actual debit/credit amounts exactly (no rounding mismatch) |
| REQ-HIST-05 | A user shall only see transactions belonging to their own accounts |

## Module 7: Logout & Session Management

| Req ID | Requirement |
|---|---|
| REQ-SESS-01 | User shall be able to log out manually via a visible Logout control |
| REQ-SESS-02 | After logout, the user shall not be able to access account pages via browser back button |
| REQ-SESS-03 | Session shall expire automatically after a defined period of inactivity (template requirement) |
| REQ-SESS-04 | After session expiry, any attempted action shall redirect to Login, not silently fail |
| REQ-SESS-05 | A user shall not be able to perform any account action without a valid, active session (no unauthorized/direct-URL access) |

## Non-Functional Requirements

| Req ID | Requirement |
|---|---|
| NFR-01 | All sensitive data (passwords) shall be masked in the UI and never logged in plaintext |
| NFR-02 | Application shall respond to balance/transfer actions within 3 seconds under normal load |
| NFR-03 | Application shall be usable on Chrome, Firefox, and Edge (latest 2 versions) |
| NFR-04 | All monetary values shall use consistent currency formatting across every screen |
| NFR-05 | Error messages shall be clear and shall never expose internal system/stack trace details |

## Out of Scope
Penetration/security testing, load/stress testing, native mobile apps, multi-currency
conversion logic, real payment gateway integration.

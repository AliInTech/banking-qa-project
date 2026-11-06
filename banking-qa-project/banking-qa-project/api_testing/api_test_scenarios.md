# API Testing Scenarios — SecureBank Backend

ParaBank actually exposes a **real REST API** you can call directly — no mock needed:
`https://parabank.parasoft.com/parabank/services/bank/...` — which is why this project is
built to be genuinely executable, not just a template. A WSDL/REST reference is linked from
the ParaBank site itself ("About" → API documentation). Where ParaBank's API doesn't cover a
scenario (e.g., DELETE on a beneficiary), the collection falls back to a generic banking-style
practice API shape so the request/test-script pattern is still runnable and interview-ready.

## Scenario Group 1: Accounts (GET)

| ID | Scenario | Method & Endpoint | Expected Status | Key Assertions |
|---|---|---|---|---|
| API-01 | Get all accounts for a customer | GET `/customers/{customerId}/accounts` | 200 | Response is an array; each account has `id`, `type`, `balance` |
| API-02 | Get a single account by ID | GET `/accounts/{accountId}` | 200 | Returned `id` matches requested account ID |
| API-03 | Get account with invalid/non-existent ID | GET `/accounts/999999999` | 404 (or documented error body) | No 500 server error; clean error response |
| API-04 | Get transactions for an account | GET `/accounts/{accountId}/transactions` | 200 | Response is an array of transaction objects |

## Scenario Group 2: Authentication (POST)

| ID | Scenario | Method & Endpoint | Expected Status | Key Assertions |
|---|---|---|---|---|
| API-05 | Login with valid credentials | POST `/login/{username}/{password}` | 200 | Response contains valid customer details |
| API-06 | Login with invalid password | POST `/login/{username}/{wrongpassword}` | 401/error body | No customer data returned |

## Scenario Group 3: Fund Transfer (POST)

| ID | Scenario | Method & Endpoint | Expected Status | Key Assertions |
|---|---|---|---|---|
| API-07 | Transfer valid amount between accounts | POST `/transfer?fromAccountId=X&toAccountId=Y&amount=100` | 200 | Response confirms transfer; source/destination balances update |
| API-08 | Transfer negative amount | POST `/transfer?...&amount=-100` | 400 / error body | Request is rejected; no balance change |
| API-09 | Transfer zero amount | POST `/transfer?...&amount=0` | 400 / error body | Request is rejected |
| API-10 | Transfer exceeding balance | POST `/transfer?...&amount=999999999` | 400 / error body indicating insufficient funds | Request is rejected; no balance change |

## Scenario Group 4: Beneficiary / Payee (POST, PUT, DELETE)

| ID | Scenario | Method & Endpoint | Expected Status | Key Assertions |
|---|---|---|---|---|
| API-11 | Create a new beneficiary | POST `/payees` | 200/201 | Response returns a new payee `id`; payee is retrievable afterward |
| API-12 | Create beneficiary with missing required field | POST `/payees` (no `name`) | 400 | Validation error returned, no server crash |
| API-13 | Update an existing beneficiary | PUT `/payees/{payeeId}` | 200 | Updated fields are reflected in a subsequent GET |
| API-14 | Delete a beneficiary | DELETE `/payees/{payeeId}` | 200/204 | Payee no longer appears in a subsequent GET of the payee list |
| API-15 | Delete a non-existent beneficiary | DELETE `/payees/999999` | 404 | Clean error response, not a 500 |

## Scenario Group 5: Customer Profile (PUT)

| ID | Scenario | Method & Endpoint | Expected Status | Key Assertions |
|---|---|---|---|---|
| API-16 | Update customer contact info | PUT `/customers/{customerId}` | 200 | Updated fields reflected in subsequent GET |
| API-17 | Update with invalid email format | PUT `/customers/{customerId}` (malformed email) | 400 | Validation error returned |

## Non-functional / Negative API Checks (apply across all endpoints)
- Response time is reasonable (flag anything > 2–3 seconds for a money-moving operation)
- `Content-Type` header is `application/json` (or `application/xml` per ParaBank's REST/SOAP split)
- Invalid/malformed request body in a POST/PUT returns 400, not 500
- Sensitive fields (password) are never echoed back in plaintext in any response

## How to Run This in Postman
1. Open Postman → Import → select `Banking_API_Collection.postman_collection.json`.
2. The collection's `base_url` variable is pre-set to
   `https://parabank.parasoft.com/parabank/services/bank`. ParaBank's actual REST surface is
   JSON/XML based — check the live `/services/bank` path structure from ParaBank's own API docs
   page and adjust endpoint paths in the collection if the live site's routes differ slightly,
   since public demo APIs occasionally change. This adjustment step is itself good API-testing
   practice: never assume a contract, verify it against the live docs first.
3. First register a dummy customer via the ParaBank UI (gives you a real `customerId`), then
   use `Login` to confirm API-level auth before trying account/transfer endpoints.
4. Run requests individually, or click **Run Collection** to execute all requests with the
   built-in test assertions and see a pass/fail summary.
5. Each request's **Tests** tab script checks status code and basic response shape.

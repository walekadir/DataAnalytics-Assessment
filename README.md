DataAnalytics-Assessment

This repository contains SQL queries written for a Data Analyst Assessment for Cowrywise, solving four business problems using a relational database in Microsoft SQL Server.


The queries address the following business problems:

| Query | Problem | Key Tables |
|-------|---------|------------|
| Q1    | High-Value Customers | `users_customuser`, `savings_savingsaccount`, `plans_plan` |
| Q2    | Transaction Frequency | Transaction tables |
| Q3    | Account Inactivity | `savings_savingsaccount`, `plans_plan` |
| Q4    | Customer Lifetime Value | `users_customuser`, `savings_savingsaccount` |

Below are my explanations

Assessment_Q1.sql: High-Value Customers with Multiple Products

- My Approach: Joined `users_customuser` with `savings_savingsaccount` and `plans_plan` using `LEFT JOIN` to identify customers with both funded savings (`is_regular_savings = 1`, `confirmed_amount > 0`) and investment plans (`is_a_fund = 1`, `confirmed_amount > 0`). Calculated `savings_count` and `investment_count` using `COUNT(DISTINCT)`, summed `confirmed_amount` from both tables for `total_deposits` (converted from kobo to NGN), and used `WHERE` to ensure both plan types exist. Ordered by `total_deposits` DESC.

- Challenge: Ensured `total_deposits` included both savings and investment amounts. Ensured accurate numeric calculations in SQL Server.

Assessment_Q2.sql: Transaction Frequency Analysis

- My Approach: I used a CTE - Common Table Expression - to calculate average transactions per month by dividing total transactions by the account’s active months (`DATEDIFF(MONTH, MIN(transaction_date), GETDATE())`). Categorized into High (≥10), Medium (3-9), or Low (≤2) frequency using `CASE`. Aggregated customer counts and average transactions per category.

- Challenge: Replaced SQLite’s `strftime` with T-SQL’s `DATEDIFF`. Handled accounts with short active periods using `+1` in the denominator.

Assessment_Q3.sql: Account Inactivity Alert

- My Approach: Used subqueries for `savings_savingsaccount` and `plans_plan` to find accounts with no transactions in 365 days, combined with `UNION`. Calculated `inactivity_days` using `DATEDIFF(DAY, ..., GETDATE())`. Filtered for funded accounts (`confirmed_amount > 0`).

- Challenge: Fixed improper table joins. Adapted SQLite’s `JULIANDAY` to T-SQL’s `DATEDIFF`. Handled NULL transaction dates.

Assessment_Q4.sql: Customer Lifetime Value (CLV) Estimation

- Approach: Joined `users_customuser` with `savings_savingsaccount` to calculate `tenure_months` (`DATEDIFF(MONTH, signup_date, GETDATE())`), `total_transactions`, and `estimated_clv` using the formula: `(total_transactions / tenure) * 12 * avg_profit_per_transaction`, where profit is 0.1% of `confirmed_amount` (in NGN). Used `NULLIF` to prevent division by zero.

- Challenge: Adapted SQLite date functions to T-SQL. Handled edge cases (zero tenure/transactions).

General Challenges

- Replaced SQLite functions (`strftime`, `JULIANDAY`, `DATE('now')`) with T-SQL equivalents (`DATEDIFF`, `GETDATE()`).
- Fixed Q1 to include investment deposits and Q3 to handle savings and investment accounts separately.
- Added `NULLIF` and `COALESCE` to handle zero values and NULLs in calculations.

Assumptions
- `signup_date` exists in `users_customuser`.
- `transaction_date` exists in both transaction tables.
- "Funded" accounts have `confirmed_amount > 0`.

Submission Notes
- Queries are formatted with comments and indentation.
- File names follow the format `Assessment_QN.sql` (CamelCase).
- Repository contains only SQL files and this README.
- Link to repository: https://github.com/walekadir/DataAnalytics-Assessment

License
This repository is for assessment purposes only and not intended for public reuse.

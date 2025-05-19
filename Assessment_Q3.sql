Find accounts with no transactions in the last 365 days

SELECT
    id AS plan_id,
    owner_id,
    'Savings' AS type,
    last_transaction_date,
    DATEDIFF(DAY, last_transaction_date, GETDATE()) AS inactivity_days
FROM (
    SELECT
        id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM
        savings_savingsaccount
    WHERE
        is_regular_savings = 1 AND confirmed_amount > 0
    GROUP BY
        id, owner_id
    HAVING
        MAX(transaction_date) < DATEADD(DAY, -365, GETDATE()) OR MAX(transaction_date) IS NULL
) savings
UNION
SELECT
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    last_transaction_date,
    DATEDIFF(DAY, last_transaction_date, GETDATE()) AS inactivity_days
FROM (
    SELECT
        id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM
        plans_plan
    WHERE
        is_a_fund = 1 AND confirmed_amount > 0
    GROUP BY
        id, owner_id
    HAVING
        MAX(transaction_date) < DATEADD(DAY, -365, GETDATE()) OR MAX(transaction_date) IS NULL
) investments;

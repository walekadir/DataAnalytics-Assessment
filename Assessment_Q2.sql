WITH TransactionCounts AS (
    SELECT
        owner_id,
        COUNT(*) * 1.0 / (DATEDIFF(MONTH, MIN(transaction_date), GETDATE()) + 1) AS avg_transactions_per_month
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id
)
SELECT
    CASE
        WHEN tc.avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN tc.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(DISTINCT u.id) AS customer_count,
    ROUND(AVG(tc.avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM
    users_customuser u
JOIN
    TransactionCounts tc ON u.id = tc.owner_id
GROUP BY
    CASE
        WHEN tc.avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN tc.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END
ORDER BY
    avg_transactions_per_month DESC;

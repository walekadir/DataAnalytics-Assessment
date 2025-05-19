Calculate Customer Lifetime Value (CLV)
SELECT
    u.id AS customer_id,
    u.name,
    DATEDIFF(MONTH, u.signup_date, GETDATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
    ROUND(
        (COUNT(sa.id) * 1.0 / NULLIF(DATEDIFF(MONTH, u.signup_date, GETDATE()), 0)) * 12 * 
        (0.001 * SUM(COALESCE(sa.confirmed_amount, 0)) / 100.0 / NULLIF(COUNT(sa.id), 0)),
        2
    ) AS estimated_clv
FROM
    users_customuser u
LEFT JOIN
    savings_savingsaccount sa ON u.id = sa.owner_id
WHERE
    DATEDIFF(MONTH, u.signup_date, GETDATE()) > 0
GROUP BY
    u.id, u.name
ORDER BY
    estimated_clv DESC;

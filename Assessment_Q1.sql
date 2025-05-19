Identify customers with both funded savings and investment plans, sorted by total deposits
SELECT
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT sa.id) AS savings_count,
    COUNT(DISTINCT pl.id) AS investment_count,
    (SUM(COALESCE(sa.confirmed_amount, 0)) + SUM(COALESCE(pl.confirmed_amount, 0))) / 100.0 AS total_deposits -- Convert kobo to NGN
FROM
    users_customuser u
LEFT JOIN
    savings_savingsaccount sa ON u.id = sa.owner_id AND sa.is_regular_savings = 1 AND sa.confirmed_amount > 0
LEFT JOIN
    plans_plan pl ON u.id = pl.owner_id AND pl.is_a_fund = 1 AND pl.confirmed_amount > 0
WHERE
    sa.id IS NOT NULL AND pl.id IS NOT NULL
GROUP BY
    u.id, u.name
HAVING
    COUNT(DISTINCT sa.id) >= 1 AND COUNT(DISTINCT pl.id) >= 1
ORDER BY
    total_deposits DESC;


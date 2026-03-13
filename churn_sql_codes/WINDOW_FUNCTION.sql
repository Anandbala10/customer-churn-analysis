-- WINDOW FUNCTION
-- 4.1  Rank subscription types by churn rate within each contract length
SELECT
    contract_length,
    subscription_type,
    COUNT(*)                                                AS customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    RANK() OVER (
        PARTITION BY contract_length
        ORDER BY SUM(Churn) * 100.0 / COUNT(*) DESC
    )                                                       AS churn_rank_in_contract
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY contract_length, subscription_type
ORDER BY contract_length, churn_rank_in_contract;

-- 4.2  Running total of churned customers ordered by Support Calls
--      (useful for identifying support-call thresholds)
SELECT
    support_calls,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    SUM(SUM(Churn)) OVER (
        ORDER BY support_calls
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                       AS running_total_churned
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY support_calls
ORDER BY support_calls;


-- 4.3  Percentile spend buckets for churned vs retained
SELECT
    CASE Churn WHEN 1 THEN 'Churned' ELSE 'Retained' END        AS segment,
    ROUND(AVG(total_spend), 2)                                   AS spend_mean,
    ROUND(MIN(total_spend), 2)                                   AS spend_min,
    ROUND(MAX(total_spend), 2)                                   AS spend_max,
    ROUND(APPROX_QUANTILES(total_spend, 4)[OFFSET(1)], 2)        AS spend_p25,
    ROUND(APPROX_QUANTILES(total_spend, 4)[OFFSET(2)], 2)        AS spend_median,
    ROUND(APPROX_QUANTILES(total_spend, 4)[OFFSET(3)], 2)        AS spend_p75
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY Churn
ORDER BY Churn;

-- 4.4  Month-over-month churn delta (simulated via last_interaction as proxy month)
WITH monthly_churn AS (
    SELECT
        last_interaction                                    AS interaction_day,
        COUNT(*)                                            AS customers,
        SUM(Churn)                                          AS churned
    FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
    GROUP BY last_interaction
)
SELECT
    interaction_day,
    customers,
    churned,
    ROUND(churned * 100.0 / customers, 2)                  AS churn_rate_pct,
    churned - LAG(churned) OVER (ORDER BY interaction_day) AS churn_delta_vs_prev
FROM monthly_churn
ORDER BY interaction_day;
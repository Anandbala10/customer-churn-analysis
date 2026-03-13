-- CTE SUBQUERY
-- 5.1  High-risk customer profile using CTEs
WITH risk_flags AS (
    SELECT
        CustomerID,
        Age,
        Tenure,
        support_calls,
        payment_delay,
        total_spend,
        Churn,
        -- Flag customers showing multiple warning signals
        (CASE WHEN support_calls   >= 5  THEN 1 ELSE 0 END
       + CASE WHEN payment_delay   >= 20 THEN 1 ELSE 0 END
       + CASE WHEN usage_frequency <= 5  THEN 1 ELSE 0 END
       + CASE WHEN Tenure          <= 6  THEN 1 ELSE 0 END)
                                                            AS risk_score
    FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
),
risk_summary AS (
    SELECT
        risk_score,
        COUNT(*)                                            AS customers,
        SUM(Churn)                                          AS churned,
        ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)            AS churn_rate_pct,
        ROUND(AVG(total_spend), 2)                          AS avg_spend
    FROM risk_flags
    GROUP BY risk_score
)
SELECT *
FROM risk_summary
ORDER BY risk_score DESC;



-- 5.2  Identify the top 1% of spenders and their churn behaviour
WITH spend_percentiles AS (
    SELECT
        CustomerID,
        total_spend,
        Churn,
        PERCENT_RANK() OVER (ORDER BY total_spend)          AS spend_percentile
    FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
)
SELECT
    CASE
        WHEN spend_percentile >= 0.99 THEN 'Top 1%'
        WHEN spend_percentile >= 0.90 THEN 'Top 10%'
        WHEN spend_percentile >= 0.75 THEN 'Top 25%'
        ELSE                               'Bottom 75%'
    END                                                     AS spend_tier,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(total_spend), 2)                              AS avg_spend
FROM spend_percentiles
GROUP BY spend_tier
ORDER BY avg_spend DESC;


-- 5.3  Customers never contacting support vs heavy support users
SELECT
    CASE
        WHEN support_calls = 0              THEN 'No support contact'
        WHEN support_calls BETWEEN 1 AND 3  THEN 'Low (1–3 calls)'
        WHEN support_calls BETWEEN 4 AND 6  THEN 'Medium (4–6 calls)'
        ELSE                                     'High (7+ calls)'
    END                                                     AS support_tier,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(payment_delay), 1)                            AS avg_payment_delay_days
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY support_tier
ORDER BY churn_rate_pct DESC;
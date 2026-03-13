-- BUSINESS DRIVEN METRICS
-- 6.1  Estimated revenue at risk from churned customers
SELECT
    subscription_type,
    SUM(CASE WHEN Churn = 1 THEN total_spend ELSE 0 END)   AS churned_revenue,
    SUM(total_spend)                                        AS total_revenue,
    ROUND(
        SUM(CASE WHEN Churn = 1 THEN total_spend ELSE 0 END)
        * 100.0 / SUM(total_spend), 2
    )                                                       AS revenue_at_risk_pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY subscription_type
ORDER BY churned_revenue DESC;


-- 6.2  Average revenue per user (ARPU) by segment
SELECT
    contract_length,
    subscription_type,
    ROUND(AVG(total_spend), 2)                              AS arpu,
    ROUND(AVG(CASE WHEN Churn = 0 THEN total_spend END), 2) AS arpu_retained,
    ROUND(AVG(CASE WHEN Churn = 1 THEN total_spend END), 2) AS arpu_churned
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY contract_length, subscription_type
ORDER BY arpu DESC;


-- 6.3  Payment delay impact on spend and churn
SELECT
    CASE
        WHEN payment_delay = 0         THEN 'No delay'
        WHEN payment_delay BETWEEN 1 AND 10 THEN '1–10 days'
        WHEN payment_delay BETWEEN 11 AND 20 THEN '11–20 days'
        ELSE                                     '21+ days'
    END                                                     AS delay_band,
    COUNT(*)                                                AS customers,
    ROUND(AVG(total_spend), 2)                              AS avg_spend,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY delay_band
ORDER BY churn_rate_pct DESC;


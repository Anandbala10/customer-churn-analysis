-- CORE CHURN METRICS
-- 2.1  Overall churn rate
SELECT
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`;



-- 2.2  Churn rate by Subscription Type
SELECT
    subscription_type,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(total_spend), 2)                              AS avg_spend
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY subscription_type
ORDER BY churn_rate_pct DESC;


-- 2.3  Churn rate by Contract Length
SELECT
    contract_length,
    COUNT(*)  AS customers,
    SUM(Churn) AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY contract_length
ORDER BY churn_rate_pct DESC;


-- 2.4  Churn rate by Gender
SELECT
    Gender,
    COUNT(*) AS customers,
    SUM(Churn) AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY Gender;
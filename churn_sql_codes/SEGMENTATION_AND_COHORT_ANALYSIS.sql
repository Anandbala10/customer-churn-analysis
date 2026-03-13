-- SEGMENTATION AND COHORT ANALYSIS
-- 3.1  Age-band churn analysis
SELECT
    CASE
        WHEN Age < 25              THEN '18–24'
        WHEN Age BETWEEN 25 AND 34 THEN '25–34'
        WHEN Age BETWEEN 35 AND 44 THEN '35–44'
        WHEN Age BETWEEN 45 AND 54 THEN '45–54'
        ELSE                            '55+'
    END                                                     AS age_band,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(total_spend), 2)                              AS avg_spend
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY age_band
ORDER BY age_band;


-- 3.2  Tenure cohort vs churn (early vs late lifecycle)
SELECT
    CASE
        WHEN Tenure <= 12  THEN '0–12 months'
        WHEN Tenure <= 24  THEN '13–24 months'
        WHEN Tenure <= 36  THEN '25–36 months'
        ELSE                    '37+ months'
    END                                                     AS tenure_band,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(support_calls), 1)                            AS avg_support_calls
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY tenure_band
ORDER BY tenure_band;


-- 3.3  Multi-dimensional cross-tab: Subscription × Contract
SELECT
    subscription_type,
    contract_length,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(total_spend), 2)                              AS avg_spend
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY subscription_type, contract_length
ORDER BY churn_rate_pct DESC;
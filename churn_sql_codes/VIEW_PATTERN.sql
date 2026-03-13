-- VIEW PATTERN
-- 8.1  Create a reusable view for the churn dashboard
CREATE OR REPLACE VIEW customer_churn_dataset.vw_churn_summary AS
SELECT
    subscription_type,
    contract_length,
    Gender,
    CASE
        WHEN Age < 25              THEN '18–24'
        WHEN Age BETWEEN 25 AND 34 THEN '25–34'
        WHEN Age BETWEEN 35 AND 44 THEN '35–44'
        WHEN Age BETWEEN 45 AND 54 THEN '45–54'
        ELSE                            '55+'
    END                                                     AS age_band,
    CASE
        WHEN Tenure <= 12  THEN '0–12 months'
        WHEN Tenure <= 24  THEN '13–24 months'
        WHEN Tenure <= 36  THEN '25–36 months'
        ELSE                    '37+ months'
    END                                                     AS tenure_band,
    COUNT(*)                                                AS customers,
    SUM(Churn)                                              AS churned,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(total_spend), 2)                              AS avg_spend,
    ROUND(SUM(total_spend), 2)                              AS total_spend
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY
    subscription_type,
    contract_length,
    Gender,
    age_band,
    tenure_band;
 
-- Query the view like a table
SELECT * FROM customer_churn_dataset.vw_churn_summary
WHERE churn_rate_pct > 30
ORDER BY churn_rate_pct DESC;


-- 8.2  Parameterised query pattern — filter by subscription type
--      Replace @sub_type with 'Basic', 'Standard', or 'Premium'
SELECT
    contract_length,
    COUNT(*)                                                AS customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2)                AS churn_rate_pct,
    ROUND(AVG(total_spend), 2)                              AS avg_spend
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
WHERE subscription_type = @sub_type
GROUP BY contract_length
ORDER BY churn_rate_pct DESC;
 
 

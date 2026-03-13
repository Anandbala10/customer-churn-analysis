-- DATA QUALITY AND PROFILING
-- 1.1  Row count and basic completeness check
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT CustomerID) AS duplicate_customer_ids,
    ROUND(AVG(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) * 100, 2) AS churn_null_pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`;

-- 1.2  Distribution of the target variable
SELECT
    Churn,
    COUNT(*)                                            AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
    GROUP BY Churn
    ORDER BY Churn;

-- 1.3  Numeric column summary (min / max / mean / stddev)
SELECT
    ROUND(MIN(Age), 0)              AS age_min,
    ROUND(MAX(Age), 0)              AS age_max,
    ROUND(AVG(Age), 1)              AS age_avg,
    ROUND(STDDEV(Age), 1)           AS age_stddev,
 
    ROUND(MIN(Tenure), 0)           AS tenure_min,
    ROUND(MAX(Tenure), 0)           AS tenure_max,
    ROUND(AVG(Tenure), 1)           AS tenure_avg,
 
    ROUND(MIN(Total_Spend), 2)      AS spend_min,
    ROUND(MAX(Total_Spend), 2)      AS spend_max,
    ROUND(AVG(Total_Spend), 2)      AS spend_avg,
    ROUND(STDDEV(Total_Spend), 2)   AS spend_stddev
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`

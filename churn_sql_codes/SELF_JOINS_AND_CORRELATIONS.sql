-- SELF JOINS AND CORRELATIONS
-- 7.1  Compare each customer's spend to their subscription-type average
--      (flags above/below-average spenders within cohort)
SELECT
    c.CustomerID,
    c.subscription_type,
    c.total_spend,
    ROUND(avg_by_sub.avg_spend, 2)                         AS cohort_avg_spend,
    ROUND(c.total_spend - avg_by_sub.avg_spend, 2)         AS spend_vs_cohort,
    c.Churn
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean` c
JOIN (
    SELECT
        subscription_type,
        AVG(total_spend)                                   AS avg_spend
    FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
    GROUP BY subscription_type
) avg_by_sub
  ON c.subscription_type = avg_by_sub.subscription_type
ORDER BY spend_vs_cohort DESC
LIMIT 100;


-- 7.2  Correlation proxy: average feature values for churned vs retained
--      (quick sanity check before modelling)
SELECT
    CASE Churn WHEN 1 THEN 'Churned' ELSE 'Retained' END   AS segment,
    ROUND(AVG(Age), 1)                                      AS avg_age,
    ROUND(AVG(Tenure), 1)                                   AS avg_tenure,
    ROUND(AVG(usage_frequency), 1)                          AS avg_usage_freq,
    ROUND(AVG(support_calls), 1)                            AS avg_support_calls,
    ROUND(AVG(payment_delay), 1)                            AS avg_payment_delay,
    ROUND(AVG(total_spend), 2)                              AS avg_total_spend,
    ROUND(AVG(last_interaction), 1)                         AS avg_last_interaction_day
FROM `golden-photon-490019-f1.customer_churn_dataset.customer_churn_clean`
GROUP BY Churn;
-- _______________________________________________
-- Telecom Customer Churn Analysis
-- Author: Janak Ojha
-- Tool: SQLite Online
-- Date: April 2026
-- Total Queries: 10
-- _______________________________________________

-- _______________________________________________
-- QUERY 1: Overall Churn Rate
-- Result: 7043 customers, 1869 churned, 26.54%
-- _______________________________________________
SELECT
  COUNT(*) AS Total_Customers,
  SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END)
  * 100.0 / COUNT(*), 2) AS Churn_Rate_Pct
FROM Telecom_churn_cleaned;

-- _______________________________________________
-- QUERY 2: Churn by Contract Type
-- Result: Month-to-month 42%, One year 11%, Two year 3%
-- _______________________________________________
SELECT
  Contract,
  COUNT(*) AS Total,
  SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END)
  * 100.0 / COUNT(*), 2) AS Churn_Rate_Pct
FROM Telecom_churn_cleaned
GROUP BY Contract
ORDER BY Churn_Rate_Pct DESC;

-- ________________________________________________
-- QUERY 3: Revenue at Risk by Risk Segment
-- RESULT: "High Risk Churned customers represent the largest Revenue loss. CLTV-based targeting lets us proritize which customers save first".
-- ________________________________________________
SELECT
  Risk_Segment,
  COUNT(*) AS Customers,
  SUM(Revenue_At_Risk) AS Total_Revenue_At_Risk,
  ROUND(AVG(CLTV), 0) AS Avg_CLTV
FROM Telecom_churn_cleaned
WHERE Churn_Label = 'Yes'
GROUP BY Risk_Segment
ORDER BY Total_Revenue_At_Risk DESC;

-- __________________________________________________
-- QUERY 4: TOP CHURN REASONS 
-- RESULT: "Staff attitude issues and competitor offers together account for nearly 30% of churn pointing to both a service training problem and a competitive pricing gap".
-- __________________________________________________
SELECT
  Churn_Reason,
  COUNT(*) AS Customer_Count,
  ROUND(COUNT(*) * 100.0 /
  (SELECT COUNT(*) FROM Telecom_churn_cleaned
  WHERE Churn_Label = 'Yes'), 2) AS Pct_of_Churned
FROM Telecom_churn_cleaned
WHERE Churn_Label = 'Yes'
AND Churn_Reason IS NOT NULL
GROUP BY Churn_Reason
ORDER BY Customer_Count DESC
LIMIT 10;

-- __________________________________________________
-- QUERY 5: Churn by Internet Service
-- RESULT: "Fiber optic customers churn the most despite paying the highest monthly charges - a sign that perceived value does not match the premium price".
-- __________________________________________________
SELECT
  Internet_Service,
  COUNT(*) AS Total,
  SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(AVG(Monthly_Charges), 2) AS Avg_Monthly_Charge
FROM Telecom_churn_cleaned
GROUP BY Internet_Service
ORDER BY Churned DESC;

-- ___________________________________________________
-- QUERY 6: High-Value Customers at Risk
-- RESULt: These 20 customers are high _value, have not churned yet, but show churn scores above 71. Proactive outreach to this group should be the retention teams's first priority.
--____________________________________________________
SELECT
  CustomerID, City, Contract,
  Monthly_Charges, CLTV,
  Churn_Score, Tenure_Months
FROM Telecom_churn_cleaned
WHERE Churn_Label = 'No'
AND Risk_Segment = 'High Risk'
AND CLTV > 5000
ORDER BY Churn_Score DESC
LIMIT 20;

--_____________________________________________________
-- QUERY 7: Churn by Tenure Group
-- RESULT: "Customers in their first 12 months churn at the highest rate. Onboarding programs and entry-tenure loyalty offers could significantly reduce this ".
-- ____________________________________________________
SELECT
  Tenure_Group,
  COUNT(*) AS Total,
  SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END)
  * 100.0 / COUNT(*), 2) AS Churn_Rate_Pct
FROM Telecom_churn_cleaned
GROUP BY Tenure_Group
ORDER BY Churn_Rate_Pct DESC;

-- ______________________________________________________
-- QUERY 8: Churn by City
-- RESULT: "Certain cities show disproportionately high churn rates--suggesting localized network or competitor issues that require city-specific intervention".
-- ______________________________________________________
SELECT
  City,
  COUNT(*) AS Total,
  SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(SUM(CASE WHEN Churn_Label = 'Yes' THEN 1 ELSE 0 END)
  * 100.0 / COUNT(*), 2) AS Churn_Rate_Pct
FROM Telecom_churn_cleaned
GROUP BY City
HAVING COUNT(*) >= 20
ORDER BY Churn_Rate_Pct DESC
LIMIT 15;

-- ________________________________________________________
-- QUERY 9: Payment Method 
-- Result: "Electronic check users show the highest churn rate as data indentifies a strong link between manual payment methods icncresed customers turnover and long term are bank transfers or credit cards could significantly improve".
-- ________________________________________________________
SELECT Payment_Method,
  COUNT(*) AS Total,
  SUM(CASE WHEN Churn_Label='Yes' THEN 1 ELSE 0 END) AS Churned,
  ROUND(SUM(CASE WHEN Churn_Label='Yes' THEN 1 ELSE 0 END)
  *100.0/COUNT(*),2) AS Churn_Rate
FROM Telecom_churn_cleaned
GROUP BY Payment_Method
ORDER BY Churn_Rate DESC;
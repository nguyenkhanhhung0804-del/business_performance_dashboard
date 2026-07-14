SELECT * FROM fact_sales
SELECT * FROM dim_account

-- Top 10 most profitable products
SELECT  TOP 10 Product_id
	, ROUND(SUM((Sales_USD - COGS_USD)*quantity)/1e6, 2) AS profit_millios
FROM fact_sales
GROUP BY Product_id
ORDER BY profit_millios DESC

-- Revenue and Profit by country
SELECT da.country_code
	, ROUND(SUM(fs.Sales_USD * fs.quantity)/1e6,2) AS revenue_millions
	, ROUND(SUM((fs.Sales_USD - fs.COGS_USD)*fs.quantity)/1e6,2) AS profit_millions
FROM fact_sales AS fs
JOIN dim_account AS da
ON fs.Account_id = da.Account_id
GROUP BY da.country_code

-- Monthly Revenue Trend with Month-over-Month (MoM) Growth
WITH MonthlyRevenue AS (
    SELECT CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, Date_Time), 0) AS DATE) AS revenue_month
        , SUM(Sales_USD) AS total_revenue
    FROM fact_sales
    GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, Date_Time), 0)
),
RevenueWithLag AS (
    SELECT revenue_month
        , total_revenue
        , LAG(total_revenue) OVER (ORDER BY revenue_month) AS previous_month_revenue
    FROM MonthlyRevenue
)
SELECT revenue_month
    , total_revenue
    , previous_month_revenue
    , CASE 
        WHEN previous_month_revenue IS NULL OR previous_month_revenue = 0 THEN NULL
        ELSE ROUND(((total_revenue - previous_month_revenue)/previous_month_revenue)*100, 2)
    END AS mom_growth_pct
FROM RevenueWithLag
ORDER BY revenue_month

-- Year-over-Year (YoY) Profit Growth
WITH YearlyProfit AS (
    SELECT YEAR(Date_Time) AS revenue_year
         , ROUND(SUM(Sales_USD - COGS_USD)/1e6,2) AS total_profit_millions
    FROM fact_sales
    GROUP BY YEAR(Date_Time)
),
ProfitWithLag AS (
    SELECT revenue_year
        , total_profit_millions
        , LAG(total_profit_millions) OVER (ORDER BY revenue_year) AS previous_year_profit_millions
    FROM YearlyProfit
)
SELECT revenue_year
    , total_profit_millions
    , previous_year_profit_millions
    , CASE 
        WHEN previous_year_profit_millions IS NULL OR previous_year_profit_millions = 0 THEN NULL
        ELSE ROUND(((total_profit_millions - previous_year_profit_millions)/previous_year_profit_millions)*100, 2)
    END AS yoy_profit_growth_pct
FROM ProfitWithLag
ORDER BY revenue_year

-- Profit Margin by Product
SELECT Product_id
    , ROUND(SUM(Sales_USD*quantity)/1e6, 2) AS revenue_millions
    , ROUND(SUM((Sales_USD - COGS_USD)*quantity)/1e6, 2) AS profit_millios
    , ROUND(ROUND(SUM(Sales_USD*quantity)/1e6, 2)/ROUND(SUM((Sales_USD - COGS_USD)*quantity)/1e6, 2),2)*100 AS profit_margin_pct
FROM fact_sales
GROUP BY Product_id

-- Top 3 Products in each Country
WITH top_products AS(
    SELECT da.country_code
           , fs.Product_id
           ,ROW_NUMBER() OVER(PARTITION BY da.country_code ORDER BY SUM(Sales_USD) DESC) AS product_rank
FROM fact_sales AS fs
JOIN dim_account AS da
ON fs.Account_id = da.Account_id
GROUP BY da.country_code
        , fs.Product_id
)

SELECT * FROM top_products
WHERE product_rank <= 3

-- Profit by Country
SELECT da.country_code
    , ROUND(SUM((fs.Sales_USD - fs.COGS_USD)*fs.quantity)/1e6, 2) AS profit_millios
FROM fact_sales AS fs
JOIN dim_account AS da
ON fs.Account_id = da.Account_id
GROUP BY da.country_code

-- High-Revenue, Low-Profit Products
WITH ProductPerformance AS(
    SELECT Product_id
        , SUM(Sales_USD) AS total_revenue
        , SUM(Sales_USD - COGS_USD) AS total_profit
        , (SUM(Sales_USD - COGS_USD)/SUM(Sales_USD))*100 AS profit_margin_pct
    FROM fact_sales
    GROUP BY Product_id
),
Benchmarks AS (
    SELECT AVG(total_revenue) AS avg_revenue
        , AVG(profit_margin_pct) AS avg_margin_pct
    FROM ProductPerformance
)

SELECT p.Product_id
    , ROUND(p.total_revenue, 2) AS total_revenue
    , ROUND(p.total_profit, 2) AS total_profit
    , ROUND(p.profit_margin_pct, 2) AS profit_margin_pct
FROM ProductPerformance p
CROSS JOIN Benchmarks b
WHERE p.total_revenue > b.avg_revenue     
AND p.profit_margin_pct < b.avg_margin_pct

-- Pareto Analysis (80/20 Contribution)
WITH ProductRevenue AS(
    SELECT Product_id
        , SUM(Sales_USD) AS product_revenue
    FROM fact_sales
    GROUP BY Product_id
),
CumulativeRevenue AS (
    SELECT Product_id
        , product_revenue
        , SUM(product_revenue) OVER (ORDER BY product_revenue DESC) AS running_total_revenue
        , SUM(product_revenue) OVER () AS total_company_revenue
    FROM ProductRevenue
),
ParetoCalculation AS (
    SELECT Product_id
        , product_revenue
        , running_total_revenue
        , total_company_revenue
        , ROUND((running_total_revenue/total_company_revenue)*100, 2) AS cumulative_revenue_pct
    FROM CumulativeRevenue
)

SELECT Product_id
    , ROUND(product_revenue, 2) AS product_revenue
    , ROUND(running_total_revenue, 2) AS running_total_revenue
    , cumulative_revenue_pct
    , CASE 
        WHEN cumulative_revenue_pct <= 80.00 THEN 'Top 80%'
        ELSE 'Remaining 20%'
    END AS pareto_classification
FROM ParetoCalculation

-- Country contribution to Total Revenue
WITH total_revenue AS(
    SELECT SUM(Sales_USD) AS sum_revenue
    FROM fact_sales
)

SELECT da.country_code
    , ROUND(SUM(fs.Sales_USD)/(SELECT sum_revenue FROM total_revenue)*100, 2) AS contribution_pct
FROM fact_sales AS fs
JOIN dim_account AS da
ON fs.Account_id = da.Account_id
GROUP BY da.country_code









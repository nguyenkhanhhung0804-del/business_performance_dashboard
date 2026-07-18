# Plant Sales Analytics (SQL & Power BI Data Modeling)

This repository contains a comprehensive data analysis project focused on regional plant sales, product performance, and financial reporting. It utilizes a multi-table database (`Plant_DTS.xls`) to extract key business insights using custom **T-SQL** queries and structured data relationship models.

---

## 📊 Dataset Schema Overview

The database consists of three main sheets representing a typical star-schema relational model:

1. **`Plant_FACT` (Sales Fact Table)**
   * **Key Metrics:** `Sales_USD`, `quantity`, `Price_USD`, `COGS_USD`
   * **Dimensions:** `Date_Time`, `Product_id`, `Account_id`
2. **`Accounts` (Customer/Geography Dimension)**
   * Contains regional attributes including `country_code`, `latitude2`/`longitude`, `country2`, and location identifiers.
3. **`Plant_Hierarchy` (Product Dimension)**
   * Categorizes items with attributes like `Product_Family`, `Product_Group`, `Product_Name`, `Product_Size`, and `Produt_Type`.

---

## 🎨 Power BI Dashboard & Data Modeling Skills

In addition to SQL extraction, this project features an interactive **Sales Performance Dashboard** (`Sales Performance_Dashboard.pbix`) built to turn raw data into executive-level insights. This component highlights key business intelligence capabilities:

* **Star-Schema Data Modeling:** Designed a highly efficient relational data model in Power BI, establishing robust relationships (1-to-many) between the centralized fact table (`Plant_FACT`) and the geographical (`Accounts`) and product (`Plant_Hierarchy`) dimensions.
* **DAX Formulas (Data Analysis Expressions):** Wrote custom DAX measures to compute key performance indicators (KPIs) dynamically, such as total revenues, profit margins, geographic distribution percentages, and time-intelligence metrics (MoM and YoY performance).
* **Interactive Data Visualization:** Developed an intuitive user interface utilizing slicers, map-based regional breakdowns, and product category trends to allow stakeholders to drill down from global trends directly into specific product families.

---

## 🛠️ SQL Queries & Analytical Tasks

The repository includes curated **SQL/T-SQL scripts** designed to answer critical business performance questions, structured into the following analytical themes:

### 1. Financial Trends & Growth Analysis
* **Month-over-Month (MoM) Revenue Growth:** Utilizes window functions (`LAG()`) to calculate sequential monthly growth percentages over time.
* **Year-over-Year (YoY) Profit Growth:** Summarizes profit margins by year and calculates annual percent growth.
* **Pareto Analysis (80/20 Rule):** Computes cumulative revenue percentages to identify which top products generate $80\%$ of total company revenue.

### 2. Product & Category Optimization
* **Top 10 Most Profitable Products:** Pinpoints high-volume drivers by calculating gross profits:
  $$\text{Profit} = (\text{Sales USD} - \text{COGS USD}) \times \text{Quantity}$$
* **High-Revenue, Low-Profit Products:** Highlights products with higher-than-average revenue but below-average margins, pointing to high production costs or pricing issues.
* **Profit Margin by Product:** Breaks down individual product margin efficiency percentages.

### 3. Geographical Segmentation
* **Country Contribution to Revenue:** Measures percent share contributions for each geographical market.
* **Revenue & Profit by Country:** Summarizes overall financial performance per country code.
* **Top 3 Products by Country:** Uses partitioning and row ranking (`ROW_NUMBER()`) to extract top selling items tailored to local market preferences.

---

## 🚀 Technical Highlights & Key T-SQL Syntax Used

The queries showcase advanced database and data warehouse concepts:
* **Common Table Expressions (CTEs):** Structured, clean, and readable subqueries for modular logic.
* **Window Functions:** `ROW_NUMBER() OVER(PARTITION BY ... ORDER BY ...)` and `LAG() OVER(...)` for ranking and time-series growth tracking.
* **Aggregations & Joins:** Highly optimized joins linking fact tables to dimension accounts and products.
* **Statistical Benchmarks:** Cross-joining average metrics against row-level attributes to filter outliers and underperformers dynamically.

## Author

**Hung Khanh Nguyen**

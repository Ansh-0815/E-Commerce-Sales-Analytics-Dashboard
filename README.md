# Olist E-Commerce Sales Analytics Dashboard
### End-to-End SQL + MySQL + Power BI Analytics Pipeline

An end-to-end business analytics project built using the **Olist Brazilian E-Commerce Dataset**. This project demonstrates a complete analytics pipeline by importing raw CSV files into **MySQL**, performing data cleaning and business analysis using **SQL**, and building an interactive **Power BI dashboard** connected directly to the cleaned MySQL tables through **ODBC**.

The objective of this project is to transform raw transactional data into actionable business insights covering sales performance, customer behavior, product performance, payment trends, and operational efficiency.

---

# Tech Stack

- **Database:** MySQL
- **Business Intelligence:** Power BI
- **Query Language:** SQL
- **Data Transformation:** Power Query
- **Analytics:** DAX
- **Connection:** ODBC
- **Dataset:** Olist Brazilian E-Commerce Dataset (Kaggle)

---

# Dataset

**Source:** Olist Brazilian E-Commerce Public Dataset (Kaggle)

The dataset contains information related to:

- Customers
- Orders
- Order Items
- Payments
- Products
- Product Category Translation

Dataset Size:

- **99K+ Orders**
- **96K+ Customers**
- **112K+ Order Items**
- **74 Product Categories**

---

# Project Architecture

```text
                Raw CSV Files
                      │
                      ▼
               MySQL Database
      (Data Cleaning & SQL Analysis)
                      │
                      ▼
              Clean Reporting Tables
      (clean_order_items, clean_products)
                      │
                      ▼
               ODBC Data Source
                      │
                      ▼
               Power Query (ETL)
                      │
                      ▼
               Power BI Data Model
                 (DAX Measures)
                      │
                      ▼
          Interactive Business Dashboard
```

Unlike the initial version of this project, the dashboard is now connected directly to **MySQL** instead of importing CSV files into Power BI, creating a true end-to-end SQL analytics pipeline.

---

# Business Objectives

- Monitor overall sales performance
- Analyze customer purchasing behavior
- Evaluate product category performance
- Understand customer geographic distribution
- Analyze payment preferences
- Monitor delivery performance
- Generate business recommendations through interactive dashboards

---

# Data Preparation & Cleaning

The data was cleaned and validated inside **MySQL** before visualization.

### Data Engineering Steps

- Imported six CSV datasets into MySQL using `LOAD DATA LOCAL INFILE`
- Created relational database schema
- Validated row counts and relationships
- Integrated Product Category Translation table
- Converted Portuguese category names into English
- Removed incomplete September 2018 reporting period
- Built cleaned reporting tables:
  - `clean_order_items`
  - `clean_products`
- Validated KPIs using SQL before dashboard development
- Connected Power BI directly to MySQL using ODBC

---

# SQL Analysis

The analytical workflow was performed in MySQL before visualization.

## SQL Operations

- Database creation
- CSV import
- Data validation
- Data cleaning
- Multi-table joins
- Aggregations
- Window functions
- KPI calculations
- Revenue analysis
- Customer analysis
- Product category analysis

## Key Metrics

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value (AOV)
- Monthly Revenue Trend
- Delivery Success Rate
- Payment Method Distribution
- Order Status Distribution
- Top Product Categories
- Freight Cost Analysis

---

# Power BI Dashboard

The report consists of three interactive dashboard pages.

---

## 1. Executive Overview

Provides a high-level summary of business performance.

### KPIs

- Revenue
- Orders
- Customers
- Average Order Value (AOV)
- Delivery Success Rate

### Visualizations

- Monthly Revenue Trend
- Top Product Categories
- Payment Method Distribution
- Order Fulfillment Status

---

## 2. Customer Analysis

Analyzes customer distribution and regional performance.

### KPIs

- Total Customers
- Total States
- Revenue per Customer
- Orders

### Visualizations

- Revenue by State
- Orders by State
- Customers by State
- Top Cities by Revenue

---

## 3. Product Analysis

Analyzes product category performance and profitability.

### KPIs

- Total Categories
- Top Category Revenue
- Order Items Count
- Category Average Order Value

### Visualizations

- Revenue by Category
- Revenue vs Freight Cost
- Order Items by Category
- Category Average Order Value

---

# Executive Summary

| KPI | Value |
|------|-------:|
| Revenue | **R$13.59M** |
| Orders | **99.4K** |
| Customers | **96.1K** |
| Order Items | **112K** |
| Delivery Success Rate | **97.02%** |
| Average Order Value | **R$136.68** |

---

# Key Business Insights

## Executive Overview

- Generated **R$13.59M** revenue across nearly **100K orders**.
- Maintained a **97.02% delivery success rate**, indicating strong operational performance.
- Credit card payments accounted for the majority of transactions.
- Revenue demonstrated consistent growth throughout the reporting period.

---

## Customer Analysis

- São Paulo generated the highest revenue and order volume.
- Revenue is concentrated across a small number of states.
- Major metropolitan regions contribute the majority of business performance.
- Customer distribution closely aligns with revenue contribution.

---

## Product Analysis

- Health & Beauty generated the highest revenue.
- Revenue is concentrated among a limited number of product categories.
- High-revenue categories also incur relatively high freight costs.
- Product portfolio optimization should focus on top-performing categories.

---

# Dashboard Preview

## Executive Overview

![Executive Overview](images/Overview.png)

---

## Customer Analysis

![Customer Analysis](images/Customer_Analysis.png)

---

## Product Analysis

![Product Analysis](images/Product_Analysis.png)

---

# Repository Structure

```text
olist-ecommerce-analysis/
│
├── README.md
│
├── sql/
│   └── olist_analysis.sql
│
├── dashboard/
│   └── Olist_dashboard.pbix
│
├── docs/
│   └── Insights.md
│
├── images/
│   ├── Overview.png
│   ├── Customer_Analysis.png
│   └── Product_Analysis.png
│
└── Dataset/
    └── dataset_link.txt
```

---

# How to Run

## 1. SQL

Import the dataset into MySQL and execute:

```sql
SOURCE sql/olist_analysis.sql;
```

---

## 2. Power BI

1. Install **MySQL ODBC Driver**.
2. Create an ODBC DSN named:

```text
Olist_MySQL
```

3. Open:

```text
dashboard/Olist_dashboard.pbix
```

4. Refresh the dataset.

---

# Future Improvements

- Create SQL reporting views (`vw_orders`, `vw_customers`, etc.)
- Add a dedicated Date table for DAX time intelligence.
- Organize DAX measures into a dedicated `_Measures` table.
- Extend the dashboard with profitability and customer lifetime value analysis.
- Publish the dashboard to Power BI Service.

---

# Repository

```
CSV Files
      ↓
MySQL Database
      ↓
SQL Cleaning & Analysis
      ↓
ODBC Connection
      ↓
Power Query
      ↓
Power BI Data Model
      ↓
Interactive Dashboard
```

---

# Author

## Ansh Agarwal

**Aspiring Data Analyst | Data Science Student**

**Skills**

- SQL
- MySQL
- Power BI
- Power Query
- DAX
- Python
- Data Visualization
- Data Cleaning
- Business Analytics
- Machine Learning

---

⭐ If you found this project useful, consider giving the repository a **Star**.

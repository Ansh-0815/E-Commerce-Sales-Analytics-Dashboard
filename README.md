Olist E-Commerce Sales Analytics
End-to-End SQL + MySQL + Power BI Analytics Pipeline

End-to-end business analytics project built on the Brazilian Olist E-Commerce dataset. The project demonstrates a complete analytics pipeline by loading raw CSV data into MySQL, performing data cleaning and business analysis using SQL, and building an interactive Power BI dashboard connected directly to the cleaned MySQL tables through ODBC.

The objective is to transform raw transactional data into actionable business insights covering sales performance, customer behavior, product performance, payment trends, and operational efficiency.

Tech Stack
Database: MySQL
Business Intelligence: Power BI
Query Language: SQL
Data Transformation: Power Query
Analytics: DAX
Data Source: Olist Brazilian E-Commerce Dataset (Kaggle)
Dataset

Source: Olist Brazilian E-Commerce Public Dataset (Kaggle)

The dataset contains information related to:

Customers
Orders
Order Items
Payments
Products
Product Category Translation

Approximately:

99K Orders
96K Customers
112K Order Items
74 Product Categories
Project Architecture
Raw CSV Files
        │
        ▼
MySQL Database
(Data Cleaning & SQL Analysis)
        │
        ▼
Clean Tables
(clean_order_items, clean_products)
        │
        ▼
ODBC Connection
        │
        ▼
Power BI
(Power Query + DAX)
        │
        ▼
Interactive Dashboard

Unlike the earlier version of this project, the dashboard is now connected directly to MySQL instead of importing CSV files into Power BI, making it a true end-to-end SQL analytics pipeline.

Business Objectives
Monitor overall sales performance
Analyze customer purchasing behavior
Evaluate product category performance
Understand customer geographic distribution
Analyze payment preferences
Monitor delivery performance
Generate business recommendations using interactive dashboards
Data Preparation & Cleaning

Before dashboard development, the data was cleaned and validated inside MySQL.

Data Engineering Steps
Imported six CSV datasets into MySQL
Created relational database schema
Validated row counts and relationships
Joined Product Category Translation table
Converted Portuguese category names into English
Removed incomplete September 2018 reporting period
Built cleaned reporting tables:
clean_order_items
clean_products
Validated business KPIs before visualization
Connected Power BI to MySQL using ODBC instead of CSV imports
SQL Analysis

The analytical workflow was performed in MySQL before visualization.

SQL Operations
Database creation
Data import using LOAD DATA LOCAL INFILE
Data validation
Data cleaning
Multi-table joins
Aggregations
Window functions
KPI calculations
Revenue analysis
Customer analysis
Product category analysis
Key Metrics
Total Revenue
Total Orders
Total Customers
Average Order Value (AOV)
Monthly Revenue Trend
Delivery Success Rate
Payment Method Distribution
Order Status Distribution
Top Product Categories
Freight Cost Analysis
Power BI Dashboard

The report consists of three interactive pages.

1. Executive Overview

Executive summary of overall business performance.

KPIs
Revenue
Orders
Customers
Average Order Value
Delivery Success Rate
Visualizations
Monthly Revenue Trend
Top Product Categories
Payment Method Distribution
Order Fulfillment Status
2. Customer Analysis

Customer distribution and regional performance.

KPIs
Total Customers
Total States
Revenue per Customer
Orders
Visualizations
Revenue by State
Orders by State
Customers by State
Top Cities by Revenue
3. Product Analysis

Product category performance and profitability.

KPIs
Total Categories
Top Category Revenue
Order Items Count
Category Average Order Value
Visualizations
Revenue by Category
Revenue vs Freight Cost
Order Items by Category
Category Average Order Value
Executive Summary
R$13.59M total revenue
99.4K completed orders
96.1K customers
112K order items
97.02% delivery success rate
R$136.68 average order value
Key Business Insights
Executive Overview
Revenue exceeded R$13.5M across nearly 100K orders.
Delivery success remained above 97%.
Credit card payments dominated customer transactions.
Revenue demonstrated consistent growth throughout the reporting period.
Customer Analysis
São Paulo generated the highest revenue and order volume.
Revenue is concentrated within a relatively small number of states.
Major metropolitan areas contribute the majority of business performance.
Product Analysis
Health & Beauty generated the highest revenue.
Revenue is concentrated among a limited number of product categories.
High-revenue categories also incur relatively high freight costs.
Product portfolio optimization should prioritize top-performing categories.
Dashboard Preview
Executive Overview
![Executive Overview](images/Overview.png)
Customer Analysis
![Customer Analysis](images/Customer_Analysis.png)
Product Analysis
![Product Analysis](images/Product_Analysis.png)
Repository Structure
olist-ecommerce-analysis/
│
├── README.md
│
├── docs/
│   └── Insights.md
│
├── sql/
│   └── olist_analysis.sql
│
├── dashboard/
│   └── Olist_dashboard.pbix
│
├── images/
│   ├── Overview.png
│   ├── Customer_Analysis.png
│   └── Product_Analysis.png
│
└── Dataset/
    └── dataset_link.txt
Power BI Dashboard

The PBIX dashboard is available via Google Drive:

(Keep your existing Google Drive link here.)

Future Improvements
Add a dedicated Date dimension for DAX time intelligence.
Organize all DAX measures into a dedicated _Measures table.
Create SQL views for reporting (vw_clean_order_items, vw_clean_products) to separate the reporting layer from physical tables.
Extend the dashboard with profitability and customer lifetime value analysis.
Author

Ansh Agarwal

Aspiring Data Analyst | Data Science Student

Skilled in SQL, Power BI, Python, Data Cleaning, Data Visualization, Machine Learning, and Business Analytics.

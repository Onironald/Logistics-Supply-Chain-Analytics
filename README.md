# Logistics & Supply Chain Analytics

## Improving Delivery Performance While Reducing Operational Costs

An end-to-end **Logistics & Supply Chain Analytics** project using **SQL, Power BI, and business analysis** to evaluate inventory risk, supplier performance, transportation costs, lead times, and logistics efficiency.

The project transforms a 100-record supply-chain dataset into an interactive three-page Power BI dashboard supported by SQL-based data preparation, exploratory analysis, business insights, and operational recommendations.

---

## Project Overview

This project analyzes supply-chain operations to identify opportunities to:

* Reduce logistics and transportation costs
* Improve inventory availability
* Identify supplier performance risks
* Evaluate transportation trade-offs
* Understand regional logistics cost differences
* Support data-driven operational decisions

### Key Business Questions

1. Which products require inventory replenishment?
2. Which suppliers create the greatest operational risk?
3. Which transportation modes provide the best cost-versus-speed trade-off?
4. Which locations have the highest logistics costs?
5. How significant are logistics costs relative to revenue?

---

## Business Objectives

The analysis focuses on four major areas:

* **Inventory Management** — Identify low-stock and out-of-stock products.
* **Supplier Performance** — Compare supplier cost, lead time, and inspection outcomes.
* **Transportation Efficiency** — Evaluate logistics cost against shipping time.
* **Regional Performance** — Identify locations with higher logistics cost burdens.

---

## Executive KPIs

| **KPI**                 |  **Value** |
| ----------------------- | ---------: |
| Records / Orders        |        100 |
| Total Revenue           | 577,604.86 |
| Total Logistics Cost    |  52,924.57 |
| Logistics Cost %        |      9.16% |
| SKUs                    |        100 |
| Units Sold              |     46,099 |
| Low-Stock SKUs          |         26 |
| Out-of-Stock SKUs       |          1 |
| Suppliers               |          5 |
| Avg. Supplier Lead Time | 17.08 days |
| Avg. Shipping Time      |  5.75 days |
| Avg. Order Lead Time    | 15.96 days |

---

## Dataset

The dataset contains **100 supply-chain records across 24 fields**.

### Dataset Characteristics

* 100 records
* 24 fields
* 100 unique SKUs
* 5 suppliers
* 5 supplier locations
* 4 transportation modes
* No missing values
* No duplicate SKU records

### Key Fields

The dataset includes information relating to:

* Product type
* SKU
* Product price
* Availability
* Units sold
* Revenue generated
* Customer demographics
* Stock levels
* Order quantities
* Shipping time
* Shipping costs
* Shipping carriers
* Supplier
* Supplier location
* Supplier lead time
* Production volume
* Manufacturing lead time
* Manufacturing cost
* Inspection results
* Defect rates
* Transportation mode
* Routes
* Logistics costs

---

## Data Preparation & Transformation

SQL was used to prepare, validate, and analyze the dataset before visualization.

### Calculated Metrics

**Inventory Movement Ratio**

```text
Inventory Movement Ratio = Units Sold / Stock Level
```

**Inventory Status**

| **Stock Level** | **Status**   |
| --------------- | ------------ |
| 0               | Out of Stock |
| 1–20            | Low Stock    |
| >20             | Adequate     |

**Logistics Cost %**

```text
Logistics Cost % = Logistics Cost / Revenue × 100
```

---

# Key Findings

## 1. Inventory Replenishment Risk

The analysis identified:

* **26 low-stock SKUs**
* **1 out-of-stock SKU**
* **13 low-stock SKUs** had sold at least 500 units

### Product Category Performance

| **Product Category** | **Avg. Units Sold** | **Avg. Stock** |
| -------------------- | ------------------: | -------------: |
| Skincare             |              518.28 |          40.20 |
| Cosmetics            |              452.19 |          58.65 |
| Haircare             |              400.32 |          48.35 |

**Key insight:** Skincare recorded the highest average units sold while maintaining a relatively lower average stock level, creating a potential replenishment risk.

---

## 2. Supplier Performance

Supplier performance was evaluated using logistics cost, supplier lead time, and inspection outcomes.

| **Supplier** | **Avg. Logistics Cost** | **Avg. Supplier Lead Time** |
| ------------ | ----------------------: | --------------------------: |
| Supplier 1   |                  574.85 |                  14.80 days |
| Supplier 2   |                  515.03 |                  18.55 days |
| Supplier 3   |                  468.80 |                  20.13 days |
| Supplier 4   |                  521.81 |                    ~17 days |
| Supplier 5   |                  536.02 |                  18.06 days |

Supplier 3 recorded the lowest average logistics cost but also the longest average supplier lead time.

### Supplier 4 Inspection Results

Supplier 4 recorded:

* 18 inspections
* 12 failures
* 0 passes
* 6 pending inspections
* 66.7% of all inspections were failures
* 100% of completed inspections were failures, excluding pending inspections

This indicates that Supplier 4 requires closer operational review.

---

## 3. Transportation Cost vs. Speed

Transportation modes were compared based on average logistics cost and shipping time.

| **Transportation Mode** | **Avg. Logistics Cost** | **Avg. Shipping Time** |
| ----------------------- | ----------------------: | ---------------------: |
| Sea                     |                  417.82 |              7.12 days |
| Road                    |                  553.39 |              4.72 days |
| Rail                    |                  541.75 |              6.57 days |
| Air                     |                  561.71 |              5.12 days |

**Key insight:** Sea transportation had the lowest average logistics cost but the longest average shipping time. Road transportation had a shorter average shipping time but a higher average logistics cost.

This demonstrates a clear cost-versus-speed trade-off.

---

## 4. Regional Logistics Costs

Average logistics costs varied considerably by location.

| **Location** | **Avg. Logistics Cost** |
| ------------ | ----------------------: |
| Chennai      |                  621.75 |
| Bangalore    |                  586.71 |
| Delhi        |                  548.24 |
| Kolkata      |                  491.27 |
| Mumbai       |                  428.34 |

Chennai and Bangalore recorded the highest average logistics costs in the dataset, making them areas for further operational investigation.

---

## 5. Logistics Cost Burden

The dataset generated:

* **Total Revenue:** 577,604.86
* **Total Logistics Cost:** 52,924.57
* **Logistics Cost as % of Revenue:** 9.16%

This indicates that logistics represents a meaningful component of overall revenue and should be monitored as part of cost-management activities.

---

# Power BI Dashboard

The Power BI dashboard contains three analytical pages.

## 1. Executive Overview

Provides a high-level view of:

* Revenue
* Logistics costs
* Inventory status
* Supplier performance
* Shipping performance
* Overall operational KPIs

![Executive Overview](https://github.com/Onironald/Logistics-Supply-Chain-Analytics/raw/main/screenshots/executive_overview.png)

---

## 2. Inventory & Product Analysis

Focuses on:

* Inventory status
* Product categories
* Units sold
* Stock levels
* Inventory movement
* High-demand products

![Inventory & Product Analysis](https://github.com/Onironald/Logistics-Supply-Chain-Analytics/raw/main/screenshots/inventory_product_analysis.png)

---

## 3. Supplier & Logistics Performance

Analyzes:

* Supplier performance
* Supplier lead times
* Logistics costs
* Transportation modes
* Shipping times
* Regional logistics performance
* Inspection results

![Supplier & Logistics Performance](https://github.com/Onironald/Logistics-Supply-Chain-Analytics/raw/main/screenshots/supplier_logistics_performance.png)

---

# Tools & Technologies

| **Tool**        | **Purpose**                                                                           |
| --------------- | ------------------------------------------------------------------------------------- |
| **SQL**         | Data cleaning, transformation, validation, exploratory analysis, and KPI calculations |
| **Power BI**    | Interactive dashboard development and visualization                                   |
| **Excel / CSV** | Source data inspection and analysis                                                   |
| **PowerPoint**  | Business presentation and communication                                               |
| **GitHub**      | Project documentation and portfolio delivery                                          |

---

# Business Recommendations

### 1. Strengthen Inventory Replenishment

Prioritize the **26 low-stock SKUs**, particularly products combining high demand with limited stock.

### 2. Protect High-Demand Skincare Inventory

Skincare has the highest average units sold among the three product categories. Inventory planning should therefore pay particular attention to demand and stock availability within this category.

### 3. Monitor Supplier Performance Using Multiple KPIs

Supplier evaluation should consider:

* Logistics cost
* Supplier lead time
* Inspection outcomes
* Defect rates
* Overall reliability

### 4. Investigate Supplier 4

Supplier 4's inspection results require further investigation because all completed inspections in the dataset were failures.

### 5. Investigate Higher-Cost Locations

Chennai and Bangalore recorded the highest average logistics costs. Further analysis should investigate:

* Route efficiency
* Transportation selection
* Supplier proximity
* Shipping patterns
* Distribution network design

### 6. Match Transportation Mode to Business Need

Transportation decisions should balance:

* Cost
* Delivery speed
* Product urgency
* Customer expectations
* Operational requirements

### 7. Establish Recurring KPI Monitoring

Inventory, supplier, transportation, and logistics KPIs should be monitored regularly to identify emerging operational risks.

---

# Analytical Limitations

Several limitations should be considered when interpreting the analysis.

### No Transaction Date

The dataset does not contain a transaction date, so monthly, quarterly, or historical trends cannot be reliably analyzed.

### No Customer ID

Customer-level profitability, retention, repeat purchases, and purchasing behavior cannot be calculated.

### No Profit Field

Revenue and logistics costs are available, but a complete profit calculation would require additional cost information.

### No Single Order Fulfillment Time Field

Order fulfillment is represented through related measures such as:

* Order Lead Time
* Supplier Lead Time
* Shipping Time

These should not be interpreted as one directly measured fulfillment-time metric.

---

# Project Structure

```text
Logistics-Supply-Chain-Analytics/
│
├── data/
│   └── supply_chain_data.csv
│
├── powerbi/
│   └── SupplyChainAnalytics.pbix
│
├── presentation/
│   └── Logistics_Supply_Chain_Analysis.pptx
│
├── report/
│   └── Logistics_Supply_Chain_Business_Report.docx
│
├── screenshots/
│   ├── executive_overview.png
│   ├── inventory_product_analysis.png
│   └── supplier_logistics_performance.png
│
├── sql/
│   └── SupplyChainAnalytics.sql
│
├── PROJECT_PACKAGE.md
└── README.md
```

---

# Project Outcome

The project follows an end-to-end analytics workflow:

```text
Raw Data
   ↓
SQL Data Preparation
   ↓
Exploratory Analysis
   ↓
Business Analysis
   ↓
Power BI Dashboard
   ↓
Business Insights
   ↓
Operational Recommendations
```

The final solution demonstrates how supply-chain data can be transformed into actionable insights around inventory management, supplier performance, transportation efficiency, and logistics costs.

---

# About

**Chidi Onochie Ronald**

Data Analyst | Supply Chain & Operations

**Core Skills**

SQL • Power BI • Excel • Data Analysis • Supply Chain Analytics • Business Intelligence

---

## Project Repository

[View the full project on GitHub](https://github.com/Onironald/Logistics-Supply-Chain-Analytics)

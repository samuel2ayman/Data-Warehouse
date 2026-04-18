> **Layer:** Gold | **Schema Type:** Star Schema | **Purpose:** Analytical / Reporting

---

## Overview

The Gold Layer star schema is designed to support business intelligence and reporting workloads. It consists of one central **fact table** (`Fact_Sales`) surrounded by two **dimension tables** (`Customer_Dim` and `Product_Dim`), enabling efficient slicing and dicing of sales data by customer and product attributes.

---

## Tables

### 1. Fact_Sales *(Fact Table)*

Central table capturing transactional sales events. Each row represents a single sales order line.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| Order_Number | VARCHAR | Primary Key | Unique identifier for each sales order |
| Customer_Key | INT | Foreign Key → Customer_Dim | Reference to the customer dimension |
| Product_Key | INT | Foreign Key → Product_Dim | Reference to the product dimension |
| Order_Date | DATE | NOT NULL | Date the order was placed |
| Ship_Date | DATE | NULLABLE | Date the order was shipped |
| Due_Date | DATE | NULLABLE | Expected delivery due date |
| Sales_Amount | DECIMAL(18,2) | NOT NULL | Total monetary value of the sale |
| Quantity | INT | NOT NULL | Number of units sold |
| Price | DECIMAL(18,2) | NOT NULL | Unit price at time of sale |

**Grain:** One row per order line item.

**Relationships:**
- `Customer_Key` → `Customer_Dim.Customer_Key` (Many-to-One)
- `Product_Key` → `Product_Dim.Product_Key` (Many-to-One)

---

### 2. Customer_Dim *(Dimension Table)*

Describes the customers who placed orders. Supports demographic and geographic analysis.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| Customer_Key | INT | Primary Key | Surrogate key for the customer dimension |
| Customer_Id | VARCHAR | NOT NULL | Natural / source system customer identifier |
| Customer_Number | VARCHAR | NULLABLE | Business-assigned customer number |
| First_Name | VARCHAR | NOT NULL | Customer's first name |
| Last_Name | VARCHAR | NOT NULL | Customer's last name |
| Gender | VARCHAR | NULLABLE | Customer's gender |
| Martial_Status | VARCHAR | NULLABLE | Customer's marital status |
| Country | VARCHAR | NULLABLE | Country of residence |
| Birth_Date | DATE | NULLABLE | Customer's date of birth |
| cst_create_date | DATE | NOT NULL | Date the customer record was created in source system |

**Primary Key:** `Customer_Key`

**Common Use Cases:**
- Sales segmentation by gender, marital status, or country
- Customer age-band analysis using `Birth_Date`
- Cohort analysis using `cst_create_date`

---

### 3. Product_Dim *(Dimension Table)*

Describes the products sold. Supports category, line, and cost-based analysis.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| Product_Key | INT | Primary Key | Surrogate key for the product dimension |
| Product_Id | VARCHAR | NOT NULL | Natural / source system product identifier |
| Product_Number | VARCHAR | NULLABLE | Business-assigned product number / SKU |
| Product_Name | VARCHAR | NOT NULL | Display name of the product |
| Category_Id | VARCHAR | NULLABLE | Identifier for the product category |
| Sub_Category | VARCHAR | NULLABLE | Sub-category classification of the product |
| Martial_Status | VARCHAR | NULLABLE | Product status flag (active, discontinued, etc.) |
| Maintenance | VARCHAR | NULLABLE | Maintenance tier or requirements |
| Cost | DECIMAL(18,2) | NULLABLE | Standard cost of the product |
| Product_Line | VARCHAR | NULLABLE | High-level product line grouping |
| Start_Date | DATE | NULLABLE | Date the product became available / effective |

**Primary Key:** `Product_Key`

**Common Use Cases:**
- Sales performance by category and sub-category
- Margin analysis using `Cost` vs `Fact_Sales.Sales_Amount`
- Product line trend reporting
- Active vs discontinued product filtering via `Martial_Status`

---

## Entity Relationship Summary

```
Customer_Dim ──────< Fact_Sales >────── Product_Dim
(Customer_Key)    (Customer_Key)        (Product_Key)
                  (Product_Key)
```

| Relationship | Type | From | To |
|---|---|---|---|
| Customer → Sales | One-to-Many | `Customer_Dim.Customer_Key` | `Fact_Sales.Customer_Key` |
| Product → Sales | One-to-Many | `Product_Dim.Product_Key` | `Fact_Sales.Product_Key` |

---

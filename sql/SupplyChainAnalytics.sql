/*
=====================================================================
STUDENT: CHIDI ONOCHIE RONALD
PROJECT: LOGISTICS & SUPPLY CHAIN ANALYTICS
DATABASE: supplychainanalytics
TABLE: supply_chain_data
DATASET: Supply Chain Logistics Dataset
DOWNLOAD LINK: https://www.kaggle.com/datasets/harshsingh2209/supply-chain-analysis?utm_source=chatgpt.com
PURPOSE:
Analyze delivery performance, shipping costs, supplier performance,
inventory movement, regional logistics efficiency and order
fulfillment time.

WORKFLOW:
PART 1 - Database and Table Setup
PART 2 - Data Cleaning
PART 3 - Data Transformation
PART 4 - Exploratory Data Analysis (EDA)
PART 5 - Business Analysis

IMPORTANT:
- The CSV was imported into MySQL Workbench before the SQL analysis.
- The cleaning and transformation steps below are performed directly
  on supply_chain_data, as required by the assignment.
- PART 1 column-renaming statements are intended to be run ONCE on
  the raw imported table. 
=====================================================================
*/

/*=====================================================================
PART 1 - DATABASE AND TABLE SETUP
=====================================================================*/
CREATE DATABASE SupplyChainAnalytics;
USE SupplyChainAnalytics;

/*
CSV IMPORT NOTE:
The CSV was imported into MySQL Workbench using the Table Data Import
Wizard. Therefore, no LOAD DATA LOCAL INFILE command is required here.
*/

/* Verify the imported table */
SELECT *
FROM supply_chain_data
LIMIT 10;

/* I am renaming raw CSV columns and assigning appropriate data types.
   I WILL RUN THIS SECTION ONCE ON THE RAW IMPORTED TABLE. */
   
ALTER TABLE supply_chain_data CHANGE COLUMN `Costs` LogisticsCosts DECIMAL(10,2);   
ALTER TABLE supply_chain_data CHANGE COLUMN `Lead times` OrderLeadTimeDays INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Lead time` SupplierLeadTimeDays INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Product type` ProductType VARCHAR(50);
ALTER TABLE supply_chain_data CHANGE COLUMN `Number of products sold` NumProductsSold INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Revenue generated` RevenueGenerated DECIMAL(12,2);
ALTER TABLE supply_chain_data CHANGE COLUMN `Customer demographics` CustomerDemographics VARCHAR(20);
ALTER TABLE supply_chain_data CHANGE COLUMN `Stock levels` StockLevels INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Order quantities` OrderQuantities INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Shipping times` ShippingTimesDays INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Shipping carriers` ShippingCarrier VARCHAR(20);
ALTER TABLE supply_chain_data CHANGE COLUMN `Shipping costs` ShippingCosts DECIMAL(10,2);
ALTER TABLE supply_chain_data CHANGE COLUMN `Supplier name` SupplierName VARCHAR(20);
ALTER TABLE supply_chain_data CHANGE COLUMN `Location` SupplierLocation VARCHAR(30);
ALTER TABLE supply_chain_data CHANGE COLUMN `Production volumes` ProductionVolumes INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Manufacturing lead time` ManufacturingLeadTimeDays INT;
ALTER TABLE supply_chain_data CHANGE COLUMN `Manufacturing costs` ManufacturingCosts DECIMAL(10,2);
ALTER TABLE supply_chain_data CHANGE COLUMN `Inspection results` InspectionResults VARCHAR(10);
ALTER TABLE supply_chain_data CHANGE COLUMN `Defect rates` DefectRates DECIMAL(6,4);
ALTER TABLE supply_chain_data CHANGE COLUMN `Transportation modes` TransportationMode VARCHAR(20);
ALTER TABLE supply_chain_data CHANGE COLUMN `Routes` Route VARCHAR(20);

/* Correct data types identified during data profiling */
ALTER TABLE supply_chain_data MODIFY COLUMN SKU VARCHAR(50);
ALTER TABLE supply_chain_data MODIFY COLUMN Price DECIMAL(10,2);

/* Updating Customerdemographics column from unknown to Not Available*/

UPDATE supply_chain_data
SET customerdemographics = 'Not Available'
WHERE customerdemographics = 'Unknown';

SELECT CustomerDemographics, COUNT(*) AS Total
FROM supply_chain_data
GROUP BY customerdemographics;

/* Verify structure after setup */
DESCRIBE supply_chain_data;

/* Verify record count */
SELECT COUNT(*) AS TotalRecords
FROM supply_chain_data;

/*=====================================================================
PART 2 - DATA CLEANING
=====================================================================*/

/* 2.1 Checking for NULL values across important fields */
SELECT
    COUNT(*) AS TotalRecords,
    SUM(SKU IS NULL) AS NullSKU,
    SUM(ProductType IS NULL) AS NullProductType,
    SUM(Price IS NULL) AS NullPrice,
    SUM(Availability IS NULL) AS NullAvailability,
    SUM(NumProductsSold IS NULL) AS NullProductsSold,
    SUM(RevenueGenerated IS NULL) AS NullRevenue,
    SUM(CustomerDemographics IS NULL) AS NullCustomerDemographics,
    SUM(StockLevels IS NULL) AS NullStock,
    SUM(OrderQuantities IS NULL) AS NullOrderQuantity,
    SUM(ShippingTimesDays IS NULL) AS NullShippingTime,
    SUM(ShippingCarrier IS NULL) AS NullCarrier,
    SUM(ShippingCosts IS NULL) AS NullShippingCost,
    SUM(SupplierName IS NULL) AS NullSupplier,
    SUM(SupplierLocation IS NULL) AS NullSupplierLocation,
    SUM(ProductionVolumes IS NULL) AS NullProductionVolume,
    SUM(ManufacturingLeadTimeDays IS NULL) AS NullManufacturingLeadTime,
    SUM(ManufacturingCosts IS NULL) AS NullManufacturingCost,
    SUM(InspectionResults IS NULL) AS NullInspectionResults,
    SUM(DefectRates IS NULL) AS NullDefectRate,
    SUM(TransportationMode IS NULL) AS NullTransportationMode,
    SUM(Route IS NULL) AS NullRoute,
    SUM(LogisticsCosts IS NULL) AS NullLogisticsCost,
    SUM(OrderLeadTimeDays IS NULL) AS NullOrderLeadTime,
    SUM(SupplierLeadTimeDays IS NULL) AS NullSupplierLeadTime
FROM supply_chain_data;

/* 2.2 Checking for duplicate SKU values */
SELECT
    SKU,
    COUNT(*) AS DuplicateCount
FROM supply_chain_data
GROUP BY SKU
HAVING COUNT(*) > 1;

/* 2.3 Checking for complete duplicate records */
SELECT
    SKU,
    ProductType,
    Price,
    NumProductsSold,
    RevenueGenerated,
    COUNT(*) AS DuplicateCount
FROM supply_chain_data
GROUP BY
    SKU,
    ProductType,
    Price,
    NumProductsSold,
    RevenueGenerated
HAVING COUNT(*) > 1;

/* 2.4 Checking text fields for blank values */
SELECT *
FROM supply_chain_data
WHERE TRIM(SKU) = ''
   OR TRIM(ProductType) = ''
   OR TRIM(CustomerDemographics) = ''
   OR TRIM(ShippingCarrier) = ''
   OR TRIM(SupplierName) = ''
   OR TRIM(SupplierLocation) = ''
   OR TRIM(InspectionResults) = ''
   OR TRIM(TransportationMode) = ''
   OR TRIM(Route) = '';

/* 2.5 Check text fields for leading/trailing spaces */
SELECT
    SKU,
    ProductType,
    SupplierName,
    SupplierLocation,
    TransportationMode,
    Route,
    InspectionResults
FROM supply_chain_data
WHERE SKU <> TRIM(SKU)
   OR ProductType <> TRIM(ProductType)
   OR SupplierName <> TRIM(SupplierName)
   OR SupplierLocation <> TRIM(SupplierLocation)
   OR TransportationMode <> TRIM(TransportationMode)
   OR Route <> TRIM(Route)
   OR InspectionResults <> TRIM(InspectionResults);

/* 2.6 Clean/standardize text fields */
UPDATE supply_chain_data
SET ProductType = LOWER(TRIM(ProductType)),
    SupplierName = TRIM(SupplierName),
    SupplierLocation = TRIM(SupplierLocation),
    TransportationMode = TRIM(TransportationMode),
    Route = TRIM(Route),
    InspectionResults = TRIM(InspectionResults),
    SKU = TRIM(SKU),
    CustomerDemographics = TRIM(CustomerDemographics),
    ShippingCarrier = TRIM(ShippingCarrier);
    
/* 2.7 Checking categorical values after cleaning */
SELECT ProductType, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY ProductType
ORDER BY ProductType;

SELECT CustomerDemographics, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY CustomerDemographics
ORDER BY CustomerDemographics;

SELECT ShippingCarrier, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY ShippingCarrier
ORDER BY ShippingCarrier;

SELECT SupplierName, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY SupplierName;

SELECT SupplierLocation, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY SupplierLocation
ORDER BY SupplierLocation;

SELECT InspectionResults, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY InspectionResults
ORDER BY InspectionResults;

SELECT TransportationMode, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY TransportationMode
ORDER BY TransportationMode;

SELECT Route, COUNT(*) AS NumberOfRecords
FROM supply_chain_data
GROUP BY Route
ORDER BY Route;

/* 2.8 Check for invalid negative numerical values */
SELECT *
FROM supply_chain_data
WHERE Price < 0
   OR Availability < 0
   OR NumProductsSold < 0
   OR RevenueGenerated < 0
   OR StockLevels < 0
   OR OrderQuantities < 0
   OR ShippingTimesDays < 0
   OR ShippingCosts < 0
   OR ProductionVolumes < 0
   OR ManufacturingLeadTimeDays < 0
   OR ManufacturingCosts < 0
   OR DefectRates < 0
   OR LogisticsCosts < 0
   OR OrderLeadTimeDays < 0
   OR SupplierLeadTimeDays < 0;

/* 2.9 Check data types */
SELECT
    COLUMN_NAME AS ColumnName,
    DATA_TYPE AS DataType,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'supplychainanalytics'
  AND TABLE_NAME = 'supply_chain_data'
ORDER BY ORDINAL_POSITION;

/* 2.10 Check numerical ranges */
SELECT
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice,
    ROUND(AVG(Price), 2) AS AvgPrice,
    MIN(NumProductsSold) AS MinProductsSold,
    MAX(NumProductsSold) AS MaxProductsSold,
    ROUND(AVG(NumProductsSold), 2) AS AvgProductsSold,
    MIN(RevenueGenerated) AS MinRevenue,
    MAX(RevenueGenerated) AS MaxRevenue,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue,
    MIN(StockLevels) AS MinStock,
    MAX(StockLevels) AS MaxStock,
    ROUND(AVG(StockLevels), 2) AS AvgStock,
    MIN(OrderQuantities) AS MinOrderQuantity,
    MAX(OrderQuantities) AS MaxOrderQuantity,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity
FROM supply_chain_data;

SELECT
    MIN(ShippingTimesDays) AS MinShippingTime,
    MAX(ShippingTimesDays) AS MaxShippingTime,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    MIN(ShippingCosts) AS MinShippingCost,
    MAX(ShippingCosts) AS MaxShippingCost,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    MIN(SupplierLeadTimeDays) AS MinSupplierLeadTime,
    MAX(SupplierLeadTimeDays) AS MaxSupplierLeadTime,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    MIN(ManufacturingLeadTimeDays) AS MinManufacturingLeadTime,
    MAX(ManufacturingLeadTimeDays) AS MaxManufacturingLeadTime,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    MIN(OrderLeadTimeDays) AS MinOrderLeadTime,
    MAX(OrderLeadTimeDays) AS MaxOrderLeadTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data;

SELECT
    MIN(ProductionVolumes) AS MinProductionVolume,
    MAX(ProductionVolumes) AS MaxProductionVolume,
    ROUND(AVG(ProductionVolumes), 2) AS AvgProductionVolume,
    MIN(ManufacturingCosts) AS MinManufacturingCost,
    MAX(ManufacturingCosts) AS MaxManufacturingCost,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    MIN(LogisticsCosts) AS MinLogisticsCost,
    MAX(LogisticsCosts) AS MaxLogisticsCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    MIN(DefectRates) AS MinDefectRate,
    MAX(DefectRates) AS MaxDefectRate,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    MIN(Availability) AS MinAvailability,
    MAX(Availability) AS MaxAvailability,
    ROUND(AVG(Availability), 2) AS AvgAvailability
FROM supply_chain_data;

/*=====================================================================
PART 3 - DATA TRANSFORMATION
=====================================================================*/

/* 3.1 Inventory movement ratio */
ALTER TABLE supply_chain_data
ADD COLUMN InventoryMovementRatio DECIMAL(10,2);

UPDATE supply_chain_data
SET InventoryMovementRatio =
    CASE
        WHEN StockLevels = 0 THEN NULL
        ELSE ROUND(NumProductsSold / StockLevels, 2)
    END;

/* 3.2 Inventory status */
ALTER TABLE supply_chain_data
ADD COLUMN InventoryStatus VARCHAR(30);

UPDATE supply_chain_data
SET InventoryStatus =
    CASE
        WHEN StockLevels = 0 THEN 'Out of Stock'
        WHEN StockLevels <= 20 THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END;

/* 3.3 Logistics cost as a percentage of revenue */
ALTER TABLE supply_chain_data
ADD COLUMN LogisticsCostPercentage DECIMAL(10,2);

UPDATE supply_chain_data
SET LogisticsCostPercentage =
    CASE
        WHEN RevenueGenerated = 0 THEN NULL
        ELSE ROUND((LogisticsCosts / RevenueGenerated) * 100, 2)
    END;

/*=====================================================================
PART 4 - EXPLORATORY DATA ANALYSIS (EDA)
=====================================================================*/

/* 4.1 Overall numerical summary */
SELECT
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice,
    ROUND(AVG(Price), 2) AS AvgPrice,
    MIN(NumProductsSold) AS MinProductsSold,
    MAX(NumProductsSold) AS MaxProductsSold,
    ROUND(AVG(NumProductsSold), 2) AS AvgProductsSold,
    MIN(RevenueGenerated) AS MinRevenue,
    MAX(RevenueGenerated) AS MaxRevenue,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue,
    MIN(StockLevels) AS MinStock,
    MAX(StockLevels) AS MaxStock,
    ROUND(AVG(StockLevels), 2) AS AvgStock,
    MIN(OrderQuantities) AS MinOrderQuantity,
    MAX(OrderQuantities) AS MaxOrderQuantity,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity
FROM supply_chain_data;

/* 4.2 Product type performance */
SELECT
    ProductType,
    COUNT(*) AS TotalRecords,
    ROUND(AVG(StockLevels), 2) AS AvgStockLevel,
    ROUND(AVG(NumProductsSold), 2) AS AvgProductsSold,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity,
    ROUND(AVG(Availability), 2) AS AvgAvailability,
    ROUND(AVG(InventoryMovementRatio), 2) AS InventoryMovementRatio
FROM supply_chain_data
GROUP BY ProductType
ORDER BY InventoryMovementRatio DESC;

/* 4.3 Top-selling products */
SELECT
    SKU,
    ProductType,
    NumProductsSold,
    StockLevels,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
ORDER BY NumProductsSold DESC
LIMIT 10;

/* 4.4 Top revenue-generating products */
SELECT
    SKU,
    ProductType,
    ROUND(RevenueGenerated, 2) AS RevenueGenerated,
    Price,
    NumProductsSold,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
ORDER BY RevenueGenerated DESC
LIMIT 10;

/* 4.5 Lowest revenue-generating products */
SELECT
    SKU,
    ProductType,
    ROUND(RevenueGenerated, 2) AS RevenueGenerated,
    Price,
    NumProductsSold,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
ORDER BY RevenueGenerated ASC
LIMIT 10;

/* 4.6 Supplier cost performance */
SELECT
    SupplierName,
    COUNT(*) AS TotalOrders,
    ROUND(SUM(ManufacturingCosts), 2) AS TotalManufacturingCost,
    ROUND(SUM(ShippingCosts), 2) AS TotalShippingCost,
    ROUND(SUM(LogisticsCosts), 2) AS TotalLogisticsCost,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgLogisticsCost DESC;

/* 4.7 Supplier fulfillment performance */
SELECT
    SupplierName,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgOrderLeadTime DESC;

/* 4.8 Supplier inspection performance */
SELECT
    SupplierName,
    COUNT(*) AS TotalInspections,
    SUM(CASE WHEN InspectionResults = 'Pass' THEN 1 ELSE 0 END) AS PassedInspections,
    SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END) AS FailedInspections,
    SUM(CASE WHEN InspectionResults = 'Pending' THEN 1 ELSE 0 END) AS PendingInspections,
    ROUND(
        SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS FailureRatePercent
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY FailureRatePercent DESC;

/* 4.9 Completed-inspection failure rate (excluding Pending) */
SELECT
    SupplierName,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN InspectionResults = 'Pass' THEN 1 ELSE 0 END) AS Passed,
    SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END) AS Failed,
    SUM(CASE WHEN InspectionResults = 'Pending' THEN 1 ELSE 0 END) AS Pending,
    ROUND(
        SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END)
        / NULLIF(
            SUM(CASE WHEN InspectionResults IN ('Pass', 'Fail') THEN 1 ELSE 0 END),
            0
        ) * 100,
        2
    ) AS CompletedInspectionFailureRate
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY CompletedInspectionFailureRate DESC;

/* 4.10 Transportation mode performance */
SELECT
    TransportationMode,
    COUNT(*) AS TotalOrders,
    ROUND(SUM(ShippingCosts), 2) AS TotalShippingCost,
    ROUND(SUM(LogisticsCosts), 2) AS TotalLogisticsCost,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY TransportationMode
ORDER BY AvgLogisticsCost DESC;

/* 4.11 Route performance */
SELECT
    Route,
    COUNT(*) AS TotalOrders,
    ROUND(SUM(ShippingCosts), 2) AS TotalShippingCost,
    ROUND(SUM(LogisticsCosts), 2) AS TotalLogisticsCost,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY Route
ORDER BY AvgLogisticsCost DESC;

/* 4.12 Route and transportation combination */
SELECT
    Route,
    TransportationMode,
    COUNT(*) AS NumberOfOrders,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY Route, TransportationMode
ORDER BY Route, AvgLogisticsCost DESC;

/* 4.13 Shipping carrier performance */
SELECT
    ShippingCarrier,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost
FROM supply_chain_data
GROUP BY ShippingCarrier
ORDER BY AvgShippingTime ASC;

/* 4.14 Regional logistics efficiency */
SELECT
    SupplierLocation,
    COUNT(*) AS TotalOrders,
    ROUND(SUM(LogisticsCosts), 2) AS TotalLogisticsCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY SupplierLocation
ORDER BY AvgLogisticsCost DESC;

/* 4.15 Inventory movement by product type */
SELECT
    ProductType,
    ROUND(AVG(NumProductsSold), 2) AS AvgProductsSold,
    ROUND(AVG(StockLevels), 2) AS AvgStockLevel,
    ROUND(AVG(InventoryMovementRatio), 2) AS InventoryMovementRatio
FROM supply_chain_data
GROUP BY ProductType
ORDER BY InventoryMovementRatio DESC;

/* 4.16 Low-stock products */
SELECT
    SKU,
    ProductType,
    StockLevels,
    NumProductsSold,
    OrderQuantities,
    Availability,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
WHERE StockLevels BETWEEN 1 AND 20
ORDER BY StockLevels ASC, NumProductsSold DESC;

/* 4.17 Out-of-stock products */
SELECT
    SKU,
    ProductType,
    StockLevels,
    NumProductsSold,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
WHERE StockLevels = 0
ORDER BY NumProductsSold DESC;

/* 4.18 Highest logistics-cost products */
SELECT
    SKU,
    ProductType,
    ROUND(LogisticsCosts, 2) AS LogisticsCost,
    ROUND(ShippingCosts, 2) AS ShippingCost,
    ROUND(ManufacturingCosts, 2) AS ManufacturingCost,
    ROUND(RevenueGenerated, 2) AS RevenueGenerated,
    SupplierName,
    SupplierLocation,
    TransportationMode,
    Route
FROM supply_chain_data
ORDER BY LogisticsCosts DESC
LIMIT 10;

/* 4.19 Overall cost analysis */
SELECT
    ROUND(SUM(RevenueGenerated), 2) AS TotalRevenue,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue,
    ROUND(SUM(ManufacturingCosts), 2) AS TotalManufacturingCost,
    ROUND(SUM(ShippingCosts), 2) AS TotalShippingCost,
    ROUND(SUM(LogisticsCosts), 2) AS TotalLogisticsCost,
    ROUND(
        SUM(LogisticsCosts) / NULLIF(SUM(RevenueGenerated), 0) * 100,
        2
    ) AS LogisticsCostPercentage
FROM supply_chain_data;

/* =========================================================
   4.20 PRICE AND DEMAND ANALYSIS
   Purpose: determine whether product price is associated with
   demand and compare price, units sold, and revenue by
   product type.
   ========================================================= */


/* 4.20.1 Product Type Price, Demand and Revenue Analysis
   Purpose: compare pricing, units sold, and revenue across
   different product types.
*/

SELECT
    ProductType,
    COUNT(*) AS TotalSKUs,
    ROUND(AVG(Price), 2) AS AvgPrice,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold,
    ROUND(SUM(NumProductsSold), 2) AS TotalUnitsSold,
    ROUND(SUM(RevenueGenerated), 2) AS TotalRevenue,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue
FROM supply_chain_data
GROUP BY ProductType
ORDER BY TotalRevenue DESC;


/* 4.20.2 Top 10 Highest-Priced SKUs
   Purpose: examine whether the highest-priced products
   generate strong sales volume and revenue.
*/

SELECT
    SKU,
    ProductType,
    ROUND(Price, 2) AS Price,
    NumProductsSold,
    ROUND(RevenueGenerated, 2) AS RevenueGenerated
FROM supply_chain_data
ORDER BY Price DESC
LIMIT 10;

/* 4.21 Customer demographic analysis
   Purpose: ensure the CustomerDemographics column is not ignored and
   identify differences in demand, revenue and order quantity. */
SELECT
    CustomerDemographics,
    COUNT(*) AS TotalRecords,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold,
    SUM(NumProductsSold) AS TotalUnitsSold,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue,
    ROUND(SUM(RevenueGenerated), 2) AS TotalRevenue
FROM supply_chain_data
GROUP BY CustomerDemographics
ORDER BY TotalRevenue DESC;

/* =========================================================
   4.22 AVAILABILITY ANALYSIS
   Purpose: assess whether product availability differs by
   product type, supplier and supplier location.
   ========================================================= */


/* 4.22.1 Availability by Product Type
   Purpose: compare availability, stock levels and order
   quantities across product types.
*/

SELECT
    ProductType,
    COUNT(*) AS TotalSKUs,
    ROUND(AVG(Availability), 2) AS AvgAvailability,
    MIN(Availability) AS MinAvailability,
    MAX(Availability) AS MaxAvailability,
    ROUND(AVG(StockLevels), 2) AS AvgStockLevel,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity
FROM supply_chain_data
GROUP BY ProductType
ORDER BY AvgAvailability DESC;


/* 4.22.2 Availability by Supplier
   Purpose: compare supplier availability, stock levels,
   order quantities and average units sold.
*/

SELECT
    SupplierName,
    ROUND(AVG(Availability), 2) AS AvgAvailability,
    ROUND(AVG(StockLevels), 2) AS AvgStockLevel,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgAvailability DESC;


/* 4.22.3 Availability by Supplier Location
   Purpose: compare product availability, stock levels,
   order quantities and average units sold across supplier
   locations.
*/

SELECT
    SupplierLocation,
    COUNT(*) AS TotalSKUs,
    ROUND(AVG(Availability), 2) AS AvgAvailability,
    MIN(Availability) AS MinAvailability,
    MAX(Availability) AS MaxAvailability,
    ROUND(AVG(StockLevels), 2) AS AvgStockLevel,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold
FROM supply_chain_data
GROUP BY SupplierLocation
ORDER BY AvgAvailability DESC;

/* =========================================================
   4.23 ORDER QUANTITY ANALYSIS
   Purpose: compare order quantities with demand and supplier
   lead time.
   ========================================================= */


/* 4.23.1 Order Quantity, Demand and Supplier Lead Time */

SELECT
    SupplierName,
    COUNT(*) AS TotalSKUs,
    SUM(OrderQuantities) AS TotalOrderQuantity,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgOrderQuantity DESC;


/* 4.23.2 Order Quantity and Demand by Product Type */

SELECT
    ProductType,
    SUM(OrderQuantities) AS TotalOrderQuantity,
    ROUND(AVG(OrderQuantities), 2) AS AvgOrderQuantity,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold,
    ROUND(AVG(StockLevels), 2) AS AvgStockLevel
FROM supply_chain_data
GROUP BY ProductType
ORDER BY AvgOrderQuantity DESC;

/* 4.24 Shipping cost analysis by carrier
   Purpose: evaluate ShippingCosts separately from LogisticsCosts. */
SELECT
    ShippingCarrier,
    COUNT(*) AS TotalOrders,
    ROUND(SUM(ShippingCosts), 2) AS TotalShippingCost,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost
FROM supply_chain_data
GROUP BY ShippingCarrier
ORDER BY AvgShippingCost DESC;

/* 4.25 Shipping cost analysis by transportation mode
   Purpose: identify the cost-speed trade-off using the actual
   ShippingCosts field as well as LogisticsCosts. */
SELECT
    TransportationMode,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY TransportationMode
ORDER BY AvgShippingCost ASC;

/* =========================================================
   4.26 PRODUCTION VOLUME AND MANUFACTURING PERFORMANCE
   Purpose: analyse ProductionVolumes, ManufacturingCosts and
   ManufacturingLeadTimeDays together.
   ========================================================= */


/* 4.26.1 Production and Manufacturing Performance by Supplier */

SELECT
    SupplierName,
    COUNT(*) AS TotalSKUs,
    SUM(ProductionVolumes) AS TotalProductionVolume,
    ROUND(AVG(ProductionVolumes), 2) AS AvgProductionVolume,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgManufacturingCost ASC;


/* 4.26.2 Production and Manufacturing Performance by Product Type */

SELECT
    ProductType,
    SUM(ProductionVolumes) AS TotalProductionVolume,
    ROUND(AVG(ProductionVolumes), 2) AS AvgProductionVolume,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate
FROM supply_chain_data
GROUP BY ProductType
ORDER BY AvgManufacturingLeadTime ASC;

/* 4.27 Manufacturing cost and lead-time efficiency
   Purpose: identify suppliers with a favourable or unfavourable
   manufacturing cost-speed combination. */
SELECT
    SupplierName,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(ProductionVolumes), 2) AS AvgProductionVolume,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgManufacturingLeadTime ASC, AvgManufacturingCost ASC;

/* 4.28 Inspection and quality performance
   Purpose: analyse InspectionResults directly instead of only using
   it as a slicer in Power BI. */
SELECT
    InspectionResults,
    COUNT(*) AS TotalInspections,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime
FROM supply_chain_data
GROUP BY InspectionResults
ORDER BY AvgDefectRate DESC;

/* =========================================================
   4.29 DEFECT-RATE ANALYSIS BY PRODUCT TYPE AND SUPPLIER
   ========================================================= */

/* 4.29.1 Defect-Rate Analysis by Product Type */

SELECT
    ProductType,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    MIN(DefectRates) AS MinDefectRate,
    MAX(DefectRates) AS MaxDefectRate,
    SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END) AS FailedInspections,
    COUNT(*) AS TotalInspections
FROM supply_chain_data
GROUP BY ProductType
ORDER BY AvgDefectRate DESC;


/* 4.29.2 Defect-Rate and Inspection Failure Analysis by Supplier */

SELECT
    SupplierName,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END) AS FailedInspections,
    COUNT(*) AS TotalInspections,
    ROUND(
        SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS FailureRatePercent
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgDefectRate DESC;

/* 4.30 Availability and replenishment risk
   Purpose: combine availability, stock, demand and order quantity
   to identify products requiring attention. */
SELECT
    SKU,
    ProductType,
    Availability,
    StockLevels,
    NumProductsSold,
    OrderQuantities,
    InventoryStatus,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
ORDER BY Availability ASC, StockLevels ASC, NumProductsSold DESC;

/* 4.31 Cost structure by supplier
   Purpose: compare manufacturing, shipping and logistics costs together. */
SELECT
    SupplierName,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(
        AVG(ManufacturingCosts + ShippingCosts + LogisticsCosts),
        2
    ) AS AvgTotalOperationalCost,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgTotalOperationalCost ASC;

/* 4.32 Overall lead-time composition
   Purpose: show the separate operational components of delivery time. */
SELECT
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime,
    ROUND(
        AVG(SupplierLeadTimeDays + ManufacturingLeadTimeDays + ShippingTimesDays),
        2
    ) AS AvgCombinedOperationalTime
FROM supply_chain_data;

/*=====================================================================
PART 5 - BUSINESS ANALYSIS
=====================================================================*/

/* 5.1 FINAL EXECUTIVE KPI SUMMARY */
SELECT
    COUNT(*) AS TotalOrders,
    ROUND(SUM(RevenueGenerated), 2) AS TotalRevenue,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue,
    ROUND(SUM(ManufacturingCosts), 2) AS TotalManufacturingCost,
    ROUND(SUM(ShippingCosts), 2) AS TotalShippingCost,
    ROUND(SUM(LogisticsCosts), 2) AS TotalLogisticsCost,
    ROUND(
        SUM(LogisticsCosts) / NULLIF(SUM(RevenueGenerated), 0) * 100,
        2
    ) AS LogisticsCostPercentage,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    ROUND(AVG(Availability), 2) AS AvgAvailability,
    SUM(CASE WHEN StockLevels = 0 THEN 1 ELSE 0 END) AS OutOfStockProducts,
    SUM(CASE WHEN StockLevels > 0 AND StockLevels <= 20 THEN 1 ELSE 0 END) AS LowStockProducts
FROM supply_chain_data;


/* 5.2 Critical inventory risks */
SELECT
    SKU,
    ProductType,
    StockLevels,
    NumProductsSold,
    OrderQuantities,
    Availability,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
WHERE StockLevels <= 20
ORDER BY StockLevels ASC, NumProductsSold DESC;

/* 5.3 High-demand products with critically low stock */
SELECT
    SKU,
    ProductType,
    StockLevels,
    NumProductsSold,
    SupplierName,
    SupplierLocation
FROM supply_chain_data
WHERE StockLevels <= 20
  AND NumProductsSold >= 500
ORDER BY NumProductsSold DESC;

/* 5.4 Most expensive logistics routes */
SELECT
    Route,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY Route
ORDER BY AvgLogisticsCost DESC;

/* 5.5 Supplier efficiency and risk */
SELECT
    SupplierName,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgDefectRate DESC, AvgSupplierLeadTime DESC;

/* 5.6 Regional logistics efficiency */
SELECT
    SupplierLocation,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY SupplierLocation
ORDER BY AvgLogisticsCost DESC;

/* 5.7 Transportation cost-versus-speed trade-off */
SELECT
    TransportationMode,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY TransportationMode
ORDER BY AvgLogisticsCost ASC;

/* 5.8 Identify products with the highest logistics burden */
SELECT
    SKU,
    ProductType,
    ROUND(LogisticsCosts, 2) AS LogisticsCost,
    ROUND(ShippingCosts, 2) AS ShippingCost,
    ROUND(ManufacturingCosts, 2) AS ManufacturingCost,
    ROUND(RevenueGenerated, 2) AS RevenueGenerated,
    SupplierName,
    SupplierLocation,
    TransportationMode,
    Route
FROM supply_chain_data
ORDER BY LogisticsCosts DESC
LIMIT 10;

/* 5.9 Identify suppliers associated with longer fulfillment times */
SELECT
    SupplierName,
    COUNT(*) AS TotalOrders,
    ROUND(AVG(SupplierLeadTimeDays), 2) AS AvgSupplierLeadTime,
    ROUND(AVG(ManufacturingLeadTimeDays), 2) AS AvgManufacturingLeadTime,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY AvgOrderLeadTime DESC;

/* 5.10 Route + transportation combinations requiring attention */
SELECT
    Route,
    TransportationMode,
    COUNT(*) AS NumberOfOrders,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(AVG(ShippingTimesDays), 2) AS AvgShippingTime,
    ROUND(AVG(OrderLeadTimeDays), 2) AS AvgOrderLeadTime
FROM supply_chain_data
GROUP BY Route, TransportationMode
ORDER BY AvgLogisticsCost DESC;

/* 5.11 Products with high demand and replenishment risk */

SELECT
    SKU,
    ProductType,
    StockLevels,
    NumProductsSold,
    OrderQuantities,
    Availability,
    InventoryStatus,
    SupplierName,
    SupplierLocation,
    CASE
        WHEN StockLevels = 0 THEN 'CRITICAL - OUT OF STOCK'
        WHEN StockLevels <= 20 AND NumProductsSold >= 500
            THEN 'HIGH PRIORITY'
        WHEN StockLevels <= 20
            THEN 'REPLENISH'
        ELSE 'MONITOR'
    END AS ReplenishmentPriority
FROM supply_chain_data
WHERE StockLevels <= 20
ORDER BY
    CASE
        WHEN StockLevels = 0 THEN 1
        WHEN StockLevels <= 20 AND NumProductsSold >= 500 THEN 2
        ELSE 3
    END,
    NumProductsSold DESC;

/* 5.12 Product type performance summary
   Purpose: identify product categories with strong demand,
   revenue and operational performance. */

SELECT
    ProductType,
    COUNT(*) AS TotalSKUs,
    ROUND(AVG(Price), 2) AS AvgPrice,
    SUM(NumProductsSold) AS TotalUnitsSold,
    ROUND(AVG(NumProductsSold), 2) AS AvgUnitsSold,
    ROUND(SUM(RevenueGenerated), 2) AS TotalRevenue,
    ROUND(AVG(Availability), 2) AS AvgAvailability,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost
FROM supply_chain_data
GROUP BY ProductType
ORDER BY TotalRevenue DESC;

/* 5.13 Supplier cost-efficiency analysis
   Purpose: compare operational costs against revenue
   to identify cost-efficient suppliers. */

SELECT
    SupplierName,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost,
    ROUND(AVG(ShippingCosts), 2) AS AvgShippingCost,
    ROUND(AVG(LogisticsCosts), 2) AS AvgLogisticsCost,
    ROUND(
        AVG(ManufacturingCosts + ShippingCosts + LogisticsCosts),
        2
    ) AS AvgTotalOperationalCost,
    ROUND(AVG(RevenueGenerated), 2) AS AvgRevenue,
    ROUND(
        AVG(RevenueGenerated) /
        NULLIF(AVG(ManufacturingCosts + ShippingCosts + LogisticsCosts), 0),
        2
    ) AS RevenueToOperationalCostRatio
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY RevenueToOperationalCostRatio DESC;

/* 5.14 Supplier quality risk
   Purpose: identify suppliers requiring quality-control attention. */

SELECT
    SupplierName,
    COUNT(*) AS TotalInspections,
    SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END) AS FailedInspections,
    ROUND(
        SUM(CASE WHEN InspectionResults = 'Fail' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS FailureRatePercent,
    ROUND(AVG(DefectRates), 2) AS AvgDefectRate,
    ROUND(AVG(ManufacturingCosts), 2) AS AvgManufacturingCost
FROM supply_chain_data
GROUP BY SupplierName
ORDER BY FailureRatePercent DESC;

/* 5.15 Final data quality verification */

SELECT
    COUNT(*) AS TotalRecords,
    SUM(SKU IS NULL) AS NullSKU,
    SUM(ProductType IS NULL) AS NullProductType,
    SUM(Price IS NULL) AS NullPrice,
    SUM(RevenueGenerated IS NULL) AS NullRevenue,
    SUM(StockLevels IS NULL) AS NullStock,
    SUM(SupplierName IS NULL) AS NullSupplier,
    SUM(TransportationMode IS NULL) AS NullTransportationMode,
    SUM(Route IS NULL) AS NullRoute
FROM supply_chain_data;

/*=====================================================================
FINAL BUSINESS THEMES IDENTIFIED FROM THE ANALYSIS
=====================================================================

1. INVENTORY REPLENISHMENT RISK
   Several SKUs have low or zero stock while maintaining strong demand,
   creating potential stock-out and lost-sales risks.

2. SKINCARE IS THE STRONGEST COMMERCIAL CATEGORY
   Skincare generates the highest total revenue and units sold,
   making it the most commercially important product category.

3. HAIRCARE REQUIRES OPERATIONAL ATTENTION
   Haircare has the lowest availability and highest defect rate,
   indicating opportunities for inventory and quality improvement.

4. COSMETICS HAS A STRONG OPERATIONAL PROFILE
   Cosmetics has the lowest manufacturing cost and defect rate
   and the highest average availability.

5. SUPPLIER 3 IS THE MOST COST-EFFICIENT
   Supplier 3 has the lowest average operational cost, highest
   average revenue and highest revenue-to-operational-cost ratio.

6. SUPPLIER 4 PRESENTS THE GREATEST SUPPLIER RISK
   Supplier 4 has the highest inspection failure rate and highest
   manufacturing cost, while also generating the lowest average revenue.

7. LOGISTICS COST OPTIMIZATION IS REQUIRED
   Logistics costs differ significantly across suppliers, routes,
   regions and transportation modes, creating opportunities for
   cost reduction.

8. LEAD-TIME REDUCTION SHOULD FOCUS UPSTREAM
   Supplier and manufacturing processes contribute more to operational
   lead time than shipping, suggesting that upstream improvements
   could generate greater efficiency gains.

9. QUALITY PERFORMANCE VARIES ACROSS SUPPLIERS
   Supplier 1 records the lowest average defect rate, while Supplier 3
   records the lowest inspection failure rate.

10. DEMAND-BASED INVENTORY PLANNING IS REQUIRED
    Inventory decisions should consider demand, stock levels,
    availability and order quantities rather than stock levels alone.
*/


/*=====================================================================
FINAL BUSINESS RECOMMENDATIONS
=====================================================================

1. PRIORITIZE REPLENISHMENT
   Immediately monitor and replenish high-demand SKUs with low or
   zero stock levels.

2. PROTECT SKINCARE AVAILABILITY
   Maintain adequate inventory levels for skincare because of its
   strong demand and highest revenue contribution.

3. IMPROVE HAIRCARE PERFORMANCE
   Investigate the lower availability and higher defect rate in
   haircare through better inventory and quality controls.

4. LEVERAGE COSMETICS' OPERATIONAL STRENGTH
   Evaluate opportunities to increase cosmetics sales while maintaining
   its favourable manufacturing cost and quality performance.

5. REVIEW SUPPLIER 4
   Conduct an immediate review of Supplier 4's quality, manufacturing
   cost and overall commercial performance.

6. CONSIDER SUPPLIER 3 FOR STRATEGIC SOURCING
   Supplier 3 demonstrates the strongest cost-efficiency profile,
   subject to capacity, quality and lead-time considerations.

7. CONTROL SUPPLIER 5 QUALITY
   Closely monitor Supplier 5 because it has the highest average
   defect rate.

8. REDUCE LOGISTICS COSTS
   Investigate high-cost suppliers, routes and locations to identify
   opportunities for logistics optimization.

9. REDUCE UPSTREAM LEAD TIMES
   Focus improvement efforts on supplier, ordering and manufacturing
   processes rather than concentrating only on shipping.

10. STRENGTHEN DEMAND-BASED INVENTORY PLANNING
    Use sales demand, stock levels, availability and order quantities
    together when setting replenishment priorities.
*/


/*=====================================================================
END OF SQL PROJECT

NEXT PROJECT STAGE:
I will be connecting the cleaned/transformed supply_chain_data table to Power BI
and build the executive dashboard.
=====================================================================
*/

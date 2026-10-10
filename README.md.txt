# End-to-End Data Engineering Project on Google Cloud

An end-to-end data engineering and machine learning project built using Google Cloud Platform, Databricks, Delta Lake, BigQuery, Cloud Composer, Apache Airflow, and Power BI.

The project demonstrates how to build an incremental data pipeline, implement a dimensional data warehouse, validate data quality, generate personalized product recommendations, and orchestrate workflows.

## Architecture

**Pipeline flow:**

PostgreSQL → Databricks → Google Cloud Storage (Delta Lake) → BigQuery → Power BI

Machine learning recommendations are generated using Spark MLlib ALS and stored in BigQuery. Cloud Composer orchestrates the pipeline from raw ingestion through curated processing and recommendation generation.

![Project Architecture](architecture/architecture_diagram.png)

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL | Source database containing customers, products, orders, and order items |
| Google Cloud Storage | Stores raw and processed Delta Lake data |
| Databricks | Data ingestion, transformation, and machine learning |
| Delta Lake | Reliable storage for incremental data processing |
| BigQuery | Curated data warehouse, data quality results, and ML outputs |
| Cloud Composer | Managed Apache Airflow orchestration |
| Spark MLlib ALS | Customer-product recommendation model |
| Power BI | Business intelligence and dashboard visualization |
| Google Secret Manager | Secure storage of the Databricks API token |
| IAM | Access control for Google Cloud resources |

## Project Structure

```text
gcp-end-to-end-data-engineering/
│
├── architecture/
│   ├── architecture_diagram.png
│   └── data_model_diagram.png
│
├── source_database/
│   ├── schema.sql
│   ├── generate_synthetic_data.py
│   └── README.md
│
├── databricks/
│   ├── raw_pipeline/
│   ├── curated_pipeline/
│   ├── machine_learning/
│   └── README.md
│
├── bigquery/
│   ├── raw/
│   ├── warehouse/
│   ├── data_quality/
│   ├── enriched_views/
│   ├── ml/
│   └── README.md
│
├── airflow/
│   ├── databricks_raw_curated_ml.py
│   └── README.md
│
├── powerbi/
│   ├── screenshots/
│   └── README.md
│
├── docs/
│   ├── setup_guide.md
│   ├── design_decisions.md
│   └── troubleshooting.md
│
├── .gitignore
└── README.md
```

*Keep only the files and folders that you have actually created. Update the structure as the project evolves.*

## 1. Source Database

PostgreSQL acts as the operational source system for a chocolate shop.

### Source tables

- `customers` — customer details and segmentation.
- `products` — product information, pricing, and stock.
- `orders` — order headers, status, shipping, and totals.
- `order_items` — products and quantities associated with each order.

Synthetic data is used to demonstrate initial loading and ongoing changes without exposing real customer information.

Database update triggers maintain the `updated_at` column when existing records are modified.

## 2. Raw Layer — Databricks and Delta Lake

Databricks reads source data from PostgreSQL and writes it to Google Cloud Storage as Delta Lake tables.

### Key features

- Incremental ingestion using the `updated_at` watermark.
- Initial and subsequent incremental loads.
- Delta Lake storage for raw source records.
- Watermark management to track successful processing progress.
- Separation of ingestion logic from warehouse transformation logic.

The raw layer preserves source data for downstream processing.

## 3. Curated Layer — BigQuery Data Warehouse

The curated layer transforms raw data into analysis-ready warehouse tables.

| Table | Design | Purpose |
|---|---|---|
| `DIM_CUSTOMER` | SCD Type 2 | Maintains customer history |
| `DIM_PRODUCT` | SCD Type 1 | Maintains the latest product attributes |
| `FACT_ORDER` | Fact table | Stores order-level business measures |
| `MAP_ORDER_ITEM` | Mapping/detail table | Connects orders and products through order items |

### Warehouse processing

- Deduplication and data standardization.
- Incremental merge processing.
- Historical tracking for customer changes.
- Current-value updates for product attributes.
- Fact and mapping table creation for analytics.

## 4. Data Quality Framework

The project includes a centralized `DATA_QUALITY_RESULTS` table in BigQuery.

The framework records information such as:

- Pipeline run ID and table name.
- Data quality rule and rule type.
- Total, passed, and failed record counts.
- Pass and failure percentages.
- Validation status and execution timestamps.

This provides visibility into data quality across the curated pipeline.

## 5. Enriched Views and Analytics

BigQuery views combine curated dimensions and facts into analysis-ready datasets.

These views can support business questions such as:

- Which products generate the most revenue?
- Which customers place the most orders?
- How do sales vary by city and customer segment?
- Which products are purchased most frequently?
- How do order statuses and sales trends change over time?

Power BI connects to BigQuery using DirectQuery for dashboard reporting.

## 6. Machine Learning — Product Recommendations

The machine learning component uses **Spark MLlib Alternating Least Squares (ALS)** to generate personalized customer-product recommendations.

### Processing flow

1. Read curated orders, customers, order items, and products from BigQuery.
2. Build customer-product interaction data.
3. Train the ALS recommendation model.
4. Generate product recommendations for customers.
5. Save model artifacts to Google Cloud Storage.
6. Write recommendations and model metadata to BigQuery.

### ML tables

| Table | Purpose |
|---|---|
| `CUSTOMER_PRODUCT_INTERACTIONS` | Customer-product interaction data used for training |
| `CUSTOMER_PRODUCT_RECOMMENDATIONS` | Generated product recommendations |
| `CUSTOMER_PRODUCT_ALS_MODEL_METADATA` | Model run and training metadata |

The recommendations can support personalized product discovery and customer engagement.

## 7. Orchestration — Cloud Composer and Apache Airflow

Cloud Composer orchestrates the Databricks jobs through the Databricks Jobs API.

### DAG

`databricks_raw_curated_ml`

The DAG executes the following tasks sequentially:

1. Raw ingestion.
2. Curated warehouse processing.
3. ML recommendation generation.

### Scheduling and reliability

- Schedule: every six hours.
- Maximum active DAG runs: one.
- Retries: one retry with a two-minute delay.
- Task execution timeout: three hours per task.
- Databricks API token retrieved from Google Secret Manager.

A downstream task runs only after its upstream task succeeds. Failed tasks are reported through Airflow's task status and logs.

## Security and Configuration

This repository contains example code and configuration templates. It does not provide access to the deployed cloud resources.

Before running the project, configure your own:

- Google Cloud project and billing.
- Databricks workspace and job IDs.
- Google Cloud Storage buckets.
- BigQuery datasets and Delta Lake connections.
- IAM permissions and service accounts.
- Secret Manager secret and Databricks API token.
- Cloud Composer environment.

**Never commit** access tokens, passwords, service-account JSON keys, `.env` files, or private production data.

Use placeholders in configuration examples, and create resources in your own environment.

## Setup Overview

1. Create the PostgreSQL source tables and populate them with synthetic data.
2. Configure Databricks connectivity to PostgreSQL and Google Cloud Storage.
3. Run the raw ingestion pipeline and validate the Delta Lake data.
4. Configure the BigQuery external tables and curated dataset.
5. Run the curated pipelines and validate the warehouse tables.
6. Create and validate the enriched BigQuery views.
7. Run the ALS recommendation pipeline and inspect its BigQuery outputs.
8. Configure Cloud Composer, Secret Manager, and the Databricks Jobs API.
9. Run the Airflow DAG and verify the Raw → Curated → ML sequence.
10. Connect Power BI to BigQuery and build the dashboard.

Refer to the `docs/` directory for environment-specific setup instructions and design decisions.

## Learning Outcomes

This project demonstrates practical experience with:

- Incremental ETL and watermark-based processing.
- Delta Lake and cloud data lake design.
- Dimensional data warehousing and SCD Type 1/Type 2.
- BigQuery external tables and analytical views.
- Centralized data quality monitoring.
- Spark MLlib recommendation models.
- Workflow orchestration using Cloud Composer and Airflow.
- Cloud IAM, Secret Manager, and secure configuration.
- BI integration using Power BI DirectQuery.

## Future Enhancements

- Add automated data quality gates before downstream processing.
- Add notifications and operational alerting for pipeline failures.
- Add model evaluation and recommendation-quality metrics.
- Add CI/CD for SQL, notebooks, and Airflow DAGs.
- Add automated integration tests and deployment documentation.

## Disclaimer

This project is intended for learning and portfolio demonstration. It uses synthetic source data and requires independent cloud configuration. Resource names, costs, permissions, and service availability depend on the deployment environment.

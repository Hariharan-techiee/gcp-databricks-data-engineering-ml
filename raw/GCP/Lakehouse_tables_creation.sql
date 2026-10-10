```sql
-- Purpose: Create BigQuery external tables over GCS Delta Lake data.
-- Prerequisites:
--   1. The GCS folders contain valid Delta Lake tables.
--   2. A BigQuery connection has been configured with appropriate permissions.
--   3. The BigQuery dataset exists in the appropriate location.

CREATE OR REPLACE EXTERNAL TABLE
  `YOUR_GCP_PROJECT_ID.Gcp_Raw.customers`
WITH CONNECTION
  `YOUR_REGION.YOUR_CONNECTION_NAME`
OPTIONS (
  format = 'DELTA_LAKE',
  uris = ['gs://YOUR_RAW_BUCKET_NAME/customers/']
);

CREATE OR REPLACE EXTERNAL TABLE
  `YOUR_GCP_PROJECT_ID.Gcp_Raw.order_items`
WITH CONNECTION
  `YOUR_REGION.YOUR_CONNECTION_NAME`
OPTIONS (
  format = 'DELTA_LAKE',
  uris = ['gs://YOUR_RAW_BUCKET_NAME/order_items/']
);

CREATE OR REPLACE EXTERNAL TABLE
  `YOUR_GCP_PROJECT_ID.Gcp_Raw.orders`
WITH CONNECTION
  `YOUR_REGION.YOUR_CONNECTION_NAME`
OPTIONS (
  format = 'DELTA_LAKE',
  uris = ['gs://YOUR_RAW_BUCKET_NAME/orders/']
);

CREATE OR REPLACE EXTERNAL TABLE
  `YOUR_GCP_PROJECT_ID.Gcp_Raw.products`
WITH CONNECTION
  `YOUR_REGION.YOUR_CONNECTION_NAME`
OPTIONS (
  format = 'DELTA_LAKE',
  uris = ['gs://YOUR_RAW_BUCKET_NAME/products/']
);
```
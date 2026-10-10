"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DATA_QUALITY_REJECTS`
(
  reject_id INT64 NOT NULL,
  run_id STRING NOT NULL,
  table_name STRING NOT NULL,
  dq_rule_id STRING NOT NULL,
  dq_rule_name STRING NOT NULL,
  record_key STRING,
  record_data STRING,
  failure_reason STRING NOT NULL,
  source_system STRING NOT NULL,
  pipeline_name STRING NOT NULL,
  rejected_at TIMESTAMP NOT NULL
);"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DATA_QUALITY_RESULTS`
(
  dq_result_sk INT64,
  run_id STRING,
  table_name STRING,
  column_name STRING,
  dq_rule_id STRING,
  dq_rule_name STRING,
  dq_rule_type STRING,
  check_level STRING,
  total_records INT64,
  passed_records INT64,
  failed_records INT64,
  pass_percentage NUMERIC(5, 2),
  fail_percentage NUMERIC(5, 2),
  dq_status STRING,
  error_message STRING,
  source_system STRING,
  pipeline_name STRING,
  execution_timestamp TIMESTAMP,
  dw_created_at TIMESTAMP
)
PARTITION BY DATE(execution_timestamp)
CLUSTER BY table_name, dq_rule_type, dq_status;"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DIM_CUSTOMER`
(
  customer_sk INT64,
  customer_id INT64,
  first_name STRING,
  last_name STRING,
  email STRING,
  phone STRING,
  city STRING,
  state STRING,
  country STRING,
  customer_segment STRING,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  effective_from TIMESTAMP,
  effective_to TIMESTAMP,
  is_current BOOL,
  version_number INT64,
  record_hash STRING,
  dw_created_at TIMESTAMP,
  dw_updated_at TIMESTAMP
)
PARTITION BY DATE(effective_from)
CLUSTER BY customer_id, is_current;"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DIM_CUSTOMER_STAGE`
(
  customer_sk INT64,
  customer_id INT64,
  first_name STRING,
  last_name STRING,
  email STRING,
  phone STRING,
  city STRING,
  state STRING,
  country STRING,
  customer_segment STRING,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  effective_from TIMESTAMP,
  effective_to TIMESTAMP NOT NULL,
  is_current BOOL NOT NULL,
  version_number INT64 NOT NULL,
  record_hash STRING,
  dw_created_at TIMESTAMP NOT NULL,
  dw_updated_at TIMESTAMP NOT NULL
);"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DIM_PRODUCT`
(
  product_sk INT64,
  product_id INT64,
  product_name STRING,
  category STRING,
  brand STRING,
  unit_price NUMERIC(10, 2),
  cost_price NUMERIC(10, 2),
  weight_grams INT64,
  cocoa_percentage NUMERIC(5, 2),
  stock_quantity INT64,
  is_active BOOL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  record_hash STRING,
  dw_created_at TIMESTAMP NOT NULL,
  dw_updated_at TIMESTAMP NOT NULL
)
PARTITION BY DATE(updated_at)
CLUSTER BY product_id, category;"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DIM_PRODUCT_STAGE`
(
  product_id INT64,
  product_name STRING,
  category STRING,
  brand STRING,
  unit_price NUMERIC,
  cost_price NUMERIC,
  weight_grams INT64,
  cocoa_percentage NUMERIC,
  stock_quantity INT64,
  is_active BOOL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  record_hash STRING
);"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.DQ_REJECTED_RECORDS`
(
  reject_id INT64,
  run_id STRING,
  table_name STRING,
  dq_rule_id STRING,
  dq_rule_name STRING,
  record_key STRING,
  record_data STRING,
  failure_reason STRING,
  source_system STRING,
  pipeline_name STRING,
  rejected_at TIMESTAMP
)
PARTITION BY DATE(rejected_at)
CLUSTER BY table_name, dq_rule_id;"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.FACT_ORDER`
(
  order_sk INT64 NOT NULL,
  order_id INT64 NOT NULL,
  customer_sk INT64 NOT NULL,
  order_date TIMESTAMP NOT NULL,
  order_status STRING,
  shipping_city STRING,
  shipping_state STRING,
  total_amount NUMERIC(12, 2),
  discount_amount NUMERIC(10, 2),
  tax_amount NUMERIC(10, 2),
  shipping_amount NUMERIC(10, 2),
  net_amount NUMERIC(12, 2),
  order_date_key INT64,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  dw_created_at TIMESTAMP NOT NULL,
  dw_updated_at TIMESTAMP NOT NULL
)
PARTITION BY DATE(order_date)
CLUSTER BY customer_sk, order_status;"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.FACT_ORDER_STAGE`
(
  order_sk INT64 NOT NULL,
  order_id INT64,
  customer_sk INT64,
  order_date TIMESTAMP,
  order_status STRING,
  shipping_city STRING,
  shipping_state STRING,
  total_amount NUMERIC(12, 2),
  discount_amount NUMERIC(10, 2),
  tax_amount NUMERIC(10, 2),
  shipping_amount NUMERIC(10, 2),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.MAP_ORDER_ITEM`
(
  order_item_sk INT64 NOT NULL,
  order_item_id INT64 NOT NULL,
  order_sk INT64 NOT NULL,
  order_id INT64 NOT NULL,
  product_sk INT64 NOT NULL,
  product_id INT64 NOT NULL,
  quantity INT64,
  unit_price NUMERIC(10, 2),
  discount_amount NUMERIC(10, 2),
  line_total NUMERIC(12, 2),
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  dw_created_at TIMESTAMP NOT NULL,
  dw_updated_at TIMESTAMP NOT NULL
)
PARTITION BY DATE(updated_at)
CLUSTER BY order_sk, product_sk;"
"CREATE TABLE `gcp-data-engineering-504911.Gcp_Curated.MAP_ORDER_ITEM_STAGE`
(
  order_item_sk INT64 NOT NULL,
  order_item_id INT64 NOT NULL,
  order_sk INT64 NOT NULL,
  order_id INT64 NOT NULL,
  product_sk INT64 NOT NULL,
  product_id INT64 NOT NULL,
  quantity INT64,
  unit_price NUMERIC(10, 2),
  discount_amount NUMERIC(10, 2),
  line_total NUMERIC(12, 2),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);"

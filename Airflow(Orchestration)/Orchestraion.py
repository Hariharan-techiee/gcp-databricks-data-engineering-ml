```python
from datetime import datetime, timedelta
import json
import time
import base64
import urllib.request

import google.auth
from google.auth.transport.requests import Request
from airflow import DAG
from airflow.operators.python import PythonOperator


# Configuration — replace placeholders locally
PROJECT_ID = "YOUR_GCP_PROJECT_ID"
SECRET_ID = "YOUR_SECRET_ID"
SECRET_VERSION = "latest"

DATABRICKS_HOST = "https://YOUR_DATABRICKS_WORKSPACE_HOST"

RAW_JOB_ID = YOUR_RAW_JOB_ID
CURATED_JOB_ID = YOUR_CURATED_JOB_ID
ML_JOB_ID = YOUR_ML_JOB_ID


def get_databricks_token():
    credentials, _ = google.auth.default(
        scopes=["https://www.googleapis.com/auth/cloud-platform"]
    )
    credentials.refresh(Request())

    url = (
        f"https://secretmanager.googleapis.com/v1/projects/{PROJECT_ID}"
        f"/secrets/{SECRET_ID}/versions/{SECRET_VERSION}:access"
    )

    request = urllib.request.Request(
        url,
        headers={"Authorization": f"Bearer {credentials.token}"},
    )

    with urllib.request.urlopen(request, timeout=30) as response:
        result = json.loads(response.read().decode("utf-8"))

    return base64.b64decode(
        result["payload"]["data"]
    ).decode("utf-8")


def call_databricks_api(endpoint, token, payload=None):
    url = f"{DATABRICKS_HOST}/api/2.1/jobs/{endpoint}"

    body = None if payload is None else json.dumps(payload).encode("utf-8")

    request = urllib.request.Request(
        url,
        data=body,
        method="GET" if payload is None else "POST",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
    )

    with urllib.request.urlopen(request, timeout=60) as response:
        return json.loads(response.read().decode("utf-8"))


def run_databricks_job(job_id):
    token = get_databricks_token()

    result = call_databricks_api(
        "run-now",
        token,
        {"job_id": job_id},
    )
    run_id = result["run_id"]

    print(f"Started Databricks job: {job_id}, run ID: {run_id}")

    while True:
        status = call_databricks_api(
            f"runs/get?run_id={run_id}",
            token,
        )

        state = status.get("state", {})
        life_cycle = state.get("life_cycle_state")
        result_state = state.get("result_state")

        print(
            f"Job {job_id}, run {run_id}: "
            f"{life_cycle}, {result_state}"
        )

        if life_cycle == "TERMINATED":
            if result_state == "SUCCESS":
                print(f"Databricks job {job_id} completed successfully.")
                return

            raise RuntimeError(
                f"Databricks job {job_id} failed: {state}"
            )

        if life_cycle in ("INTERNAL_ERROR", "SKIPPED"):
            raise RuntimeError(
                f"Databricks job {job_id} ended unexpectedly: {state}"
            )

        time.sleep(30)


with DAG(
    dag_id="databricks_raw_curated_ml",
    start_date=datetime(2026, 1, 1),
    schedule="0 */6 * * *",
    catchup=False,
    max_active_runs=1,
    default_args={
        "retries": 1,
        "retry_delay": timedelta(minutes=2),
    },
    tags=["databricks", "data-pipeline", "machine-learning"],
) as dag:

    raw_job = PythonOperator(
        task_id="run_raw_job",
        python_callable=run_databricks_job,
        op_kwargs={"job_id": RAW_JOB_ID},
        execution_timeout=timedelta(hours=3),
    )

    curated_job = PythonOperator(
        task_id="run_curated_job",
        python_callable=run_databricks_job,
        op_kwargs={"job_id": CURATED_JOB_ID},
        execution_timeout=timedelta(hours=3),
    )

    ml_job = PythonOperator(
        task_id="run_ml_recommendation_job",
        python_callable=run_databricks_job,
        op_kwargs={"job_id": ML_JOB_ID},
        execution_timeout=timedelta(hours=3),
    )

    raw_job >> curated_job >> ml_job
```
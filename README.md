# Amazon Data Pipeline

A containerised end-to-end data pipeline built for a vehicle catalogue dataset, following a modern **ELT** architecture (Extract → Load → Transform) across three data layers.

![Python](https://img.shields.io/badge/Python-3.13-blue?logo=python)
![Airflow](https://img.shields.io/badge/Apache%20Airflow-2.9.3-017CEE?logo=apacheairflow)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-336791?logo=postgresql)
![MinIO](https://img.shields.io/badge/MinIO-S3--compatible-C72E49?logo=minio)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)

---

## Architecture

```
CSV Files
    │
    ▼
┌─────────┐     S3 API      ┌────────────────────────┐
│  MinIO  │ ◄────────────── │   Python App           │
│(S3-like)│                 │  pandas · boto3        │
│         │                 │  psycopg2 · requests   │
│ raw-data│                 └────────────────────────┘
│ processed│                          │
│ exports │                           │ SQL
└─────────┘                           ▼
                             ┌─────────────────┐
                             │   PostgreSQL 17  │
                             │                 │
                             │  raw      (EL)  │
                             │  staging  (T)   │
                             │  marts    (BI)  │
                             └─────────────────┘
                                      ▲
                             ┌────────┴────────┐
                             │ Apache Airflow  │
                             │  Orchestration  │
                             │  DAGs · Cron    │
                             └─────────────────┘
```

## Tech Stack

| Layer           | Technology              | Role                                      |
|-----------------|-------------------------|-------------------------------------------|
| Orchestration   | Apache Airflow 2.9.3    | DAG scheduling, task monitoring           |
| Object Storage  | MinIO (S3-compatible)   | Raw file ingestion, exports               |
| Data Warehouse  | PostgreSQL 17           | 3-layer schema (raw / staging / marts)    |
| Processing      | Python 3.13             | Data extraction, transformation, loading  |
| Libraries       | pandas, boto3, psycopg2 | Data manipulation, S3 & DB connectors     |
| Infrastructure  | Docker Compose          | Full local stack orchestration            |

## Data Flow

1. **Extract** — vehicle CSV files are uploaded to MinIO (`raw-data` bucket)
2. **Load** — Python app reads from MinIO and loads raw records into the `raw` schema in PostgreSQL
3. **Transform** — SQL transformations promote data through `staging` → `marts`
4. **Orchestrate** — Airflow DAGs schedule and monitor each pipeline step

### Dataset

Vehicle catalogue with ~3 CSV files containing:
`id`, `marque`, `modele`, `annee`, `categorie`, `motorisation`, `carburant`, `puissance_ch`, `boite_vitesse`, `kilometrage`, `prix_eur`, `pays_origine`

## Services

| Service           | URL                   |
|-------------------|-----------------------|
| Airflow Webserver | http://localhost:8080 |
| MinIO Console     | http://localhost:9001 |
| MinIO S3 API      | http://localhost:9000 |
| PostgreSQL        | localhost:5432        |

## Getting Started

### Prerequisites

- Docker & Docker Compose

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/Sudoeranas/amazon-pipeline.git
cd amazon-pipeline

# 2. Configure environment variables
cp .env.example .env
# Edit .env with your credentials

# 3. Start the full stack
docker compose up -d

# 4. Follow initialisation logs
docker compose logs -f airflow-init
docker compose logs -f minio-init
```

### Stop

```bash
docker compose down        # keep volumes
docker compose down -v     # full reset (drops all data)
```

## Project Structure

```
amazon-pipeline/
├── airflow/
│   ├── dags/              # Airflow DAGs
│   ├── logs/              # Runtime logs (gitignored)
│   └── plugins/           # Custom Airflow plugins
├── data/                  # Source CSV files
├── scripts/
│   └── init-postgres.sql  # DB schema initialisation
├── app/                   # Python processing scripts
├── docker-compose.yml     # Full stack definition
├── Dockerfile             # Python app image
├── requirements.txt       # Python dependencies
├── .env.example           # Environment variables template
└── .gitignore
```

## PostgreSQL Schema

```
dataplatform (database)
├── raw        ← raw ingested data (no transformation)
├── staging    ← cleaned & typed data
└── marts      ← aggregated, BI-ready tables

airflow      ← Airflow metadata (separate database)
```

## MinIO Buckets

| Bucket           | Purpose                        |
|------------------|--------------------------------|
| `raw-data`       | Raw CSV ingestion              |
| `processed-data` | Transformed data               |
| `airflow-logs`   | Airflow remote logging         |
| `exports`        | Final exports (BI, API)        |

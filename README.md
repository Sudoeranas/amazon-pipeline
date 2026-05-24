# Data Stack – Local Dev

Stack Docker Compose pour le développement local.

| Service            | URL / Port                          |
|--------------------|-------------------------------------|
| Airflow Webserver  | http://localhost:8080               |
| MinIO Console      | http://localhost:9001               |
| MinIO S3 API       | http://localhost:9000               |
| PostgreSQL 17      | localhost:5432                      |

Les credentials sont définis dans le fichier `.env` (non versionné). Copie `.env.example` et adapte les valeurs :

```bash
cp .env.example .env
```

---

## Démarrage

```bash
# 1. Crée les répertoires nécessaires (une seule fois)
mkdir -p airflow/logs airflow/plugins

# 2. Démarrage complet
docker compose up -d

# 3. Suivre les logs d'init
docker compose logs -f airflow-init
docker compose logs -f minio-init
```

## Arrêt

```bash
docker compose down          # conserve les volumes
docker compose down -v       # supprime aussi les volumes (reset complet)
```

## Buckets MinIO créés

| Bucket           | Usage                          |
|------------------|--------------------------------|
| `raw-data`       | Données brutes ingérées        |
| `processed-data` | Données transformées           |
| `airflow-logs`   | Logs distants Airflow (opt.)   |
| `exports`        | Exports finaux                 |

## Bases / Schémas PostgreSQL

- **`dataplatform`** (base principale)
  - `raw` – données brutes
  - `staging` – données transformées
  - `marts` – données exposées (BI, API)
- **`airflow`** – metadata Airflow uniquement

## DAG Hello World

Un DAG `hello_world` est disponible dans `airflow/dags/`.  
Il tourne `@daily` et valide que la stack est opérationnelle.  
Pour le déclencher manuellement : Airflow UI → DAGs → `hello_world` → ▶ Trigger DAG.

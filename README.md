# MLOps Workflow: Comprehensive Full-Stack Deployment

[![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![GCP](https://img.shields.io/badge/Google%20Cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)](https://cloud.google.com/)
[![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Terraform](https://img.shields.io/badge/Terraform-5835CC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2671E5?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Docker](https://img.shields.io/badge/Docker-0db7ed?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Prefect](https://img.shields.io/badge/Prefect-3E4DD9?style=for-the-badge&logo=prefect&logoColor=white)](https://www.prefect.io/)
[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![MLflow](https://img.shields.io/badge/MLflow-007ACC?style=for-the-badge&logo=mlflow&logoColor=white)](https://mlflow.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-00C7B7?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)

## Overview

This project demonstrates how to build and deploy a machine learning model using a modern MLOps pipeline. The workflow is designed to be scalable, reproducible, and maintainable, leveraging the power of cloud services and open-source tools.

The primary objectives of this project include:

- **Infrastructure as Code** : Using Terraform to provision and manage cloud resources.
- **Experiment Tracking** : Logging and tracking model experiments with MLflow.
- **CI/CD Automation** : Automating the deployment pipeline with GitHub Actions.
- **Containerization** : Dockerizing applications for consistency across environments.
- **Model Serving** : Deploying the model as a REST API with FastAPI on GCP Cloud Run.
- **Data Orchestration** : Orchestrating data workflows with Prefect.
- **Data Transformation** : Utilizing dbt for data transformation in BigQuery.

## Architecture

![Architecture](assets/images/architecture.png)

The architecture consists of:

- **Terraform** : Provision GCP infrastructure (Cloud Run, BigQuery, Artifact Registry, SQL Database, Storage Buckets).
- **MLflow** : Track experiments and manage models.
- **GitHub Actions** : CI/CD pipeline to build and deploy Docker containers.
- **Docker** : Containerize the FastAPI application for deployment.
- **GCP Cloud Run** : Deploy the FastAPI application for scalable and serverless model serving.
- **Prefect** : Manage and orchestrate ETL pipelines.
- **dbt** : Transform data in BigQuery.
- **BigQuery** : Store and query the dataset for training and inference.

## Project Structure

<pre><div class="dark bg-gray-950 contain-inline-size rounded-md border-[0.5px] border-token-border-medium"><div class="flex items-center relative text-token-text-secondary bg-token-main-surface-secondary px-4 py-2 text-xs font-sans justify-between rounded-t-md"><span>bash</span><div class="flex items-center"><span class="" data-state="closed"><button class="flex gap-1 items-center"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copy code</button></span></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="!whitespace-pre hljs language-bash">├── .github/             # GitHub Actions CI/CD workflows
├── assets/              # Project images
├── dbt/                 # Data processing scripts and dbt models
├── fastapi/             # FastAPI application
├── mlflow/              # MLflow experiment scripts
├── prefect/             # Prefect flows and tasks
├── terraform/           # Terraform configuration files
└── README.md            # Project documentation
</code></div></div></pre>

## Results

The final deployed model can be accessed via the API endpoint provided by GCP Cloud Run. The results of the model predictions, including accuracy and performance metrics, can be reviewed in the MLflow UI.

## Future Work

- **Model Monitoring** : Implement monitoring tools like Prometheus and Grafana for real-time monitoring.
- **Hyperparameter Tuning** : Integrate tools like Optuna for automated hyperparameter optimization.
- **Scalability Improvements** : Explore Kubernetes for managing large-scale deployments.

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

## Project Structure

<pre>
    <div class="dark bg-gray-950 contain-inline-size rounded-md border-[0.25px] border-token-border-medium">
        <div class="overflow-y-auto p-4" dir="ltr">
            <code class="!whitespace-pre hljs language-bash">
                ├── .github/             # GitHub Actions CI/CD workflows
                ├── assets/              # Project images
                ├── dbt/                 # Data processing scripts and dbt models
                ├── fastapi/             # FastAPI application
                ├── mlflow/              # MLflow experiment scripts
                ├── prefect/             # Prefect flows and tasks
                ├── terraform/           # Terraform configuration files
                └── README.md            # Project documentation
            </code>
        </div>
    </div>
</pre>

## Results

The final deployed model is accessible through the API endpoint provided by GCP Cloud Run. Data is automatically fetched and ingested into the GCP BigQuery data warehouse on a daily schedule. Users can review the results of model predictions, along with accuracy and performance metrics, via the MLflow UI.

## Future Work

- **Model Monitoring** : Implement monitoring tools like Prometheus and Grafana for real-time monitoring.
- **Hyperparameter Tuning** : Integrate tools like Optuna for automated hyperparameter optimization.
- **Scalability Improvements** : Explore Kubernetes for managing large-scale deployments.

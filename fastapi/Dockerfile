FROM python:3.10-bookworm

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the app and default model
COPY app /app
WORKDIR /app

# Run the FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
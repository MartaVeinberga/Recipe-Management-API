# Use official Python runtime as base image
FROM python:3.11-slim

# Set working directory in container
WORKDIR /code

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ./app /code/app

# Copy environment file
COPY .env /code/.env

# Copy initial recipes file
COPY initial_recipes.py /code/initial_recipes.py

# Expose port 8000
EXPOSE 8000

# Command to run the application
# uvicorn = web server
# app.main:app = run the app from app/main.py
# --host 0.0.0.0 = listen on all network interfaces
# --port 8000 = use port 8000
# --reload = restart when code changes (development mode)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
# Basic and easy Image usage
FROM python:3.9-slim

# Setting up a working folder
WORKDIR /app

# Copying the requirements and installing
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copying the code
COPY app.py .

# Exposing port 8080 for health checks
EXPOSE 8080

# Running the application
CMD ["python", "app.py"]
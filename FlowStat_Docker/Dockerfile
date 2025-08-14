# Use official Python Alpine image as the base
FROM python:3.10-alpine

# Set working directory inside the container
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Command to run the application
CMD ["sh", "-c", "cd Interface && gunicorn --worker-class eventlet flowstat1:FlowStat1_Interface._app"]

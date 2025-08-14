# Use the official Python Alpine image as the base
FROM python:3.10-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the application code into the container
COPY . /app
# COPY FlowStat_Docker/init_db/add_db_user /

# Install any Python dependencies (if a requirements.txt exists)
RUN pip install --no-cache-dir -r requirements.txt

# Command run the application
CMD ["sh", "-c", "cd Interface && gunicorn --worker-class eventlet flowstat1:FlowStat1_Interface._app"]

# Step 1: Use a specific, small base image
FROM python:3.11-slim-buster

# Step 2: Set working directory
WORKDIR /app

# Step 3: Create a non-root user (Security Best Practice)
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /bin/sh -m appuser

# Step 4: Install dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy code and change ownership
COPY app/ .
RUN chown -R appuser:appgroup /app

# Step 6: Switch to the non-root user
USER appuser

EXPOSE 8080
CMD ["python", "main.py"]

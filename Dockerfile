# Stage 1: Build Stage
FROM python:3.11-slim-bookworm AS builder

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /build

COPY app/requirements.txt .
# Install to a specific prefix to make copying easier
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Runtime Stage
FROM python:3.11-slim-bookworm

WORKDIR /app

# Create the security user first
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /sbin/nologin -m appuser

# Copy only the installed site-packages from the builder
# This avoids copying the entire /root/.local folder
COPY --from=builder /install /usr/local
COPY app/ .

# Secure the application directory
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose non-privileged port
EXPOSE 8080

# Use the absolute path to the python binary for clarity
CMD ["python", "main.py"]

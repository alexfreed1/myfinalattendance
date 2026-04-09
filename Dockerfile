# Multi-stage Dockerfile for Flask app deployment (e.g., Render)
FROM python:3.12-slim as builder

WORKDIR /app

# Install pip deps
COPY attendance_system_flask/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim

WORKDIR /app

# Copy installed deps
COPY --from=builder /root/.local /root/.local
# Copy app
COPY attendance_system_flask/ .

# Install deps system-wide for non-root access
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

# Gunicorn now accessible
ENV PATH="/home/appuser/.local/bin:${PATH}"

EXPOSE 5000

# Run with gunicorn (install if needed in requirements.txt)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]


# --- Stage 1: Build image ---
FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt


# --- Stage 2: Runtime image ---
FROM python:3.11-slim

RUN useradd -m appuser
WORKDIR /app

COPY --from=builder /usr/local /usr/local

COPY ./app ./app

EXPOSE 8000

# Default command (API)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

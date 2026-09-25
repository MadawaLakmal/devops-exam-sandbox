# ---- Build stage: install dependencies only ----
FROM python:3.11-slim AS builder

WORKDIR /build

COPY app/requirements.txt .
RUN pip install --no-cache-dir --target=/install -r requirements.txt

# ---- Final stage: Chainguard minimal image, non-root, no shell, near-zero CVEs ----
FROM cgr.dev/chainguard/python@sha256:992f13b3e2f7d7bef9b0d74caf7d05c12329482b7b1455fe0bfc6531361b9b7d

WORKDIR /app

COPY --from=builder --chown=65532:65532 /install /app/deps
COPY --chown=65532:65532 app/ /app

ENV PYTHONPATH=/app/deps

EXPOSE 8080

CMD ["app.py"]

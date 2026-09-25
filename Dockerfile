# ---- Build stage: install dependencies only ----
FROM python:3.11-slim AS builder

WORKDIR /build

COPY app/requirements.txt .
RUN pip install --no-cache-dir --target=/install -r requirements.txt

# ---- Final stage: distroless, non-root, no shell ----
FROM gcr.io/distroless/python3-debian12:nonroot

WORKDIR /app

COPY --from=builder --chown=65532:65532 /install /app/deps
COPY --chown=65532:65532 app/ /app

ENV PYTHONPATH=/app/deps

EXPOSE 8080

CMD ["app.py"]

# Kafka ClickThrough Stream

A streaming pipeline that ingests click-through events, publishes them to Kafka, and processes the stream for real-time analytics.

## Architecture

```
clients ──▶ producer ──▶ Kafka topic (clickstream) ──▶ consumer ──▶ sink / analytics
```

## Layout

| Path | Purpose |
|------|---------|
| `src/producer/` | Emits click-through events to Kafka |
| `src/consumer/` | Reads and processes the clickstream |
| `src/schemas/`  | Event schemas (Avro/JSON) |
| `config/`       | Broker, topic, and app configuration |
| `docker/`       | Local Kafka + Zookeeper stack |
| `tests/`        | Unit and integration tests |

## Getting started

```bash
# 1. Start a local Kafka cluster
docker compose -f docker/docker-compose.yml up -d

# 2. Install dependencies
# (fill in once a language/runtime is chosen)

# 3. Run the producer and consumer
```

## Configuration

See [config/app.example.yaml](config/app.example.yaml). Copy it to `config/app.yaml` and adjust broker addresses and topic names.

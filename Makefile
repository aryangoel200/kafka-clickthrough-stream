.PHONY: kafka-up kafka-down producer consumer build tidy

# Start / stop the local Kafka stack
kafka-up:
	docker compose -f docker/docker-compose.yml up -d

kafka-down:
	docker compose -f docker/docker-compose.yml down

# Run the apps (defaults connect to localhost:9092)
producer:
	go run ./cmd/producer

consumer:
	go run ./cmd/consumer

build:
	go build ./...

tidy:
	go mod tidy

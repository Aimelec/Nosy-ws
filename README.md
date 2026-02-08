# Nosy

A game price aggregator backend built with Rails 8.1 (API-only). Connects to external APIs (IGDB for game metadata, CheapShark for prices) to provide a catalog with price comparison across platforms like Steam, GOG, and others.

## Tech Stack

- Ruby 4.0.1
- Rails 8.1.2 (API-only)
- PostgreSQL 17
- Docker / Docker Compose

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/) and Docker Compose installed
- No local Ruby installation required — everything runs inside Docker

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/Aimelec/Nosy-ws.git
cd Nosy-ws
```

### 2. Build the Docker image

```bash
docker compose build
```

### 3. Install dependencies

```bash
docker compose run --rm ws bundle install
```

### 4. Create and migrate the database

```bash
docker compose run --rm ws bin/rails db:create db:migrate
```

### 5. Start the server

```bash
docker compose up
```

The API will be available at `http://localhost:3000`.

## Common Commands

All commands run inside Docker. Never install Ruby or gems on your host machine.

### Rails

```bash
# Rails console
docker compose run --rm ws bin/rails console

# Generate a migration
docker compose run --rm ws bin/rails generate migration MigrationName

# Run migrations
docker compose run --rm ws bin/rails db:migrate

# Reset database (drop + create + migrate)
docker compose run --rm ws bin/rails db:reset
```

### Testing

```bash
# Run the full test suite (includes SimpleCov coverage report)
docker compose run --rm -e RAILS_ENV=test ws bundle exec rspec

# Run a specific test file
docker compose run --rm -e RAILS_ENV=test ws bundle exec rspec spec/models/game_spec.rb

# Run tests for a specific directory
docker compose run --rm -e RAILS_ENV=test ws bundle exec rspec spec/models/
```

After running the tests, SimpleCov generates a coverage report at `coverage/index.html`.

> **Note:** The `-e RAILS_ENV=test` flag is required because `docker-compose.yml` sets `RAILS_ENV=development` by default.

### Linting (RuboCop)

```bash
# Check for offenses
docker compose run --rm ws bundle exec rubocop

# Auto-fix correctable offenses
docker compose run --rm ws bundle exec rubocop -A
```

### Security Analysis (Brakeman)

```bash
docker compose run --rm ws bundle exec brakeman
```

### Dependency Audit (Bundler-Audit)

```bash
docker compose run --rm ws bundle exec bundler-audit check --update
```

### Code Quality (RubyCritic)

```bash
# Generate HTML report (opens tmp/rubycritic/overview.html)
docker compose run --rm ws bundle exec rubycritic app/

# Console output only
docker compose run --rm ws bundle exec rubycritic app/ --no-browser --format console
```

### Schema Annotations (AnnotateRb)

Adds column/index comments to the top of model files.

```bash
docker compose run --rm ws bundle exec annotaterb models
```

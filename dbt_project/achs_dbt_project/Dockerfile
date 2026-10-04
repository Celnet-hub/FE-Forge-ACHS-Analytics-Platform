FROM python:3.11-slim

WORKDIR /usr/app/dbt

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --no-cache-dir dbt

COPY . .

# Set environment variables for dbt
# This tells dbt to look for profiles.yml in the current working directory
ENV DBT_PROFILES_DIR=.

CMD ["dbt", "run"]
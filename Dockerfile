ARG build_for=linux/amd64
FROM --platform=$build_for python:3.11.2-slim-bullseye as base

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

RUN useradd -ms /bin/bash a8-user
USER a8-user
WORKDIR /home/a8-user
RUN python -m venv env
ARG vpy=/home/a8-user/env/bin
ENV vpy=/home/a8-user/env/bin
RUN $vpy/python -m pip install --upgrade pip
RUN $vpy/python -m pip install wheel setuptools dbt-snowflake>=1.4.0 prefect>=2.10.8 prefect-snowflake>=0.26.1 prefect-dbt>=0.3.1 prefect-gcp python-dotenv prefect-docker
ENTRYPOINT $vpy/prefect cloud login --key $api_key --workspace $workspace && $vpy/prefect block register -m prefect_docker && $vpy/prefect worker start --pool 'dbt-core-demo' --type docker

FROM python:3.12 AS build
RUN apt update && apt install -y \
    libhdf4-0-alt \
    libhdf4-alt-dev \ 
  && \
  rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /opt/iff
ENV PATH=$PATH:/opt/iff/bin
ENV VIRTUALENV=/opt/iff
COPY docker/requirements.txt /tmp/
RUN python3 -m pip install --no-cache-dir \
  -i http://devpi.sips/sips/prod/+simple --trusted-host=devpi.sips \
  -r /tmp/requirements.txt
COPY docker/viirs-iff docker/modis-iff /opt/iff/bin/

# FIXME: We're ignore the leapsec.dat expirations, so make sure it's up to date
ENV GRAIN_DISABLE_DOWNLOAD=1 
ENV GRAIN_IGNORE_EXPIRED=1

RUN useradd app
USER app

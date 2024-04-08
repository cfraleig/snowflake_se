FROM python:3.8-slim

USER root

ENV PYTHONPATH /app

WORKDIR /app

RUN pip install "snowflake-snowpark-python[pandas]"

COPY python_exercises/se_python.py se_python.py

RUN chmod +x /app/se_python.py
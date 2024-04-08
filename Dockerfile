FROM python:3.8-slim

USER root

ENV PYTHONPATH /app
WORKDIR /app

RUN pip install poetry

# Copy poetry configuration files
COPY pyproject.toml ./
# Install dependencies
RUN  poetry config virtualenvs.create false && poetry install --no-root

COPY python_exercises/se_python.py se_python.py

RUN chmod +x /app/se_python.py


# # # Replace this with a command that keeps the container alive without exiting
# # CMD ["tail", "-f", "/dev/null"]



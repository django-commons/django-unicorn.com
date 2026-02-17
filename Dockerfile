# Creating a python base with shared environment variables
FROM python:3.12-slim as python-base
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    UV_PROJECT_ENVIRONMENT="/opt/venv"

ENV PATH="$UV_PROJECT_ENVIRONMENT/bin:$PATH"

# builder-base is used to build dependencies
FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        git \
        build-essential

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# We copy our Python requirements here to cache them
# and install only runtime deps using uv
WORKDIR /app
COPY uv.lock pyproject.toml ./
RUN uv sync --frozen --no-dev --no-install-project

# 'production' stage uses the clean 'python-base' stage and copies
# in only our runtime deps that were installed in the 'builder-base'
FROM python-base as production

COPY --from=builder-base /opt/venv /opt/venv

COPY . /app
WORKDIR /app

EXPOSE 80

# Install curl, collect static assets, compress static assets
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y curl wget && \
    ENVIRONMENT=live SECRET_KEY=dummy python manage.py collectstatic --no-input && \
    ENVIRONMENT=live SECRET_KEY=dummy python manage.py compress

HEALTHCHECK --interval=1m --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/ || exit 1

# Run gunicorn
CMD ["gunicorn", "project.wsgi", "--config=gunicorn.conf.py"]

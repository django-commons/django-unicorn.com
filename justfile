# Run the dev server
r:
    uv run ./manage.py runserver 0:8000

# Make migrations
mm:
    uv run ./manage.py makemigrations

# Migrate
m:
    uv run ./manage.py migrate

# Make and migrate
md: mm m

# Run manage.py with arguments
ma *args:
    uv run ./manage.py {{args}}

# Run tests
t:
    uv run pytest

# Copy docs
cd:
    rm -f 'source/*.md'
    cp ../django-unicorn/docs/source/*.md source/
    cp ../django-unicorn/docs/source/conf.py source/

# Build PDF documentation
sp:
    uv run sphinx-build -E -a -b pdf source docs

# Build documentation and host at localhost:8000
sa:
    uv run sphinx-autobuild -b dirhtml source docs

# Build documentation
sb:
    uv run sphinx-build -E -a -b dirhtml source docs

# Copy docs, build, and run
l: cd sb r

# Run ruff check
ruff:
    uv run ruff check .

# Run ty type checking
ty:
    uv run ty

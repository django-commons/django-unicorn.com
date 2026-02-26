import? 'adamghill.justfile'
import? '../dotfiles/just/justfile'

src := "."

# List commands
_default:
    just --list --unsorted --justfile {{ justfile() }} --list-heading $'Available commands:\n'

# Grab default `adamghill.justfile` from GitHub
fetch:
  curl https://raw.githubusercontent.com/adamghill/dotfiles/master/just/justfile > adamghill.justfile

# Copy docs
docs-copy:
    rm -f 'source/*.md'
    cp ../django-unicorn/docs/source/*.md source/
    cp ../django-unicorn/docs/source/conf.py source/
    # cp source/changelog.md docs/source/changelog.md

# Build PDF documentation
docs-build-pdf:
    uv run sphinx-build -E -a -b pdf source docs

# Build documentation and host at localhost:8000
docs-only-serve:
    uv run sphinx-autobuild -b dirhtml source docs

# Build documentation
docs-build:
    uv run sphinx-build -E -a -b dirhtml source docs

# Copy docs, build, and run
docs-serve: docs-copy docs-build serve

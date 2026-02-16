# Developing

## Install

1. `git clone git@github.com:adamghill/django-unicorn.git`
1. `git clone git@github.com:adamghill/django-unicorn.com.git`
1. `cd django-unicorn.com`
1. `uv sync`

## Build latest docs

1. Make sure `django-unicorn` directory has latest code
1. `just l` to get the latest docs from `django-unicorn`, build the documentation, and start http://localhost:8000
1. Update `www/templates/www/index.html` with the latest version
1. Remove the comparison box from `source/index.md` and run `just sp` to build the pdf documentation

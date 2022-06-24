FROM python:3.9-alpine3.13
LABEL maintainer="edanbainglass"

# do not buffer python output to avoid delays
# python output printed directly to screen
ENV PYTHONBUFFERED 1 

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# logical governing installation of dev-dependencies
ARG DEV=false

# using a virtual environment avoids conflicts between the 
# project's dependencies and those of the base image
# ! switch off root user to limit potential hacker access
# ! some db setup dependecies get cleaned after install (see --virtual)
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then \
    /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"

# switch to non-root user created in previous step
USER django-user

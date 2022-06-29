#!/bin/sh

set -e

python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py migrate

# workers: CPUs running the app (4 is safe)
# master: assign the uWSGI daemon as the master thread
uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi

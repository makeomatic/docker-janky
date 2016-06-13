#!/bin/sh

# run migration, idempotent?
rake db:migrate

# start the app
/bin/sh -c "bundle exec $@"

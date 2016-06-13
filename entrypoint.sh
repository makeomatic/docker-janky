#!/bin/sh

set -e
#set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

# launch migration
bundle exec rake db:migrate

# launch db
bundle exec $@

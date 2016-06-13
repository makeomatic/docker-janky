#!/bin/bash

set -e
#set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

pid=0

# launch migration
bundle exec rake db:migrate & pid="$!"

# launch db
/bin/sh -c "wait $pid && /bin/sh -c \"bundle exec $@\"" & pid="$!"

# SIGTERM & SIGINT -handler
# https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86#.2rkt303t7
term_handler() {
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 0; # we drop 0, because SIGINT is just a reload
}

trap term_handler SIGTERM SIGINT

# wait indefinetely
while true
do
  tail -f /dev/null & wait ${!}
done

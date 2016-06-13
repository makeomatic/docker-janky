#!/bin/sh

pid=0

launch_migration() {
  # run migration, idempotent?
  rake db:migrate > /var/logs/db.init.log || exit 128

  # start the app
  /bin/sh -c "bundle exec $@" & pid="$!"
}

# background
launch_migration &

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

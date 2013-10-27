#! /bin/bash

# Sleep until we can successfully SSH into a vagrant box.
# eg. $ wait_for_vagrant devbox && vagrant ssh devbox --command 'cd project && ./manage.py runserver'
# Uses doublinng backoff while waiting

# with_backoff() adapted from http://stackoverflow.com/a/8351489
# Retries a command a configurable number of times with backoff.
#
# The retry count is given by ATTEMPTS (default 5), the initial backoff
# timeout is given by TIMEOUT in seconds (default 1.)
#
# Successive backoffs double the timeout.
with_backoff() {
  local max_attempts=${ATTEMPTS-5}
  local timeout=${TIMEOUT-1}
  local attempt=0
  local exitCode=0

  while [ $attempt -lt $max_attempts ]
  do
    set +e
    "$@"
    exitCode=$?
    set -e

    if [ $exitCode -eq 0 ]
    then
      break
    fi

    echo "Failure! Retrying in $timeout.." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [ $exitCode -ne 0 ]
  then
    echo "You've failed me for the last time! ($@)" 1>&2
  fi

  return $exitCode
}

VAGRANT_BOX=${1:-default}
ATTEMPTS=${ATTEMPTS:-10}

export ATTEMPTS
with_backoff vagrant ssh $VAGRANT_BOX --command 'exit';
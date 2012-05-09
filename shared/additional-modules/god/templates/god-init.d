#!/bin/bash

<%= init_d_prolog %>

PATH=/usr/local/ruby/bin:<%= scope.lookupvar('base::path') %>
NAME=god
DESC=god

BIN=<%= scope.lookupvar('god::bin') %>
PID=<%= scope.lookupvar('god::pid') %>
DIR=<%= scope.lookupvar('god::dir') %>
LOG=<%= scope.lookupvar('god::log') %>

<%= init_d_prerun %>

RETVAL=0

start() {
  echo -n "Starting $DESC: "
  rm -f $PID
  $BIN -P $PID -l $LOG
  RETVAL=$?

  if [ $RETVAL -eq 0 ]; then
    sleep 2
    if [ -d $DIR ]; then
      for file in $(find $DIR -name "*.god"); do
        echo "$NAME: loading $file ..."
        $BIN load $file
      done
    fi
  fi
  echo "$NAME."

  return $RETVAL
}

stop() {
  echo -n "Stopping $DESC: "
  if [ -f $PID ]; then
    kill `cat $PID`
    rm $PID
  fi

  killall -9 $BIN || true
  echo "$NAME."

  return 0
}

status_q() {
  test -f $PID
}

case "$1" in
  start)
    status_q && exit 0
    start
    ;;
  stop)
    status_q || exit 0
    stop
    ;;
  restart)
    status_q
    if [ $? -eq 0 ]; then stop; fi
    start
    ;;
  status)
    $BIN status
    RETVAL=$?
    ;;
  *)
    echo "Usage: $NAME {start|stop|restart|status}"
    exit 1
    ;;
esac

exit $RETVAL


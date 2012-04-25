#!/bin/sh

### BEGIN INIT INFO
# Provides:             god
# Required-Start:       $all
# Required-Stop:        $all
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    God
### END INIT INFO

PATH=/usr/local/ruby/bin:<%= scope.lookupvar('base::path') %>
NAME=god
DESC=god

set -e

# Make sure the binary and the config file are present before proceeding
test -x <%= god_bin %> || exit 0

. /lib/lsb/init-functions

RETVAL=0

PID_PATH=<%= pid_path %>

start() {
  echo -n "Starting $DESC: "
  rm -f $PID_PATH
  <%= god_bin %> -P $PID_PATH -l /var/log/god.log
  RETVAL=$?

  if [ $RETVAL -eq 0 ]; then
    sleep 2
    if [ -d <%= god_dir %> ]; then
      for file in $(find <%= god_dir %> -name "*.god"); do
        echo "god: loading $file ..."
        <%= god_bin %> load $file
      done
    fi
  fi
  echo "$NAME."

  return $RETVAL
}

stop() {
  echo -n "Stopping $DESC: "
  kill `cat $PID_PATH`
  rm $PID_PATH
  killall -9 god
  RETVAL=$?
  echo "$NAME."
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    <%= god_bin %> status
    RETVAL=$?
    ;;
  *)
    echo "Usage: god {start|stop|restart|status}"
    exit 1
    ;;
esac

exit $RETVAL


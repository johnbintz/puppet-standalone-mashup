<%= scope.function_template([ 'base/init-d-header' ]) %>

<%= init_d_prolog %>
<%= init_d_prerun %>

USER=<%= user %>
GROUP=<%= group %>

start() {
  echo -n "Starting $NAME: "

  <%= scope.lookupvar('varnish::bin') %> \
    -P <%= scope.lookupvar('varnish::pid') %> \
    -T 127.0.0.1:6082 \
    -u $USER -g $GROUP \
    -w 1,1,3600 \
    -f <%= scope.lookupvar('varnish::vcl_path') %> \
    -s file,<%= scope.lookupvar('varnish::store_file_path') %>
  RETVAL=$?
  echo $RETVAL
  if [ $RETVAL -eq 0 ]; then
    <%= scope.lookupvar('varnish::ncsa_bin') %> \
      -P <%= scope.lookupvar('varnish::ncsa_pid') %> \
      -a -w <%= scope.lookupvar('varnish::ncsa_log') %> -D
    RETVAL=$?
  fi

  echo "done"
}

stop() {
  echo -n "Stopping $NAME: "

  for pid in <%= scope.lookupvar('varnish::pid') %> <%= scope.lookupvar('varnish::ncsa_pid') %>; do
    if [ -f $pid ]; then
      kill `cat $pid`
      rm $pid
    fi
  done

  killall -9 varnishd
  killall -9 varnishncsa

  echo "done"
}

<%= scope.function_template([ 'base/init-d-actions' ]) %>


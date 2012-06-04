<%= scope.function_template(['base/init-d-header']) %>
<% bin = scope.lookupvar('god::bin') %>

<%= init_d_prolog %>

PATH=/usr/local/ruby/bin:<%= scope.lookupvar('base::path') %>

<%= init_d_prerun %>

start() {
  echo -n "Starting $DESC: "
  <%= bin %> -P <%= scope.lookupvar('god::pid') %> -l <%= scope.lookupvar('god::log') %>
  RETVAL=$?

  if [ $RETVAL -eq 0 ]; then
    sleep 2
    for file in $(find <%= scope.lookupvar('god::dir') %> -name "*.god"); do
      echo "$NAME: loading $file ..."
      <%= bin %> load $file
    done
  fi
  echo "$NAME."
}

stop() {
  echo -n "Stopping $DESC: "

  for pid in <%= scope.lookupvar('god::pid') %>; do
    if [ -f pid ]; then
      kill `cat $pid`
      rm $PID
    fi
  done

  pkill -9 -f <%= bin %> || true
  echo "$NAME."
}

<%= scope.function_template(['base/init-d-actions']) %>


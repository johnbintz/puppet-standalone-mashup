<%= scope.function_template('base/init-d-header') %>

<%= init_d_prolog %>
<%= init_d_prerun %>

start() {
  echo -n "Starting $NAME: "

  <%= scope.lookupvar('tc::debian::config') %>

  echo "done"
}

stop() {
  echo -n "Stopping $NAME: "

  tc qdisc del dev eth0 root

  echo "done"
}

<%= scope.function_template('base/init-d-actions') %>


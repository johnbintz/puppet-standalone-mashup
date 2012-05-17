<%= scope.function_template('base/init-d-header') %>

<%= init_d_prolog %>
<%= init_d_prerun %>

PATH=<%= scope::lookupvar('squid::sbin') %>:<%= scope::lookupvar('squid::bin') %>:$PATH
BIN=<%= scope.lookupvar('squid::sbin') %>/squid
PID=<%= scope.lookupvar('squid::pid') %>
CONFIG=<%= scope.lookupvar('squid::config') %>
ARGS="-YC -f $CONFIG"

find_cache_dir() {
  w="     " # space tab
  res=`sed -ne '
          s/^'$1'['"$w"']\+[^'"$w"']\+['"$w"']\+\([^'"$w"']\+\).*$/\1/p;
          t end;
          d;
          :end q' < $CONFIG`
  [ -n "$res" ] || res=$2
  echo "$res"
}

find_cache_type() {
  w="     " # space tab
  res=`sed -ne '
          s/^'$1'['"$w"']\+\([^'"$w"']\+\).*$/\1/p;
          t end;
          d;
          :end q' < $CONFIG`
  [ -n "$res" ] || res=$2
  echo "$res"
}

start() {
  cache_dir=`find_cache_dir cache_dir <%= scope.lookupvar('squid::data_dir') %>`
  cache_type=`find_cache_type cache_dir ufs`

  #
  # Create spool dirs if they don't exist.
  #
  if [ "$cache_type" = "coss" -a -d "$cache_dir" -a ! -f "$cache_dir/stripe" ] || [ "$cache_type" != "coss" -a -d "$cache_dir" -a ! -d "$cache_dir/00" ]; then
    echo "Creating $DESC cache structure"
    $BIN -z
  fi

  umask 027
  ulimit -n 65535
  $BIN $ARGS
  RETVAL=$?

  return $RETVAL
}

stop() {
  PIDID=`cat $PID 2>/dev/null`

  if [ -f $PID ]; then
    kill $PIDID
  fi

  cnt=0
  while kill -0 $PIDID 2>/dev/null
  do
          cnt=`expr $cnt + 1`
          if [ $cnt -gt 24 ]
          then
              RETVAL=1
              return RETVAL
          fi
          sleep 5
  done

  return $RETVAL
}

<%= scope.function_template('base/init-d-actions') %>

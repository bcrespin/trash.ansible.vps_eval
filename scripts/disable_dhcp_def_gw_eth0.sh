#!/bin/bash

cat << EOF > /etc/dhcp/dhclient-enter-hooks.d/restrict-default-route
case \${interface} in
  eth0)
    unset new_routers
    ;;
  *)
    ;;
esac
EOF

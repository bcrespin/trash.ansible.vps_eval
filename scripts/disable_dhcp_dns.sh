#!/bin/bash

cat << EOF > /etc/dhcp/dhclient-enter-hooks.d/remove_dns
case \${interface} in
  eth0)
    unset new_domain-name-servers
    ;;
  *)
    ;;
esac
EOF

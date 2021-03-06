#!/bin/bash -eE
PROTO=${2:-tcp}
if [ $PROTO == "udp" ]; then
  openvpn $1
else
  udp2tcp= <<EOF
EOF
  openvpn <(sed -r 's/proto.+udp/proto tcp/g;s/(remote.*)1337/\1443/g;s/tls-auth/tls-crypt/g' $1)
fi

#!/bin/bash

if [ ! -f /etc/profile.d/go.sh ]; then
    sudo cat <<EOF > /etc/profile.d/go.sh
if [ -x /usr/local/go/bin/go ]; then
    export PATH=\$PATH:/usr/local/go/bin
fi
EOF
    sudo chmod a+r /etc/profile.d/go.sh
fi

export PATH=$PATH:/usr/local/go/bin

go version

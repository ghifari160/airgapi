#!/bin/bash

for f in /etc/firstboot.d/*; do
    echo "Executing $f"
    "$f"
done

echo "Disabling firstboot script"
sudo mv /etc/firstboot.sh /etc/firstboot.sh.done

echo "Done!"

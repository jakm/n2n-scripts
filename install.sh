if [ $(id -u) != 0 ]; then
    echo "You must be a root user" 2>&1
    exit 1
fi

useradd -M -r -s /bin/false n2n

echo Installing files...

install --backup=numbered -m 600 n2n.conf /etc/n2n.conf
install --backup=numbered -m 600 nm_n2n.conf /etc/nm_n2n.conf
install -m 755 n2n-control.sh /usr/local/sbin/n2n-control
install -m 700 99nm_n2n.sh /etc/NetworkManager/dispatcher.d/99nm_n2n

echo DONE

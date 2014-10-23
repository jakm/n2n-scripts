my n2n scripts
--------------

Shell scripts that automatically connect n2n VPN when network interface is not
connected to "home" network.

dependencies:

* [n2n](http://www.ntop.org/products/n2n)
* [ipcalc](http://jodies.de/ipcalc)

scripts:

* n2n-control: controls connection to n2n VPN defined by parameters
    in configfile
* 99nm_n2n.sh: NetworkManager hook that runs n2n-control when monitored
    interface isn't connected to "home" network

files:

* /etc/n2n.conf: parameters of n2n VPN
* /etc/nm_n2n.conf: monitored interfaces and "home" networks
* /var/run/n2n.pid
* /var/log/n2n.log

installation:

* run install.sh
* write parameters to /etc/n2n.conf and /etc/nm_n2n.conf

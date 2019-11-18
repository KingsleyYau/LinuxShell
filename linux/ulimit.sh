#!/bin/sh
ulimit -c unlimited
ulimit -d unlimited
ulimit -f unlimited
ulimit -i unlimited
# Just for MacOSX
#sudo sysctl -w kern.maxfiles=1048600
#sudo sysctl -w kern.maxfilesperproc=1048576
ulimit -n 1048576   
ulimit -q unlimited
ulimit -u unlimited
ulimit -v unlimited
ulimit -x unlimited
ulimit -s 240      
ulimit -l unlimited

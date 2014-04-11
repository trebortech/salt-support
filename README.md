salt-support
============

Support files


ssh-bootstrap.sh
  This file allows you to bootstrap a remote client via ssh. It patches in the bootstrap-salt.sh file which can be downloaded at https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.sh
  
  Usage :  ssh-bootstrap.sh [options]

  Examples:
    - ssh-bootstrap.sh
    - ssh-bootstrap.sh -c ubuntu@10.111.5.90 -m saltme.mydomain.com -n coolclient

  Options:
  -h  Display this message
  -c  ssh login that has sudo priv
  -m  DNS / IP address of salt master
  -n  The minion name you would like to set
    

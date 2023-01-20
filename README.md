salt-support
============

Support files


ssh-bootstrap.sh
  This file allows you to bootstrap a remote salt-minion or salt-master (controller) via ssh. It patches in the bootstrap-salt.sh file which can be downloaded at https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.sh <br>
  <br>
  Usage :  ssh-bootstrap.sh [options]<br>
  <br>
  <b>Examples:</b><br>
    - ssh-bootstrap.sh<br>
    - ssh-bootstrap.sh -c ubuntu@10.111.5.90 -m saltme.mydomain.com -n coolclient<br>

  <b>Options:</b><br>
  -h  Display this message<br>
  -c  ssh login that has sudo priv<br>
  -m  DNS / IP address of salt master<br>
  -n  The minion name you would like to set<br>
  
  <b>Optional:</b><br>
  -k  SSH key to use for connection (default to ~/.ssh/id_rsa)<br>
  -t  Type of salt deployment. Default to minion. [minion | controller])<br>

#! /bin/bash

#===============================================================================
#          FILE: ssh-bootstrap.sh
#
#   DESCRIPTION: Executes the bootstrap-salt.sh script on a remote client via ssh
#
#     COPYRIGHT: (c) 2014 by the TreborTech, LLC.
#
#       LICENSE: Apache 2.0
#  ORGANIZATION: TreborTech, LLC (www.trebortech.com)
#       CREATED: 4/10/2014
#
#
#  Updates:
#         2014-04-11-1 - Shane Gibson
#           Much better way of handling ssh connections
#         2023-01-20 - TreborTech
#           Changed to offer master deployment and minion deployment
#           Changed to systemd
#===============================================================================

set -o nounset 
__ScriptVersion="2022.10.04"
__ScriptName="ssh-bootstrap.sh"

_Ssh_Key="${HOME}/.ssh/id_rsa"
_Type="minion"

#---  PRE-FLIGHT  --------------------------------------------------------------
#  DESCRIPTION:  Verify dependencies can be found
#-------------------------------------------------------------------------------

if [ -e "bootstrap-salt.sh" ]
then
  echo "bootstrap-salt.sh is available"
else
  echo "************************************"
  echo "YOU MUST DOWNLOAD A FILE TO CONTINUE"
  echo "You can download the required file from"
  echo ""
  echo "wget https://raw.githubusercontent.com/saltstack/salt-bootstrap/stable/bootstrap-salt.sh"
  echo ""
  echo "*************************************"
  exit 1
fi


#---  FUNCTION -----------------------------------------------------------------
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#-------------------------------------------------------------------------------
usage() {
    cat << EOT

  Usage :  ${__ScriptName} [options]

  Examples:
    - ${__ScriptName} -h
    - ${__ScriptName} -c ubuntu@10.111.5.90 -m saltme.mydomain.com -n coolclient
    - ${__ScriptName} -k myspecialkey.priv -c ubuntu@10.111.5.90 -m saltme.mydomain.com -n coolclient

  Options:
  -h  Display this message
  
  Mandatory
  -c  ssh login that has sudo priv
  -m  DNS / IP address of salt master
  -n  The minion name you would like to set
  
  Optional
  -k  SSH key to use for connection (default to ~/.ssh/id_rsa)
  -t  Type of salt deployment. Default to minion. [minion | controller]

  
EOT
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

while getopts ":hc::n::m::k:t:" opt 
do
    case "${opt}" in
        h)  usage; exit 0;;
        c)  _Target=$OPTARG;;
        n)  _Minion_Name=$OPTARG;;
        m)  _Master_Name=$OPTARG;;
        k)  _Ssh_Key=$OPTARG;;
        t)  _Type=$OPTARG;;
        \?) echo
            echo "Option does not exist : $OPTARG"
            usage
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

_Options="-i ${_Ssh_Key} ${_Target}"

case "${_Type}" in
  develop)
      # If your bootstrap-salt.sh script is from the develop branch
      ssh ${_Options} sudo bash -s -- < bootstrap-salt.sh -X -A ${_Master_Name} -i ${_Minion_Name}
      ;;
  minion)
      # If your bootstrap-salt.sh script is from the stable branch
      ssh ${_Options} " (sudo bash -s -- " < bootstrap-salt.sh "-X -A ${_Master_Name} -i ${_Minion_Name} -U ) &&
                        ( systemctl stop salt-minion ) &&
                        ( systemctl start salt-minion ) "
      ;;
  controller)
      # If your bootstrap-salt.sh script is from the stable branch
      ssh ${_Options} " (sudo bash -s -- " < bootstrap-salt.sh "-X -A ${_Master_Name} -M -i ${_Minion_Name} -U ) &&
                        ( systemctl stop salt-minion ) &&
                        ( systemctl stop salt-master ) &&
                        ( systemctl start salt-master ) &&
                        ( systemctl start salt-minion ) "
      ;;
esac



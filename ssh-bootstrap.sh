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
#         20140-04-11-1 - Shane Gibson
#           Much better way of handling ssh connections
#===============================================================================

set -o nounset 
__ScriptVersion="2014.04.10-1"
__ScriptName="ssh-bootstrap.sh"

_Ssh_Key="${HOME}/.ssh/id_rsa"


#---  PRE-FLIGHT  --------------------------------------------------------------
#  DESCRIPTION:  Verify dependencies can be found
#-------------------------------------------------------------------------------

if [ -e "bootstrap-salt.sh" ]
then
  echo "boothstrap-salt.sh is available"
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
    - ${__ScriptName}
    - ${__ScriptName} -c ubuntu@10.111.5.90 -m saltme.mydomain.com -n coolclient

  Options:
  -h  Display this message
  -c  ssh login that has sudo priv
  -m  DNS / IP address of salt master
  -n  The minion name you would like to set


  
EOT
}

while getopts ":hc::n::m::k" opt 
do
    case "${opt}" in
        h)  usage; exit 0;;
        c)  _Target=$OPTARG;;
        n)  _Minion_Name=$OPTARG;;
        m)  _Master_Name=$OPTARG;;
        k)  _Ssh_Key=$OPTARG;;
        \?) echo
            echoerror "Option does not exist : $OPTARG"
            usage
            exit 1
            ;;

    esac
done

shift $((OPTIND-1))

_Options="-i ${_Sssh_Key} ${_Target}"

# If your bootstrap-salt.sh script is from the develop branch
ssh ${_Options} sudo bash -s -- < bootstrap-salt.sh -X -A ${_Master_Name} -i ${_Minion_Name}

# If your bootstrap-salt.sh script is from the stable branch
#ssh ${_Options} " ( sudo bash -s -- < bootstrap-salt.sh -X -A ${_Master_Name} ) &&
#                  ( sudo sed -i "s/\#id\:/id:\ ${_Minion_Name}/g" /etc/salt/minion ) &&
#                  ( sudo service salt-minion stop ) &&
#                  ( sudo service salt-minion start ) "


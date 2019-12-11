#!/usr/bin/env bash

CURRENT_DIR="$(pwd)"
VAGRANT_TEMPLATE_FILE=$gitmine/vagrant_template/Vagrantfile-centos7-en0
NET_OPT=$1
VM_NAME=$2
IP_ADDR=$3
VM_MEM=$4


# Check if arguments are present
if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]] 
then
	printf "One or more argument not given!\nExample: ./create-vagrantfile.sh <private or public net> <vm-name> <ip-address> <vm-memory>\n" && exit 1
fi


# Either public network or private; chose according to argument 
if [[ $1 == 'private']]
then
	VAGRANT_TEMPLATE_FILE=$gitmine/vagrant_template/Vagrantfile-centos7-en0
elif [[ $1 == 'public']]
then
	VAGRANT_TEMPLATE_FILE=$gitmine/vagrant_template/Vagrantfile-centos7-private
fi


# Create the ssh keys
ssh-keygen -b 4096 -N '' -f $VM_NAME 

# SSH pub key variable after generation
SSH_KEY="$(cat $VM_NAME.pub)"

echo "Copy vagrantfile to current dir.. $CURRENT_DIR"
cp -v $VAGRANT_TEMPLATE_FILE $CURRENT_DIR 
mv -v Vagrantfile-centos7-en0 Vagrantfile


# The following commands are run on mac, and i want to use gnu sed, installed with brew
# Need to use different delimiter because of pub key
echo "Replace ssh key with generated one.."
gsed -i.bak "s%SSH-KEY-GOES-HERE%$SSH_KEY%g" Vagrantfile

echo "Replacing vm-name and hostname.."
gsed -i.bak "s/VM-NAME/$VM_NAME/g" Vagrantfile

echo "replacing IP address.."
gsed -i.bak "s/IP-ADDR-GOES-HERE/$IP_ADDR/g" Vagrantfile

echo "entering memory for VM.."
gsed -i.bak "s/MEM-GOES-HERE/$VM_MEM/g" Vagrantfile

# At the end validate the file is ready to run!
echo "Validating Vagrantfile.."
vagrant validate

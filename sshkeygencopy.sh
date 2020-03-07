#!/usr/bin/env bash

if [ $# -lt 2 ]; then
    echo "Usage:"
    echo "$0 username host [port]"
    exit 1
else
    user=$1
    host=$2
    port=${3:-"22"}
    uah=$user@$host # user at host
    echo "creating key pair for user $uah"
    ssh-keygen -t rsa -b 4096 -f "$uah" -N ""
    echo "copying pub key for user $user to host $host"
    ssh-copy-id -p $port -o PubkeyAuthentication=no -f -i $uah.pub $uah
    cp $uah* ~/.ssh
    rm $uah*

    echo "testing keys"
    ssh -i ~/.ssh/$uah -p $port -t $uah "echo hello from remote host"
    if [ $? -ne 0 ]; then
        echo "something went wrong"
        exit 1
    else
        echo "everything ok"
        echo "connect with ssh -i ~/.ssh/$uah $uah -p $port "
        exit 0
    fi
fi

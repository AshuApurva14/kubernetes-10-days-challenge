#!/usr/bin/env bash

set -e


function rename {
    mv ${source} ${dest}
}


source=$1
dest=$2

rename $1 $2

/workspaces/kubernetes-10-days-challenge/Day_2/challenge.md
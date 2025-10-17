#!/usr/bin/env bash

set -euo pipefail

NO_OF_DAY_FILE_CREATED=$1

FILE_PATH=/workspaces/kubernetes-10-days-challenge/k8s-challenge



create_file ()
{

   touch $FILE_PATH/Day_$NO_OF_DAY_FILE_CREATED/challenge.md $FILE_PATH/Day_$NO_OF_DAY_FILE_CREATED/solution.md

   echo "Files created successfully"


}

create_file

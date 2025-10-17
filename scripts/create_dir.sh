#!/usr/bin/env bash

set -x

DIRECTORY_NUMBER=$1

DIRECTORY_FULL_PATH=/workspaces/kubernetes-10-days-challenge/k8s-challenge

for dir in $DIRECTORY_NUMBER;
 do
 
   echo "Creating the directory"
   mkdir -p $DIRECTORY_FULL_PATH/Day_$dir

   echo "Successfully created the directory"

done



   
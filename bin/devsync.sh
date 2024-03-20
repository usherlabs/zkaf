#!/bin/bash

OPERATION=$1
shift

echo "Synchronising local repository to remote server at $OPERATION...";

rsync -urltv --delete -e ssh ./ $OPERATION:~/zkOracle/

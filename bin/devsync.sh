#!/bin/bash

OPERATION=$1
shift

echo "Synchronising local repository to remote server at $OPERATION...";

rsync -azP -e ssh ./ $OPERATION:~/zkoracle/

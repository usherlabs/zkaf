#!/bin/bash

OPERATION=$1
shift

echo "Synchronising local repository to remote server at $OPERATION...";

while inotifywait -r -e modify,create,delete ./; do
  rsync -urltv --delete -e ssh ./ $OPERATION:~/zkOracle/
done
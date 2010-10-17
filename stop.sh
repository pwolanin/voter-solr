#!/bin/bash

# Make sure we are in the right directory
cd `dirname $0`
echo "Stopping Solr"
java -DSTOP.PORT=8079 -DSTOP.KEY=secret -jar start.jar --stop

if [ -s logs/solr.pid ]; then
  rm logs/solr.pid
fi


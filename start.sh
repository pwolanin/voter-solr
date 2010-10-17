#!/bin/bash

# Make sure we are in the right directory
cd `dirname $0`

port=8983

if [ -n "$1" ]; then
  port=$1
fi

if [ -s "./logs/solr.pid" ]; then
  echo "logs/solr.pid already exists - is Solr already running?"
  echo ""
  echo "If you are sure it's not running, delete logs/solr.pid"
  exit 1
fi

echo "Starting Solr on port $port"

rm -f logs/console.log
nohup java -DSTOP.PORT=8079 -DSTOP.KEY=secret -Xmx128m \
           -Dsolr.solr.home=./solr \
           -Djetty.home=. \
           -Djetty.port=$port \
           -Djetty.logs=./logs \
           -jar start.jar 2> ./logs/console.log  &

# Write the process ID into the file "pid"
echo $! > ./logs/solr.pid

echo "Solr running under process ID $!";
exit


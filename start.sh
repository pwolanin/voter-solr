#!/bin/bash
# Usage: ./start.sh [port]


# Make sure we are in the right directory
cd `dirname $0`

# Default port is 8983
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

JAVA_OPTS="$JAVA_OPTS -DSTOP.PORT=8079 -DSTOP.KEY=secret -Xmx128m"
JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=./solr -Djetty.home=."
JAVA_OPTS="$JAVA_OPTS -Djetty.port=$port -Djetty.logs=./logs"
export JAVA_OPTS

rm -f logs/console.log
nohup java $JAVA_OPTS -jar start.jar 2> ./logs/console.log  &

# Write the process ID into the file "pid"
echo $! > ./logs/solr.pid

echo "Solr running under process ID $!";
exit


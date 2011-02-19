#!/bin/bash
#
# Script for starting Solr under Jetty.
#
# Usage: ./start.sh [port]

# Copyright 2010 Peter Wolanin. All Rights Reserved
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

if [ -z $JETTY_HOME ]; then
  JETTY_HOME='./apache-solr/example'
fi

JAVA_OPTS="$JAVA_OPTS -DSTOP.PORT=8079 -Xmx128m"
JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=./solr -Djetty.home=$JETTY_HOME"
JAVA_OPTS="$JAVA_OPTS -Djetty.port=$port -Djetty.logs=$JETTY_HOME/logs"
export JAVA_OPTS

rm -f logs/console.log
# </dev/null is not needed on GNU/linux, but may be on Free BSD
# Jetty echos the stop key to stdout if it's not provided.
nohup java $JAVA_OPTS -jar $JETTY_HOME/start.jar </dev/null > $JETTY_HOME/logs/key.txt  2> $JETTY_HOME/logs/console.log  &

# Write the process ID into the file "pid"
echo $! > $JETTY_HOME/logs/solr.pid

echo "Solr running under process ID $!";
exit


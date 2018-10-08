#!/bin/bash

if [[ -z $ZOOKEEPER_SERVER ]]; then
  echo "ERROR: ZOOKEEPER_SERVER variable is not set"
  exit 1
fi
if [[ "$1" == "zookeeper" ]]; then
  if [[ -z $ZOOKEEPER_ID ]]; then
    echo "ERROR: variable ZOOKEEPER_ID is not set"
    exit 1
  fi
  echo "tickTime=2000" > /kafka/config/zookeeper.properties
  echo "initLimit=10" >> /kafka/config/zookeeper.properties
  echo "syncLimit=5" >> /kafka/config/zookeeper.properties
  echo "dataDir=/tmp/zookeeper" >> /kafka/config/zookeeper.properties
  echo "clientPort=2181" >> /kafka/config/zookeeper.properties
  i=0
  IFS=","
  for H in $ZOOKEEPER_SERVER; do
    echo "server.$i=$H" >> /kafka/config/zookeeper.properties
    i=$[$i+1]
  done
  unset IFS
  echo "$ZOOKEEPER_ID" > /tmp/zookeeper/myid
  /kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties
elif [[ "$1" == "broker" ]]; then
  if [[ -z $BROKER_ID ]]; then
    echo "ERROR: BROKER_ID variable is not set"
    exit 1
  fi
  sed -i "s/localhost:2181/$ZOOKEEPER_SERVER/g" /kafka/config/server.properties
  sed -i "s/broker.id=0/broker.id=$BROKER_ID/g" /kafka/config/server.properties
  echo -e "\nlisteners=PLAINTEXT://:$KAFKA_PORT" >> /kafka/config/server.properties
  sleep 10
  /kafka/create-topic.sh &
  cat /kafka/config/server.properties && sleep 3
  /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
fi
